#!/bin/bash

# Массив серверов
servers=(
"p33-switcherry.dio"
"vpn430-lv-switcherry.htzn"
"vpn440-al-switcherry.alb"
"vpn477-fi-switcherry.htzn"
"vpn478-pt-switcherry.pqhs"
"vpn479-sk-switcherry.pqhs"
)

# Команды для выполнения на каждом сервере
commands=(
  "sudo service monit stop"
  "sudo apt remove -y monit     --allow-change-held-packages"
)

# Пройти по каждому серверу и выполнить команды
for server in "${servers[@]}"; do
  echo "Подключение к серверу $server"

  # Подключение по SSH и выполнение команд
  for command in "${commands[@]}"; do
    echo "Выполнение команды: $command"
    ssh otulashvili@"$server" "$command"
    if [ $? -ne 0 ]; then
      echo "Ошибка при выполнении команды: $command на сервере $server"
      exit 1
    fi
  done

  echo "Команды выполнены успешно на сервере $server"
done
