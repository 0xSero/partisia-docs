function contract_cleanup() {
  echo "Removing dependencies folder"
  rm -rf dependencies/
  rm -rf binder-test/
  rm -f binder-integration-test.sh
  rm -f version.txt
  rm -f README.md
  # shellcheck disable=SC2164
  pushd src
  rm -f test.rs
  # shellcheck disable=SC2164
  popd
  echo "Patching Cargo.toml"
  sed -i -e '/\[package\.metadata\.partisiablockchain\]/,+1d' \
    -e 's/ssh:\/\//https:\/\//g' \
    -e 's/secata\/pbc\/language\/rust-contract-sdk/partisiablockchain\/language\/contract-sdk/g' \
    Cargo.toml
  echo "Patching lib.rs"
  sed -i 's/mod test\;//g' src/lib.rs
}

function zk_contract_cleanup() {
  echo "Removing dependencies folder"
  rm -rf dependencies/
  rm -f README.md
  # shellcheck disable=SC2164
  pushd src
  rm -f zk_lib.rs
  rm -f zk_test.rs
  # shellcheck disable=SC2164
  popd
  echo "Patching Cargo.toml"
  sed -i -e '/\[\[test\]\]/,+2d' \
    -e '/\[package\.metadata\.partisiablockchain\]/,+1d' \
    -e 's/download_method = "mvn"/download_method = "http"/g' \
    -e 's/com\.partisia\.language/com\.partisiablockchain\.language/g' \
    -e 's/https:\/\/nexus\.secata\.com\/repository\/mvn/https:\/\/gitlab\.com\/api\/v4\/projects\/37549006\/packages\/maven/g' \
    -e 's/ssh:\/\//https:\/\//g' \
    -e 's/secata\/pbc\/language\/rust-contract-sdk/partisiablockchain\/language\/contract-sdk/g' \
    Cargo.toml


  echo "Patching zk_compute.rs"
  sed -i '/use crate::zk_lib::\*;/d' src/zk_compute.rs
}

function delete_cargo_partisia_tests() {
  echo "Removing testdata folder"
  rm -rf testdata
}

function delete_sdk_tests() {
  echo "Deleting SDK test for each subfolder"
  rm -r sdk_tests/
  rm README.md
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

if [[ "${CI}" == "true" ]]; then
  URL_PREFIX="https://gitlab-ci-token:${CI_JOB_TOKEN}"
else
  URL_PREFIX="ssh://git"
fi
export URL_PREFIX

# shellcheck disable=SC2034
declare -A content0=(
  [repo]='gitlab.com/privacyblockchain/language/cargo-partisia-contract.git'
  [output]='cargo-partisia-contract'
  [version_ref]='tags/0.2.9'
  [post_process]='delete_cargo_partisia_tests'
)

# shellcheck disable=SC2034
declare -A content1=(
  [repo]='gitlab.com/privacyblockchain/language/contracts/token.git'
  [output]='contracts/example-token-contract'
  [version_ref]='tags/0.2.14-sdk-9.1.1'
  [post_process]='contract_cleanup'
)

# shellcheck disable=SC2034
declare -A content2=(
  [repo]='gitlab.com/privacyblockchain/language/contracts/voting.git'
  [output]='contracts/example-voting-contract'
  [version_ref]='tags/0.2.8-sdk-9.1.1'
  [post_process]='contract_cleanup'
)

# shellcheck disable=SC2034
declare -A content3=(
  [repo]='gitlab.com/privacyblockchain/language/contracts/auction.git'
  [output]='contracts/example-auction-contract'
  [version_ref]='tags/0.1.11-sdk-9.1.1'
  [post_process]='contract_cleanup'
)

# shellcheck disable=SC2034
declare -A content4=(
  [repo]='gitlab.com/privacyblockchain/language/contracts/nft.git'
  [output]='contracts/example-nft-contract'
  [version_ref]='tags/0.1.3-sdk-9.1.1'
  [post_process]='contract_cleanup'
)

# shellcheck disable=SC2034
declare -A content5=(
  [repo]='gitlab.com/privacyblockchain/language/contracts/zk-voting.git'
  [output]='contracts/example-zk-voting'
  [version_ref]='tags/0.1.3-sdk-9.1.1'
  [post_process]='zk_contract_cleanup'
)

# shellcheck disable=SC2034
declare -A content6=(
  [repo]='gitlab.com/privacyblockchain/language/contracts/zk-second-price-auction.git'
  [output]='contracts/example-zk-second-price-auction'
  [version_ref]='tags/0.1.1-sdk-9.1.1'
  [post_process]='zk_contract_cleanup'
)

# shellcheck disable=SC2034
declare -A content7=(
  [repo]='gitlab.com/privacyblockchain/language/contracts/zk-average-salary.git'
  [output]='contracts/example-zk-average-salary'
  [version_ref]='tags/0.1.2-sdk-9.1.1'
  [post_process]='zk_contract_cleanup'
)

# shellcheck disable=SC2034
declare -n content
