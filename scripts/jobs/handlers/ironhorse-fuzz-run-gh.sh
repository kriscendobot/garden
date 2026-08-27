#!/bin/bash
# ironhorse-fuzz-run-gh.sh — default RUNNER seam for ironhorse-fuzz.sh.
#
# Invoked as: ironhorse-fuzz-run-gh.sh <target> <corpus-dir> <artifacts-dir> <seconds>
#
# Runs ONE bounded libFuzzer increment of <target> against the persistent <corpus-dir>,
# writing any crashing inputs as files into <artifacts-dir>. Exit 0 = clean increment,
# 77 = at least one crash artifact produced, other = error (the service skips the
# target this tick and logs).
#
# This is the ONLY seam that touches the heavy fuzz toolchain (pinned nightly +
# cargo-fuzz + the c/moddable XS-oracle submodule). It provisions a PINNED project
# checkout under $GARDEN_STATE (never a job worktree, never the deployed root) and
# reuses it across ticks so the corpus and build cache accumulate. Hermetic service
# tests inject a stub runner via GARDEN_IRONHORSE_FUZZ_RUNNER, so this path is the
# live-deployment default, not something the tests exercise.
#
# Untrusted-data note: crash bytes are handled ONLY as files (copied by path into
# <artifacts-dir>); nothing here interpolates their content into a command.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=../common.sh
source "$HERE/../common.sh"
GARDEN_TAG="ironhorse-fuzz-run"

target="${1:?usage: <target> <corpus-dir> <artifacts-dir> <seconds>}"
corpus="${2:?corpus dir}"
arts="${3:?artifacts dir}"
secs="${4:-60}"

: "${GARDEN_IRONHORSE_FUZZ_STATE:=$GARDEN_STATE/ironhorse-fuzz}"
: "${GARDEN_IRONHORSE_FUZZ_PROJECT_DIR:=$GARDEN_IRONHORSE_FUZZ_STATE/project}"
: "${GARDEN_IRONHORSE_FUZZ_REPO:=endojs/endo-but-for-bots}"
: "${GARDEN_IRONHORSE_FUZZ_BASE_BRANCH:=llm}"
: "${GARDEN_IRONHORSE_FUZZ_TOOLCHAIN:=nightly-2026-08-15}"
: "${GARDEN_IRONHORSE_FUZZ_RSS_LIMIT_MB:=4096}"
: "${GARDEN_IRONHORSE_FUZZ_FUZZ_SUBDIR:=rust/engine/ironhorse-fuzz}"
: "${GARDEN_IRONHORSE_FUZZ_SUBMODULE:=c/moddable}"

# cargo/cargo-fuzz live under ~/.cargo/bin, which is not always on PATH.
export PATH="$HOME/.cargo/bin:$PATH"
require_tools git cargo

PROJ="$GARDEN_IRONHORSE_FUZZ_PROJECT_DIR"
BARE="$GARDEN_ROOT/worktrees/${GARDEN_IRONHORSE_FUZZ_REPO//\//-}.git"

