#!/bin/bash

# Список туннелей, которые необходимо проверять
tunnels=("IKEv2-MSCHAPv2-Apple-Dome-vpn" "IKEv2-MSCHAPv2-Apple-Shakevpn" "IKEv2-MSCHAPv2-Apple-Stellarshieldvpn")

# Команда для проверки состояния туннеля
check_tunnel() {
    ipsec status $1 | grep 'ESTABLISHED' > /dev/null
    if [ $? -ne 0 ]; then
        echo "Tunnel $1 is down"
        # Здесь можно добавить команду для отправки уведомления
    fi
}

# Проверка всех туннелей
for tunnel in "${tunnels[@]}"; do
    check_tunnel $tunnel
done
