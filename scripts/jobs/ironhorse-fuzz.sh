#!/bin/bash
# ironhorse-fuzz.sh — the continuous Ironhorse libFuzzer campaign, off the PR
# critical path. A deterministic, leader-only, no-LLM background producer that drives
# a BOUNDED increment of the fuzz campaign each tick against a PERSISTENT corpus, and
# turns every distinct reproducible crash into one durable, deduplicated finding.
# Repair jobs that create-or-amend ONE standing bot-fork pull request (case + fix)
# are released serially: one may be live for a generation, and its successor stays
# durable in the findings journal until that live repair reaches tada/.
#
# Design: designs/continuous-ironhorse-fuzz.md. Directive: kriskowal on
# endojs/endo-but-for-bots#1046 (comment 5446442895) — "move the fuzzer out of CI and
# drive it continuously in the background from a new garden service; we should have a
# standing pull request that is created or amended for each ironhorse fuzz case and
# solution."
#
# ── Shape ───────────────────────────────────────────────────────────────────
# Type=oneshot timer tick, like every other leader-only singleton. Each tick runs a
# bounded fuzz increment (per-target -max_total_time) over a corpus that PERSISTS in
# $GARDEN_STATE between ticks; "continuous" is the timer firing forever over the same
# growing corpus, not one endless process. oneshot is the concurrency guard (no second
# tick starts while one is active); the leader-only ExecCondition keeps two hosts off
# the same campaign; every journal write is a CAS push, so a restart or a leader
# handoff never loses or duplicates a finding.
#
# ── Untrusted data (load-bearing) ───────────────────────────────────────────
# A crash input is adversarial bytes BY CONSTRUCTION. This script NEVER interpolates
# crash bytes into a shell command or an LLM prompt: crash files are passed to the
# fuzzer BY PATH; the stable finding identity is an inert hex sha256; the repair-job
# body carries only bounded metadata (target from a fixed allowlist, project SHA,
# toolchain, options, artifact sha256 + durable path, exact repro command) plus the
# minimized input as an INERT base64 blob the repair job decodes to disk. No eval, no
# word-split of artifact content, ever.
#
# ── Seams (all GARDEN_* overridable; this is what makes the tick hermetically
#     testable, mirroring pages-watcher.sh's GARDEN_PAGES_SOURCE/POST) ─────────
#   GARDEN_IRONHORSE_FUZZ_CLONE      journal clone dir   (default $GARDEN_STATE/ironhorse-fuzz/journal)
#   GARDEN_IRONHORSE_FUZZ_STATE      durable state root  (default $GARDEN_STATE/ironhorse-fuzz)
#   GARDEN_IRONHORSE_FUZZ_RUNNER     run one bounded increment; drop crashes into artifacts dir
#                                    (default handlers/ironhorse-fuzz-run-gh.sh)
#       runner <target> <corpus-dir> <artifacts-dir> <seconds>
#         -> exit 0 clean / 77 crash / 2 shared campaign setup outage / other target error
#   GARDEN_IRONHORSE_FUZZ_MINIMIZER  minimize a crash input
#       minimizer <target> <in-file> <out-file>  -> writes minimized bytes (falls back to a copy)
#   GARDEN_IRONHORSE_FUZZ_REPRODUCER confirm a crash still reproduces
#       reproducer <target> <in-file>  -> exit 0 reproduces / nonzero does not
#   GARDEN_IRONHORSE_FUZZ_SHA_CMD     echo the project SHA under fuzz    (default handlers/ironhorse-fuzz-sha-gh.sh)
#   GARDEN_IRONHORSE_FUZZ_PR_STATE    echo OPEN|MERGED|CLOSED|NONE for the standing PR
#                                    (default handlers/ironhorse-fuzz-pr-state-gh.sh <repo> <marker-base> <author>)
#   GARDEN_IRONHORSE_FUZZ_POST        post-job seam       (default post-job.sh)
#   GARDEN_IRONHORSE_FUZZ_TARGETS     space-separated target allowlist (default: the 9 maintained targets)
#   GARDEN_IRONHORSE_FUZZ_SECS        per-target seconds  (default 60)
#   GARDEN_IRONHORSE_FUZZ_REPO        bot fork owner/name (default endojs/endo-but-for-bots)
#   GARDEN_IRONHORSE_FUZZ_BASE_BRANCH standing-PR base    (default llm)
#   GARDEN_IRONHORSE_FUZZ_BRANCH_STEM standing branch stem (default ironhorse-fuzz-findings)
#   GARDEN_IRONHORSE_FUZZ_TOOLCHAIN   pinned nightly      (default nightly-2026-08-15)
#   GARDEN_IRONHORSE_FUZZ_MAX_ARTIFACT_BYTES  cap on a handled/embedded crash input (default 1048576)
#   GARDEN_IRONHORSE_FUZZ_CORPUS_MAX_MB       per-target corpus size cap (default 256)
#   GARDEN_IRONHORSE_FUZZ_MAX_FINDINGS_PER_TICK  bound work per tick (default 8)
#   GARDEN_IRONHORSE_FUZZ_SHARED_RETRY_SECS retry delay after shared runner rc=2
#                                    (default 900; clamped to 1..3600 seconds)

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=common.sh
source "$HERE/common.sh"
export GARDEN_TAG="ironhorse-fuzz"

: "${GARDEN_IRONHORSE_FUZZ_STATE:=$GARDEN_STATE/ironhorse-fuzz}"
: "${GARDEN_IRONHORSE_FUZZ_CLONE:=$GARDEN_IRONHORSE_FUZZ_STATE/journal}"
: "${GARDEN_IRONHORSE_FUZZ_RUNNER:=$HERE/handlers/ironhorse-fuzz-run-gh.sh}"
: "${GARDEN_IRONHORSE_FUZZ_MINIMIZER:=$HERE/handlers/ironhorse-fuzz-minimize-gh.sh}"
: "${GARDEN_IRONHORSE_FUZZ_REPRODUCER:=$HERE/handlers/ironhorse-fuzz-reproduce-gh.sh}"
: "${GARDEN_IRONHORSE_FUZZ_SHA_CMD:=$HERE/handlers/ironhorse-fuzz-sha-gh.sh}"
: "${GARDEN_IRONHORSE_FUZZ_PR_STATE:=$HERE/handlers/ironhorse-fuzz-pr-state-gh.sh}"
: "${GARDEN_IRONHORSE_FUZZ_POST:=$HERE/post-job.sh}"
: "${GARDEN_IRONHORSE_FUZZ_TARGETS:=differential_source bytecode_decoder differential_stage2b differential_regexp differential_regexp_surface parser differential_compile snapshot_roundtrip snapshot_decoder}"
: "${GARDEN_IRONHORSE_FUZZ_SECS:=60}"
: "${GARDEN_IRONHORSE_FUZZ_REPO:=endojs/endo-but-for-bots}"
: "${GARDEN_IRONHORSE_FUZZ_BASE_BRANCH:=llm}"
: "${GARDEN_IRONHORSE_FUZZ_BRANCH_STEM:=ironhorse-fuzz-findings}"
: "${GARDEN_IRONHORSE_FUZZ_TOOLCHAIN:=nightly-2026-08-15}"
: "${GARDEN_IRONHORSE_FUZZ_MAX_ARTIFACT_BYTES:=1048576}"
: "${GARDEN_IRONHORSE_FUZZ_CORPUS_MAX_MB:=256}"
: "${GARDEN_IRONHORSE_FUZZ_MAX_FINDINGS_PER_TICK:=8}"
: "${GARDEN_IRONHORSE_FUZZ_SHARED_RETRY_SECS:=900}"
: "${GARDEN_IRONHORSE_FUZZ_BOT_LOGIN:=${GARDEN_BOT_LOGIN:-kriscendobot}}"

