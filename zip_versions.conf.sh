function replace_dependency_path() {
  echo "Removing dependencies folder"
  rm -rf dependencies/
  echo "Patching Cargo.toml"
  sed -i 's/"dependencies/"..\/../g' Cargo.toml
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
  [version_ref]='tags/0.2.6'
  [post_process]='true'
)

# shellcheck disable=SC2034
declare -A content1=(
  [repo]='gitlab.com/privacyblockchain/language/rust-contract-sdk.git'
  [output]='rust-contract-sdk'
  [version_ref]='tags/3.1.0'
  [post_process]='true'
)

# shellcheck disable=SC2034
declare -A content2=(
  [repo]='gitlab.com/privacyblockchain/language/rust-example-token-contract.git'
  [output]='examples/rust-example-token-contract'
  [version_ref]='0.2.1-a-sdk-3.1.0'
  [post_process]='replace_dependency_path'
)

# shellcheck disable=SC2034
declare -A content3=(
  [repo]='gitlab.com/privacyblockchain/language/rust-example-voting-contract.git'
  [output]='examples/rust-example-voting-contract'
  [version_ref]='0.2.2-sdk-3.1.0'
  [post_process]='replace_dependency_path'
)

# shellcheck disable=SC2034
declare -n content
