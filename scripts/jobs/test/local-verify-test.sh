#!/bin/bash
# local-verify-test.sh — validate the deterministic pre-PR verification harness.
#
# Asserts the contract from skills/local-verify/SKILL.md:
#   1. A full pass emits NOTHING and exits 0.
#   2. A failing step emits ONLY `STEP <name> FAILED ... <sha>` + a one-line tail
#      (no raw output body), and exits non-zero.
#   3. `git cat-file -p <sha>` in the worktree returns the captured combined
#      output of the failing step.
#   4. Steps are discovered from package.json scripts (check-variant first).
#   5. Overrides: LOCAL_VERIFY_<STEP>=- skips; =<cmd> replaces.
#   6. A worktree with no package.json verifies nothing and exits 0.
#   7. The run is deterministic: identical failing input hashes to the same SHA.
#   8. Codegen-then-clean gate: a generator that staled a checked-in artifact
#      leaves the tree dirty -> the gate fails with a `left tree dirty` message
#      and a SHA-captured diff --stat (no raw diff on stdout); an up-to-date
#      generator keeps the tree clean and the gate silent.
#
# No systemd, no network: the harness is exercised against throwaway git repos
# with a stubbed package runner (GARDEN_YARN).

# The fixtures below are single-quoted stub bodies that must NOT expand (SC2016),
# and the ok/bad assertion idiom is the intended A && pass || fail (SC2015, safe
# because ok never fails). Both are deliberate throughout this test.
# shellcheck disable=SC2015,SC2016
set -uo pipefail
# Explicit positive test-context sentinel: protects this standalone suite even when
# invoked outside the test-tree entrypoint heuristic.
export GARDEN_TEST=1
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LV="$(cd "$HERE/../gardening" && pwd)/local-verify.sh"
TR="$(mktemp -d "${TMPDIR:-/tmp}/lv-test.XXXXXX")"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
trap 'rm -rf "$TR"' EXIT

# A stub package runner: `yarn run <script>` -> run scripts/<script> body from a
# tiny dispatch table the fixture defines. Invoked as `bash <stub> run <script>`.
make_repo() {  # make_repo <dir> <stub-body>
  local dir="$1" stub="$2"
  mkdir -p "$dir"; git -C "$dir" init -q
  git -C "$dir" config user.email t@localhost; git -C "$dir" config user.name test
  cat > "$dir/package.json" <<'PKG'
{ "name": "fixture", "scripts": { "format:check": "fmt", "lint": "lint", "test": "test" } }
PKG
  printf '%s\n' "$stub" > "$dir/yarn-stub.sh"
  git -C "$dir" add -A; git -C "$dir" commit -qm init >/dev/null
}

# --- 1+2+3: a failing test step --------------------------------------------
R1="$TR/fail"
make_repo "$R1" '#!/bin/bash
case "$2" in
  format:check) echo "prettier: ok"; exit 0 ;;
  lint)         echo "eslint: clean"; exit 0 ;;
  test)         echo "test 1 ok"; echo "test 2 FAIL boom"; echo "1 failed"; exit 1 ;;
  *)            echo "unknown $2"; exit 1 ;;
esac'
out="$(GARDEN_YARN="bash $R1/yarn-stub.sh" "$LV" "$R1" 2>&1)"; rc=$?
[ "$rc" -ne 0 ] && ok "failing run exits non-zero ($rc)" || bad "failing run should exit non-zero"
printf '%s' "$out" | grep -q 'STEP test FAILED' && ok "emits the failing step name" || bad "missing STEP test FAILED line"
printf '%s' "$out" | grep -qv 'STEP format' && ! printf '%s' "$out" | grep -q 'STEP format'  && ok "passing steps are silent" || bad "passing steps leaked"
sha="$(printf '%s' "$out" | grep -oE '[0-9a-f]{40}' | head -1)"
[ -n "$sha" ] && ok "emits a 40-hex blob SHA" || bad "no blob SHA in output"
# The raw failing body must NOT be in stdout (only the one-line tail may be).
printf '%s' "$out" | grep -q 'test 2 FAIL boom' && bad "raw output body leaked to stdout" || ok "raw output body NOT in stdout"
# But the blob must hold the full captured output.
blob="$(git -C "$R1" cat-file -p "$sha" 2>/dev/null)"
printf '%s' "$blob" | grep -q 'test 2 FAIL boom' && ok "git cat-file returns the captured output" || bad "blob missing captured output"

