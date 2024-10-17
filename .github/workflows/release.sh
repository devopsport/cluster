#!/bin/bash

echo ${GIT_TOKEN} | gh auth login --with-token
gh repo clone ${GITHUB_REPOSITORY}
cd $(echo "${GITHUB_REPOSITORY}" | cut -d "/" -f2)/
GITHUB_TAGS=$(gh release list | wc -l)

if [ ${GITHUB_TAGS} = 0 ]
then
  gh release create v0.0.1 --generate-notes
  MAJOR_VERSION="0"
  MINOR_VERSION="0"
  PATCH_VERSION="1"
else
  MAJOR_VERSION=$(gh release list | grep Latest | awk '{print $9 " " $1}' | cut -d "v" -f2 | cut -d "." -f1)
  MINOR_VERSION=$(gh release list | grep Latest | awk '{print $9 " " $1}' | cut -d "v" -f2 | cut -d "." -f2)
  PATCH_VERSION=$(gh release list | grep Latest | awk '{print $9 " " $1}' | cut -d "v" -f2 | cut -d "." -f3)
  PATCH_VERSION=$((PATCH_VERSION+1))
  gh release create v${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION} --generate-notes
fi

echo "GIT_TAG=v${MAJOR_VERSION}.${MINOR_VERSION}.${PATCH_VERSION}" >> $GITHUB_ENV
