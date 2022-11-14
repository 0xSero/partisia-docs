#!/usr/bin/env bash
set -e

source zip_versions.conf.sh

compiler_version=$(get_current_version)
filename="partisia-example-contracts-${compiler_version}.zip"

download_url="${CI_API_V4_URL}/projects/${CI_PROJECT_ID}/packages/generic/partisia-example-contracts/${compiler_version}/${filename}"
curl -o "$filename" -w "%{http_code}\n" --header "JOB-TOKEN: $CI_JOB_TOKEN" "${download_url}"

mkdir -p public
mv "$filename" public/

echo "Replacing LINK_TO_RUST_EXAMPLE_CONTRACTS with $filename"
find public/ -type f -print0 -iname "*.html" | xargs -0 sed -i "s/LINK_TO_RUST_EXAMPLE_CONTRACTS/$filename/g"
