#!/bin/bash
# ironhorse-fuzz-run-gh.sh — default RUNNER seam for ironhorse-fuzz.sh.
#
# Invoked as: ironhorse-fuzz-run-gh.sh <target> <corpus-dir> <artifacts-dir> <seconds>
#
# Runs ONE bounded libFuzzer increment of <target> against the persistent <corpus-dir>,
# writing any crashing inputs as files into <artifacts-dir>. Exit 0 = clean increment,
# 77 = at least one crash artifact produced, 2 = campaign-wide checkout/toolchain
# provisioning failure, and 1 = target-specific build/run failure. The distinction
# lets the campaign stop after one shared failure instead of provisioning all targets.
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

# ── Per-subprocess wall-clock bounds (the fix for the unbounded-subprocess hang) ──
# libFuzzer's -max_total_time bounds only its RUN phase; the cargo-fuzz BUILD phase
# (ASAN-instrumented, per target) and the provisioning git fetch/checkout/submodule
# calls are otherwise unbounded, so a cold cache, toolchain drift, or a stuck network
# fetch can silently blow the unit's TimeoutStartSec (3600s). Bound each heavy child
# with `timeout` so a stuck build/fetch self-terminates and is diagnosable well inside
# the unit budget instead of relying on systemd's SIGKILL backstop.
#   PROVISION_TIMEOUT_SECS — cap on each provisioning git op (clone/fetch/checkout/submodule)
#   BUILD_ALLOWANCE_SECS   — fixed build-phase headroom added to the per-target run seconds
#                            to form the cargo-fuzz-run budget (build + libFuzzer run)
#   KILL_AFTER_SECS        — grace between the TERM and the KILL escalation
: "${GARDEN_IRONHORSE_FUZZ_PROVISION_TIMEOUT_SECS:=900}"
: "${GARDEN_IRONHORSE_FUZZ_BUILD_ALLOWANCE_SECS:=1200}"
: "${GARDEN_IRONHORSE_FUZZ_KILL_AFTER_SECS:=30}"

# Sanitize the timing knobs: a bad unit override must never yield an empty/zero budget
# (which `timeout` would reject or treat as "no limit").
_pos_secs() {  # _pos_secs <value> <default> -> a positive integer
  local v="$1" d="$2"
  case "$v" in ''|*[!0-9]*) v="$d" ;; esac
  [ "$v" -ge 1 ] 2>/dev/null || v="$d"
  printf '%s' "$v"
}
GARDEN_IRONHORSE_FUZZ_PROVISION_TIMEOUT_SECS="$(_pos_secs "$GARDEN_IRONHORSE_FUZZ_PROVISION_TIMEOUT_SECS" 900)"
GARDEN_IRONHORSE_FUZZ_BUILD_ALLOWANCE_SECS="$(_pos_secs "$GARDEN_IRONHORSE_FUZZ_BUILD_ALLOWANCE_SECS" 1200)"
GARDEN_IRONHORSE_FUZZ_KILL_AFTER_SECS="$(_pos_secs "$GARDEN_IRONHORSE_FUZZ_KILL_AFTER_SECS" 30)"
secs="$(_pos_secs "$secs" 60)"

# --- bounded, signal-forwarding subprocess execution -------------------------
# This unit runs KillMode=mixed, so a systemd stop/drain SIGTERMs only the unit's MAIN
# process (self-heal-run.sh -> ironhorse-fuzz.sh), never this runner or the git/cargo
# subprocess it spawns; without forwarding, the graceful path never reaches the fuzz
# tree and the cgroup-wide SIGKILL at TimeoutStopSec fires every time. `set -m` places
# each bounded child in its OWN process group (pgid == the launched pid) and
# `timeout --foreground` keeps timeout from splitting off a second group, so the child
# AND its descendant tree (rustc, the fuzz binary, git's helpers) share one addressable
# group. A TERM/INT here forwards to that whole group (then a bounded KILL backstop) so
# a drain is honored promptly; `timeout` still enforces the wall (rc=124, or 137 after
# --kill-after) even if no signal ever arrives.
bounded_child_pgid=""
forward_signal() {  # forward_signal <signame> <exit-code>
  local sig="$1" code="$2"
  if [ -n "$bounded_child_pgid" ]; then
    kill -"$sig" -- "-$bounded_child_pgid" 2>/dev/null || true
    ( sleep "$GARDEN_IRONHORSE_FUZZ_KILL_AFTER_SECS"
      kill -KILL -- "-$bounded_child_pgid" 2>/dev/null || true ) &
    wait "$bounded_child_pgid" 2>/dev/null || true
  fi
  exit "$code"
}
trap 'forward_signal TERM 143' TERM
trap 'forward_signal INT 130' INT

