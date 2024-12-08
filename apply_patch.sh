#!/bin/bash

cp -f ./docker-baseimage-alpine/Dockerfile ./Dockerfile
patch < ./Dockerfile.patch
