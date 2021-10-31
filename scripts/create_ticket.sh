#!/usr/bin/env bash

echo $GITHUB_ENV

QUEUE_NAME=TMP

SUMMARY="Релиз ${BUILD_NAME}"
CHANGELOG=$(git log --pretty=format:"%h "%s" %an %ad\n" --date=short $PREV_TAG..$TAG | tr -s "\n" " ")

DESCRIPTION="Версия релиза: ${TAG}\nВерсия пакета с релизом: ${BUILD_NAME}\n\n${CHANGELOG}"

RESPONSE=$(curl -X  POST \
-o /dev/null -s -w "%{http_code}\n" \
-d '{"queue": "'"${QUEUE_NAME}"'", "summary": "'"${SUMMARY}"'", "description": "'"${DESCRIPTION}"'", "unique": "'"${BUILD_NAME}"'"}' \
-H 'Content-Type: application-json' \
-H 'X-Org-ID: '"$ORG_ID" \
-H 'Authorization: OAuth '"$APP_TOKEN" \
https://api.tracker.yandex.net/v2/issues/)

echo $RESPONSE

if [ $RESPONSE = "201" ]
then
  echo "Тикет создан"
else
  echo "Ошибка создания тикета"
fi