# ── Triage-and-batch backpressure (designs/ironhorse-fuzz-triage-and-batch.md) ─
# The lane no longer opens one repair per finding. Capture stays; between capture
# and release sit a bounded triage stage and a batcher that clusters GENUINE
# findings into at most one cluster repair per generation. Three producer-side
# controllers bound the lane:
#   1. a hysteretic band on nonterminal-finding depth (the only one in the repo);
#   2. doom-signature feedback (N same-signature dooms from one target stops that
#      target's release regardless of depth); and
#   3. serialization: at most one triage job and one cluster repair live, and
#      triage release pauses while a cluster repair is changing the standing head.
: "${GARDEN_IRONHORSE_FUZZ_HIGH_WATER_TOTAL:=24}"    # stop fuzzing at/above this many nonterminal findings
: "${GARDEN_IRONHORSE_FUZZ_HIGH_WATER_TARGET:=8}"    # ...or this many for any single target
: "${GARDEN_IRONHORSE_FUZZ_LOW_WATER_TOTAL:=12}"     # resume only below this many total
: "${GARDEN_IRONHORSE_FUZZ_LOW_WATER_TARGET:=4}"     # ...and below this many for EVERY target
: "${GARDEN_IRONHORSE_FUZZ_TRIAGE_BATCH_MAX:=12}"    # oldest pending markers a triage job handles
: "${GARDEN_IRONHORSE_FUZZ_CLUSTER_MAX:=8}"          # max findings in one cluster repair
: "${GARDEN_IRONHORSE_FUZZ_DOOM_STOP_N:=3}"          # same-signature dooms from a target that stop its release

# These defaults are configuration values, but the band must stay hysteretic: the
# high-water thresholds must strictly exceed their low-water counterparts, or the
# band collapses to a single edge and the timer flaps on and off (design §
# Backpressure). Fail closed toward the safe defaults rather than actuate on an
# ordering a bad unit override inverted.
_clamp_int() {  # _clamp_int <value> <default> <min> — non-negative integer or default
  local v="$1" d="$2" min="$3"
  case "$v" in ''|*[!0-9]*) printf '%s' "$d"; return ;; esac
  [ "$v" -ge "$min" ] 2>/dev/null && printf '%s' "$v" || printf '%s' "$d"
}
GARDEN_IRONHORSE_FUZZ_HIGH_WATER_TOTAL="$(_clamp_int "$GARDEN_IRONHORSE_FUZZ_HIGH_WATER_TOTAL" 24 1)"
GARDEN_IRONHORSE_FUZZ_HIGH_WATER_TARGET="$(_clamp_int "$GARDEN_IRONHORSE_FUZZ_HIGH_WATER_TARGET" 8 1)"
GARDEN_IRONHORSE_FUZZ_LOW_WATER_TOTAL="$(_clamp_int "$GARDEN_IRONHORSE_FUZZ_LOW_WATER_TOTAL" 12 0)"
GARDEN_IRONHORSE_FUZZ_LOW_WATER_TARGET="$(_clamp_int "$GARDEN_IRONHORSE_FUZZ_LOW_WATER_TARGET" 4 0)"
GARDEN_IRONHORSE_FUZZ_TRIAGE_BATCH_MAX="$(_clamp_int "$GARDEN_IRONHORSE_FUZZ_TRIAGE_BATCH_MAX" 12 1)"
GARDEN_IRONHORSE_FUZZ_CLUSTER_MAX="$(_clamp_int "$GARDEN_IRONHORSE_FUZZ_CLUSTER_MAX" 8 1)"
GARDEN_IRONHORSE_FUZZ_DOOM_STOP_N="$(_clamp_int "$GARDEN_IRONHORSE_FUZZ_DOOM_STOP_N" 3 1)"
if [ "$GARDEN_IRONHORSE_FUZZ_HIGH_WATER_TOTAL" -le "$GARDEN_IRONHORSE_FUZZ_LOW_WATER_TOTAL" ] \
   || [ "$GARDEN_IRONHORSE_FUZZ_HIGH_WATER_TARGET" -le "$GARDEN_IRONHORSE_FUZZ_LOW_WATER_TARGET" ]; then
  log "WARN: backpressure band not hysteretic (high<=low) — reverting to safe defaults 24/8 over 12/4"
  GARDEN_IRONHORSE_FUZZ_HIGH_WATER_TOTAL=24; GARDEN_IRONHORSE_FUZZ_HIGH_WATER_TARGET=8
  GARDEN_IRONHORSE_FUZZ_LOW_WATER_TOTAL=12;  GARDEN_IRONHORSE_FUZZ_LOW_WATER_TARGET=4
fi

require_tools git sha256sum

fleet_draining && { log "fleet draining; skipping"; exit 0; }

STATE="$GARDEN_IRONHORSE_FUZZ_STATE"
CLONE="$GARDEN_IRONHORSE_FUZZ_CLONE"
CORPUS_ROOT="$STATE/corpus"
FINDINGS_ROOT="$STATE/findings"
LOGS_ROOT="$STATE/logs"
SHARED_COOLDOWN="$STATE/shared-runner-cooldown"
SHARED_DIAGNOSTIC="$LOGS_ROOT/shared-runner-outage.log"
mkdir -p "$STATE" "$CORPUS_ROOT" "$FINDINGS_ROOT" "$LOGS_ROOT"

ensure_clone "$CLONE"
sync_clone "$CLONE"

JSTANDING="ironhorse-fuzz/standing.md"
jshow() {  # jshow <journal2-relative-path> -> file content on stdout (empty if absent)
  git -C "$CLONE" show "origin/$JOURNAL_BRANCH:$1" 2>/dev/null || true
}
field() {  # field <text> <key> -> value of "key: value" (first match)
  printf '%s\n' "$1" | sed -n "s/^$2: *//p" | head -n1
}

# rc=2 is reserved by the runner for a campaign-wide provisioning/toolchain
# outage. Keep its retry delay finite even if a bad unit override asks for more.
shared_retry_secs="$GARDEN_IRONHORSE_FUZZ_SHARED_RETRY_SECS"
case "$shared_retry_secs" in
  ''|*[!0-9]*) shared_retry_secs=900 ;;
esac
[ "$shared_retry_secs" -ge 1 ] || shared_retry_secs=1
[ "$shared_retry_secs" -le 3600 ] || shared_retry_secs=3600

shared_cooldown_remaining() {
  [ -s "$SHARED_COOLDOWN" ] || return 1
  local txt retry_after now
  txt="$(cat "$SHARED_COOLDOWN" 2>/dev/null || true)"
  retry_after="$(field "$txt" retry_after)"
  case "$retry_after" in ''|*[!0-9]*) return 1 ;; esac
  now="$(date +%s)"
  [ "$retry_after" -gt "$now" ] || return 1
  printf '%s' "$((retry_after - now))"
}

record_shared_failure() {  # record_shared_failure <failed-target> <runner-log>
  local target="$1" runner_log="$2" now retry_after tmp previous started count diagnostic_tmp
  now="$(date +%s)"
  retry_after=$((now + shared_retry_secs))
  previous="$(cat "$SHARED_COOLDOWN" 2>/dev/null || true)"
  started="$(field "$previous" started_at)"
  count="$(field "$previous" consecutive_failures)"
  case "$started" in ''|*[!0-9]*) started="$now" ;; esac
  case "$count" in ''|*[!0-9]*) count=0 ;; esac
  count=$((count + 1))

  # Keep the latest failed setup transcript separate from the per-target log: the
  # successful recovery probe overwrites that target log. One bounded snapshot is
  # enough to retain the diagnostics without accumulating one file per retry.
  diagnostic_tmp="$(mktemp "$LOGS_ROOT/.shared-runner-outage.XXXXXX")"
  cp "$runner_log" "$diagnostic_tmp"
  mv -f "$diagnostic_tmp" "$SHARED_DIAGNOSTIC"

  tmp="$(mktemp "$STATE/.shared-runner-cooldown.XXXXXX")"
  {
    printf 'started_at: %s\n' "$started"
    printf 'last_failed_at: %s\n' "$now"
    printf 'retry_after: %s\n' "$retry_after"
    printf 'consecutive_failures: %s\n' "$count"
    printf 'failed_target: %s\n' "$target"
    printf 'diagnostic_log: %s\n' "$SHARED_DIAGNOSTIC"
  } > "$tmp"
  mv -f "$tmp" "$SHARED_COOLDOWN"

  shared_failure_count="$count"
  shared_outage_duration=$((now - started))
}

