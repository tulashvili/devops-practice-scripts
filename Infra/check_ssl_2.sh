#!/bin/bash

# Список хостов для проверки
HOSTS=(
    "sk0alzdx.com"
    "zLhXn2Zr.com"
    "nspz9gsd.com"
    "exsd6l96b6sw.com"
    "unhcmcim.com"
    "obp2qv8r.com"
    "birox0id.com"
    "kjjkspew.com"
)

# Текущая дата в формате UNIX timestamp
CURRENT_DATE=$(date +%s)

# Проверка каждого хоста
for HOST in "${HOSTS[@]}"; do
    echo "\nПроверка сертификата для хоста: $HOST"

    # Извлечение информации о сертификате с использованием openssl
    EXPIRATION_DATE=$(echo | openssl s_client -servername "$HOST" -connect "$HOST":443 2>/dev/null \
        | openssl x509 -noout -enddate 2>/dev/null \
        | sed 's/^notAfter=//')

    if [ -z "$EXPIRATION_DATE" ]; then
        echo "Ошибка: невозможно получить информацию о сертификате для $HOST"
        continue
    fi

    # Диагностика даты истечения
    echo "Извлеченная дата истечения сертификата: $EXPIRATION_DATE"

    # Преобразование даты истечения сертификата в формат UNIX timestamp
    EXPIRATION_DATE_UNIX=$(date -d "$EXPIRATION_DATE" +%s 2>/dev/null)

    if [ $? -ne 0 ]; then
        echo "Ошибка: некорректный формат даты истечения сертификата для $HOST"
        echo "Проверьте сертификат вручную или уточните формат даты: $EXPIRATION_DATE"
        continue
    fi

    # Сравнение текущей даты с датой истечения
    if [ "$EXPIRATION_DATE_UNIX" -lt "$CURRENT_DATE" ]; then
        echo "Сертификат истек! (дата истечения: $EXPIRATION_DATE)"
    else
        echo "Сертификат действителен (дата истечения: $EXPIRATION_DATE)"
    fi

done

