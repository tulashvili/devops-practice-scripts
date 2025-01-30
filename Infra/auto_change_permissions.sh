#!/usr/bin/env bash

path="/var/www/shakes_pics/landings/"
expected_owner="git"
expected_group="git"

# find files, change permissions and print them
MESSAGE=$(echo "the permissions of the following files have been changed in '$path' on '$expected_owner:$expected_group': " && \
sudo find "$path"  \! -user "$expected_owner" \! -group "$expected_group" -exec chown "$expected_owner":"$expected_group" {} \; -print)

echo $MESSAGE
# send message to telegram
# API_TOKEN="418006998:AAFCFQSLzNZbnvUJawrLSz5ZFfV6JaWQKKM"
# CHAT_ID="-1002488713430"

#curl -s -X POST "https://api.telegram.org/bot${API_TOKEN}/sendMessage" \
 #   -d chat_id="${CHAT_ID}" \
 #  -d text="${MESSAGE}"