summarize_shared_recovery() {  # summarize_shared_recovery <recovered-target>
  [ -s "$SHARED_COOLDOWN" ] || return 0
  local target="$1" txt started count failed_target diagnostic now duration
  txt="$(cat "$SHARED_COOLDOWN" 2>/dev/null || true)"
  started="$(field "$txt" started_at)"
  count="$(field "$txt" consecutive_failures)"
  failed_target="$(field "$txt" failed_target)"
  diagnostic="$(field "$txt" diagnostic_log)"
  now="$(date +%s)"
  case "$started" in ''|*[!0-9]*) started="$now" ;; esac
  case "$count" in ''|*[!0-9]*) count=1 ;; esac
  duration=$((now - started))
  rm -f "$SHARED_COOLDOWN"
  log "shared fuzz campaign setup recovered after ${duration}s and ${count} consecutive rc=2 failure(s); resumed at $target (last failed target $failed_target; diagnostics retained at ${diagnostic:-$SHARED_DIAGNOSTIC})"
}

# --- validate a target against the fixed allowlist (never trust dynamic input) ---
declare -A ALLOWED=()
for _t in $GARDEN_IRONHORSE_FUZZ_TARGETS; do ALLOWED["$_t"]=1; done
is_allowed_target() { [ -n "${ALLOWED[$1]:-}" ]; }

# --- CAS-write a small file into the journal (whole-file) --------------------
# Mirrors land-journal-edit.sh's loop but confined to our ironhorse-fuzz/ subtree so
# the service is self-contained and hermetically testable against a bare-repo stub.
journal_put() {  # journal_put <journal2-relative-path> <src-file> <commit-msg>
  local rel="$1" src="$2" msg="$3" attempt
  for attempt in $(seq 1 "${GARDEN_POST_ATTEMPTS:-50}"); do
    sync_clone "$CLONE"
    mkdir -p "$CLONE/$(dirname "$rel")"
    cp "$src" "$CLONE/$rel"
    git -C "$CLONE" add -- "$rel" >/dev/null 2>&1 || true
    local rc=0; commit_and_push "$CLONE" "$msg" || rc=$?
    case "$rc" in
      0|2) return 0 ;;               # landed, or nothing-to-commit (already present)
      *)   backoff "$attempt" ;;      # push race / transient — re-sync and retry
    esac
  done
  return 1
}

# ─────────────────────────────────────────────────────────────────────────────
# 1. Standing-PR lifecycle: load, and roll over after a merge/close.
# ─────────────────────────────────────────────────────────────────────────────
standing_txt="$(jshow "$JSTANDING")"
gen="$(field "$standing_txt" generation)"; gen="${gen:-1}"
[ "$gen" -ge 1 ] 2>/dev/null || gen=1
st_state="$(field "$standing_txt" state)"; st_state="${st_state:-active}"
st_pr="$(field "$standing_txt" pr_number)"
branch="$(field "$standing_txt" branch)"
marker_base="$(field "$standing_txt" marker_base)"

write_standing() {  # write_standing <generation> <branch> <marker_base> <state> [pr_number] [pr_url]
  local g="$1" br="$2" mb="$3" stt="$4" prn="${5:-}" pru="${6:-}" tmp
  tmp="$(mktemp)"
  {
    printf 'generation: %s\n' "$g"
    printf 'branch: %s\n' "$br"
    printf 'marker_base: %s\n' "$mb"
    printf 'base_branch: %s\n' "$GARDEN_IRONHORSE_FUZZ_BASE_BRANCH"
    printf 'repo: %s\n' "$GARDEN_IRONHORSE_FUZZ_REPO"
    printf 'state: %s\n' "$stt"
    [ -n "$prn" ] && printf 'pr_number: %s\n' "$prn"
    [ -n "$pru" ] && printf 'pr_url: %s\n' "$pru"
    printf 'updated_by: %s\n' "$GARDEN"
  } > "$tmp"
  journal_put "$JSTANDING" "$tmp" "ironhorse-fuzz: standing gen $g ($stt)" || { rm -f "$tmp"; return 1; }
  rm -f "$tmp"
}

# Initialize on first run.
if [ -z "$standing_txt" ]; then
  branch="${GARDEN_IRONHORSE_FUZZ_BRANCH_STEM}"
  marker_base="${GARDEN_IRONHORSE_FUZZ_BRANCH_STEM}"
  write_standing "$gen" "$branch" "$marker_base" active || log "WARN: could not initialize standing state (will retry next tick)"
  standing_txt="$(jshow "$JSTANDING")"
  st_state="active"; st_pr=""
fi
[ -n "$branch" ] || branch="${GARDEN_IRONHORSE_FUZZ_BRANCH_STEM}"
[ -n "$marker_base" ] || marker_base="${GARDEN_IRONHORSE_FUZZ_BRANCH_STEM}"

# Roll over if a recorded PR has merged or closed. The next finding creates the next
# generation's PR; we do NOT pre-create an empty one.
if [ -n "$st_pr" ] && [ "$st_state" = "active" ]; then
  pr_state="$("$GARDEN_IRONHORSE_FUZZ_PR_STATE" "$GARDEN_IRONHORSE_FUZZ_REPO" "$marker_base" "$GARDEN_IRONHORSE_FUZZ_BOT_LOGIN" 2>/dev/null || echo UNKNOWN)"
  case "$pr_state" in
    MERGED|CLOSED)
      log "standing PR #$st_pr is $pr_state — archiving gen $gen and rolling over"
      archtmp="$(mktemp)"; printf '%s\n' "$standing_txt" > "$archtmp"
      printf 'retired_state: %s\n' "$pr_state" >> "$archtmp"
      journal_put "ironhorse-fuzz/standing-archive/$gen.md" "$archtmp" "ironhorse-fuzz: archive standing gen $gen ($pr_state)" || true
      rm -f "$archtmp"
      gen=$((gen + 1))
      branch="${GARDEN_IRONHORSE_FUZZ_BRANCH_STEM}-${gen}"
      marker_base="${GARDEN_IRONHORSE_FUZZ_BRANCH_STEM}-${gen}"
      write_standing "$gen" "$branch" "$marker_base" active || log "WARN: rollover write failed (retry next tick)"
      st_pr=""
      ;;
    OPEN|NONE|UNKNOWN) : ;;   # keep amending / not yet created / transient — no rollover
  esac
fi

log "campaign gen=$gen branch=$branch marker=$marker_base targets=[$GARDEN_IRONHORSE_FUZZ_TARGETS]"

# ─────────────────────────────────────────────────────────────────────────────
# 2. Resolve the project SHA under fuzz (provenance).
# ─────────────────────────────────────────────────────────────────────────────
project_sha="$("$GARDEN_IRONHORSE_FUZZ_SHA_CMD" 2>/dev/null | head -n1 | tr -d '[:space:]' || true)"
[ -n "$project_sha" ] || project_sha="unknown"

# ─────────────────────────────────────────────────────────────────────────────
# 3. Run a bounded fuzz increment per target; collect crash artifacts.
# ─────────────────────────────────────────────────────────────────────────────
ART_ROOT="$(mktemp -d)"
cleanup() { rm -rf "$ART_ROOT" 2>/dev/null || true; }

