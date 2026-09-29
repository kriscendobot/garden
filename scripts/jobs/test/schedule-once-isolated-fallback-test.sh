#!/bin/bash
# schedule-once-isolated-fallback-test.sh — set-schedule-once.sh must land a
# deferral even when the shared producer clone is wedged or broken.
#
# Regression for improve-schedule-once-producer-livelock: at 2026-09-29T17:17Z
# the shared producer clone was corrupt and livelocked on a stale index.lock,
# and set-schedule-once.sh had no path around it. The script now caps the
# shared-clone phase and falls back to a fresh temporary clone.
#
# Asserts:
#   1. HEALTHY  — the shared clone lands the schedule (no fallback logged).
#   2. HANG     — a shared clone whose commit hangs (a pre-commit hook sleeping
#      far past the phase-1 cap) is abandoned, and the isolated clone lands it.
#   3. COMMIT-FAILS — a shared clone whose commit always fails (the stale-lock
#      shape: commit_and_push rc=2) is NOT mistaken for "unchanged"; the
#      isolated clone lands it.
#   4. IDEMPOTENT — re-running with identical content through the broken clone
#      succeeds without minting a new commit.
#
# Hermetic: a throwaway bare journal; no real garden, journal, or network.
#
# Usage: schedule-once-isolated-fallback-test.sh

# shellcheck disable=SC2015,SC2046
set -uo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
TR="$(mktemp -d "${TMPDIR:-/tmp}/schedule-once-fallback-test.XXXXXX")"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
trap 'rm -rf "$TR"' EXIT

unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_)' || true) 2>/dev/null || true

BARE="$TR/journal.git"; git init -q --bare "$BARE"
SEED="$TR/seed"; git init -q "$SEED"; git -C "$SEED" checkout -q -b journal2
( cd "$SEED" || exit 1
  mkdir -p schedules; touch schedules/.gitkeep
  git add -A
  git -c user.name=test -c user.email=test@localhost commit -q -m seed
  git remote add origin "$BARE"
  git push -q -u origin journal2 )

export JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH=journal2 GARDEN_TEST=1 \
       GARDEN_STATE="$TR/state" GARDEN_PRODUCER_CLONE="$TR/state/producer/journal" \
       GARDEN=fallbackhost GARDEN_ROLE=gardener GARDEN_NO_MAINTAINER_ALERT=1 \
       GARDEN_SCHEDULE_ONCE_SHARED_ATTEMPTS=2 GARDEN_FETCH_KILL_AFTER=2
ohead() { git ls-remote "$BARE" refs/heads/journal2 | awk '{print $1}'; }
landed() {  # landed <name> <when> — origin carries the schedule with that time
  git --git-dir="$BARE" show "journal2:schedules/$1.md" 2>/dev/null | grep -qx "once: $2"
}
run() {  # run <name> <when> ; fills $rc/$out
  # Capture through a file, not $(...): the abandoned hook's orphaned `sleep`
  # keeps a capture pipe open until it exits.
  printf 'body for %s\n' "$1" | timeout 120 "$JOBS/set-schedule-once.sh" "$1" "$2" >"$TR/out" 2>&1
  rc=$?; out="$(cat "$TR/out")"
}
hook() {  # hook <script-body> — install a pre-commit hook in the shared clone
  printf '#!/bin/sh\n%s\n' "$1" > "$GARDEN_PRODUCER_CLONE/.git/hooks/pre-commit"
  chmod +x "$GARDEN_PRODUCER_CLONE/.git/hooks/pre-commit"
}

echo "== 1. HEALTHY: the shared producer clone lands the schedule"
run healthy 2030-01-01T00:00:00Z
[ "$rc" -eq 0 ] && landed healthy 2030-01-01T00:00:00Z && ok "landed via shared clone" \
  || bad "healthy run failed (rc=$rc): $out"
grep -q 'falling back' <<<"$out" && bad "healthy run fell back: $out" || ok "no fallback on a healthy clone"

echo "== 2. HANG: a wedged shared clone is abandoned at the phase-1 cap"
hook 'sleep 30'
t0=$(date +%s)
GARDEN_SCHEDULE_ONCE_SHARED_TIMEOUT=5 run hang 2030-02-01T00:00:00Z
dt=$(( $(date +%s) - t0 ))
[ "$rc" -eq 0 ] && landed hang 2030-02-01T00:00:00Z && ok "landed via isolated clone" \
  || bad "hang run failed (rc=$rc): $out"
grep -q 'via isolated clone' <<<"$out" && ok "logged the isolated landing" || bad "no isolated-landing log: $out"
[ "$dt" -lt 60 ] && ok "bounded (${dt}s)" || bad "took ${dt}s"

echo "== 3. COMMIT-FAILS: rc=2 from a failed commit is not trusted as unchanged"
hook 'exit 1'
run failing 2030-03-01T00:00:00Z
[ "$rc" -eq 0 ] && landed failing 2030-03-01T00:00:00Z && ok "landed via isolated clone" \
  || bad "commit-fails run did not land (rc=$rc): $out"
grep -q 'schedule failing unchanged' <<<"$out" && bad "a failed commit was reported unchanged: $out" \
  || ok "failed commit not reported as unchanged"

echo "== 4. IDEMPOTENT: identical content through the broken clone mints nothing"
h0="$(ohead)"
run failing 2030-03-01T00:00:00Z
[ "$rc" -eq 0 ] && ok "idempotent re-run succeeds" || bad "idempotent re-run failed (rc=$rc): $out"
[ "$(ohead)" = "$h0" ] && ok "no new commit" || bad "journal head moved on an identical re-run"

echo "passed=$PASS failed=$FAIL"
[ "$FAIL" -eq 0 ]
