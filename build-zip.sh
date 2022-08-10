#!/usr/bin/env bash
set -e

source zip_versions.conf.sh

function clone_and_clean() {
  echo "Cloning $1 tag $3 into $2"
  git clone --recursive "$1" "$2"

  pushd "$2" || exit
  echo "Checking $3"
  git checkout "$3"

  echo "Removing git indices and pipeline definition"
  rm -rf .git/
  rm -f .gitignore
  rm -f .gitmodules
  rm .gitlab-ci.yml

  echo "Running post_process: '$post_process'"
  eval "$4"

  popd || exit
}

# Version
sdk_version=$(get_current_version)
filename="partisia-sdk-${sdk_version}.zip"

# Make zip build directory
mkdir -p build_zip

# Copy readme into the directory
cp sdk-readme.md build_zip/README.md

pushd build_zip || exit

# Create the examples folder
mkdir -p contracts

for content in ${!content@}; do
  url="${URL_PREFIX}@${content[repo]}"
  ref="${content[version_ref]}"
  folder="${content[output]}"
  post_process="${content[post_process]}"

  clone_and_clean "$url" "$folder" "$ref" "$post_process"
done
curl ${NETRC} "https://nexus.secata.com/repository/mvn/com/partisia/language/zkcompiler/${ZK_COMPILER_VERSION}/zkcompiler-${ZK_COMPILER_VERSION}-jar-with-dependencies.jar" -o "${ZK_COMPILER_OUTPUT}"
# Compress everything in the build_zip folder to sdk.zip
zip -9r "sdk.zip" *

# Rename sdk.zip to partisia-sdk-<version>.zip
mv sdk.zip "$filename"

url="${CI_API_V4_URL}/projects/${CI_PROJECT_ID}/packages/generic/partisia-sdk/${sdk_version}/${filename}?select=package_file"

echo "======================================================="
echo "The newest package version is: $sdk_version"
echo ""
echo "Uploading ${filename} to ${url}"

curl -o /dev/null -w "%{http_code}\n" --header "JOB-TOKEN: $CI_JOB_TOKEN" --upload-file "${filename}" "${url}"
