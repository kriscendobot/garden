#!/bin/bash
# ironhorse-fuzz-reproduce-gh.sh — default REPRODUCER seam for ironhorse-fuzz.sh.
#
# Invoked as: ironhorse-fuzz-reproduce-gh.sh <target> <in-file>
#
# Confirms that <in-file> STILL crashes <target> deterministically. Contract:
#   exit 0  -> the input reproduces the crash (a real finding)
#   exit 1  -> the input does NOT crash (a flake / already-fixed — discard)
#   exit 2  -> could not determine (toolchain missing) -> treated by the caller as
#              "does not reproduce" so we never post on an unconfirmed crash.
#
# We run the single input under `cargo fuzz run <target> <in-file> -- -runs=0`, which
# executes the target on exactly that input once. libFuzzer exits NONZERO on a crash,
# ZERO on a clean run — so "reproduces" == the run exited nonzero AFTER a successful
# build. We build first (separately) so a BUILD failure is not mistaken for a crash.
#
# Untrusted-data note: the input is passed to the fuzzer BY PATH only.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../common.sh
source "$HERE/../common.sh"
GARDEN_TAG="ironhorse-fuzz-reproduce"

target="${1:?usage: <target> <in-file>}"
infile="${2:?in-file}"

: "${GARDEN_IRONHORSE_FUZZ_STATE:=$GARDEN_STATE/ironhorse-fuzz}"
: "${GARDEN_IRONHORSE_FUZZ_PROJECT_DIR:=$GARDEN_IRONHORSE_FUZZ_STATE/project}"
: "${GARDEN_IRONHORSE_FUZZ_TOOLCHAIN:=nightly-2026-08-15}"
: "${GARDEN_IRONHORSE_FUZZ_FUZZ_SUBDIR:=rust/engine/ironhorse-fuzz}"
: "${GARDEN_IRONHORSE_FUZZ_REPRO_TIMEOUT_SECS:=120}"

export PATH="$HOME/.cargo/bin:$PATH"
[ -s "$infile" ] || exit 1

command -v cargo >/dev/null 2>&1 || exit 2
FUZZDIR="$GARDEN_IRONHORSE_FUZZ_PROJECT_DIR/$GARDEN_IRONHORSE_FUZZ_FUZZ_SUBDIR"
[ -d "$FUZZDIR/fuzz" ] || exit 2
cargo +"$GARDEN_IRONHORSE_FUZZ_TOOLCHAIN" fuzz --help >/dev/null 2>&1 || exit 2

export CARGO_TARGET_DIR="$GARDEN_IRONHORSE_FUZZ_STATE/target/$target"

# Build the target first so a compile error can't masquerade as a crash.
if ! ( cd "$FUZZDIR" && cargo +"$GARDEN_IRONHORSE_FUZZ_TOOLCHAIN" fuzz build "$target" >/dev/null 2>&1 ); then
  log "WARN: could not build fuzz target $target — cannot confirm reproduction"
  exit 2
fi

rc=0
if command -v timeout >/dev/null 2>&1; then
  ( cd "$FUZZDIR" && timeout --signal=TERM --kill-after=10s "${GARDEN_IRONHORSE_FUZZ_REPRO_TIMEOUT_SECS}s" \
      cargo +"$GARDEN_IRONHORSE_FUZZ_TOOLCHAIN" fuzz run "$target" "$infile" -- -runs=0 >/dev/null 2>&1 ) || rc=$?
else
  ( cd "$FUZZDIR" && cargo +"$GARDEN_IRONHORSE_FUZZ_TOOLCHAIN" fuzz run "$target" "$infile" -- -runs=0 >/dev/null 2>&1 ) || rc=$?
fi

# Nonzero after a clean build == the target crashed on this input == reproduces.
[ "$rc" -ne 0 ] && exit 0
exit 1
