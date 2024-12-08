#!/bin/bash

set -e

VERSION=$(cat Dockerfile | grep "ENV REL=" | cut -d"v" -f2)
REPOS=(${REPOS:-ngc7331/riscv-linuxserver-baseimage-alpine})

echo "Build version: ${VERSION}"
echo "Build repos: ${REPOS[*]}"

# Build
echo "Building image..."
TAGS=()
for repo in ${REPOS[@]}; do
    TAGS+=("-t ${repo}:${VERSION}")
    TAGS+=("-t ${repo}:${VERSION%.*}")
    TAGS+=("-t ${repo}:latest")
done
docker buildx build \
    --platform linux/riscv64 \
    --build-arg VERSION=${VERSION} \
    ${TAGS[*]} \
    --push \
    .
