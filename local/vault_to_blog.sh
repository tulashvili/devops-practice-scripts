#!/bin/bash

# Исходная и целевая директории
SOURCE_DIR=""/Users/omartulashvili/Library/Mobile\ Documents/iCloud\~md\~obsidian/Documents/Thinking/
DEST_DIR="/Users/omartulashvili/quartz/content/draft/"
ATTACHMENTS_DIR="attachments"

# Функция для копирования файлов .md с учётом вложений
copy_files_with_draft() {
    # Поиск всех файлов .md с draft: true
    find "$SOURCE_DIR" -type f -name "*.md" | while read file; do
        # Проверяем, содержится ли "draft: true" в файле
        if grep -q "draft: true" "$file"; then
            # Копирование самого .md файла в целевую папку
            dest_file="$DEST_DIR/$(basename "$file")"
            cp -f "$file" "$dest_file"  # флаг -f заменяет файл, если он уже существует

            # Поиск вложений, например: ![[some_name.jpeg]]
            grep -oE '!\[\[[^]]+\]\]' "$file" | while read attachment; do
                # Извлечение пути вложения
                attachment_file=$(echo "$attachment" | sed -E 's/!\[\[(.*)\]\]/\1/')
                
                # Проверка, что вложение существует
                if [ -f "$SOURCE_DIR/$attachment_file" ]; then
                    # Копирование вложения в целевую папку
                    dest_attachment_dir="$DEST_DIR/$ATTACHMENTS_DIR"
                    mkdir -p "$dest_attachment_dir"  # Создаём папку, если её нет
                    cp -f "$SOURCE_DIR/$attachment_file" "$dest_attachment_dir/"
                fi
            done
        fi
    done
}

# Запуск функции
copy_files_with_draft

