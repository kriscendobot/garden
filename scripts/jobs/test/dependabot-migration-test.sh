#!/bin/bash
# dependabot-migration-test.sh — validate dependabot-migration.sh's hook table and
# its fail-closed runner on throwaway git fixtures, with no network. `npm` is a PATH
# stub whose behaviour per script name is driven by STUB_* variables, so each gate
# is exercised without Anthropic's manifest or gpg.
#
# Asserts:
#   A. lookup: the exact (repo, package) row matches; a different repo, a different
#      package, and a prefix of the package do not
#   B. happy path: a plain bump plus a refresh that rewrites only release.json →
#      `committed <sha>`, and the new commit touches release.json alone
#   C. a requeue on an already-refreshed head → `already-current`, no new commit
#   D. a PR that touches a path outside the input set → rc 2, refresh never runs
#   E. a dirty checkout → rc 2, refresh never runs
#   F. a refresh that writes outside the output set → rc 3, nothing committed
#   G. a refresh that creates an untracked file → rc 3, nothing committed
#   H. a failed refresh → rc 4; a failed pin check → rc 4; nothing committed
#   I. lifecycle hooks are disabled for the npm invocations (ignore-scripts)
#
# Usage: dependabot-migration-test.sh
set -euo pipefail
export GARDEN_TEST=1
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MIG="$(cd "$HERE/.." && pwd)/dependabot-migration.sh"
TR="$(mktemp -d "${TMPDIR:-/tmp}/depmig-test.XXXXXX")"
trap 'rm -rf "$TR"' EXIT
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
hr()  { echo "----------------------------------------------------------------"; }
git_id=(-c user.name=test -c user.email=test@localhost)
H=tools/claude-harness

# --- npm stub ----------------------------------------------------------------
mkdir -p "$TR/bin"
cat > "$TR/bin/npm" <<'EOF'
#!/bin/bash
# npm --prefix <dir> run --silent <script>
prefix="" script=""
while [ $# -gt 0 ]; do
  case "$1" in --prefix) prefix="$2"; shift 2;; run|--silent) shift;; *) script="$1"; shift;; esac
done
printf '%s ignore=%s\n' "$script" "${npm_config_ignore_scripts:-}" >> "$STUB_LOG"
cd "$prefix"
case "$script" in
  claude-harness:refresh)
    [ "${STUB_REFRESH_FAIL:-}" = 1 ] && exit 1
    [ -n "${STUB_REFRESH_WRITE:-}" ] && printf '{"version":"%s"}\n' "${STUB_VERSION:-2.1.283}" > tools/claude-harness/release.json
    [ -n "${STUB_STRAY_MOD:-}" ] && echo stray >> "$STUB_STRAY_MOD"
    [ -n "${STUB_STRAY_NEW:-}" ] && echo new > "$STUB_STRAY_NEW"
    exit 0 ;;
  claude-harness:check)
    [ "${STUB_CHECK_FAIL:-}" = 1 ] && exit 1
    exit 0 ;;
esac
exit 2
EOF
chmod +x "$TR/bin/npm"
export PATH="$TR/bin:$PATH" STUB_LOG="$TR/npm.log"

# fixture <dir> [extra-path]: base commit, then a Dependabot-shaped bump commit.
fixture() {
  local d="$1"
  git init -q "$d"
  mkdir -p "$d/$H" "$d/src"
  echo '{"dependencies":{"@anthropic-ai/claude-code":"2.1.278"}}' > "$d/$H/package.json"
  echo '{"lock":"2.1.278"}' > "$d/$H/package-lock.json"
  echo '{"version":"2.1.278"}' > "$d/$H/release.json"
  echo 'code' > "$d/src/app.js"
  git -C "$d" add -A; git -C "$d" "${git_id[@]}" commit -q -m base
  git -C "$d" tag base
  echo '{"dependencies":{"@anthropic-ai/claude-code":"2.1.283"}}' > "$d/$H/package.json"
  echo '{"lock":"2.1.283"}' > "$d/$H/package-lock.json"
  [ -n "${2:-}" ] && echo touched >> "$d/$2"
  git -C "$d" add -A; git -C "$d" "${git_id[@]}" commit -q -m 'Bump @anthropic-ai/claude-code'
  git -C "$d" config user.name test; git -C "$d" config user.email test@localhost
}
run() {  # run <dir> -> sets RC, OUT
  set +e; OUT="$("$MIG" run claude-harness-refresh "$1" base 2>"$TR/err")"; RC=$?; set -e
}
refreshed() { grep -q '^claude-harness:refresh' "$STUB_LOG" 2>/dev/null; }
head_is() { [ "$(git -C "$1" log -1 --format=%s)" = "$2" ]; }