# --- provision / refresh the pinned project checkout (idempotent) ------------
provision_project() {
  if [ ! -d "$PROJ/.git" ]; then
    mkdir -p "$(dirname "$PROJ")"
    if [ -d "$BARE" ]; then
      git clone --quiet "$BARE" "$PROJ"
      git -C "$PROJ" remote set-url origin "https://github.com/$GARDEN_IRONHORSE_FUZZ_REPO.git" 2>/dev/null || true
    else
      git clone --quiet "https://github.com/$GARDEN_IRONHORSE_FUZZ_REPO.git" "$PROJ"
    fi
  fi
  git -C "$PROJ" fetch --quiet origin "$GARDEN_IRONHORSE_FUZZ_BASE_BRANCH" || return 1
  git -C "$PROJ" checkout --quiet -B "$GARDEN_IRONHORSE_FUZZ_BASE_BRANCH" FETCH_HEAD || return 1
  # The XS oracle needs the c/moddable submodule. Init from a warm peer clone if one
  # exists to avoid the multi-GB GitHub fetch (file transport must be explicitly enabled).
  if [ -n "$GARDEN_IRONHORSE_FUZZ_SUBMODULE" ] && [ ! -e "$PROJ/$GARDEN_IRONHORSE_FUZZ_SUBMODULE/.git" ] \
     && [ ! -s "$PROJ/$GARDEN_IRONHORSE_FUZZ_SUBMODULE/.git" ]; then
    local peer=""
    if [ -n "${GARDEN_IRONHORSE_FUZZ_SUBMODULE_PEER:-}" ] && [ -d "${GARDEN_IRONHORSE_FUZZ_SUBMODULE_PEER}" ]; then
      peer="$GARDEN_IRONHORSE_FUZZ_SUBMODULE_PEER"
    fi
    if [ -n "$peer" ]; then
      git -C "$PROJ" -c protocol.file.allow=always \
        -c "submodule.${GARDEN_IRONHORSE_FUZZ_SUBMODULE}.url=$peer/$GARDEN_IRONHORSE_FUZZ_SUBMODULE" \
        submodule update --init "$GARDEN_IRONHORSE_FUZZ_SUBMODULE" || \
        git -C "$PROJ" submodule update --init --depth 1 "$GARDEN_IRONHORSE_FUZZ_SUBMODULE" || return 1
    else
      git -C "$PROJ" submodule update --init --depth 1 "$GARDEN_IRONHORSE_FUZZ_SUBMODULE" || return 1
    fi
  fi
  return 0
}

if ! provision_project; then
  log "WARN: could not provision the pinned project checkout for $GARDEN_IRONHORSE_FUZZ_REPO@$GARDEN_IRONHORSE_FUZZ_BASE_BRANCH"
  exit 2
fi

FUZZDIR="$PROJ/$GARDEN_IRONHORSE_FUZZ_FUZZ_SUBDIR"
[ -d "$FUZZDIR/fuzz" ] || { log "WARN: no fuzz project at $FUZZDIR/fuzz — skipping"; exit 2; }

# Ensure cargo-fuzz is available (pinned toolchain installed out of band by the operator).
if ! cargo +"$GARDEN_IRONHORSE_FUZZ_TOOLCHAIN" fuzz --help >/dev/null 2>&1; then
  log "WARN: cargo +$GARDEN_IRONHORSE_FUZZ_TOOLCHAIN fuzz unavailable (install the pinned nightly + cargo-fuzz) — skipping"
  exit 2
fi

# Point libFuzzer at our PERSISTENT corpus and write crash artifacts into a private
# prefix we then harvest. -rss_limit_mb bounds a single process's memory; -max_total_time
# bounds wall clock; CARGO_TARGET_DIR keeps build output off any noexec /tmp.
mkdir -p "$corpus" "$arts"
export CARGO_TARGET_DIR="$GARDEN_IRONHORSE_FUZZ_STATE/target/$target"
crash_prefix="$arts/crash-"

rc=0
( cd "$FUZZDIR" && \
  cargo +"$GARDEN_IRONHORSE_FUZZ_TOOLCHAIN" fuzz run "$target" "$corpus" -- \
    -max_total_time="$secs" \
    -rss_limit_mb="$GARDEN_IRONHORSE_FUZZ_RSS_LIMIT_MB" \
    -artifact_prefix="$crash_prefix" \
    -print_final_stats=1 ) || rc=$?

# libFuzzer exits nonzero when it stops on a crash. Any crash file present => finding.
if find "$arts" -type f -name 'crash-*' 2>/dev/null | grep -q .; then
  exit 77
fi
# A nonzero rc with no crash artifact is a build/setup error, not a finding.
if [ "$rc" -ne 0 ]; then
  log "WARN: $target fuzz run exited rc=$rc with no crash artifact (build/setup issue?)"
  exit "$rc"
fi
exit 0
