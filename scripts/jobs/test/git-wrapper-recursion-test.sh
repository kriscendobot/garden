#!/bin/bash
# git-wrapper-recursion-test.sh: a PATH shim that execs bin/git again fails fast
# instead of nesting until the worker's memory limit stalls the host, and ordinary
# nesting through a shim to the real git still works.

set -uo pipefail
export GARDEN_TEST=1
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
WRAPPER_DIR="$(cd "$HERE/../bin" && pwd)"
PASS=0; FAIL=0
ok() { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }

TR="$(mktemp -d "${TMPDIR:-/tmp}/git-wrapper-recursion.XXXXXX")"; trap 'rm -rf "$TR"' EXIT
export GARDEN_STATE="$TR/state"; mkdir -p "$GARDEN_STATE"
REAL_GIT=""
while IFS= read -r candidate; do
  case "$candidate" in */scripts/jobs/bin/git) continue ;; esac
  REAL_GIT="$candidate"; break
done < <(type -aP git)
[ -n "$REAL_GIT" ] || { echo "no real git on PATH"; exit 1; }

mkdir "$TR/cycle" "$TR/good"
printf '#!/bin/bash\nexec "%s/git" "$@"\n' "$WRAPPER_DIR" > "$TR/cycle/git"
printf '#!/bin/bash\nexec "%s" "$@"\n' "$REAL_GIT" > "$TR/good/git"
chmod +x "$TR/cycle/git" "$TR/good/git"
# On a noexec TMPDIR the wrapper would skip these shims and never reach the cycle.
"$TR/good/git" --version >/dev/null 2>&1 || { echo "cannot execute shims in $TR: set TMPDIR"; exit 1; }

run() { # <shim-dir> <git args...>; a wrapper without the guard hits this timeout
  local dir="$1"; shift
  env -u GARDEN_REAL_GIT -u GARDEN_GIT_BOUNDED -u GARDEN_GIT_WRAPPER_DEPTH \
    PATH="$WRAPPER_DIR:$dir:$PATH" timeout -k 2 "${RUN_TIMEOUT:-60}" git "$@"
}

for cmd in "init -q $TR/cycle-repo" "--version"; do
  # shellcheck disable=SC2086
  run "$TR/cycle" $cmd > "$TR/cycle.out" 2>&1; rc=$?
  [ "$rc" = 126 ] && ok "'$cmd' through a cycle fails with rc=126" || bad "'$cmd' rc=$rc, wanted 126"
  grep -q 'garden git wrapper: nested' "$TR/cycle.out" && ok "'$cmd' names the cycle" || bad "'$cmd' printed no diagnosis"
done

rc=0; run "$TR/good" init -q "$TR/repo" || rc=$?
[ "$rc" = 0 ] && ok "init through a shim to the real git works" || bad "init rc=$rc"
out="$(run "$TR/good" -C "$TR/repo" rev-parse --is-inside-work-tree 2>/dev/null)"
[ "$out" = true ] && ok "a bounded command through the shim works" || bad "rev-parse said '$out'"

# A hook that calls git nests the wrapper without any cycle.
printf '#!/bin/bash\ngit rev-parse HEAD >/dev/null\n' > "$TR/repo/.git/hooks/post-commit"
chmod +x "$TR/repo/.git/hooks/post-commit"
rc=0; run "$TR/good" -C "$TR/repo" -c user.name=t -c user.email=t@example.invalid commit -q --allow-empty -m one 2>"$TR/hook.err" || rc=$?
[ "$rc" = 0 ] && ! grep -q 'nested' "$TR/hook.err" && ok "a hook calling git stays under the limit" || bad "hook commit rc=$rc: $(cat "$TR/hook.err")"

# A bad inherited value must not defeat the guard or fail the command.
rc=0; GARDEN_GIT_WRAPPER_DEPTH=junk env -u GARDEN_REAL_GIT PATH="$WRAPPER_DIR:$TR/good:$PATH" git --version >/dev/null 2>&1 || rc=$?
[ "$rc" = 0 ] && ok "a non-numeric inherited depth is reset" || bad "junk depth rc=$rc"

echo "git-wrapper-recursion-test: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
