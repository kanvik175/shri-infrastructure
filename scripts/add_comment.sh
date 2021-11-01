#!/usr/bin/env bash

COMMENT="{ \"text\": \"$1\" }"
TASK_ID=$2
ORG_ID=$3
APP_TOKEN=$4

URL="https://api.tracker.yandex.net/v2/issues/${TASK_ID}/comments"

CREATE_RESPONSE_CODE=$(curl -X  POST \
-d "$COMMENT" \
-H 'Content-Type: application-json' \
-H 'X-Org-ID: '"$ORG_ID" \
-H 'Authorization: OAuth '"$APP_TOKEN" \
$URL)

echo $CREATE_RESPONSE_CODE
echo $TASK_ID
echo $COMMENT

# if [ $CREATE_RESPONSE_CODE = '201' ]
# then
#   echo "comment \"$1\" is created"
# else
#   echo "comment is not created"
#   exit 1
# fi