# --- 4: discovery picks the check-variant for format -----------------------
# (format:check exists; the stub echoes which script it ran — assert via a forced
# format failure so the script name surfaces in the captured blob.)
R4="$TR/disc"
make_repo "$R4" '#!/bin/bash
echo "ran:$2"; [ "$2" = "format:check" ] && exit 1 || exit 0'
o4="$(GARDEN_YARN="bash $R4/yarn-stub.sh" "$LV" "$R4" 2>&1)"
s4="$(printf '%s' "$o4" | grep -oE '[0-9a-f]{40}' | head -1)"
git -C "$R4" cat-file -p "$s4" 2>/dev/null | grep -q 'ran:format:check' \
  && ok "discovers the format:check variant" || bad "format discovery wrong"

# --- 5: overrides (skip + replace) -----------------------------------------
R5="$TR/over"
make_repo "$R5" '#!/bin/bash
echo "stub:$2"; exit 0'
o5="$(LOCAL_VERIFY_FORMAT=- LOCAL_VERIFY_TEST='echo override-ran; exit 2' \
      GARDEN_YARN="bash $R5/yarn-stub.sh" "$LV" "$R5" 2>&1)"; rc5=$?
[ "$rc5" -ne 0 ] && ok "override failing command exits non-zero" || bad "override command did not fail"
s5="$(printf '%s' "$o5" | grep -oE '[0-9a-f]{40}' | head -1)"
git -C "$R5" cat-file -p "$s5" 2>/dev/null | grep -q 'override-ran' \
  && ok "LOCAL_VERIFY_TEST override command runs" || bad "test override not honored"
printf '%s' "$o5" | grep -q 'STEP format' && bad "LOCAL_VERIFY_FORMAT=- did not skip" || ok "LOCAL_VERIFY_FORMAT=- skips the step"

# --- 6: no package.json -> silent, exit 0 ----------------------------------
R6="$TR/empty"; mkdir -p "$R6"; git -C "$R6" init -q
o6="$("$LV" "$R6" 2>&1)"; rc6=$?
[ "$rc6" -eq 0 ] && [ -z "$o6" ] && ok "no package.json: silent, exit 0" || bad "empty repo not silent/zero (rc=$rc6 out=[$o6])"

# --- 7: determinism (same input -> same SHA) -------------------------------
o7="$(GARDEN_YARN="bash $R1/yarn-stub.sh" "$LV" "$R1" 2>&1)"
sha7="$(printf '%s' "$o7" | grep -oE '[0-9a-f]{40}' | head -1)"
[ "$sha7" = "$sha" ] && ok "deterministic: identical failure hashes to the same SHA" || bad "non-deterministic SHA ($sha vs $sha7)"

# --- 8: codegen-then-clean gate fires when a generator staled an artifact ----
# `gen:code-mode-types` rewrites a checked-in artifact to NEW content, so the
# worktree goes dirty after the steps run; the gate must fail loud.
R8="$TR/codegen-dirty"; mkdir -p "$R8"; git -C "$R8" init -q
git -C "$R8" config user.email t@localhost; git -C "$R8" config user.name test
cat > "$R8/package.json" <<'PKG'
{ "name": "fixture", "scripts": { "gen:code-mode-types": "gen" } }
PKG
echo "stale" > "$R8/generated.txt"
printf '%s\n' '#!/bin/bash
case "$2" in
  gen:code-mode-types) echo "regenerated-content" > "$PWD/generated.txt"; echo "regenerated"; exit 0 ;;
  *) exit 0 ;;
esac' > "$R8/yarn-stub.sh"
git -C "$R8" add -A; git -C "$R8" commit -qm init >/dev/null  # commit the stub too, so only the regen dirties the tree
o8="$(GARDEN_YARN="bash $R8/yarn-stub.sh" "$LV" "$R8" 2>&1)"; rc8=$?
[ "$rc8" -ne 0 ] && ok "codegen dirty gate exits non-zero ($rc8)" || bad "codegen dirty gate should fail"
printf '%s' "$o8" | grep -q 'left tree dirty' && ok "gate emits the stale-artifact message" || bad "missing left-tree-dirty message"
# The raw diff must NOT leak to stdout — only the SHA + inspect command.
printf '%s' "$o8" | grep -q 'regenerated-content' && bad "raw diff leaked to stdout" || ok "raw diff NOT in stdout"
s8="$(printf '%s' "$o8" | grep -oE '[0-9a-f]{40}' | head -1)"
git -C "$R8" cat-file -p "$s8" 2>/dev/null | grep -q 'generated.txt' \
  && ok "diff --stat blob names the staled artifact" || bad "blob missing staled artifact"