# Graceful drain propagation. self-heal-run.sh forwards a systemd stop SIGTERM to THIS
# script, but the fuzz runner is spawned per target as a bounded child; a plain
# FOREGROUND call would DEFER this trap until that (possibly build-length) child returned
# on its own, so the cgroup-wide SIGKILL backstop fired at TimeoutStopSec every time. Run
# each runner in the BACKGROUND and, on TERM/INT, forward the signal to it before exiting.
# The runner has its own TERM trap that reaps its timeout'd git/cargo process group, so a
# single TERM to the runner tears the whole tree down; `timeout` inside the runner still
# bounds a stuck build even if no signal arrives. A bounded KILL backstop covers a runner
# that somehow ignores TERM.
: "${GARDEN_IRONHORSE_FUZZ_RUNNER_KILL_AFTER_SECS:=20}"
case "$GARDEN_IRONHORSE_FUZZ_RUNNER_KILL_AFTER_SECS" in ''|*[!0-9]*) GARDEN_IRONHORSE_FUZZ_RUNNER_KILL_AFTER_SECS=20 ;; esac
runner_pid=""
drain_forward() {  # drain_forward <exit-code>
  local code="$1"
  if [ -n "$runner_pid" ]; then
    kill -TERM "$runner_pid" 2>/dev/null || true
    ( sleep "$GARDEN_IRONHORSE_FUZZ_RUNNER_KILL_AFTER_SECS"
      kill -KILL "$runner_pid" 2>/dev/null || true ) &
    wait "$runner_pid" 2>/dev/null || true
  fi
  cleanup
  exit "$code"
}
trap 'cleanup' EXIT
trap 'drain_forward 143' TERM
trap 'drain_forward 130' INT

posted_this_tick=0

handle_finding() {  # handle_finding <target> <crash-file>
  local target="$1" crash="$2"
  is_allowed_target "$target" || { log "WARN: ignoring crash for unknown target '$target'"; return 0; }
  [ -s "$crash" ] || { log "WARN: empty crash file for $target — skipping"; return 0; }

  local sz; sz="$(wc -c < "$crash" | tr -d '[:space:]')"
  if [ "$sz" -gt "$GARDEN_IRONHORSE_FUZZ_MAX_ARTIFACT_BYTES" ]; then
    log "WARN: $target crash input ${sz}B exceeds cap ${GARDEN_IRONHORSE_FUZZ_MAX_ARTIFACT_BYTES}B — recording metadata only, not embedding"
  fi

  # Confirm it still reproduces (never chase a flake). Bounded by the reproducer seam.
  if ! "$GARDEN_IRONHORSE_FUZZ_REPRODUCER" "$target" "$crash" >/dev/null 2>&1; then
    log "$target crash did not reproduce deterministically — discarding (not a finding)"
    return 0
  fi

  # Minimize (stable identity). Fall back to the raw input if the minimizer no-ops.
  local minz; minz="$(mktemp)"
  if ! "$GARDEN_IRONHORSE_FUZZ_MINIMIZER" "$target" "$crash" "$minz" >/dev/null 2>&1 || [ ! -s "$minz" ]; then
    cp "$crash" "$minz"
  fi

  local art_sha fid repair_base
  art_sha="$(sha256sum "$minz" | cut -d' ' -f1)"
  fid="$(printf '%s\0' "$target" | cat - "$minz" | sha256sum | cut -c1-16)"
  repair_base="ironhorse-fuzz-${fid}-repair"

  # Dedup gate 1: journal marker (survives restart AND leader handoff).
  if [ -n "$(jshow "ironhorse-fuzz/findings/$fid.md")" ]; then
    log "finding $fid already recorded — idempotent skip"
    rm -f "$minz"; return 0
  fi
  # Persist durable host-local artifact (raw bytes stay on disk, referenced by path).
  local fdir="$FINDINGS_ROOT/$fid"
  mkdir -p "$fdir"
  cp "$minz" "$fdir/input.bin"
  local repro_cmd="cargo +${GARDEN_IRONHORSE_FUZZ_TOOLCHAIN} fuzz run ${target} <input> -- -runs=1"
  {
    printf 'finding_id: %s\n' "$fid"
    printf 'target: %s\n' "$target"
    printf 'project_sha: %s\n' "$project_sha"
    printf 'toolchain: %s\n' "$GARDEN_IRONHORSE_FUZZ_TOOLCHAIN"
    printf 'artifact_sha256: %s\n' "$art_sha"
    printf 'artifact_bytes: %s\n' "$(wc -c < "$minz" | tr -d '[:space:]')"
    printf 'repro_command: %s\n' "$repro_cmd"
    printf 'discovered_by: %s\n' "$GARDEN"
    printf 'generation: %s\n' "$gen"
    printf 'branch: %s\n' "$branch"
    printf 'marker_base: %s\n' "$marker_base"
  } > "$fdir/meta.md"

  # Journal dedup marker + portable provenance. Embed the minimized input as INERT
  # base64 ONLY when within the size cap, so a finding is reproducible cross-host
  # without depending on this leader's local disk. base64 is never interpolated into
  # a shell/LLM context — the repair job decodes it to a file.
  local jmark; jmark="$(mktemp)"
  {
    cat "$fdir/meta.md"
    printf 'repair_base: %s\n' "$repair_base"
    printf 'artifact_path: %s\n' "$fdir/input.bin"
    if [ "$sz" -le "$GARDEN_IRONHORSE_FUZZ_MAX_ARTIFACT_BYTES" ]; then
      printf 'input_base64: '
      base64 -w0 "$minz" 2>/dev/null || base64 "$minz" | tr -d '\n'
      printf '\n'
    else
      printf 'input_base64: (omitted: %sB exceeds cap)\n' "$sz"
    fi
  } > "$jmark"
  if ! journal_put "ironhorse-fuzz/findings/$fid.md" "$jmark" "ironhorse-fuzz: record finding $fid ($target)"; then
    log "WARN: could not land finding marker $fid — will re-handle next tick"
    rm -f "$minz" "$jmark"; return 0
  fi
  rm -f "$jmark"

  log "recorded finding $fid (target $target) — triage-pending until the triage stage classifies it"
  rm -f "$minz"
}

job_is_live() {  # job_is_live <base> — plan/todo/doin all block a successor
  local base="$1" sub
  for sub in "$JOBS_PLAN" "$JOBS_TODO" "$JOBS_DOIN"; do
    git -C "$CLONE" cat-file -e "origin/$JOURNAL_BRANCH:$sub/$base.md" 2>/dev/null && return 0
  done
  return 1
}

job_is_complete() {  # job_is_complete <base>
  local base="$1"
  tada_find_tree "$CLONE" "origin/$JOURNAL_BRANCH" "$base" >/dev/null 2>&1
}

# ── Finding state machine (captured → triage-pending → genuine → clustered → repaired)
# Triage records live at ironhorse-fuzz/triage/<fid>.md and carry `status:`
# (pending|genuine|artifact|duplicate). A genuine finding cleared by a completed
# cluster is stamped `resolved_by_cluster:` and becomes terminal. The producer is
# the DETERMINISTIC half: it never classifies a finding itself (that is the triage
# job's LLM work); it only reads the durable records to count depth and to decide
# what bounded job to release next.
finding_target()   { field "$(jshow "ironhorse-fuzz/findings/$1.md")" target; }
triage_show()      { jshow "ironhorse-fuzz/triage/$1.md"; }
finding_untriaged() { [ -z "$(triage_show "$1")" ]; }  # no triage record yet

