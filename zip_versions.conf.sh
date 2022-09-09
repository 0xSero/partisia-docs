function contract_cleanup() {
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
    -e 's/secata\/pbc\/language\/contract-sdk/partisiablockchain\/language\/contract-sdk/g' \
    Cargo.toml
  echo "Patching lib.rs"
  sed -i 's/mod test\;//g' src/lib.rs
}

function zk_contract_cleanup() {
  rm -f README.md
  # shellcheck disable=SC2164
  pushd src
  rm -f zk_test.rs
  # shellcheck disable=SC2164
  popd
  echo "Patching Cargo.toml"
  sed -i -e '/\[\[test\]\]/,+2d' \
    -e '/\[package\.metadata\.partisiablockchain\]/,+1d' \
    -e "/\[package\.metadata\.zkcompiler\]/{ n; s/download_method = \"mvn\"/download_method = \"http\"/; n; n; s/https:\/\/nexus\.secata\.com\/repository\/mvn/https:\/\/gitlab\.com\/api\/v4\/projects\/37549006\/packages\/maven/; n; s/com\.partisia\.language/com\.partisiablockchain\.language/; n; n; s/version = .*/version = \"${ZK_COMPILER_VERSION}\"/ }" \
    -e 's/ssh:\/\//https:\/\//g' \
    -e 's/secata\/pbc\/language\/contract-sdk/partisiablockchain\/language\/contract-sdk/g' \
    Cargo.toml
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

ZK_COMPILER_VERSION="3.0.18"

ZK_COMPILER_VERSION="${ZK_COMPILER_VERSION/"."/"\."}"

# shellcheck disable=SC2034
declare -A content1=(
  [repo]='gitlab.com/secata/pbc/language/contracts/token.git'
  [output]='contracts/example-token-contract'
  [version_ref]='tags/0.2.15-sdk-9.1.2'
  [post_process]='contract_cleanup'
)

# shellcheck disable=SC2034
declare -A content2=(
  [repo]='gitlab.com/secata/pbc/language/contracts/voting.git'
  [output]='contracts/example-voting-contract'
  [version_ref]='tags/0.2.9-sdk-9.1.2'
  [post_process]='contract_cleanup'
)

# shellcheck disable=SC2034
declare -A content3=(
  [repo]='gitlab.com/secata/pbc/language/contracts/auction.git'
  [output]='contracts/example-auction-contract'
  [version_ref]='tags/0.1.12-sdk-9.1.2'
  [post_process]='contract_cleanup'
)

# shellcheck disable=SC2034
declare -A content4=(
  [repo]='gitlab.com/secata/pbc/language/contracts/nft.git'
  [output]='contracts/example-nft-contract'
  [version_ref]='tags/0.1.4-sdk-9.1.2'
  [post_process]='contract_cleanup'
)

# shellcheck disable=SC2034
declare -A content5=(
  [repo]='gitlab.com/secata/pbc/language/contracts/zk-voting.git'
  [output]='contracts/example-zk-voting'
  [version_ref]='tags/0.1.4-sdk-9.1.2'
  [post_process]='zk_contract_cleanup'
)

# shellcheck disable=SC2034
declare -A content6=(
  [repo]='gitlab.com/secata/pbc/language/contracts/zk-second-price-auction.git'
  [output]='contracts/example-zk-second-price-auction'
  [version_ref]='tags/0.1.2-sdk-9.1.2'
  [post_process]='zk_contract_cleanup'
)

# shellcheck disable=SC2034
declare -A content7=(
  [repo]='gitlab.com/secata/pbc/language/contracts/zk-average-salary.git'
  [output]='contracts/example-zk-average-salary'
  [version_ref]='tags/0.1.3-sdk-9.1.2'
  [post_process]='zk_contract_cleanup'
)

# shellcheck disable=SC2034
declare -n content