run_bounded() {  # run_bounded <budget-secs> <cmd...> -> wall-bounded, signal-forwarding
  local budget="$1"; shift
  set -m
  timeout --foreground --signal=TERM \
    --kill-after="${GARDEN_IRONHORSE_FUZZ_KILL_AFTER_SECS}s" "${budget}s" "$@" &
  bounded_child_pgid=$!
  set +m
  local rc=0
  wait "$bounded_child_pgid" || rc=$?
  bounded_child_pgid=""
  return "$rc"
}

# cargo/cargo-fuzz live under ~/.cargo/bin, which is not always on PATH.
export PATH="$HOME/.cargo/bin:$PATH"
if ! command -v git >/dev/null 2>&1 || ! command -v cargo >/dev/null 2>&1; then
  log "WARN: shared fuzz prerequisites unavailable (git and cargo are required)"
  exit 2
fi
if ! command -v timeout >/dev/null 2>&1; then
  log "WARN: coreutils 'timeout' unavailable — cannot bound the fuzz/provisioning subprocesses"
  exit 2
fi

PROJ="$GARDEN_IRONHORSE_FUZZ_PROJECT_DIR"
BARE="$GARDEN_ROOT/worktrees/${GARDEN_IRONHORSE_FUZZ_REPO//\//-}.git"

# --- provision / refresh the pinned project checkout (idempotent) ------------
provision_project() {
  local pb="$GARDEN_IRONHORSE_FUZZ_PROVISION_TIMEOUT_SECS"
  if [ ! -d "$PROJ/.git" ]; then
    mkdir -p "$(dirname "$PROJ")"
    if [ -d "$BARE" ]; then
      run_bounded "$pb" git clone --quiet "$BARE" "$PROJ"
      git -C "$PROJ" remote set-url origin "https://github.com/$GARDEN_IRONHORSE_FUZZ_REPO.git" 2>/dev/null || true
    else
      run_bounded "$pb" git clone --quiet "https://github.com/$GARDEN_IRONHORSE_FUZZ_REPO.git" "$PROJ"
    fi
  fi
  run_bounded "$pb" git -C "$PROJ" fetch --quiet origin "$GARDEN_IRONHORSE_FUZZ_BASE_BRANCH" || return 1
  run_bounded "$pb" git -C "$PROJ" checkout --quiet -B "$GARDEN_IRONHORSE_FUZZ_BASE_BRANCH" FETCH_HEAD || return 1
  # The XS oracle needs the c/moddable submodule. Init from a warm peer clone if one
  # exists to avoid the multi-GB GitHub fetch (file transport must be explicitly enabled).
  if [ -n "$GARDEN_IRONHORSE_FUZZ_SUBMODULE" ] && [ ! -e "$PROJ/$GARDEN_IRONHORSE_FUZZ_SUBMODULE/.git" ] \
     && [ ! -s "$PROJ/$GARDEN_IRONHORSE_FUZZ_SUBMODULE/.git" ]; then
    local peer=""
    if [ -n "${GARDEN_IRONHORSE_FUZZ_SUBMODULE_PEER:-}" ] && [ -d "${GARDEN_IRONHORSE_FUZZ_SUBMODULE_PEER}" ]; then
      peer="$GARDEN_IRONHORSE_FUZZ_SUBMODULE_PEER"
    fi
    if [ -n "$peer" ]; then
      run_bounded "$pb" git -C "$PROJ" -c protocol.file.allow=always \
        -c "submodule.${GARDEN_IRONHORSE_FUZZ_SUBMODULE}.url=$peer/$GARDEN_IRONHORSE_FUZZ_SUBMODULE" \
        submodule update --init "$GARDEN_IRONHORSE_FUZZ_SUBMODULE" || \
        run_bounded "$pb" git -C "$PROJ" submodule update --init --depth 1 "$GARDEN_IRONHORSE_FUZZ_SUBMODULE" || return 1
    else
      run_bounded "$pb" git -C "$PROJ" submodule update --init --depth 1 "$GARDEN_IRONHORSE_FUZZ_SUBMODULE" || return 1
    fi
  fi
  return 0
}