finding_disposition() {  # finding_disposition <fid> -> pending|genuine|terminal
  local tr; tr="$(triage_show "$1")"
  local st; st="$(field "$tr" status)"
  case "$st" in
    artifact|duplicate) printf terminal ;;
    genuine)
      if [ -n "$(field "$tr" resolved_by_cluster)" ]; then printf terminal; else printf genuine; fi ;;
    *) printf pending ;;
  esac
}

# ── Backpressure: count nonterminal findings, total and per target ────────────
declare -A NT_BY_TARGET=()
NT_TOTAL=0
count_nonterminal() {
  NT_TOTAL=0; NT_BY_TARGET=()
  local rel fid target disp
  while IFS= read -r rel; do
    [ -n "$rel" ] || continue
    fid="$(basename "$rel" .md)"
    disp="$(finding_disposition "$fid")"
    [ "$disp" = terminal ] && continue
    target="$(finding_target "$fid")"; [ -n "$target" ] || target="(unknown)"
    NT_TOTAL=$((NT_TOTAL + 1))
    NT_BY_TARGET["$target"]=$(( ${NT_BY_TARGET["$target"]:-0} + 1 ))
  done < <(git -C "$CLONE" ls-tree -r --name-only "origin/$JOURNAL_BRANCH" -- ironhorse-fuzz/findings \
    | grep '^ironhorse-fuzz/findings/[^/]*\.md$' | sort || true)
}
max_target_nonterminal() {
  local m=0 t
  for t in "${!NT_BY_TARGET[@]}"; do [ "${NT_BY_TARGET[$t]}" -gt "$m" ] && m="${NT_BY_TARGET[$t]}"; done
  printf '%s' "$m"
}

# Hysteretic decision, persisted in the journal so it follows a leader handoff and
# is auditable in git. Written only when the state flips (chatter suppression,
# copied from budget-level's exact-equality guard). Returns 0 = fuzz this tick,
# 1 = suppressed.
BP_STATE_PATH="ironhorse-fuzz/backpressure.md"
backpressure_allows_fuzzing() {  # returns 0 to fuzz, 1 to suppress
  count_nonterminal
  local mt prev new; mt="$(max_target_nonterminal)"
  prev="$(field "$(jshow "$BP_STATE_PATH")" fuzzing)"; prev="${prev:-running}"
  if [ "$prev" = running ]; then
    if [ "$NT_TOTAL" -ge "$GARDEN_IRONHORSE_FUZZ_HIGH_WATER_TOTAL" ] \
       || [ "$mt" -ge "$GARDEN_IRONHORSE_FUZZ_HIGH_WATER_TARGET" ]; then new=stopped; else new=running; fi
  else
    if [ "$NT_TOTAL" -lt "$GARDEN_IRONHORSE_FUZZ_LOW_WATER_TOTAL" ] \
       && [ "$mt" -lt "$GARDEN_IRONHORSE_FUZZ_LOW_WATER_TARGET" ]; then new=running; else new=stopped; fi
  fi
  if [ "$new" != "$prev" ]; then
    local tmp; tmp="$(mktemp)"
    {
      printf 'fuzzing: %s\n' "$new"
      printf 'nonterminal_total: %s\n' "$NT_TOTAL"
      printf 'nonterminal_max_target: %s\n' "$mt"
      printf 'high_water_total: %s\n' "$GARDEN_IRONHORSE_FUZZ_HIGH_WATER_TOTAL"
      printf 'high_water_target: %s\n' "$GARDEN_IRONHORSE_FUZZ_HIGH_WATER_TARGET"
      printf 'low_water_total: %s\n' "$GARDEN_IRONHORSE_FUZZ_LOW_WATER_TOTAL"
      printf 'low_water_target: %s\n' "$GARDEN_IRONHORSE_FUZZ_LOW_WATER_TARGET"
      printf 'updated_by: %s\n' "$GARDEN"
    } > "$tmp"
    journal_put "$BP_STATE_PATH" "$tmp" "ironhorse-fuzz: backpressure $prev -> $new (nonterminal=$NT_TOTAL, max_target=$mt)" || true
    rm -f "$tmp"
    log "backpressure $prev -> $new (nonterminal total=$NT_TOTAL max_target=$mt; high=${GARDEN_IRONHORSE_FUZZ_HIGH_WATER_TOTAL}/${GARDEN_IRONHORSE_FUZZ_HIGH_WATER_TARGET} low=${GARDEN_IRONHORSE_FUZZ_LOW_WATER_TOTAL}/${GARDEN_IRONHORSE_FUZZ_LOW_WATER_TARGET})"
  fi
  [ "$new" = running ]
}

# ── Doom-signature feedback: N same-signature dooms from one target stop that
# target's release, regardless of queue depth (design § Backpressure; the reaper
# writes doom_signature: policy-refusal but no producer read it until now). The
# doomed jobs sit in plan/ (gate go-ahead, never auto-promoted); the histogram is
# recomputed each tick from that durable state, so no producer-side event memory
# is needed.
declare -A DOOM_SIG_COUNT=()   # "target|signature" -> count
scan_doom_feedback() {
  DOOM_SIG_COUNT=()
  local rel base body sig tgt
  while IFS= read -r rel; do
    [ -n "$rel" ] || continue
    base="$(basename "$rel" .md)"
    body="$(jshow "$rel")"
    sig="$(field "$body" doom_signature)"; [ -n "$sig" ] || continue
    # Prefer the machine-readable target marker we stamp into every triage/cluster
    # body; fall back to the finding marker for a legacy per-finding repair base.
    tgt="$(printf '%s\n' "$body" | sed -n 's/.*<!-- ironhorse-fuzz-target: \([^ ]*\) -->.*/\1/p' | head -n1)"
    if [ -z "$tgt" ]; then
      case "$base" in
        ironhorse-fuzz-*-repair)
          local mid="${base#ironhorse-fuzz-}"; mid="${mid%-repair}"
          case "$mid" in
            [0-9a-f]*) [ "${#mid}" = 16 ] && tgt="$(finding_target "$mid")" ;;
          esac ;;
      esac
    fi
    [ -n "$tgt" ] || continue
    DOOM_SIG_COUNT["$tgt|$sig"]=$(( ${DOOM_SIG_COUNT["$tgt|$sig"]:-0} + 1 ))
  done < <(git -C "$CLONE" ls-tree -r --name-only "origin/$JOURNAL_BRANCH" -- "$JOBS_PLAN" \
    | grep -E "^$JOBS_PLAN/ironhorse-fuzz-.*\.md$" | sort || true)
}
target_doom_stopped() {  # target_doom_stopped <target> -> 0 if release for it must stop
  local target="$1" key sig cnt
  for key in "${!DOOM_SIG_COUNT[@]}"; do
    [ "${key%%|*}" = "$target" ] || continue
    sig="${key#*|}"; cnt="${DOOM_SIG_COUNT[$key]}"
    if [ "$cnt" -ge "$GARDEN_IRONHORSE_FUZZ_DOOM_STOP_N" ]; then
      DOOM_STOP_SIG="$sig"; DOOM_STOP_CNT="$cnt"; return 0
    fi
  done
  return 1
}

# ── Serialization predicates ─────────────────────────────────────────────────
triage_is_live() {  # any triage job live on the board
  git -C "$CLONE" ls-tree -r --name-only "origin/$JOURNAL_BRANCH" -- "$JOBS_PLAN" "$JOBS_TODO" "$JOBS_DOIN" 2>/dev/null \
    | grep -Eq "/ironhorse-fuzz-triage-.*\.md$"
}
cluster_is_live() {  # any cluster repair live for the CURRENT generation
  local rel cbase crec
  while IFS= read -r rel; do
    [ -n "$rel" ] || continue
    crec="$(jshow "$rel")"
    [ "$(field "$crec" generation)" = "$gen" ] || continue
    cbase="$(field "$crec" repair_base)"; [ -n "$cbase" ] || continue
    job_is_live "$cbase" && { CLUSTER_LIVE_BASE="$cbase"; return 0; }
  done < <(git -C "$CLONE" ls-tree -r --name-only "origin/$JOURNAL_BRANCH" -- ironhorse-fuzz/clusters \
    | grep '^ironhorse-fuzz/clusters/[^/]*\.md$' | sort || true)
  return 1
}

