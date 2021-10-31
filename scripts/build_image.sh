#!/usr/bin/env bash
TAG=$(git tag --sort=-creatordate | head -1)
PREV_TAG=$(git tag --sort=-creatordate | sed -n 2p)
HASH=$(git rev-parse HEAD | cut -c1-10)
BUILD_NAME=$TAG-$HASH

echo TAG >> $GITHUB_ENV
echo PREV_TAG >> $GITHUB_ENV
echo HASH >> $GITHUB_ENV
echo BUILD_NAME >> $GITHUB_ENV

docker build . -t $BUILD_NAME