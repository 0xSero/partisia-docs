function contract_cleanup() {
  rm -f README.md
  rm -f -r contract-tests
  # shellcheck disable=SC2164
  pushd src
  rm -f test.rs
  rm -f tests.rs
  # shellcheck disable=SC2164
  popd
  echo "Patching Cargo.toml"
  sed -i -e '/\[package\.metadata\.partisiablockchain\]/,+1d' \
    -e '/contract-integrationtest/d' \
    -e 's/ssh:\/\//https:\/\//g' \
    -e 's/secata\/pbc\/language\/contract-sdk/partisiablockchain\/language\/contract-sdk/g' \
    Cargo.toml
  echo "Patching lib.rs"
  sed -i '/\#\[cfg(test)\]/d' src/lib.rs
  sed -i '/mod test\;/d' src/lib.rs
  sed -i '/mod tests\;/d' src/lib.rs
}

function token_or_auction_cleanup() {
  mv src/main/rust/lib.rs src/lib.rs
  rm -r src/main
  rm -r src/test
  rm pom.xml
  rm run-contract-tests.sh
  sed -i -e 's/src\/main\/rust\/lib.rs/src\/lib.rs/g' Cargo.toml
  contract_cleanup
}

function zk_contract_cleanup() {
  rm -f README.md
  rm -f -r contract-tests
  mv src/contract.rs src/lib.rs 2>/dev/null || true
  # shellcheck disable=SC2164
  pushd src
  rm -f zk_test.rs
  rm -f tests.rs
  # shellcheck disable=SC2164
  popd
  echo "Patching Cargo.toml"
  sed -i -e '/\[\[test\]\]/,+2d' \
    -e 's/src\/contract.rs/src\/lib.rs/g' \
    -e '/\[package\.metadata\.partisiablockchain\]/,+1d' \
    -e "/\[package\.metadata\.zkcompiler\]/{ n; s/https:\/\/nexus\.secata\.com\/repository\/mvn\/com\/partisia\/blockchain/https:\/\/gitlab\.com\/api\/v4\/projects\/37549006\/packages\/maven\/com\/partisiablockchain/; s/zkcompiler\/.*\//zkcompiler\/${ZK_COMPILER_VERSION}\//; s/zkcompiler\-.*\-jar/zkcompiler\-${ZK_COMPILER_VERSION}\-jar/}" \
    -e 's/ssh:\/\//https:\/\//g' \
    -e 's/secata\/pbc\/language\/contract-sdk/partisiablockchain\/language\/contract-sdk/g' \
    Cargo.toml

  sed -i '/\#\[cfg(test)\]/d' src/lib.rs
  sed -i '/mod tests\;/d' src/lib.rs
}

function get_current_version() {
  contract_examples_version=$(head -n 1 contract-examples-version.txt)
  if [[ "$CI_COMMIT_REF_NAME" != "$CI_DEFAULT_BRANCH" ]]; then
    echo "$contract_examples_version-${CI_COMMIT_SHORT_SHA}"
  else
    echo "$contract_examples_version"
  fi
}

if [[ "${CI}" == "true" ]]; then
  URL_PREFIX="https://gitlab-ci-token:${CI_JOB_TOKEN}"
else
  URL_PREFIX="ssh://git"
fi
export URL_PREFIX

ZK_COMPILER_VERSION="3.63.0"

ZK_COMPILER_VERSION="${ZK_COMPILER_VERSION//'.'/'\.'}"

# shellcheck disable=SC2034
declare -A content01=(
  [repo]='gitlab.com/secata/pbc/language/contracts/token.git'
  [output]='contracts/token'
  [version_ref]='tags/v.0.19.0'
  [post_process]='token_or_auction_cleanup'
)

# shellcheck disable=SC2034
declare -A content02=(
  [repo]='gitlab.com/secata/pbc/language/contracts/voting.git'
  [output]='contracts/voting'
  [version_ref]='tags/v.1.9.0'
  [post_process]='contract_cleanup'
)

# shellcheck disable=SC2034
declare -A content03=(
  [repo]='gitlab.com/secata/pbc/language/contracts/auction.git'
  [output]='contracts/auction'
  [version_ref]='tags/v.0.13.0'
  [post_process]='token_or_auction_cleanup'
)

# shellcheck disable=SC2034
declare -A content04=(
  [repo]='gitlab.com/secata/pbc/language/contracts/nft.git'
  [output]='contracts/nft'
  [version_ref]='tags/v.0.10.0'
  [post_process]='contract_cleanup'
)

# shellcheck disable=SC2034
declare -A content05=(
  [repo]='gitlab.com/secata/pbc/language/contracts/zk-voting-simple.git'
  [output]='contracts/zk-voting-simple'
  [version_ref]='tags/v.0.8.0'
  [post_process]='zk_contract_cleanup'
)

# shellcheck disable=SC2034
declare -A content06=(
  [repo]='gitlab.com/secata/pbc/language/contracts/zk-second-price-auction.git'
  [output]='contracts/zk-second-price-auction'
  [version_ref]='tags/v.0.10.0'
  [post_process]='zk_contract_cleanup'
)

# shellcheck disable=SC2034
declare -A content07=(
  [repo]='gitlab.com/secata/pbc/language/contracts/zk-average-salary.git'
  [output]='contracts/zk-average-salary'
  [version_ref]='tags/v.0.11.0'
  [post_process]='zk_contract_cleanup'
)

# shellcheck disable=SC2034
declare -A content08=(
  [repo]='gitlab.com/secata/pbc/language/contracts/conditional-escrow-transfer.git'
  [output]='contracts/conditional-escrow-transfer'
  [version_ref]='tags/v.0.9.0'
  [post_process]='contract_cleanup'
)

# shellcheck disable=SC2034
declare -A content09=(
  [repo]='gitlab.com/secata/pbc/language/contracts/liquidity-swap.git'
  [output]='contracts/liquidity-swap'
  [version_ref]='tags/v.1.14.0'
  [post_process]='contract_cleanup'
)

# shellcheck disable=SC2034
declare -A content10=(
  [repo]='gitlab.com/secata/pbc/language/contracts/multi-voting.git'
  [output]='contracts/multi-voting'
  [version_ref]='tags/v.1.7.0'
  [post_process]='contract_cleanup'
)

# shellcheck disable=SC2034
declare -A content12=(
  [repo]='gitlab.com/secata/pbc/language/contracts/zk-liquidity-swap.git'
  [output]='contracts/zk-liquidity-swap'
  [version_ref]='tags/v.2.2.0'
  [post_process]='zk_contract_cleanup'
)

# shellcheck disable=SC2034
declare -A content13=(
  [repo]='gitlab.com/secata/pbc/language/contracts/zk-struct-open.git'
  [output]='contracts/zk-struct-open'
  [version_ref]='tags/v.0.4.0'
  [post_process]='zk_contract_cleanup'
)

# shellcheck disable=SC2034
declare -n content
