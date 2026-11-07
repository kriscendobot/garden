#!/bin/bash
# shellcheck disable=SC2016
# run-sandboxed-state-test.sh — the sandbox gives each job a writable, isolated
# GARDEN_STATE, keeps the host state read-only, drops inherited clone paths, and
# shares only repo-locks with the host so same-host pushes still serialize.
set -uo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RS="$HERE/../../secrets/run-sandboxed.sh"
PASS=0; FAIL=0
ok()  { PASS=$((PASS+1)); echo "  ok: $1"; }
bad() { FAIL=$((FAIL+1)); echo "  FAIL: $1"; }

if ! command -v bwrap >/dev/null 2>&1 || ! bwrap --ro-bind / / true 2>/dev/null; then
  echo "  SKIP: bwrap unusable here"; exit 0
fi

BASE="$(mktemp -d "${GARDEN_TEST_BASE:-$HOME}/.sbx-state-test.XXXXXX")"
trap 'rm -rf "$BASE"' EXIT
mkdir -p "$BASE/tmp" "$BASE/wt" "$BASE/state/monks/2/journal"
S="$BASE/state"
export TMPDIR="$BASE/tmp" GARDEN_STATE="$S" GARDEN_SECRETS_DIR="$BASE/secrets"
# Hermetic root: keep the real garden scratch bind from covering $BASE.
export GARDEN_ROOT="$BASE/root"; unset GARDEN_SCRATCH
export GARDEN_WORKER_CLONE="$S/monks/2/journal" GARDEN_PRODUCER_CLONE="$S/producer/journal"
export GARDEN_INBOX_CLONE="$S/inbox/x/journal" JOURNAL_REMOTE_CACHE="$S/config/journal-remote"

run() { "$RS" --worktree "$BASE/wt" -- bash -c "$1" 2>&1; }

out="$(run '
  case "$GARDEN_STATE" in "'"$S"'"/sandbox-state/sbx-state.*) ;; *) echo "state=$GARDEN_STATE"; exit 41;; esac
  mkdir -p "$GARDEN_STATE/inbox/x" && : >"$GARDEN_STATE/journal.lock" || exit 42
  if touch "'"$S"'/nope" 2>/dev/null; then exit 43; fi
  if touch "'"$S"'/monks/2/journal/nope" 2>/dev/null; then exit 44; fi
  for v in GARDEN_WORKER_CLONE GARDEN_PRODUCER_CLONE GARDEN_INBOX_CLONE JOURNAL_REMOTE_CACHE; do
    [ -z "${!v+x}" ] || { echo "$v leaked"; exit 45; }
  done
  mkdir -p "$GARDEN_STATE/repo-locks/k" && : >"$GARDEN_STATE/repo-locks/k/repo.lock" || exit 46
  echo ran
')"; rc=$?
if [ "$rc" -eq 0 ] && [ "$out" = ran ]; then
  ok "per-job GARDEN_STATE writable; host state read-only; clone paths re-derived"
else
  bad "sandbox GARDEN_STATE check failed rc=$rc out='$out'"
fi

if [ -f "$S/repo-locks/k/repo.lock" ]; then
  ok "repo-locks are the host's shared directory"
else
  bad "repo-lock written in the sandbox is not visible on the host"
fi

a="$(run 'echo "$GARDEN_STATE"')"; b="$(run 'echo "$GARDEN_STATE"')"
if [ -n "$a" ] && [ "$a" != "$b" ]; then
  ok "each sandboxed run gets its own state directory"
else
  bad "state directories not isolated: '$a' vs '$b'"
fi

out="$(run 'ls "$GARDEN_STATE/sandbox-state" 2>/dev/null | wc -l; touch "'"$a"'/x" 2>/dev/null && echo leak')"
case "$out" in *leak*) bad "a job can write a sibling job's state";; *) ok "sibling job state stays read-only";; esac

echo "run-sandboxed-state: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
