#!/bin/bash

# domains list
DOMAINS=("dpteamapi.com" "bzteamapi.com")

# api credentials
AUTH_EMAILS=("dev-hosting@dephouse.club" "dev-hosting@banzai.partners")
AUTH_KEYS=("babab60da437024ee48fd6553567fe309d3eb" "f1e59fb498dc0a9b691a0f93283a260692aac")

if [ "${#AUTH_EMAILS[@]}" -ne "${#AUTH_KEYS[@]}" ]; then
    echo "Ошибка: количество email и ключей не совпадает."
    exit 1
fi

# 3. Цикл по каждому аккаунту
for i in "${!AUTH_EMAILS[@]}"; do
    AUTH_EMAIL="${AUTH_EMAILS[$i]}"
    AUTH_KEY="${AUTH_KEYS[$i]}"
    
    echo "Обработка аккаунта с email: ${AUTH_EMAIL}"

    # Массив для хранения zone_id для текущего аккаунта
    ID_ZONES=()

    # 4. Получение zone_id для каждого домена
    for DOMAIN in "${DOMAINS[@]}"; do
        ZONE_ID=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones" \
            -H "X-Auth-Email: ${AUTH_EMAIL}" \
            -H "X-Auth-Key: ${AUTH_KEY}" \
            -H "Content-Type: application/json" | \
            jq -r --arg DOMAIN "$DOMAIN" '.result[] | select(.name == $DOMAIN) | .id')

        if [ -n "$ZONE_ID" ]; then
            echo "Найден zone_id для домена ${DOMAIN}: ${ZONE_ID}"
            ID_ZONES+=("$ZONE_ID")
        else
            echo "zone_id для домена ${DOMAIN} не найден для аккаунта ${AUTH_EMAIL}"
        fi
    done

    # 5. Отключение ECH для каждой zone_id текущего аккаунта
    for ZONE_ID in "${ID_ZONES[@]}"; do
        curl -X PATCH "https://api.cloudflare.com/client/v4/zones/${ZONE_ID}/settings/ech" \
            -H "X-Auth-Email: ${AUTH_EMAIL}" \
            -H "X-Auth-Key: ${AUTH_KEY}" \
            -H "Content-Type: application/json" \
            --data '{"id":"ech","value":"off"}'

        echo "ECH отключен для zone_id=${ZONE_ID} в аккаунте ${AUTH_EMAIL}"

        # Проверка, что ECH действительно отключен
        ECH_STATUS_CF=$(curl -s -X GET "https://api.cloudflare.com/client/v4/zones/${ZONE_ID}/settings/ech" \
            -H "X-Auth-Email: ${AUTH_EMAIL}" \
            -H "X-Auth-Key: ${AUTH_KEY}" \
            -H "Content-Type: application/json" | jq -r '.result.value')
        if [ "$ECH_STATUS_CF" == "off" ]; then
            echo "ECH успешно отключен для zone_id=${ZONE_ID}."
        else
            echo "Ошибка: ECH не отключен для zone_id=${ZONE_ID}."
        fi
    done
done

for DOMAIN in "${DOMAINS[@]}"; do
    echo "Проверка DNS для ${DOMAIN}"
    curl -s "https://dns.google/resolve?name=${DOMAIN}&type=HTTPS" | jq
done
