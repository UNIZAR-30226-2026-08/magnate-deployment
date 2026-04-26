#!/bin/sh

# Updates all repositories using git

git pull
git submodule sync
git submodule update --remote --rebase