standing_for_gen() {  # echoes "branch marker" for a finding/cluster generation
  local g="$1" br mk
  if [ "$g" = "$gen" ]; then br="$branch"; mk="$marker_base"; else
    if [ "$g" = 1 ]; then br="$GARDEN_IRONHORSE_FUZZ_BRANCH_STEM"; mk="$br"; else br="${GARDEN_IRONHORSE_FUZZ_BRANCH_STEM}-${g}"; mk="$br"; fi
  fi
  printf '%s %s' "$br" "$mk"
}

# ── Release a bounded triage job (≤ TRIAGE_BATCH_MAX oldest pending, one target) ─
release_triage() {
  local rel fid target chosen_target="" members="" count=0
  # Pick the target owning the oldest pending finding that is not doom-stopped.
  declare -A PENDING_BY_TARGET=()
  local ordered=""
  while IFS= read -r rel; do
    [ -n "$rel" ] || continue
    fid="$(basename "$rel" .md)"
    [ "$(field "$(jshow "$rel")" generation)" = "$gen" ] || continue
    # Only UNTRIAGED findings need a triage job. A finding with a triage record —
    # even one left `pending` (inconclusive) — has been triaged and is not
    # re-triaged automatically; a human or a new deterministic matcher advances it.
    finding_untriaged "$fid" || continue
    target="$(finding_target "$fid")"; [ -n "$target" ] || continue
    if [ -z "${PENDING_BY_TARGET[$target]:-}" ]; then ordered="$ordered $target"; fi
    PENDING_BY_TARGET["$target"]="${PENDING_BY_TARGET[$target]:-} $fid"
  done < <(git -C "$CLONE" ls-tree -r --name-only "origin/$JOURNAL_BRANCH" -- ironhorse-fuzz/findings \
    | grep '^ironhorse-fuzz/findings/[^/]*\.md$' | sort || true)

  for target in $ordered; do
    if target_doom_stopped "$target"; then
      log "triage release for '$target' held: $DOOM_STOP_CNT same-signature dooms ($DOOM_STOP_SIG) >= stop threshold $GARDEN_IRONHORSE_FUZZ_DOOM_STOP_N"
      continue
    fi
    chosen_target="$target"; break
  done
  [ -n "$chosen_target" ] || { log "no releasable pending findings (all triaged, held by doom feedback, or none captured)"; return 1; }

  for fid in ${PENDING_BY_TARGET[$chosen_target]}; do
    [ "$count" -lt "$GARDEN_IRONHORSE_FUZZ_TRIAGE_BATCH_MAX" ] || break
    members="$members $fid"; count=$((count + 1))
  done

  local batch_id base sbr smk
  batch_id="$(printf '%s\0%s\0%s' "$gen" "$chosen_target" "$(printf '%s\n' $members | sort)" | sha256sum | cut -c1-12)"
  base="ironhorse-fuzz-triage-${chosen_target}-${batch_id}"
  read -r sbr smk < <(standing_for_gen "$gen")

  if job_is_live "$base" || job_is_complete "$base"; then
    log "triage batch $base already live/complete — idempotent skip"; return 1
  fi

  local jb; jb="$(mktemp)"
  {
    printf '%s\n' '---'
    printf '%s\n' 'role: builder'
    printf '%s\n' 'tier: minion'
    printf '%s\n' 'fallback-tier: minion'
    printf '%s\n' 'dispatch: automatic'
    printf '%s\n\n' '---'
    printf '<!-- ironhorse-fuzz-target: %s -->\n' "$chosen_target"
    printf '<!-- ironhorse-fuzz-kind: triage -->\n\n'
    printf '# Triage %s Ironhorse fuzz finding(s) for target `%s`\n\n' "$count" "$chosen_target"
    printf 'The `ironhorse-fuzz` service captured reproducers for the Ironhorse JS engine port.\n'
    printf 'Classify each into a bounded, durable triage record so only clusters of PROBABLE\n'
    printf 'port defects buy repair work; known oracle/harness artifacts and duplicates end here.\n\n'
    printf '## Members (bounded metadata — never paste input bytes into a prompt or a shell command)\n\n'
    for fid in $members; do
      local mk; mk="$(jshow "ironhorse-fuzz/findings/$fid.md")"
      printf -- '- Finding `%s`: sha256 `%s` (%s bytes), project `%s`, artifact `%s`, journal `ironhorse-fuzz/findings/%s.md`\n' \
        "$fid" "$(field "$mk" artifact_sha256)" "$(field "$mk" artifact_bytes)" "$(field "$mk" project_sha)" "$(field "$mk" artifact_path)" "$fid"
    done
    printf '\n## Procedure (per member, per designs/ironhorse-fuzz-triage-and-batch.md)\n\n'
    printf '1. Recover the minimized input to a FILE (decode `input_base64` from the finding marker\n'
    printf '   with `base64 -d`, or copy the durable artifact path). Verify its `sha256`.\n'
    printf '2. Reproduce by path at the recorded project SHA, and re-run at the current standing head\n'
    printf '   (`%s` branch of `%s`).\n' "$sbr" "$GARDEN_IRONHORSE_FUZZ_REPO"
    printf '3. Run the target-specific diagnostic adapter and write `ironhorse-fuzz/triage/<finding-id>.md`\n'
    printf '   (schema 1) with bounded fields only — `status` (genuine|artifact|duplicate|pending),\n'
    printf '   `failure_kind`, `failure_site`, `semantic_relation`, `input_shape`, `root_signature`,\n'
    printf '   `evidence_sha256`, `evidence_path`, `classified_at_project_sha`, and for a terminal\n'
    printf '   disposition a named `reason` (artifact) or `canonical_finding` (duplicate). Never put raw\n'
    printf '   input text in any field.\n'
    printf '4. A known-artifact relation becomes an automatic suppression ONLY once a versioned\n'
    printf '   deterministic matcher exists under `ironhorse-fuzz/suppressions/`; a new relation stays\n'
    printf '   `pending` until then. When uncertain, leave `status: pending` — an inconclusive triage\n'
    printf '   never becomes repair work.\n'
    printf '5. Land every triage record with journal CAS discipline. Post NO repair job — the producer\n'
    printf '   batches genuine findings into one cluster repair on a later tick.\n'
  } > "$jb"

  if "$GARDEN_IRONHORSE_FUZZ_POST" --identity "$base" "$base" "$jb" >/dev/null 2>&1; then
    posted_this_tick=$((posted_this_tick + 1))
    log "released triage job $base ($count finding(s), target $chosen_target)"
    rm -f "$jb"; return 0
  fi
  log "WARN: post of triage job $base did not land — findings persist, retry next tick"
  rm -f "$jb"; return 1
}

