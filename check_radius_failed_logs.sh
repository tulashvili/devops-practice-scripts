#!/bin/bash

# Ваш Telegram API токен
TOKEN="6862400180:AAH8JKd40p2uVxWIEUtYYdjG_D0NwyPQFIs"

# ID вашего канала или чата
CHAT_ID="-1002218752222"

# Функция для отправки сообщений в Telegram
send_telegram_message() {
    MESSAGE=$1
    curl -s -X POST "https://api.telegram.org/bot$TOKEN/sendMessage" \
        -d chat_id="$CHAT_ID" \
        -d text="$MESSAGE"
}

# Путь к файлу лога
LOG_FILE="/var/log/syslog"

# Проверка файла лога на наличие строк с ошибками RADIUS
grep -i "RADIUS authentication of '.*' failed" $LOG_FILE | while read -r line; do
    echo "Found line: $line" # Для отладки
    send_telegram_message "Alert: $line"
done
