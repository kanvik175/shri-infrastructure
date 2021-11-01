#!/usr/bin/env bash

docker build . -t $BUILD_NAME

if [ $? = 0 ]
then
  sh ./add_comment.sh "Собран образ ${BUILD_NAME}"
else
  exit 1
fi