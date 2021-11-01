#!/usr/bin/env bash

docker build . -t $BUILD_NAME

if [ $? = 0 ]
then
  MESSAGE="Собран образ ${BUILD_NAME}"
  echo $MESSAGE
  sh ./scripts/add_comment.sh "$MESSAGE"
else
  echo "Сборка образа завершилась с ошибкой"
  exit 1
fi