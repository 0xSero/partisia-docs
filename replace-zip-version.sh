#!/usr/bin/env bash
set -e

sdk_version=$(head -n 1 version.txt)
filename="partisia-sdk-${sdk_version}.zip"

download_url="${CI_API_V4_URL}/projects/${CI_PROJECT_ID}/packages/generic/partisia-sdk/${sdk_version}/${filename}"
curl -o "$filename" -w "%{http_code}\n" --header "JOB-TOKEN: $CI_JOB_TOKEN" "${download_url}"

mv "$filename" public/

find . -type f -print0 -iname "*.md" | xargs -0 sed -i "s/http:\/\/example\.com\/RUST_CONTRACT_SDK/$filename/g"