hr; echo "A — lookup matches only the exact (repo, package) row"; hr
[ "$("$MIG" lookup kriscendobot/minion.town @anthropic-ai/claude-code)" = claude-harness-refresh ] \
  && ok "exact row matches" || bad "exact row did not match"
"$MIG" lookup endojs/endo-but-for-bots @anthropic-ai/claude-code >/dev/null && bad "other repo matched" || ok "other repo: no hook"
"$MIG" lookup kriscendobot/minion.town vitest >/dev/null && bad "other package matched" || ok "other package: no hook"
"$MIG" lookup kriscendobot/minion.town @anthropic-ai/claude >/dev/null && bad "package prefix matched" || ok "package prefix: no hook"

hr; echo "B — happy path commits release.json alone"; hr
: > "$STUB_LOG"; fixture "$TR/b"
STUB_REFRESH_WRITE=1 run "$TR/b"
[ "$RC" -eq 0 ] && [ "${OUT%% *}" = committed ] && ok "rc 0, $OUT" || bad "rc $RC out '$OUT' err $(cat "$TR/err")"
[ "$(git -C "$TR/b" show --name-only --format= HEAD)" = "$H/release.json" ] \
  && ok "commit touches release.json only" || bad "commit touched: $(git -C "$TR/b" show --name-only --format= HEAD | tr '\n' ' ')"
[ -z "$(git -C "$TR/b" status --porcelain)" ] && ok "checkout clean after commit" || bad "checkout left dirty"
grep -q '^claude-harness:check' "$STUB_LOG" && ok "pin check ran on the result" || bad "pin check never ran"

hr; echo "C — already-refreshed head is a no-op"; hr
: > "$STUB_LOG"; before="$(git -C "$TR/b" rev-parse HEAD)"
STUB_REFRESH_WRITE=1 run "$TR/b"
[ "$RC" -eq 0 ] && [ "$OUT" = already-current ] && [ "$(git -C "$TR/b" rev-parse HEAD)" = "$before" ] \
  && ok "already-current, no new commit" || bad "rc $RC out '$OUT'"

hr; echo "D — PR outside the input set is refused before running"; hr
: > "$STUB_LOG"; fixture "$TR/d" src/app.js
STUB_REFRESH_WRITE=1 run "$TR/d"
[ "$RC" -eq 2 ] && ! refreshed && grep -q 'not a plain bump' "$TR/err" \
  && ok "rc 2, refresh never ran" || bad "rc $RC refreshed=$(refreshed && echo y || echo n)"

hr; echo "E — dirty checkout is refused before running"; hr
: > "$STUB_LOG"; fixture "$TR/e"; echo scratch > "$TR/e/scratch.txt"
STUB_REFRESH_WRITE=1 run "$TR/e"
[ "$RC" -eq 2 ] && ! refreshed && ok "rc 2, refresh never ran" || bad "rc $RC"

hr; echo "F — write outside the output set fails closed"; hr
: > "$STUB_LOG"; fixture "$TR/f"
STUB_REFRESH_WRITE=1 STUB_STRAY_MOD="$H/package-lock.json" run "$TR/f"
[ "$RC" -eq 3 ] && head_is "$TR/f" 'Bump @anthropic-ai/claude-code' \
  && ok "rc 3, nothing committed" || bad "rc $RC head '$(git -C "$TR/f" log -1 --format=%s)'"

hr; echo "G — untracked output fails closed"; hr
: > "$STUB_LOG"; fixture "$TR/g"
STUB_REFRESH_WRITE=1 STUB_STRAY_NEW="$H/extra.json" run "$TR/g"
[ "$RC" -eq 3 ] && head_is "$TR/g" 'Bump @anthropic-ai/claude-code' \
  && ok "rc 3, nothing committed" || bad "rc $RC"

hr; echo "H — refresh or pin-check failure fails closed"; hr
: > "$STUB_LOG"; fixture "$TR/h1"
STUB_REFRESH_FAIL=1 run "$TR/h1"
[ "$RC" -eq 4 ] && head_is "$TR/h1" 'Bump @anthropic-ai/claude-code' && ok "failed refresh: rc 4" || bad "rc $RC"
: > "$STUB_LOG"; fixture "$TR/h2"
STUB_REFRESH_WRITE=1 STUB_CHECK_FAIL=1 run "$TR/h2"
[ "$RC" -eq 4 ] && head_is "$TR/h2" 'Bump @anthropic-ai/claude-code' && ok "failed pin check: rc 4" || bad "rc $RC"

hr; echo "I — npm runs with lifecycle scripts disabled"; hr
: > "$STUB_LOG"; fixture "$TR/i"
STUB_REFRESH_WRITE=1 run "$TR/i"
! grep -qv 'ignore=true$' "$STUB_LOG" && [ -s "$STUB_LOG" ] \
  && ok "every npm call carried npm_config_ignore_scripts=true" || bad "$(cat "$STUB_LOG")"

hr
echo "TOTAL: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