# --- 9: an up-to-date generator keeps the gate silent ----------------------
# The generator rewrites the SAME content, so the tree stays clean and the whole
# run is silent, exit 0 — the gate must not false-positive on a benign codegen.
R9="$TR/codegen-clean"; mkdir -p "$R9"; git -C "$R9" init -q
git -C "$R9" config user.email t@localhost; git -C "$R9" config user.name test
cat > "$R9/package.json" <<'PKG'
{ "name": "fixture", "scripts": { "codegen": "gen" } }
PKG
echo "already-fresh" > "$R9/generated.txt"
printf '%s\n' '#!/bin/bash
case "$2" in
  codegen) echo "already-fresh" > "$PWD/generated.txt"; exit 0 ;;
  *) exit 0 ;;
esac' > "$R9/yarn-stub.sh"
git -C "$R9" add -A; git -C "$R9" commit -qm init >/dev/null  # commit the stub too, so a clean regen leaves nothing dirty
o9="$(GARDEN_YARN="bash $R9/yarn-stub.sh" "$LV" "$R9" 2>&1)"; rc9=$?
[ "$rc9" -eq 0 ] && [ -z "$o9" ] && ok "up-to-date codegen: silent, exit 0" || bad "clean codegen not silent/zero (rc=$rc9 out=[$o9])"

# --- 10: steps run against repository-local git config only -----------------
# The container bind-mounts the host user's home, so the maintainer's git config
# is in effect for every git a step spawns while a CI runner has none — a silent
# local-vs-CI divergence for any SEMANTICS-changing setting. The observed case:
# rerere.enabled=true auto-resolved a project fixture's intentional rebase
# conflict, failing locally and passing on CI. The step must not see it.
R10="$TR/hermetic"
make_repo "$R10" '#!/bin/bash
case "$2" in
  test) echo "rerere=$(git config --get rerere.enabled || echo unset)"; exit 1 ;;
  *)    exit 0 ;;
esac'
HOSTCFG="$TR/host-gitconfig"
printf '[rerere]\n\tenabled = true\n' > "$HOSTCFG"
o10="$(GIT_CONFIG_GLOBAL="$HOSTCFG" GARDEN_YARN="bash $R10/yarn-stub.sh" "$LV" "$R10" 2>&1)"
s10="$(printf '%s' "$o10" | grep -oE '[0-9a-f]{40}' | head -1)"
git -C "$R10" cat-file -p "$s10" 2>/dev/null | grep -q 'rerere=unset' \
  && ok "host global git config is invisible to a step" || bad "host global git config leaked into a step"
# The opt-out escape hatch restores the inherited configuration verbatim.
o10b="$(GARDEN_INHERIT_GITCONFIG=1 GIT_CONFIG_GLOBAL="$HOSTCFG" \
        GARDEN_YARN="bash $R10/yarn-stub.sh" "$LV" "$R10" 2>&1)"
s10b="$(printf '%s' "$o10b" | grep -oE '[0-9a-f]{40}' | head -1)"
git -C "$R10" cat-file -p "$s10b" 2>/dev/null | grep -q 'rerere=true' \
  && ok "GARDEN_INHERIT_GITCONFIG=1 opts back in" || bad "opt-out did not restore inherited config"
# Repository-local config still applies (it is checked in, hence CI-identical).
git -C "$R10" config --local rerere.enabled false
o10c="$(GIT_CONFIG_GLOBAL="$HOSTCFG" GARDEN_YARN="bash $R10/yarn-stub.sh" "$LV" "$R10" 2>&1)"
s10c="$(printf '%s' "$o10c" | grep -oE '[0-9a-f]{40}' | head -1)"
git -C "$R10" cat-file -p "$s10c" 2>/dev/null | grep -q 'rerere=false' \
  && ok "repository-local git config still applies" || bad "local git config was blanked too"

echo "----------------------------------------------------------------"
echo "local-verify: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
