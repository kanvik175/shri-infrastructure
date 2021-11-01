#!/usr/bin/env bash

docker build . -t $BUILD_NAME

if [ $? = 0 ]
then
  sh ./scripts/add_comment.sh "Собран образ ${BUILD_NAME}" $TASK_ID $ORG_ID $APP_TOKEN
else
  exit 1
fi