git_object_corruption_reported() {
  local diagnostic="$1"
  grep -Eiq \
    'pack has unresolved deltas|pack checksum mismatch|packfile .* (is corrupt|does not match index)|object file .* is empty|object file .* is corrupt|loose object .* is corrupt|corrupt (loose )?object|bad (object|tree object)|invalid object [0-9a-f]+|unable to read sha1 file' \
    "$diagnostic"
}

provision_err="$(mktemp "${TMPDIR:-/tmp}/garden-ironhorse-provision.XXXXXX")"
trap 'rm -f "$provision_err"' EXIT

provision_once() {
  : > "$provision_err"
  local rc=0
  provision_project 2> "$provision_err" || rc=$?
  [ ! -s "$provision_err" ] || cat "$provision_err" >&2
  return "$rc"
}

if provision_once; then
  :
elif git_object_corruption_reported "$provision_err"; then
  quarantine="${PROJ}.corrupt-$(date -u +%Y%m%dT%H%M%SZ)-$$"
  log "WARN: Git object corruption detected while refreshing the fuzz checkout; quarantining $PROJ and retrying once"
  if [ -e "$PROJ" ] || [ -L "$PROJ" ]; then
    if ! mv -- "$PROJ" "$quarantine"; then
      log "WARN: could not quarantine corrupt fuzz checkout at $PROJ"
      exit 2
    fi
    log "quarantined corrupt fuzz checkout at $quarantine"
  fi
  if ! provision_once; then
    log "WARN: could not recreate the pinned project checkout for $GARDEN_IRONHORSE_FUZZ_REPO@$GARDEN_IRONHORSE_FUZZ_BASE_BRANCH after corruption recovery"
    exit 2
  fi
else
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
# bounds libFuzzer's RUN phase; CARGO_TARGET_DIR keeps build output off any noexec /tmp.
mkdir -p "$corpus" "$arts"
export CARGO_TARGET_DIR="$GARDEN_IRONHORSE_FUZZ_STATE/target/$target"
crash_prefix="$arts/crash-"

# -max_total_time bounds only the libFuzzer run, NOT the cargo-fuzz build. Wrap the whole
# invocation in `timeout` at the per-target run seconds plus a fixed build-phase allowance
# so an unbounded/stuck ASAN build self-terminates instead of blowing the unit budget.
cargo_budget=$(( secs + GARDEN_IRONHORSE_FUZZ_BUILD_ALLOWANCE_SECS ))
rc=0
# run_bounded backgrounds `timeout ...`, so a `cd` must live inside the launched command;
# `bash -c '... exec "$@"'` runs cargo from $FUZZDIR under that single bounded child.
run_bounded "$cargo_budget" \
  bash -c 'cd "$1" || exit 125; shift; exec "$@"' _ "$FUZZDIR" \
    cargo +"$GARDEN_IRONHORSE_FUZZ_TOOLCHAIN" fuzz run "$target" "$corpus" -- \
      -max_total_time="$secs" \
      -rss_limit_mb="$GARDEN_IRONHORSE_FUZZ_RSS_LIMIT_MB" \
      -artifact_prefix="$crash_prefix" \
      -print_final_stats=1 || rc=$?

# libFuzzer exits nonzero when it stops on a crash. Any crash file present => finding.
if find "$arts" -type f -name 'crash-*' 2>/dev/null | grep -q .; then
  exit 77
fi
# A nonzero rc with no crash artifact is a build/setup error, not a finding. rc=124/137
# is our own `timeout` firing on a stuck/too-slow build+run — bounded and diagnosable
# rather than a silent budget overrun; still target-specific, so the campaign proceeds.
if [ "$rc" -eq 124 ] || [ "$rc" -eq 137 ]; then
  log "WARN: $target fuzz run exceeded the ${cargo_budget}s build+run budget (timeout rc=$rc) — bounding and skipping this target"
  exit 1
fi
if [ "$rc" -ne 0 ]; then
  log "WARN: $target fuzz run exited rc=$rc with no crash artifact (build/setup issue?)"
  # cargo/libFuzzer may itself use rc=2. Do not leak that through our reserved
  # shared-outage code: once provisioning passed, this failure is target-specific.
  exit 1
fi
exit 0
