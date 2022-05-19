function replace_dependency_path() {
  echo "Removing dependencies folder"
  rm -rf dependencies/
  rm -rf binder-test/
  rm -f binder-integration-test.sh
  rm -f version.txt
  # shellcheck disable=SC2164
  pushd src
  rm -f test.rs
  # shellcheck disable=SC2164
  popd
  echo "Patching Cargo.toml"
  sed -i 's/dependencies\/rust-/\.\.\/\.\.\//g' Cargo.toml
  echo "Patching lib.rs"
  sed -i 's/mod test\;//g' src/lib.rs
}

function delete_cargo_partisia_tests() {
  echo "Removing testdata folder"
  rm -rf testdata
}

function delete_sdk_tests() {
    echo "Deleting SDK test for each subfolder"
    rm -r sdk_tests/
    shopt -s globstar
    for f in *; do
      # shellcheck disable=SC1073
      if [ -d "$f" ]; then
        # shellcheck disable=SC2164
        pushd "${f}"
        # shellcheck disable=SC2164
        rm -rf tests
        rm -rf unit_tests
        rm -f .gitignore
        # shellcheck disable=SC2164
        popd
      fi
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
  [version_ref]='tags/0.2.9'
  [post_process]='delete_cargo_partisia_tests'
)

# shellcheck disable=SC2034
declare -A content1=(
  [repo]='gitlab.com/privacyblockchain/language/rust-contract-sdk.git'
  [output]='contract-sdk'
  [version_ref]='tags/7.0.0'
  [post_process]='delete_sdk_tests'
)

# shellcheck disable=SC2034
declare -A content2=(
  [repo]='gitlab.com/privacyblockchain/language/rust-example-token-contract.git'
  [output]='contracts/example-token-contract'
  [version_ref]='tags/0.2.8-sdk-7.0.0'
  [post_process]='replace_dependency_path'
)

# shellcheck disable=SC2034
declare -A content3=(
  [repo]='gitlab.com/privacyblockchain/language/rust-example-voting-contract.git'
  [output]='contracts/example-voting-contract'
  [version_ref]='tags/0.2.4-sdk-7.0.0'
  [post_process]='replace_dependency_path'
)

# shellcheck disable=SC2034
declare -A content4=(
  [repo]='gitlab.com/privacyblockchain/language/rust-example-auction-contract.git'
  [output]='contracts/example-auction-contract'
  [version_ref]='tags/0.1.5-sdk-7.0.0'
  [post_process]='replace_dependency_path'
)

# shellcheck disable=SC2034
declare -n content
