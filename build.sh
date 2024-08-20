#!/bin/bash

set -e

VERSION=${VERSION:-3.20}
ARCHS=(${ARCHS:-riscv64})
REPOS=(${REPOS:-ngc7331/baseimage-alpine})
IMAGES=()
OFFICIAL_REPO=lscr.io/linuxserver/baseimage-alpine

echo "Building version: ${VERSION}"
echo "Building archs: ${ARCHS[*]}"
echo "Building repos: ${REPOS[*]}"

# Build
echo "Building images..."
for arch in ${ARCHS[@]}; do
    TAGS=()
    for repo in ${REPOS[@]}; do
        TAGS+=("-t ${repo}:${arch}-${VERSION}")
    done
    docker buildx build \
        --platform linux/${arch} \
        --build-arg VERSION=${VERSION} \
        -f Dockerfile.${arch} \
        ${TAGS[*]} \
        --push \
        .
    IMAGES+=(${repo}:${arch}-${VERSION})
done

# Combine with official Alpine image & push
echo "Combining with official Alpine image..."
TAGS=()
for repo in ${REPOS[@]}; do
    TAGS+=("-t ${repo}:${VERSION}")
done
docker buildx imagetools create ${TAGS[*]} \
    ${IMAGES[*]} \
    ${OFFICIAL_REPO}:${VERSION}
