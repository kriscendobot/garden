#!/bin/bash
# Regression coverage for skills/panel-hints/probes/B-sibling-family.sh, the
# sensing half of the `incomplete-sibling-transformation` review-miss cluster
# (correctness-bug; grounding endojs/endo-but-for-bots #475 and #1099). Each
# assertion feeds the probe a file list via --files-stdin (the historical diffs
# the four cluster members occurred in) and checks it fires the breaker, and that
# a diff touching no seeded sibling family abstains.

set -uo pipefail

ROOT=$(cd "$(dirname "$0")/../../.." && pwd)
PROBE="$ROOT/skills/panel-hints/probes/B-sibling-family.sh"

passes=0
failures=0
ok() { echo "ok - $1"; passes=$((passes + 1)); }
bad() { echo "not ok - $1"; failures=$((failures + 1)); }

fires() { # <name> <files...>
  local name="$1"; shift
  local out
  out=$(printf '%s\n' "$@" | "$PROBE" --files-stdin 2>&1)
  case "$out" in
    "fire breaker"*) ok "$name — $out" ;;
    *) bad "$name did not fire: $out" ;;
  esac
}

abstains() { # <name> <files...>
  local name="$1"; shift
  local out
  out=$(printf '%s\n' "$@" | "$PROBE" --files-stdin 2>&1)
  case "$out" in
    "skip breaker") ok "$name abstains" ;;
    *) bad "$name should abstain: $out" ;;
  esac
}

# --- Member re-litigation: the real historical diffs where each miss occurred ---

# #1099 (1) hex/base64: 048f439f3 gave hex the immutability gate; base64 untouched.
fires 'pr1099 hex without base64 twin (048f439f3)' \
  packages/hex/package.json packages/hex/src/encode.js packages/hex/tsconfig.composite.json

# #1099 (2) harden/ses: 729ab06a2 converted harden; ses untouched (one-sided).
fires 'pr1099 harden without ses twin (729ab06a2)' \
  packages/harden/make-hardener.js \
  packages/harden/test/make-hardener-immutable-typed-array.test.js

# #1099 (2) harden/ses at PR granularity: both twins touched but divergent — the
# both-touched case a one-sided-only probe would have missed.
fires 'pr1099 harden+ses both touched, divergent (PR diff)' \
  packages/harden/make-hardener.js packages/ses/src/make-hardener.js

# #475 f66ed689: immutable-arraybuffer lib.js hosts the paired DataView/TypedArray
# emulation constructors (buggy predecessor a4767d542, fix 4dbe5ffff).
fires 'pr475 immutable-arraybuffer lib.js host (a4767d542 / 4dbe5ffff)' \
  packages/immutable-arraybuffer/src/lib.js

# --- Controls ---

# A diff touching no seeded sibling family abstains (6ee3fda77 fix(cbor)).
abstains 'unrelated cbor diff (6ee3fda77)' \
  packages/cbor/test/cbor.test.js

# Prefix-collision guard: packages/hexdump is not packages/hex.
abstains 'hexdump is not the hex twin' \
  packages/hexdump/src/index.js

echo "1..$((passes + failures))"
echo "# passes=$passes failures=$failures"
[ "$failures" -eq 0 ]
