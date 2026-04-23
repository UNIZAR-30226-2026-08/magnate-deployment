#!/bin/sh

# Updates all repositories using git

git pull
git submodule update --recursive --remote

