function replace_dependency_path() {
  echo "Removing dependencies folder"
  rm -rf dependencies/
  rm -rf binder-test/
  rm -f binder-integration-test.sh
  echo "Patching Cargo.toml"
  sed -i 's/"dependencies/"..\/../g' Cargo.toml
}

function delete_sdk_tests() {
    echo "Deleting SDK test for each subfolder"
    rm -r sdk_tests/
    shopt -s globstar
    for f in ./**/Cargo.toml; do
      echo "Found file"
      f="${f#./}"
      # shellcheck disable=SC2034
      child_folder="${f%%/Cargo.toml}"
      echo "${child_folder}"
      # shellcheck disable=SC2164
      pushd child_folder
      rm -rf tests
      rm -rf unit_tests
      # shellcheck disable=SC2164
      popd
    done

}

function get_current_version() {
  sdk_version=$(head -n 1 version.txt)
  if [[ "$CI_COMMIT_REF_NAME" != "$CI_DEFAULT_BRANCH" ]]; then
    echo "${sdk_version}-${CI_COMMIT_SHORT_SHA}"
  else
    echo "${sdk_version}"
  fi
}

# shellcheck disable=SC2034
declare -A content0=(
  [repo]='gitlab.com/privacyblockchain/language/cargo-partisia-contract.git'
  [output]='cargo-partisia-contract'
  [version_ref]='tags/0.2.8'
  [post_process]='true'
)

# shellcheck disable=SC2034
declare -A content1=(
  [repo]='gitlab.com/privacyblockchain/language/rust-contract-sdk.git'
  [output]='contract-sdk'
  [version_ref]='tags/6.1.0'
  [post_process]='delete_sdk_tests'
)

# shellcheck disable=SC2034
declare -A content2=(
  [repo]='gitlab.com/privacyblockchain/language/rust-example-token-contract.git'
  [output]='examples/example-token-contract'
  [version_ref]='tags/0.2.6-sdk-6.1.0'
  [post_process]='replace_dependency_path'
)

# shellcheck disable=SC2034
declare -A content3=(
  [repo]='gitlab.com/privacyblockchain/language/rust-example-voting-contract.git'
  [output]='examples/example-voting-contract'
  [version_ref]='tags/0.2.3-sdk-6.1.0'
  [post_process]='replace_dependency_path'
)

# shellcheck disable=SC2034
declare -A content4=(
  [repo]='gitlab.com/privacyblockchain/language/rust-example-auction-contract.git'
  [output]='examples/example-auction-contract'
  [version_ref]='tags/0.1.4-sdk-6.1.0'
  [post_process]='replace_dependency_path'
)

# shellcheck disable=SC2034
declare -n content
