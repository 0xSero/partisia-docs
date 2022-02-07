#!/usr/bin/env bash
set -e

source zip_versions.conf.sh

function clone_and_clean() {
  echo "Cloning $1 tag $3 into $2"
  git clone --recursive "$1" "$2"

  pushd "$2" || exit
  echo "Checking tags/$3"
  git checkout "$3"

  echo "Removing git indices and pipeline definition"
  rm -rf .git/
  rm .gitlab-ci.yml

  echo "Running post_process: '$post_process'"
  eval "$4"

  popd || exit
}

mkdir -p build_zip
pushd build_zip || exit

mkdir -p examples

for content in ${!content@}; do
    url="https://gitlab-ci-token:${CI_JOB_TOKEN}@${content[repo]}"
    ref="${content[version_ref]}"
    folder="${content[output]}"
    post_process="${content[post_process]}"

    clone_and_clean "$url" "$folder" "$ref" "$post_process"
done

sdk_version=$(head -n 1 ../version.txt)
filename="partisia-sdk-${sdk_version}.zip"

zip -9r "sdk.zip" *
mv sdk.zip "$filename"

url="${CI_API_V4_URL}/projects/${CI_PROJECT_ID}/packages/generic/partisia-sdk/${sdk_version}/${filename}?select=package_file"

echo "======================================================="
echo "The newest package version is: $sdk_version"
echo ""
echo "Uploading ${filename} to ${url}"

curl -o /dev/null -w "%{http_code}\n" --header "JOB-TOKEN: $CI_JOB_TOKEN" --upload-file "${filename}" "${url}"

