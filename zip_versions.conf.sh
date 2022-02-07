function replace_dependency_path() {
  echo "Removing dependencies folder"
  rm -rf dependencies/
  echo "Patching Cargo.toml"
  sed 's/"dependencies/"..\/../g' Cargo.toml >Cargo.toml
}

declare -A content0=(
  [repo]='gitlab.com/privacyblockchain/language/cargo-partisia-contract.git'
  [output]='cargo-partisia-contract'
  [version_ref]='master'
  [post_process]='true'
)

declare -A content1=(
  [repo]='gitlab.com/privacyblockchain/language/rust-contract-sdk.git'
  [output]='rust-contract-sdk'
  [version_ref]='master'
  [post_process]='true'
)

declare -A content2=(
  [repo]='gitlab.com/privacyblockchain/language/rust-example-token-contract.git'
  [output]='examples/rust-example-token-contract'
  [version_ref]='master'
  [post_process]='replace_dependency_path'
)

declare -A content3=(
  [repo]='gitlab.com/privacyblockchain/language/rust-example-voting-contract.git'
  [output]='examples/rust-example-voting-contract'
  [version_ref]='master'
  [post_process]='replace_dependency_path'
)

declare -n content
