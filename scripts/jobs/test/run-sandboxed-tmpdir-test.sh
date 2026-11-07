#!/bin/bash
# shellcheck disable=SC2016
# run-sandboxed-tmpdir-test.sh — the sandbox gives the harness a writable per-job
# TMPDIR while leaving sibling directories under the parent TMPDIR read-only.
set -uo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
RS="$HERE/../../secrets/run-sandboxed.sh"
PASS=0; FAIL=0
ok()  { PASS=$((PASS+1)); echo "  ok: $1"; }
bad() { FAIL=$((FAIL+1)); echo "  FAIL: $1"; }

if ! command -v bwrap >/dev/null 2>&1 || ! bwrap --ro-bind / / true 2>/dev/null; then
  echo "  SKIP: bwrap unusable here"; exit 0
fi

BASE="$(mktemp -d "${GARDEN_TEST_BASE:-$HOME}/.sbx-tmpdir-test.XXXXXX")"
trap 'rm -rf "$BASE"' EXIT
mkdir -p "$BASE/tmp/sibling" "$BASE/wt"
export TMPDIR="$BASE/tmp" GARDEN_STATE="$BASE/state" GARDEN_SECRETS_DIR="$BASE/secrets"

out="$("$RS" --worktree "$BASE/wt" -- bash -c '
  [ "$TMPDIR" != "'"$BASE/tmp"'" ] || exit 41
  case "$TMPDIR" in "'"$BASE/tmp"'"/sbx-tmp.*) ;; *) exit 42;; esac
  mkdir -p "$TMPDIR/claude-1000/session" || exit 43
  printf "#!/bin/sh\necho ran\n" >"$TMPDIR/x"; chmod +x "$TMPDIR/x"; "$TMPDIR/x"
  if mkdir "'"$BASE/tmp/sibling"'/nope" 2>/dev/null; then exit 44; fi
  if touch "'"$BASE/tmp"'/nope" 2>/dev/null; then exit 45; fi
' 2>&1)"; rc=$?
if [ "$rc" -eq 0 ] && [ "$out" = ran ]; then
  ok "per-job TMPDIR is writable and exec-capable; sibling and parent stay read-only"
else
  bad "sandbox TMPDIR check failed rc=$rc out='$out'"
fi

echo "run-sandboxed-tmpdir: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
