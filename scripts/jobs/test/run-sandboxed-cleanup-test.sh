#!/bin/bash
# shellcheck disable=SC2016
# run-sandboxed-cleanup-test.sh — the launcher removes the per-job TMPDIR and
# GARDEN_STATE when the job exits, keeps the job's exit status and stdin, forwards
# TERM, and tells the job to borrow journal objects instead of copying them.
set -uo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RS="$HERE/../../secrets/run-sandboxed.sh"
PASS=0; FAIL=0
ok()  { PASS=$((PASS+1)); echo "  ok: $1"; }
bad() { FAIL=$((FAIL+1)); echo "  FAIL: $1"; }
if ! command -v bwrap >/dev/null 2>&1 || ! bwrap --ro-bind / / true 2>/dev/null; then
  echo "  SKIP: bwrap unusable here"; exit 0
fi
BASE="$(mktemp -d "${GARDEN_TEST_BASE:-$HOME}/.sbx-cleanup-test.XXXXXX")"
trap 'rm -rf "$BASE"' EXIT
mkdir -p "$BASE/tmp" "$BASE/wt" "$BASE/state"
export TMPDIR="$BASE/tmp" GARDEN_STATE="$BASE/state" GARDEN_SECRETS_DIR="$BASE/secrets"
export GARDEN_ROOT="$BASE/root"; unset GARDEN_SCRATCH
run() { "$RS" --worktree "$BASE/wt" -- bash -c "$1"; }

out="$(run 'echo "$GARDEN_JOURNAL_BORROW_OBJECTS"; echo hi >"$GARDEN_STATE/f"; echo hi >"$TMPDIR/f"')"
[ "$out" = 1 ] && ok "job is told to borrow journal objects" || bad "borrow flag: '$out'"
if [ -z "$(ls -A "$BASE/state/sandbox-state")" ] && [ -z "$(ls -A "$BASE/tmp")" ]; then
  ok "per-job state and TMPDIR removed on exit"
else
  bad "leftovers: $(ls "$BASE/state/sandbox-state" "$BASE/tmp" | tr '\n' ' ')"
fi
run 'exit 7'; rc=$?
[ "$rc" -eq 7 ] && ok "job exit status preserved" || bad "rc=$rc, wanted 7"
out="$(echo piped | run 'cat')"
[ "$out" = piped ] && ok "stdin reaches the job" || bad "stdin: '$out'"
start=$SECONDS
"$RS" --worktree "$BASE/wt" -- bash -c 'sleep 30' & pid=$!
sleep 2; kill -TERM "$pid"; wait "$pid" 2>/dev/null
if [ $((SECONDS - start)) -lt 15 ]; then ok "TERM stops the job promptly"; else bad "TERM did not stop the job"; fi
sleep 1
[ -z "$(ls -A "$BASE/state/sandbox-state")" ] && ok "state removed after TERM" || bad "state left after TERM"
echo "run-sandboxed-cleanup: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
