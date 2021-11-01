#!/usr/bin/env bash

npm test -- --watchAll=false

if [ $? = 0 ]
then
  sh ./add_comment.sh "Тесты успешно пройдены"
else
  exit 1
fi