# ── Batcher: cluster genuine findings and release one cluster repair ──────────
release_cluster() {
  local rel fid target rootsig key first_key="" members
  declare -A CLUSTER_MEMBERS=()
  declare -A CLUSTER_TARGET=()
  declare -A CLUSTER_ROOTSIG=()
  local ordered=""
  while IFS= read -r rel; do
    [ -n "$rel" ] || continue
    fid="$(basename "$rel" .md)"
    [ "$(field "$(jshow "$rel")" generation)" = "$gen" ] || continue
    [ "$(finding_disposition "$fid")" = genuine ] || continue
    target="$(finding_target "$fid")"; [ -n "$target" ] || continue
    rootsig="$(field "$(triage_show "$fid")" root_signature)"; rootsig="${rootsig:-none}"
    key="${target}|${rootsig}"
    if [ -z "${CLUSTER_MEMBERS[$key]:-}" ]; then ordered="$ordered $key"; fi
    CLUSTER_MEMBERS["$key"]="${CLUSTER_MEMBERS[$key]:-} $fid"
    CLUSTER_TARGET["$key"]="$target"; CLUSTER_ROOTSIG["$key"]="$rootsig"
  done < <(git -C "$CLONE" ls-tree -r --name-only "origin/$JOURNAL_BRANCH" -- ironhorse-fuzz/findings \
    | grep '^ironhorse-fuzz/findings/[^/]*\.md$' | sort || true)

  for key in $ordered; do
    target="${CLUSTER_TARGET[$key]}"
    if target_doom_stopped "$target"; then
      log "cluster release for '$target' held: $DOOM_STOP_CNT same-signature dooms ($DOOM_STOP_SIG) >= stop threshold $GARDEN_IRONHORSE_FUZZ_DOOM_STOP_N"
      continue
    fi
    first_key="$key"; break
  done
  [ -n "$first_key" ] || { log "no genuine findings ready to cluster (or all held by doom feedback)"; return 1; }

  target="${CLUSTER_TARGET[$first_key]}"; rootsig="${CLUSTER_ROOTSIG[$first_key]}"
  local cluster_id count=0 chosen=""
  cluster_id="$(printf '%s\0%s\0%s' "$gen" "$target" "$rootsig" | sha256sum | cut -c1-12)"
  for fid in ${CLUSTER_MEMBERS[$first_key]}; do
    [ "$count" -lt "$GARDEN_IRONHORSE_FUZZ_CLUSTER_MAX" ] || break
    chosen="$chosen $fid"; count=$((count + 1))
  done

  local repair_base sbr smk
  repair_base="ironhorse-fuzz-${target}-${cluster_id}-repair"
  read -r sbr smk < <(standing_for_gen "$gen")

  if job_is_live "$repair_base" || job_is_complete "$repair_base"; then
    log "cluster repair $repair_base already live/complete — idempotent skip"; return 1
  fi

  # Write the durable cluster record (bounded; no raw bytes).
  local crec; crec="$(mktemp)"
  {
    printf 'schema: 1\n'
    printf 'cluster_id: %s\n' "$cluster_id"
    printf 'generation: %s\n' "$gen"
    printf 'target: %s\n' "$target"
    printf 'root_signature: %s\n' "$rootsig"
    printf 'branch: %s\n' "$sbr"
    printf 'marker_base: %s\n' "$smk"
    printf 'repair_base: %s\n' "$repair_base"
    printf 'created_by: %s\n' "$GARDEN"
    printf 'members:\n'
    for fid in $chosen; do printf -- '  - %s\n' "$fid"; done
  } > "$crec"
  if ! journal_put "ironhorse-fuzz/clusters/$cluster_id.md" "$crec" "ironhorse-fuzz: cluster $cluster_id ($target, $count member(s))"; then
    log "WARN: could not land cluster record $cluster_id — retry next tick"; rm -f "$crec"; return 1
  fi
  rm -f "$crec"

  post_cluster_repair "$cluster_id" "$target" "$rootsig" "$sbr" "$smk" "$repair_base" "$chosen"
}

post_cluster_repair() {  # <cluster-id> <target> <rootsig> <branch> <marker> <repair-base> <member-fids>
  local cluster_id="$1" target="$2" rootsig="$3" sbr="$4" smk="$5" repair_base="$6" members="$7"
  local proj toolchain cluster_sha count fid jb
  count="$(printf '%s\n' $members | grep -c .)"
  cluster_sha="$(jshow "ironhorse-fuzz/clusters/$cluster_id.md" | sha256sum | cut -d' ' -f1)"
  jb="$(mktemp)"
  {
    printf '%s\n' '---'
    printf '%s\n' 'role: builder'
    printf '%s\n' 'tier: mentor'
    printf '%s\n' 'fallback-tier: minion'
    printf '%s\n' 'dispatch: automatic'
    printf '%s\n\n' '---'
    printf '<!-- ironhorse-fuzz-target: %s -->\n' "$target"
    printf '<!-- ironhorse-fuzz-kind: cluster-repair -->\n\n'
    printf '# Repair one Ironhorse engine defect cluster (target `%s`, %s case(s)) and amend the standing PR\n\n' "$target" "$count"
    printf 'The `ironhorse-fuzz` triage stage grouped %s GENUINE finding(s) that share one root\n' "$count"
    printf 'signature into a single cluster. Identify the ONE causal change, add the smallest set of\n'
    printf 'load-bearing regression cases that distinguishes the behaviours, and amend the ONE standing\n'
    printf 'pull request. One cluster gets one gauntlet and one panel.\n\n'
    printf '## Cluster (bounded metadata — never paste input bytes into a prompt or a shell command)\n\n'
    printf -- '- Cluster record: `ironhorse-fuzz/clusters/%s.md` (sha256 `%s`)\n' "$cluster_id" "$cluster_sha"
    printf -- '- Target: `%s` (one of the maintained ironhorse-fuzz targets)\n' "$target"
    printf -- '- Root signature: `%s`\n' "$rootsig"
    printf -- '- Standing branch: `%s` of `%s` (base `%s`)\n\n' "$sbr" "$GARDEN_IRONHORSE_FUZZ_REPO" "$GARDEN_IRONHORSE_FUZZ_BASE_BRANCH"
    printf '### Members\n\n'
    for fid in $members; do
      local mk; mk="$(jshow "ironhorse-fuzz/findings/$fid.md")"
      proj="$(field "$mk" project_sha)"; toolchain="$(field "$mk" toolchain)"
      printf -- '- Finding `%s`: sha256 `%s` (%s bytes), project `%s`, toolchain `%s`, artifact `%s`\n' \
        "$fid" "$(field "$mk" artifact_sha256)" "$(field "$mk" artifact_bytes)" "$proj" "$toolchain" "$(field "$mk" artifact_path)"
    done
    printf '\n## Procedure\n\n'
    printf '1. Get an isolated project checkout of `%s` @ `%s` via ensure-project-worktree.sh.\n' "$GARDEN_IRONHORSE_FUZZ_REPO" "$sbr"
    printf '2. For each member recover the minimized input to a FILE without inlining it into any prompt\n'
    printf '   (decode `input_base64` from the finding marker with `base64 -d`, or copy the durable\n'
    printf '   artifact path). Verify each `sha256`.\n'
    printf '3. Set up the pinned `ironhorse-fuzz` environment (c/moddable submodule peer-init, the pinned\n'
    printf '   toolchain, cargo-fuzz — see the ironhorse-fuzz-build-setup runbook) and confirm the\n'
    printf '   incorrect behaviour or abort from each file before changing any code.\n'
    printf '4. Identify the ONE causal change common to the cluster. Add LOAD-BEARING regression cases as\n'
    printf '   Rust unit tests in `ironhorse-vm` (`fuzz/corpus` and `fuzz/artifacts` are gitignored, so a\n'
    printf '   corpus seed is not a permanent regression) — the smallest set that distinguishes behaviours.\n'
    printf '5. Fix the causal defect. Keep the fix minimal and targeted.\n'
    printf '6. Amend the STANDING branch `%s` with fetch/rebase/push CAS discipline, then\n' "$sbr"
    printf '   `scripts/jobs/gardening/ensure-pr.sh %s %s %s:%s %s` to create-or-adopt the standing\n' "$smk" "$GARDEN_IRONHORSE_FUZZ_REPO" "$GARDEN_IRONHORSE_FUZZ_BOT_LOGIN" "$sbr" "$GARDEN_IRONHORSE_FUZZ_BASE_BRANCH"
    printf '   PR (the `<!-- garden-job: %s -->` marker guarantees every cluster amends the SAME PR),\n' "$smk"
    printf '   and run its required gauntlet.\n'
    printf '7. Stamp each cleared member`s triage record with `resolved_by_cluster: %s` and the fixing\n' "$cluster_id"
    printf '   commit. Any member that SURVIVES the fix is recorded unresolved (drop its\n'
    printf '   `resolved_by_cluster`); the producer returns it to triage rather than claiming it fixed.\n'
    printf '8. Document the cluster and its solution in the standing PR body or a PR comment.\n'
  } > "$jb"

  if "$GARDEN_IRONHORSE_FUZZ_POST" --identity "$repair_base" "$repair_base" "$jb" >/dev/null 2>&1; then
    posted_this_tick=$((posted_this_tick + 1))
    log "released cluster repair $repair_base (cluster $cluster_id, $count member(s), target $target)"
    rm -f "$jb"; return 0
  fi
  log "WARN: post of cluster repair $repair_base did not land — cluster record persists, retry next tick"
  rm -f "$jb"; return 1
}

