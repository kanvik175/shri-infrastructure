#!/usr/bin/env bash

npm test -- --watchAll=false

if [ $? = 0 ]
then
  sh ./scripts/add_comment.sh "Тесты успешно пройдены" $TASK_ID $ORG_ID $APP_TOKEN
else
  exit 1
fi
