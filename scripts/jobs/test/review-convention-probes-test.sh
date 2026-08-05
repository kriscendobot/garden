#!/bin/bash
# Regression coverage for the deterministic probes added after the consolidated
# 2026-08-04 review retrospective.

set -uo pipefail

ROOT=$(cd "$(dirname "$0")/../../.." && pwd)
PREFER="$ROOT/scripts/jobs/gardening/pre-push-gates/probes/prefer-endo-primitives.sh"
SPELL="$ROOT/scripts/jobs/gardening/pre-push-gates/probes/spell-out-identifiers.sh"
PURIST="$ROOT/skills/panel-hints/probes/C-purist.sh"
TEMPORARY_ROOT=$(mktemp -d)
trap 'rm -rf "$TEMPORARY_ROOT"' EXIT

passes=0
failures=0
ok() { echo "ok - $1"; passes=$((passes + 1)); }
bad() { echo "not ok - $1"; failures=$((failures + 1)); }

expect_prefer_failure() {
  local package="$1" source="$2" output
  output=$(printf '%s\n' "$source" | "$PREFER" --scan-stdin fixture.js 2>&1) && {
    bad "$package signature passed"; return
  }
  printf '%s\n' "$output" | grep -Fq "use $package" \
    && ok "$package signature fires" \
    || bad "$package finding did not name the replacement: $output"
}

expect_prefer_failure '@endo/sha256' \
  "const digest = createHash('sha256').update(bytes).digest();"
expect_prefer_failure '@endo/bytes' 'const encoder = new TextEncoder();'
expect_prefer_failure '@endo/base64' 'const encoded = btoa(text);'
expect_prefer_failure '@endo/hex' \
  "hex += byte.toString(16).padStart(2, '0');"
expect_prefer_failure '@endo/ascii' \
  'const bytes = Uint8Array.from(text, character => character.charCodeAt(0));'
expect_prefer_failure '@endo/errors' \
  'const insistNatural = value => { if (value < 0) throw Error(); };'

if printf '%s\n' \
    "import { sha256 } from '@endo/sha256';" \
    "const digest = createHash('sha256').update(bytes).digest();" \
    | "$PREFER" --scan-stdin fixture.js | grep -qx pass; then
  ok 'matching @endo import suppresses the hand-roll finding'
else
  bad 'matching @endo import did not suppress the finding'
fi

if printf '%s\n' '// example: new TextEncoder()' \
    | "$PREFER" --scan-stdin fixture.js | grep -qx pass; then
  ok 'prose-only comments do not fire the pre-push probe'
else
  bad 'comment text fired the pre-push probe'
fi

spell_output=$(printf '%s\n' \
  'const listenAddr = address;' \
  'const pendingIdx = pendingInbound.indexOf(session);' \
  | "$SPELL" --scan-stdin fixture.js 2>&1) || true
printf '%s\n' "$spell_output" | grep -Fq '`listenAddr` (`addr`' \
  && ok 'spell-out probe catches Addr from PR 684' \
  || bad 'spell-out probe missed Addr'
printf '%s\n' "$spell_output" | grep -Fq '`pendingIdx` (`idx`' \
  && ok 'spell-out probe retains the PR 806 index recurrence' \
  || bad 'spell-out probe missed pendingIdx'

if printf '%s\n' 'const listenAddress = address;' \
    | "$SPELL" --scan-stdin fixture.js | grep -qx pass; then
  ok 'spelled-out address abstains'
else
  bad 'spelled-out address fired'
fi

# Exercise the staged-diff path, including an import that predates the diff.
REPOSITORY="$TEMPORARY_ROOT/repository"
mkdir -p "$REPOSITORY"
git -C "$REPOSITORY" init -q
git -C "$REPOSITORY" config user.name probe
git -C "$REPOSITORY" config user.email probe@example.invalid
printf '%s\n' "import { encodeHex } from '@endo/hex';" > "$REPOSITORY/codec.js"
git -C "$REPOSITORY" add codec.js
git -C "$REPOSITORY" commit -qm base
printf '%s\n' "hex += byte.toString(16).padStart(2, '0');" >> "$REPOSITORY/codec.js"
git -C "$REPOSITORY" add codec.js
if "$PREFER" "$REPOSITORY" | grep -qx pass; then
  ok 'a pre-existing matching import suppresses a staged finding'
else
  bad 'the staged-diff path ignored a pre-existing matching import'
fi

git -C "$REPOSITORY" reset -q --hard HEAD
printf '%s\n' 'const encoder = new TextEncoder();' > "$REPOSITORY/bytes.js"
git -C "$REPOSITORY" add bytes.js
staged_output=$("$PREFER" "$REPOSITORY" 2>&1) || true
if printf '%s\n' "$staged_output" | grep -Fq 'use @endo/bytes'; then
  ok 'staged hand-roll fails the pre-push probe'
else
  bad 'staged hand-roll escaped the pre-push probe'
fi

git -C "$REPOSITORY" reset -q --hard HEAD
printf '%s\n' '// prefer-endo-primitives-exempt: implementation package' \
  'const encoder = new TextEncoder();' > "$REPOSITORY/bytes.js"
git -C "$REPOSITORY" add bytes.js
if "$PREFER" "$REPOSITORY" | grep -qx pass; then
  ok 'documented per-file exemption works'
else
  bad 'per-file exemption did not work'
fi

# The panel hint is deliberately broader than the blocking gate: Rust base64
# implementations route to the purist for judgment rather than hard-failing.
git -C "$REPOSITORY" reset -q --hard HEAD
base=$(git -C "$REPOSITORY" rev-parse HEAD)
printf '%s\n' 'let encoded = base64::engine::general_purpose::STANDARD.encode(bytes);' \
  > "$REPOSITORY/codec.rs"
git -C "$REPOSITORY" add codec.rs
git -C "$REPOSITORY" commit -qm candidate
panel_output=$(cd "$REPOSITORY" && BASE="$base" bash "$PURIST")
printf '%s\n' "$panel_output" | grep -q '^fire purist matched: base64::' \
  && ok 'Rust base64 implementation deterministically routes to purist' \
  || bad "purist probe missed Rust base64: $panel_output"

echo "$passes passing, $failures failing"
[ "$failures" -eq 0 ]
