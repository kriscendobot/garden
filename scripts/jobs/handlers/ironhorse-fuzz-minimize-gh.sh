#!/bin/bash
# ironhorse-fuzz-minimize-gh.sh — default MINIMIZER seam for ironhorse-fuzz.sh.
#
# Invoked as: ironhorse-fuzz-minimize-gh.sh <target> <in-file> <out-file>
#
# Minimizes a crashing input to a smaller equivalent (cargo fuzz tmin), writing the
# minimized bytes to <out-file>. On ANY failure it copies the input through unchanged
# — the caller uses the minimized bytes only for stable identity, so a no-op minimize
# is always safe (the raw input is still a valid finding key). Minimization before
# identity collapses many inputs that reduce to one root cause into one finding.
#
# Untrusted-data note: the input is handled ONLY as a file path; nothing here reads or
# interpolates its contents.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../common.sh
source "$HERE/../common.sh"
GARDEN_TAG="ironhorse-fuzz-minimize"

target="${1:?usage: <target> <in-file> <out-file>}"
infile="${2:?in-file}"
outfile="${3:?out-file}"

: "${GARDEN_IRONHORSE_FUZZ_STATE:=$GARDEN_STATE/ironhorse-fuzz}"
: "${GARDEN_IRONHORSE_FUZZ_PROJECT_DIR:=$GARDEN_IRONHORSE_FUZZ_STATE/project}"
: "${GARDEN_IRONHORSE_FUZZ_TOOLCHAIN:=nightly-2026-08-15}"
: "${GARDEN_IRONHORSE_FUZZ_FUZZ_SUBDIR:=rust/engine/ironhorse-fuzz}"
: "${GARDEN_IRONHORSE_FUZZ_TMIN_RUNS:=2000}"

export PATH="$HOME/.cargo/bin:$PATH"

fallback() { cp "$infile" "$outfile"; exit 0; }

command -v cargo >/dev/null 2>&1 || fallback
FUZZDIR="$GARDEN_IRONHORSE_FUZZ_PROJECT_DIR/$GARDEN_IRONHORSE_FUZZ_FUZZ_SUBDIR"
[ -d "$FUZZDIR/fuzz" ] || fallback
cargo +"$GARDEN_IRONHORSE_FUZZ_TOOLCHAIN" fuzz --help >/dev/null 2>&1 || fallback

export CARGO_TARGET_DIR="$GARDEN_IRONHORSE_FUZZ_STATE/target/$target"
tmpd="$(mktemp -d)"
trap 'rm -rf "$tmpd"' EXIT

# cargo fuzz tmin writes the minimized artifact under fuzz/artifacts/<target>/ by
# default; -artifact_prefix redirects it to our temp dir. -runs bounds the attempt.
( cd "$FUZZDIR" && \
  cargo +"$GARDEN_IRONHORSE_FUZZ_TOOLCHAIN" fuzz tmin "$target" "$infile" -- \
    -runs="$GARDEN_IRONHORSE_FUZZ_TMIN_RUNS" \
    -exact_artifact_path="$tmpd/minimized" >/dev/null 2>&1 ) || true

if [ -s "$tmpd/minimized" ]; then
  cp "$tmpd/minimized" "$outfile"
  exit 0
fi
# Some cargo-fuzz versions ignore -exact_artifact_path for tmin; harvest a prefixed file.
harvested="$(find "$tmpd" -type f -name 'min-*' 2>/dev/null | sort | head -n1 || true)"
if [ -n "$harvested" ] && [ -s "$harvested" ]; then
  cp "$harvested" "$outfile"
  exit 0
fi
fallback
