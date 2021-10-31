#!/usr/bin/env bash
export TAG=$(git tag --sort=-creatordate | head -1)
export PREV_TAG=$(git tag --sort=-creatordate | sed -n 2p)
export HASH=$(git rev-parse HEAD | cut -c1-10)

export BUILD_NAME=$TAG-$HASH

docker build . -t $BUILD_NAME