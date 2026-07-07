#!/bin/bash
# install-aws-cli.sh — user-local AWS CLI v2 install, no root, idempotent.
#
# Usage: install-aws-cli.sh
#
# Installs the official AWS CLI v2 into ~/.local (install dir ~/.local/aws-cli,
# launcher symlinks in ~/.local/bin) so the garden fleet gets `aws` without any
# system package or root. The official v2 installer supports exactly this with
# its --install-dir / --bin-dir / --update flags, and --update makes a re-run a
# safe upgrade-or-noop, so this script is idempotent: run it as often as you like.
#
# Container note: inside a gardener container HOME is the checkout path, so this
# lands under <checkout>/.local, which .gitignore excludes (the /.[!.]* rule).
# On the host, HOME is the login home and it lands under ~/.local there. Either
# way ~/.local/bin must be on PATH for `aws` to resolve; the script prints the
# line to add if it is not already there.
set -euo pipefail

INSTALL_DIR="${AWS_CLI_INSTALL_DIR:-$HOME/.local/aws-cli}"
BIN_DIR="${AWS_CLI_BIN_DIR:-$HOME/.local/bin}"

case "$(uname -m)" in
  x86_64|amd64)        AWS_ARCH="x86_64" ;;
  aarch64|arm64)       AWS_ARCH="aarch64" ;;
  *) echo "install-aws-cli: unsupported architecture $(uname -m)" >&2; exit 1 ;;
esac
ZIP_URL="https://awscli.amazonaws.com/awscli-exe-linux-${AWS_ARCH}.zip"

for tool in curl unzip; do
  command -v "$tool" >/dev/null 2>&1 || {
    echo "install-aws-cli: '$tool' is required but not on PATH" >&2; exit 1; }
done

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

echo "install-aws-cli: downloading AWS CLI v2 ($AWS_ARCH) ..."
curl -fsSL "$ZIP_URL" -o "$tmp/awscliv2.zip"
unzip -q "$tmp/awscliv2.zip" -d "$tmp"

# --update turns a second run into an in-place upgrade instead of an error, which
# is what makes this whole script idempotent.
mkdir -p "$INSTALL_DIR" "$BIN_DIR"
"$tmp/aws/install" --install-dir "$INSTALL_DIR" --bin-dir "$BIN_DIR" --update

ver="$("$BIN_DIR/aws" --version 2>&1)" || {
  echo "install-aws-cli: installed but '$BIN_DIR/aws --version' failed" >&2; exit 1; }
echo "install-aws-cli: ok — $ver"

case ":$PATH:" in
  *":$BIN_DIR:"*) : ;;
  *) echo "install-aws-cli: add $BIN_DIR to PATH, for example:"
     echo "  export PATH=\"$BIN_DIR:\$PATH\"" ;;
esac
