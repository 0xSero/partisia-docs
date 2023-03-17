function contract_cleanup() {
  rm -f README.md
  rm -f -r contract-tests
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
  rm -f -r contract-tests
  # shellcheck disable=SC2164
  pushd src
  rm -f zk_test.rs
  # shellcheck disable=SC2164
  popd
  echo "Patching Cargo.toml"
  sed -i -e '/\[\[test\]\]/,+2d' \
    -e '/\[package\.metadata\.partisiablockchain\]/,+1d' \
    -e "/\[package\.metadata\.zkcompiler\]/{ n; s/https:\/\/nexus\.secata\.com\/repository\/mvn\/com\/partisia\/blockchain/https:\/\/gitlab\.com\/api\/v4\/projects\/37549006\/packages\/maven\/com\/partisiablockchain/ }" \
    -e 's/ssh:\/\//https:\/\//g' \
    -e 's/secata\/pbc\/language\/contract-sdk/partisiablockchain\/language\/contract-sdk/g' \
    Cargo.toml
}

function get_current_version() {
  compiler_version=$(head -n 1 compiler-version.txt)
  if [[ "$CI_COMMIT_REF_NAME" != "$CI_DEFAULT_BRANCH" ]]; then
    echo "${compiler_version}-${CI_COMMIT_SHORT_SHA}"
  else
    echo "${compiler_version}"
  fi
}

if [[ "${CI}" == "true" ]]; then
  URL_PREFIX="https://gitlab-ci-token:${CI_JOB_TOKEN}"
else
  URL_PREFIX="ssh://git"
fi
export URL_PREFIX

ZK_COMPILER_VERSION="3.63.0"

ZK_COMPILER_VERSION="${ZK_COMPILER_VERSION/"."/"\."}"

# shellcheck disable=SC2034
declare -A content01=(
  [repo]='gitlab.com/secata/pbc/language/contracts/token.git'
  [output]='contracts/token'
  [version_ref]='tags/v.0.15.0-sdk-13.1.0'
  [post_process]='contract_cleanup'
)

# shellcheck disable=SC2034
declare -A content02=(
  [repo]='gitlab.com/secata/pbc/language/contracts/voting.git'
  [output]='contracts/voting'
  [version_ref]='tags/v.1.7.0-sdk-13.1.0'
  [post_process]='contract_cleanup'
)

# shellcheck disable=SC2034
declare -A content03=(
  [repo]='gitlab.com/secata/pbc/language/contracts/auction.git'
  [output]='contracts/auction'
  [version_ref]='tags/v.0.10.0-sdk-13.1.0'
  [post_process]='contract_cleanup'
)

# shellcheck disable=SC2034
declare -A content04=(
  [repo]='gitlab.com/secata/pbc/language/contracts/nft.git'
  [output]='contracts/nft'
  [version_ref]='tags/v.0.8.0-sdk-13.1.0'
  [post_process]='contract_cleanup'
)

# shellcheck disable=SC2034
declare -A content05=(
  [repo]='gitlab.com/secata/pbc/language/contracts/zk-voting.git'
  [output]='contracts/zk-voting'
  [version_ref]='tags/v.0.6.0-sdk-13.1.0'
  [post_process]='zk_contract_cleanup'
)

# shellcheck disable=SC2034
declare -A content06=(
  [repo]='gitlab.com/secata/pbc/language/contracts/zk-second-price-auction.git'
  [output]='contracts/zk-second-price-auction'
  [version_ref]='tags/v.0.7.0-sdk-13.1.0'
  [post_process]='zk_contract_cleanup'
)

# shellcheck disable=SC2034
declare -A content07=(
  [repo]='gitlab.com/secata/pbc/language/contracts/zk-average-salary.git'
  [output]='contracts/zk-average-salary'
  [version_ref]='tags/v.0.8.0-sdk-13.1.0'
  [post_process]='zk_contract_cleanup'
)

declare -A content08=(
  [repo]='gitlab.com/secata/pbc/language/contracts/conditional-escrow-transfer.git'
  [output]='contracts/conditional-escrow-transfer'
  [version_ref]='tags/v.0.7.0-sdk-13.1.0'
  [post_process]='contract_cleanup'
)

declare -A content09=(
  [repo]='gitlab.com/secata/pbc/language/contracts/liquidity-swap.git'
  [output]='contracts/liquidity-swap'
  [version_ref]='tags/v.1.12.0-sdk-13.1.0'
  [post_process]='contract_cleanup'
)

declare -A content10=(
  [repo]='gitlab.com/secata/pbc/language/contracts/multi-voting.git'
  [output]='contracts/multi-voting'
  [version_ref]='tags/v.1.5.0-sdk-13.1.0'
  [post_process]='contract_cleanup'
)

# shellcheck disable=SC2034
declare -n content
