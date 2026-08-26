#!/bin/bash
# install-node-tool-shims-test.sh - regression coverage for runtime-relative
# Node tool shims, including the tsd shim required by SES verification.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INSTALLER="$HERE/../gardening/install-node-tool-shims.sh"
TR="$(mktemp -d)"
trap 'rm -rf "$TR"' EXIT

BIN_DIR="$TR/bin"
PROJECT="$TR/project"
CALLER="$PROJECT/packages/example/src"
ENTRYPOINT="$PROJECT/node_modules/tsd/dist/cli.js"
mkdir -p "$CALLER" "$(dirname "$ENTRYPOINT")"

cat > "$ENTRYPOINT" <<'JS'
console.log(`tsd fixture: ${process.argv.slice(2).join(' ')}`);
JS

"$INSTALLER" "$BIN_DIR" >/dev/null

permissions="$(stat -c %A "$BIN_DIR/tsd")"
[ "${permissions:3:1}" = x ] || {
  echo "FAIL: installer did not create an executable tsd shim" >&2
  exit 1
}

output="$(cd "$CALLER" && bash "$BIN_DIR/tsd" --typings index.d.ts)"
[ "$output" = "tsd fixture: --typings index.d.ts" ] || {
  echo "FAIL: tsd shim did not resolve upward from the caller or forward arguments" >&2
  echo "got: $output" >&2
  exit 1
}

set +e
missing_output="$(cd "$TR" && bash "$BIN_DIR/tsd" 2>&1)"
missing_rc=$?
set -e
[ "$missing_rc" -eq 127 ] &&
  [ "$missing_output" = "tsd: no node_modules/{tsd/dist/cli.js} above $TR" ] || {
    echo "FAIL: missing tsd entrypoint did not produce the diagnostic and rc=127" >&2
    echo "rc=$missing_rc output=$missing_output" >&2
    exit 1
  }

echo "PASS: tsd shim resolves from the caller tree and reports missing entrypoints"
