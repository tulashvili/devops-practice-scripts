#!/bin/bash

"/Users/omartulashvili/Library/Mobile Documents/iCloud~md~obsidian/Documents/Thinking/matcha-rss-ai/matcha-darwin-amd64"

dir_path="/Users/omartulashvili/Library/Mobile Documents/iCloud~md~obsidian/Documents/Thinking/matcha-rss-ai"
file_path="${dir_path}/$(date +%Y-%m-%d).md"

echo "Ожидаем файл RSS: $file_path"
while [ ! -f "$file_path" ]; do
    sleep 1
done

text="$(cat "$file_path")"

title=$(date +%Y-%m-%d)
tags="today_rss"

# Отладочная информация
echo "title: $title"
echo "tags: $tags"
echo "text: $text"

# Закодируем текст для Bear
encoded_text=$(echo "$text" | python3 -c "import urllib.parse, sys; print(urllib.parse.quote(sys.stdin.read()))")
encoded_title=$(echo "$title" | python3 -c "import urllib.parse, sys; print(urllib.parse.quote(sys.stdin.read()))")

# Отправка закодированного текста в Bear
open "bear://x-callback-url/create?title=$encoded_title&tags=$tags"
open "bear://x-callback-url/add-text?text=$encoded_text&title=$encoded_title&mode=append"
