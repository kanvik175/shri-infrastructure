#!/usr/bin/env bash

npm test -- --watchAll=false

if [ $? = 0 ]
then
  MESSAGE="Тесты успешно пройдены" 
  echo $MESSAGE
  sh ./scripts/add_comment.sh $MESSAGE
else
  echo "Тесты завершились с ошибкой"
  exit 1
fi