# ── Release orchestration: at most one bounded job per tick, serialized ───────
release_next() {
  # Refresh after post-job's separate producer clone may have advanced journal2.
  sync_clone "$CLONE"
  scan_doom_feedback
  if cluster_is_live; then
    log "cluster repair $CLUSTER_LIVE_BASE is live for gen $gen — holding triage and further clusters"
    return 0
  fi
  release_cluster && return 0        # advance genuine findings toward a fix first
  if triage_is_live; then
    log "a triage job is live — holding further triage/cluster release"
    return 0
  fi
  release_triage || true
}

findings_seen=0

# ── Backpressure gate: count nonterminal findings BEFORE running any target, and
#    apply the hysteretic band. At high water the tick captures nothing new; it
#    still runs the release phase below (which may release one triage or one
#    cluster job), so the backlog drains without the producer piling more on.
fuzz_this_tick=1
if backpressure_allows_fuzzing; then
  log "backpressure=running (nonterminal total=$NT_TOTAL max_target=$(max_target_nonterminal)); fuzzing this tick"
else
  fuzz_this_tick=0
  log "backpressure=stopped (nonterminal total=$NT_TOTAL max_target=$(max_target_nonterminal); high=${GARDEN_IRONHORSE_FUZZ_HIGH_WATER_TOTAL}/${GARDEN_IRONHORSE_FUZZ_HIGH_WATER_TARGET} low=${GARDEN_IRONHORSE_FUZZ_LOW_WATER_TOTAL}/${GARDEN_IRONHORSE_FUZZ_LOW_WATER_TARGET}); skipping all fuzz runs, draining via triage/cluster release only"
fi

cooldown_remaining="$(shared_cooldown_remaining || true)"
if [ "$fuzz_this_tick" = 1 ] && [ -n "$cooldown_remaining" ]; then
  log "shared runner cooldown active (${cooldown_remaining}s remaining); skipping fuzz targets this tick"
fi
if [ "$fuzz_this_tick" = 1 ] && [ -z "$cooldown_remaining" ]; then
  for target in $GARDEN_IRONHORSE_FUZZ_TARGETS; do
  is_allowed_target "$target" || continue
  corpus="$CORPUS_ROOT/$target"; mkdir -p "$corpus"
  arts="$ART_ROOT/$target"; mkdir -p "$arts"

  rc=0
  # Backgrounded so a drain SIGTERM (drain_forward) can reach the runner promptly, rather
  # than the trap being deferred until a slow foreground runner returns on its own.
  "$GARDEN_IRONHORSE_FUZZ_RUNNER" "$target" "$corpus" "$arts" "$GARDEN_IRONHORSE_FUZZ_SECS" \
    >"$LOGS_ROOT/$target.log" 2>&1 &
  runner_pid=$!
  wait "$runner_pid" || rc=$?
  runner_pid=""
  if [ "$rc" -ne 2 ]; then
    summarize_shared_recovery "$target"
  fi
  case "$rc" in
    0)  : ;;                                   # clean increment
    77) log "$target: runner reported a crash artifact" ;;
    2)  record_shared_failure "$target" "$LOGS_ROOT/$target.log"
        if [ "$shared_failure_count" -eq 1 ]; then
          log "WARN: shared fuzz campaign setup unavailable (runner rc=2 at $target); skipping remaining targets and retrying in ${shared_retry_secs}s (diagnostics retained at $SHARED_DIAGNOSTIC)"
        else
          log "shared fuzz campaign setup remains unavailable: consecutive failure #${shared_failure_count} after ${shared_outage_duration}s (runner rc=2 at $target); retrying in ${shared_retry_secs}s (latest diagnostics at $SHARED_DIAGNOSTIC)"
        fi
        break ;;
    *)  log "WARN: $target runner exited rc=$rc (see $LOGS_ROOT/$target.log) — skipping this target this tick"
        continue ;;
  esac

  # Handle every fresh crash artifact this target produced (bounded per tick).
  while IFS= read -r crash; do
    [ -n "$crash" ] || continue
    [ "$findings_seen" -lt "$GARDEN_IRONHORSE_FUZZ_MAX_FINDINGS_PER_TICK" ] || { log "reached per-tick finding cap; deferring the rest to next tick"; break; }
    findings_seen=$((findings_seen + 1))
    handle_finding "$target" "$crash"
  done < <(find "$arts" -type f 2>/dev/null | sort)

  # Corpus disk bound: prune oldest entries beyond the per-target cap.
  cap_kb=$(( GARDEN_IRONHORSE_FUZZ_CORPUS_MAX_MB * 1024 ))
  cur_kb="$(du -sk "$corpus" 2>/dev/null | cut -f1 || echo 0)"
  if [ "${cur_kb:-0}" -gt "$cap_kb" ]; then
    log "$target corpus ${cur_kb}KB over cap ${cap_kb}KB — pruning oldest"
    # Delete oldest files until under cap (never touch the artifacts we already handled).
    while [ "$(du -sk "$corpus" 2>/dev/null | cut -f1 || echo 0)" -gt "$cap_kb" ]; do
      oldest="$(find "$corpus" -type f -printf '%T@ %p\n' 2>/dev/null | sort -n | head -n1 | cut -d' ' -f2-)"
      [ -n "$oldest" ] || break
      rm -f "$oldest"
    done
  fi
  done
fi

# Findings are captured above without fan-out. Between capture and release sit the
# triage stage and the batcher: this releases AT MOST ONE bounded job for the
# standing generation — one triage batch or one cluster repair — serialized so a
# common root cause never buys several engagements before its first fix lands, and
# held per target when the reaper's doom feedback says that target keeps refusing.
release_next

# ─────────────────────────────────────────────────────────────────────────────
# 4. If we posted the FIRST finding of a generation, the repair job will create the
#    standing PR; record its number opportunistically so rollover detection works.
#    We do NOT create the PR here (that is the repair job's job) — we only learn its
#    number, which the PR-state seam can also resolve by marker on a later tick.
# ─────────────────────────────────────────────────────────────────────────────
if [ -z "$st_pr" ]; then
  pr_num="$("$GARDEN_IRONHORSE_FUZZ_PR_STATE" "$GARDEN_IRONHORSE_FUZZ_REPO" "$marker_base" "$GARDEN_IRONHORSE_FUZZ_BOT_LOGIN" --number 2>/dev/null | head -n1 | tr -d '[:space:]' || true)"
  if [ -n "$pr_num" ] && [ "$pr_num" != "0" ]; then
    write_standing "$gen" "$branch" "$marker_base" active "$pr_num" || true
    log "recorded standing PR #$pr_num for gen $gen"
  fi
fi

log "tick complete: gen=$gen findings_handled=$findings_seen repair_jobs_posted=$posted_this_tick"
exit 0
