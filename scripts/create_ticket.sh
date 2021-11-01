#!/usr/bin/env bash

# ORG_ID=6461097
# APP_TOKEN=AQAAAAAWmi6LAAd5C9bXNaNYeE_vshAJkUkTl1c

QUEUE_NAME=TMP

TAG=$(git tag --sort=-creatordate | head -1)
PREV_TAG=$(git tag --sort=-creatordate | sed -n 2p)
HASH=$(git rev-parse HEAD | cut -c1-10)
BUILD_NAME=$TAG-$HASH

echo "TAG=${TAG}" >> $GITHUB_ENV
echo "PREV_TAG=${PREV_TAG}" >> $GITHUB_ENV
echo "HASH=${HASH}" >> $GITHUB_ENV
echo "BUILD_NAME=${BUILD_NAME}" >> $GITHUB_ENV

SUMMARY="Релиз ${TAG}"
CHANGELOG=$(git log --pretty=format:"%h "%s" %an %ad\n" --date=short $PREV_TAG..$TAG | tr -s "\n" " ")

DESCRIPTION="Версия релиза: ${TAG}\nВерсия пакета с релизом: ${BUILD_NAME}\n\n${CHANGELOG}"

JSON='{"queue": "'"${QUEUE_NAME}"'", "summary": "'"${SUMMARY}"'", "description": "'"${DESCRIPTION}"'", "unique": "'"${BUILD_NAME}"'"}'

CREATE_RESPONSE=$(curl -X  POST \
-d "$JSON" \
-H 'Content-Type: application-json' \
-H 'X-Org-ID: '"$ORG_ID" \
-H 'Authorization: OAuth '"$APP_TOKEN" \
https://api.tracker.yandex.net/v2/issues/)

TASK_ID=$(echo $CREATE_RESPONSE | tr '\n' ' ' | jq '.key' | sed 's/"//g')
ERROR_CODE=$(echo $CREATE_RESPONSE | tr '\n' ' ' | jq '.statusCode')

echo "TASK_ID=${TASK_ID}" >> $GITHUB_ENV

echo $CREATE_RESPONSE
echo $TASK_ID
echo $ERROR_CODE

if [ "$TASK_ID" = "" ]
then
  echo "Тикет создан"
else
  if [ "$ERROR_CODE" = "409" ]
  then
    echo "Тикет уже существует"

    SEARCH_RESULT=$(curl -s -X POST \
    -d '{"filter": { "unique": "'"${BUILD_NAME}"'" } }' \
    -H 'Content-Type: application-json' \
    -H 'X-Org-ID: '"$ORG_ID" \
    -H 'Authorization: OAuth '"$APP_TOKEN" \
    https://api.tracker.yandex.net/v2/issues/_search)

    TASK_URL=$(echo $SEARCH_RESULT | tr '\n' ' ' | jq '.[].self' | sed 's/"//g')
    echo "URL существующего тикета: ${TASK_URL}"

    echo "Обновление существующего тикета"

    UPDATE_RESPONSE_CODE=$(curl -X  PATCH \
    -o /dev/null -s -w "%{http_code}\n" \
    -d "$JSON" \
    -H 'Content-Type: application-json' \
    -H 'X-Org-ID: '"$ORG_ID" \
    -H 'Authorization: OAuth '"$APP_TOKEN" \
    $TASK_URL)

    if [ "$UPDATE_RESPONSE_CODE" = "200" ]
    then
      echo "Тикет успешно обновлен"
    else
      echo "Ошибка обновления"
      exit 1
    fi

  fi
fi