#!/bin/bash

# Укажите путь к конфигурационному файлу Nginx/OpenResty
config_file="/etc/openresty/openresty.conf"

# Если конфигурация разбита на несколько файлов, можно использовать `include` в конфигурации.
# Например, если конфиги находятся в /etc/nginx/conf.d/*.conf
# config_file="/etc/nginx/nginx.conf /etc/nginx/conf.d/*.conf"

# Извлечение всех server_name из конфигурационного файла
server_names=$(grep -oP 'server_name\s+\K[^;]+' $config_file)

# Функция для замера времени открытия страницы
function measure_time {
    domain=$1
    echo "Checking $domain..."
    
    # Замер времени с помощью curl
    time_total=$(curl -o /dev/null -s -w "%{time_total}\n" -k "https://$domain")
    
    if [[ $? -ne 0 ]]; then
        echo "Error: Could not connect to $domain"
    else
        echo "Time taken to connect to $domain: $time_total seconds"
    fi
}

# Проходим по каждому домену и замеряем время
for domain in $server_names; do
    for name in $domain; do
        measure_time $name
    done
done
