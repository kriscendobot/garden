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
#   9. Environment fault vs check failure: two or more steps that ran DIFFERENT
#      commands failing with byte-IDENTICAL output are reported as ONE
#      environment fault, not N verification failures — while distinct failing
#      output, and one script matched by two steps, are NOT flagged.
#  10. The gate is RUNNABLE in a warm-cache-populated worktree: a checkout
#      provisioned through the real ensure-project-worktree.sh warm-cache HIT
#      path exercises its steps (silent, exit 0), and the pre-fix shape (deps
#      linked in, no package-manager link state) is diagnosed as an environment
#      fault. This is the regression for job `fix-warm-cache-yarn-install-state`.
#  11. Node runtime parity: a project pinning a Node major different from the
#      host's `node` fails loud (`NODE RUNTIME PARITY`, exit 3) with the steps
#      proven NOT to run; a matching pin passes; the bypass/override/lts-alias/
#      .nvmrc/adopt-a-discovered-runtime paths each behave. Regression for job
#      `fix-local-verify-node24-eslint-parity` (endojs/endo-but-for-bots#1048).
#  12. CI-only test:xs parity: every workspace's additive `test:xs` suite runs
#      after its primary test under the Moddable release pinned by CI; the
#      harness initializes direct submodules like the CI checkout, uses the
#      explicitly provisioned xst rather than a mismatched host PATH entry,
#      stays silent on success, and fails loud when no pin exists.
#  13. Additive package-uniformity parity: CI's lint-leg "Check package
#      uniformity" step (`yarn test:package-uniformity && node
#      scripts/check-package-uniformity.mjs`) is reconstructed from the parts
#      present and run as its own step — the repo scan that no package.json
#      script wraps included — without duplicating it into `yarn lint`; a single
#      wrap script subsumes the parts; the step is inert where absent. Regression
#      for job `local-verify-parity-endo-package-uniformity-pr1015`
#      (endojs/endo-but-for-bots#1015).
#
# No systemd, no network: the harness is exercised against throwaway git repos
# with a stubbed package runner (GARDEN_YARN), and — for 10 — a throwaway garden
# root, fork bare clone, and stubbed package manager driving the real provisioner.

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
trap 'rm -rf "$TR" "${XS_TEST_ROOT:-}"' EXIT

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

# --- 11: workspace tests all run after one fails -----------------------------
# A root test aggregator may bail at its first red package. The harness must
# instead run each workspace test and retain both failures in the one captured
# test blob, so fixing one package never leaves the next package uncovered.
R11="$TR/workspaces"; mkdir -p "$R11/packages/a" "$R11/packages/b"
git -C "$R11" init -q
git -C "$R11" config user.email t@localhost; git -C "$R11" config user.name test
cat > "$R11/package.json" <<'PKG'
{ "name": "root", "workspaces": ["packages/*"], "scripts": { "test": "root-aggregator" } }
PKG
cat > "$R11/packages/a/package.json" <<'PKG'
{ "name": "workspace-a", "scripts": { "test": "test-a" } }
PKG
cat > "$R11/packages/b/package.json" <<'PKG'
{ "name": "workspace-b", "scripts": { "test": "test-b" } }
PKG
printf '%s\n' '#!/bin/bash
case "$1:$2" in
  workspaces:list) printf "{\"location\":\".\",\"name\":\"root\"}\\n{\"location\":\"packages/a\",\"name\":\"workspace-a\"}\\n{\"location\":\"packages/b\",\"name\":\"workspace-b\"}\\n"; exit 0 ;;
  run:test) case "$PWD" in
    */packages/a) echo "workspace-a failed"; exit 1 ;;
    */packages/b) echo "workspace-b failed"; exit 1 ;;
    *) echo "root aggregator ran"; exit 1 ;;
  esac ;;
  *) exit 0 ;;
esac' > "$R11/yarn-stub.sh"
git -C "$R11" add -A; git -C "$R11" commit -qm init >/dev/null
o11="$(GARDEN_YARN="bash $R11/yarn-stub.sh" "$LV" "$R11" 2>&1)"; rc11=$?
[ "$rc11" -ne 0 ] && ok "workspace failures exit non-zero" || bad "workspace failures should fail the gate"
s11="$(printf '%s' "$o11" | grep -oE '[0-9a-f]{40}' | head -1)"
b11="$(git -C "$R11" cat-file -p "$s11" 2>/dev/null)"
printf '%s' "$b11" | grep -q 'workspace-a failed' \
  && ok "captures the first workspace failure" || bad "first workspace failure missing"
printf '%s' "$b11" | grep -q 'workspace-b failed' \
  && ok "captures a later workspace failure" || bad "later workspace failure missing"
printf '%s' "$b11" | grep -q 'root aggregator ran' \
  && bad "re-ran the fail-fast root aggregator" || ok "does not re-run the root aggregator"

# --- 12: environment fault vs check failure ----------------------------------
# Several steps that ran DIFFERENT commands failing with byte-IDENTICAL output
# means not one of them reached a check: the runner refused them all. That is
# ONE environment fault, and must be said so rather than left looking like N
# independent verification failures (the warm-cache regression, where yarn
# refused every `yarn run` with one usage error and all six steps "FAILED").
R12="$TR/envfault"; mkdir -p "$R12"; git -C "$R12" init -q
git -C "$R12" config user.email t@localhost; git -C "$R12" config user.name test
cat > "$R12/package.json" <<'PKG'
{ "name": "fixture", "scripts": {
  "format:check": "fmt", "build": "build", "lint": "lint",
  "codegen": "gen", "test": "test", "docs": "docs" } }
PKG
# The runner refuses EVERY script with one identical usage error, exactly as
# yarn 4 does in a worktree with no link state. `workspaces list` is refused too,
# so the test step falls back to the ordinary root script.
printf '%s\n' '#!/bin/bash
echo "Usage Error: The project in /w/package.json doesn'"'"'t seem to have been installed - running an install there might help"
exit 1' > "$R12/yarn-stub.sh"
git -C "$R12" add -A; git -C "$R12" commit -qm init >/dev/null
o12="$(GARDEN_YARN="bash $R12/yarn-stub.sh" "$LV" "$R12" 2>&1)"; rc12=$?
[ "$rc12" -ne 0 ] && ok "environment fault still exits non-zero (fails loud)" \
  || bad "environment fault should not exit 0"
printf '%s' "$o12" | grep -q 'ENVIRONMENT FAULT' \
  && ok "identical output from different commands is called an environment fault" \
  || bad "no ENVIRONMENT FAULT line (out=[$o12])"
printf '%s' "$o12" | grep -q 'NOT the change' \
  && ok "the fault line says the change is not the cause" || bad "fault line does not exonerate the change"
printf '%s' "$o12" | grep -q 'NOT INSTALLED' \
  && ok "names the not-installed cause for a package-manager usage error" \
  || bad "missing the not-installed hint (out=[$o12])"
# It supplements the per-step lines rather than replacing them: the blob is still
# reachable, so a debugging agent can read the refusal verbatim.
printf '%s' "$o12" | grep -q 'STEP format FAILED' \
  && ok "per-step failure lines are retained" || bad "per-step lines disappeared"
s12="$(printf '%s' "$o12" | grep -oE '[0-9a-f]{40}' | head -1)"
git -C "$R12" cat-file -p "$s12" 2>/dev/null | grep -q "seem to have been installed" \
  && ok "the shared blob holds the runner's refusal" || bad "blob missing the refusal text"

# --- 13: the fault check does NOT fire on genuine failures -------------------
# Two steps failing with DIFFERENT output is two honest results.
R13="$TR/genuine"
make_repo "$R13" '#!/bin/bash
case "$2" in
  format:check) echo "prettier: 3 files need formatting"; exit 1 ;;
  lint)         echo "eslint: 7 problems"; exit 1 ;;
  *)            exit 0 ;;
esac'
o13="$(GARDEN_YARN="bash $R13/yarn-stub.sh" "$LV" "$R13" 2>&1)"
printf '%s' "$o13" | grep -q 'ENVIRONMENT FAULT' \
  && bad "false positive: distinct failures flagged as an environment fault" \
  || ok "distinct failing output is NOT an environment fault"

# The discriminator is DISTINCT COMMANDS: two steps can legitimately resolve to
# the SAME script (`codegen` and `docs` both match `build:types` where a project
# has no dedicated generator), and one script failing twice is one honest
# failure reported twice.
R14="$TR/samescript"; mkdir -p "$R14"; git -C "$R14" init -q
git -C "$R14" config user.email t@localhost; git -C "$R14" config user.name test
cat > "$R14/package.json" <<'PKG'
{ "name": "fixture", "scripts": { "build:types": "tsc --build" } }
PKG
printf '%s\n' '#!/bin/bash
echo "tsc: error TS2307: cannot find module"; exit 1' > "$R14/yarn-stub.sh"
git -C "$R14" add -A; git -C "$R14" commit -qm init >/dev/null
o14="$(GARDEN_YARN="bash $R14/yarn-stub.sh" "$LV" "$R14" 2>&1)"
printf '%s' "$o14" | grep -c 'STEP .* FAILED' | grep -q '^2$' \
  && ok "one script matched by two steps fails twice (the fixture holds)" \
  || bad "expected exactly 2 step failures from the shared script (out=[$o14])"
printf '%s' "$o14" | grep -q 'ENVIRONMENT FAULT' \
  && bad "false positive: the SAME command failing twice flagged as environment fault" \
  || ok "the same command failing twice is NOT an environment fault"

# --- 15: the gate is RUNNABLE in a warm-cache-populated worktree -------------
# The end-to-end regression for job `fix-warm-cache-yarn-install-state`. A per-job
# project checkout provisioned by a warm-cache HIT gets its node_modules
# hardlinked in from the cache rather than installed. A package manager keeps its
# "is this project installed?" state OUTSIDE node_modules (yarn 4:
# .yarn/install-state.gz), which is gitignored and so absent from a fresh
# `git worktree add` — so before the link-state reconcile landed, yarn refused
# every `yarn run <script>` and this gate reported ALL SIX steps FAILED with one
# usage error. The gate verified nothing on exactly the worktrees the cache is
# for.
#
# This drives the REAL ensure-project-worktree.sh through a cold build and then a
# warm hit, and asserts the gate actually runs its steps in the hit worktree.
# The package manager is stubbed with yarn 4's defining behavior: it refuses
# every `run` unless the project's link state is present.
EPW="$(cd "$HERE/.." && pwd)/ensure-project-worktree.sh"
if ! command -v flock >/dev/null 2>&1 || [ ! -f "$EPW" ]; then
  echo "  SKIP: warm-cache end-to-end needs flock + ensure-project-worktree.sh"
else
  W="$TR/warm"; GROOT="$W/garden"
  mkdir -p "$GROOT/worktrees"
  git -C "$GROOT" init -q 2>/dev/null || { mkdir -p "$GROOT"; git -C "$GROOT" init -q; }
  git -C "$GROOT" config user.name garden-bot; git -C "$GROOT" config user.email bot@localhost

  # The stub package manager, at a path stable across worktrees. Invoked as
  # `bash <stub> install` (the provisioner) and `bash <stub> run <script>` (the
  # gate). Refuses every `run` without link state, like yarn 4.
  STUB="$W/pm.sh"; mkdir -p "$W"
  cat > "$STUB" <<'PMEOF'
#!/bin/bash
if [ "$1" = install ]; then
  mkdir -p node_modules/.bin .yarn
  echo dependency > node_modules/installed
  echo state > .yarn/install-state
  exit 0
fi
if [ ! -f "$PWD/.yarn/install-state" ]; then
  echo "Usage Error: The project in $PWD/package.json doesn't seem to have been installed - running an install there might help"
  exit 1
fi
[ "$1" = workspaces ] && exit 1     # not a discoverable workspace tree
echo "ran $2 against $(cat node_modules/installed)"
exit 0
PMEOF

  # The upstream fork + its standing bare clone, as a real garden fork.
  UP="$W/upstream.git"; SEED="$W/seed"
  git init -q --bare "$UP"; git init -q "$SEED"
  cat > "$SEED/package.json" <<'PKG'
{ "name": "warm", "scripts": {
  "format:check": "fmt", "build": "build", "lint": "lint",
  "codegen": "gen", "test": "test", "docs": "docs" } }
PKG
  printf 'lockfile v1\n' > "$SEED/yarn.lock"
  printf 'node_modules/\n.yarn/\n' > "$SEED/.gitignore"
  ( cd "$SEED" || exit 1
    git -c user.name=t -c user.email=t@localhost add -A
    git -c user.name=t -c user.email=t@localhost commit -qm seed
    git branch -M llm
    git remote add origin "$UP"
    git push -q -u origin llm ) >/dev/null 2>&1
  BARE="$GROOT/worktrees/endojs-warm.git"
  git clone -q --bare "$UP" "$BARE"
  git -C "$BARE" config remote.origin.fetch '+refs/heads/*:refs/remotes/origin/*'
  git -C "$BARE" remote set-url origin "$UP"

  provision() {  # provision <base> [extra env assignments...] → path on stdout
    local b="$1"; shift
    env GARDEN_ROOT="$GROOT" GARDEN_SCRATCH="$GROOT/scratch" \
        GARDEN_DEP_INSTALL_CMD="bash $STUB install" "$@" \
        bash "$EPW" "$b" endojs/warm llm 2>"$W/err-$b.txt"
  }

  COLD="$(provision cold-job)"
  grep -q 'WARM-CACHE built' "$W/err-cold-job.txt" \
    && ok "cold provision builds the dependency cache" \
    || bad "no cold cache build (err=$(tr '\n' '|' <"$W/err-cold-job.txt"))"
  # The cold path runs the real installer, so it has link state of its own — the
  # reason the defect was invisible on the first worktree of every lockfile.
  [ -n "$COLD" ] && [ -f "$COLD/.yarn/install-state" ] \
    && ok "the cold worktree has link state (the installer wrote it)" \
    || bad "cold worktree has no link state ('$COLD')"

  HOT="$(provision hot-job)"
  grep -q 'WARM-CACHE hit' "$W/err-hot-job.txt" \
    && ok "second job provisions from the warm cache (a HIT)" \
    || bad "no warm hit (err=$(tr '\n' '|' <"$W/err-hot-job.txt"))"
  [ -n "$HOT" ] && [ -d "$HOT/node_modules" ] \
    && ok "the warm hit populated node_modules" || bad "warm hit left no node_modules in '$HOT'"

  # THE REGRESSION: the gate must exercise the real steps here, not report six
  # identical bogus failures.
  o15="$(GARDEN_YARN="bash $STUB" "$LV" "$HOT" 2>&1)"; rc15=$?
  [ "$rc15" -eq 0 ] && [ -z "$o15" ] \
    && ok "local-verify RUNS its steps in a warm-cache worktree (silent, exit 0)" \
    || bad "the gate is unrunnable on a warm-cache worktree (rc=$rc15 out=[$o15])"
  printf '%s' "$o15" | grep -q 'seem to have been installed' \
    && bad "the package manager still reports the project as not installed" \
    || ok "no not-installed refusal in a warm-cache worktree"

  # And the negative control: suppress the reconcile to recreate the pre-fix
  # worktree exactly, and confirm the gate now NAMES it as an environment fault
  # instead of six verification failures.
  BROKEN="$(provision broken-job GARDEN_SKIP_DEP_RECONCILE=1)"
  [ -n "$BROKEN" ] && [ -d "$BROKEN/node_modules" ] && [ ! -f "$BROKEN/.yarn/install-state" ] \
    && ok "the control worktree reproduces the defect (deps, no link state)" \
    || bad "control worktree not in the pre-fix shape ('$BROKEN')"
  o15b="$(GARDEN_YARN="bash $STUB" "$LV" "$BROKEN" 2>&1)"; rc15b=$?
  [ "$rc15b" -ne 0 ] && ok "the pre-fix worktree still fails loud" || bad "pre-fix worktree passed silently"
  printf '%s' "$o15b" | grep -q 'ENVIRONMENT FAULT' \
    && ok "the pre-fix worktree is reported as an ENVIRONMENT FAULT, not N failed checks" \
    || bad "six identical refusals not diagnosed as an environment fault (out=[$o15b])"
fi

# --- 16: Node runtime parity guard ------------------------------------------
# A project pins the Node major its CI runs (.node-version / .nvmrc; GitHub's
# actions/setup-node resolves that file, including the `lts/*` alias). A host on
# a DIFFERENT major verifies under the wrong runtime — type-aware lint, resolver
# edges, syntax support all move between majors — so the gate can go green here
# while the pinned-major CI goes red (endojs/endo-but-for-bots#1048: host on Node
# 22, `.node-version=lts/*` → Node 24 CI, `yarn lint:eslint` green locally / red
# on CI). The guard resolves the pin and REFUSES to run under a mismatched
# runtime (or adopts a matching one) rather than emit a misleading green.
#
# Driven relative to the ACTUAL active node major so the assertions hold on any
# host (CI runs this on whatever node it pins).
if command -v node >/dev/null 2>&1; then
  NODEMAJ="$(node --version 2>/dev/null | sed 's/^v//; s/\..*//')"
  OTHER=99                   # deliberately outside the provisioned Node window

  # A repo whose lint step FAILS, so we can prove the guard runs BEFORE the steps:
  # when the guard fires, the STEP lint FAILED line must NOT appear.
  RNP="$TR/nodeparity"
  make_repo "$RNP" '#!/bin/bash
case "$2" in
  lint) echo "eslint: 1 problem"; exit 1 ;;
  *)    exit 0 ;;
esac'

  # (a) pin a mismatched major -> fail loud, non-zero, and the steps do NOT run.
  printf '%s\n' "$OTHER" > "$RNP/.node-version"
  oa="$(GARDEN_YARN="bash $RNP/yarn-stub.sh" "$LV" "$RNP" 2>&1)"; rca=$?
  [ "$rca" -ne 0 ] && ok "mismatched Node pin fails loud (exit $rca)" || bad "mismatched Node pin should fail loud"
  printf '%s' "$oa" | grep -q 'NODE RUNTIME PARITY' \
    && ok "emits the NODE RUNTIME PARITY diagnosis" || bad "missing NODE RUNTIME PARITY line (out=[$oa])"
  printf '%s' "$oa" | grep -q 'STEP lint FAILED' \
    && bad "steps ran under the mismatched runtime (guard did not gate)" \
    || ok "the guard runs BEFORE any step (no STEP lint FAILED under a mismatch)"

  # (b) pin the ACTIVE major -> guard passes, steps run (lint fails on its own).
  printf '%s\n' "$NODEMAJ" > "$RNP/.node-version"
  ob="$(GARDEN_YARN="bash $RNP/yarn-stub.sh" "$LV" "$RNP" 2>&1)"
  printf '%s' "$ob" | grep -q 'NODE RUNTIME PARITY' \
    && bad "matching Node pin false-tripped the parity guard" || ok "matching Node pin passes the guard"
  printf '%s' "$ob" | grep -q 'STEP lint FAILED' \
    && ok "with parity satisfied the real steps run" || bad "steps did not run under a matching runtime (out=[$ob])"

  # (c) GARDEN_SKIP_NODE_PARITY=1 bypasses the guard even on a mismatch.
  printf '%s\n' "$OTHER" > "$RNP/.node-version"
  oc="$(GARDEN_SKIP_NODE_PARITY=1 GARDEN_YARN="bash $RNP/yarn-stub.sh" "$LV" "$RNP" 2>&1)"
  printf '%s' "$oc" | grep -q 'NODE RUNTIME PARITY' \
    && bad "GARDEN_SKIP_NODE_PARITY=1 did not bypass the guard" || ok "GARDEN_SKIP_NODE_PARITY=1 bypasses the guard"
  printf '%s' "$oc" | grep -q 'STEP lint FAILED' \
    && ok "bypass lets the steps run" || bad "bypass did not run the steps (out=[$oc])"

  # (d) GARDEN_REQUIRED_NODE_MAJOR overrides the file resolution (mismatch -> loud).
  printf '%s\n' "$NODEMAJ" > "$RNP/.node-version"   # file says match...
  od="$(GARDEN_REQUIRED_NODE_MAJOR="$OTHER" GARDEN_YARN="bash $RNP/yarn-stub.sh" "$LV" "$RNP" 2>&1)"; rcd=$?
  [ "$rcd" -ne 0 ] && printf '%s' "$od" | grep -q 'NODE RUNTIME PARITY' \
    && ok "GARDEN_REQUIRED_NODE_MAJOR overrides the file resolution" \
    || bad "override requirement not honored (rc=$rcd out=[$od])"

  # (e) the `lts/*` alias resolves via GARDEN_NODE_LTS_LATEST (deterministic, no net).
  printf 'lts/*\n' > "$RNP/.node-version"
  oe="$(GARDEN_NODE_LTS_LATEST="$NODEMAJ" GARDEN_YARN="bash $RNP/yarn-stub.sh" "$LV" "$RNP" 2>&1)"
  printf '%s' "$oe" | grep -q 'NODE RUNTIME PARITY' \
    && bad "lts/* resolving to the active major false-tripped the guard" \
    || ok "lts/* resolves via GARDEN_NODE_LTS_LATEST (match -> pass)"
  oe2="$(GARDEN_NODE_LTS_LATEST="$OTHER" GARDEN_YARN="bash $RNP/yarn-stub.sh" "$LV" "$RNP" 2>&1)"
  printf '%s' "$oe2" | grep -q 'NODE RUNTIME PARITY' \
    && ok "lts/* resolving to a foreign major fails loud" || bad "lts/* mismatch not caught (out=[$oe2])"

  # (f) .nvmrc is the fallback pin surface when .node-version is absent.
  rm -f "$RNP/.node-version"; printf '%s\n' "$NODEMAJ" > "$RNP/.nvmrc"
  of="$(GARDEN_YARN="bash $RNP/yarn-stub.sh" "$LV" "$RNP" 2>&1)"
  printf '%s' "$of" | grep -q 'NODE RUNTIME PARITY' \
    && bad ".nvmrc matching the active major false-tripped the guard" || ok ".nvmrc is honored as a pin surface"
  rm -f "$RNP/.nvmrc"

  # (g) the guard ADOPTS a matching runtime discovered under a version-manager
  # root: a fake nvm node reporting v<OTHER> lets a mismatched pin pass by PATH
  # swap. Proves find_node_bin_for_major -> PATH prepend, not just the refusal.
  # The adopt path invokes the discovered node DIRECTLY, so the fake must live on
  # an exec-capable filesystem — /tmp (hence $TR) is noexec in the container,
  # while a real nvm/fnm node lives under exec-capable $HOME. Find such a base
  # (as production does) or skip this one sub-case.
  EXECBASE=""
  for base in "$TR" "${HOME:-}/.cache" "${HOME:-}"; do
    [ -n "$base" ] || continue
    mkdir -p "$base" 2>/dev/null || continue
    probe="$base/.lvtest-execprobe.$$"
    if printf '#!/bin/sh\nexit 0\n' > "$probe" 2>/dev/null && chmod +x "$probe" 2>/dev/null && "$probe" 2>/dev/null; then
      rm -f "$probe"; EXECBASE="$base"; break
    fi
    rm -f "$probe" 2>/dev/null
  done
  if [ -z "$EXECBASE" ]; then
    echo "  SKIP: adopt-runtime case needs an exec-capable filesystem for the fake node"
  else
    FAKEROOT="$EXECBASE/lvtest-fakenvm.$$"
    FAKENVM="$FAKEROOT/versions/node/v$OTHER.0.0/bin"
    mkdir -p "$FAKENVM"
    printf '#!/bin/bash\necho "v%s.0.0"\n' "$OTHER" > "$FAKENVM/node"
    chmod +x "$FAKENVM/node"
    printf '%s\n' "$OTHER" > "$RNP/.node-version"
    og="$(NVM_DIR="$FAKEROOT" GARDEN_YARN="bash $RNP/yarn-stub.sh" "$LV" "$RNP" 2>&1)"
    printf '%s' "$og" | grep -q 'NODE RUNTIME PARITY' \
      && bad "guard refused despite a discoverable matching runtime (out=[$og])" \
      || ok "guard adopts a version-manager runtime matching the pin"
    printf '%s' "$og" | grep -q 'STEP lint FAILED' \
      && ok "after adopting the matching runtime the steps run" || bad "adopted runtime did not run the steps (out=[$og])"
    rm -rf "$FAKEROOT"
  fi
else
  echo "  SKIP: node parity guard needs a node on PATH"
fi

# --- 17: additive test:xs + pinned Moddable runtime parity ------------------
# endo CI runs root `test:xs` with Moddable 5.0.0 (XS 15.5.1), while the garden
# host currently also has a newer xst. The workspace gate must run BOTH primary
# test and test:xs, prepend only the explicitly provisioned binary, and never
# select the unrelated host xst merely because it appears first on PATH.
RXS="$TR/xs-parity"; mkdir -p "$RXS/.github/workflows" "$RXS/packages/a" "$RXS/packages/b"
git -C "$RXS" init -q
git -C "$RXS" config user.email t@localhost; git -C "$RXS" config user.name test
XS_SUBMODULE_SOURCE="$TR/xs-submodule-source"
mkdir -p "$XS_SUBMODULE_SOURCE/xs/sources"
git -C "$XS_SUBMODULE_SOURCE" init -q
git -C "$XS_SUBMODULE_SOURCE" config user.email t@localhost
git -C "$XS_SUBMODULE_SOURCE" config user.name test
printf '/* pinned XS oracle source */\n' > "$XS_SUBMODULE_SOURCE/xs/sources/xsAll.h"
git -C "$XS_SUBMODULE_SOURCE" add xs/sources/xsAll.h
git -C "$XS_SUBMODULE_SOURCE" commit -qm oracle
cat > "$RXS/package.json" <<'PKG'
{ "name": "root", "workspaces": ["packages/*"],
  "scripts": { "test": "root-test-aggregator", "test:xs": "root-xs-aggregator" } }
PKG
cat > "$RXS/packages/a/package.json" <<'PKG'
{ "name": "workspace-a", "scripts": { "test": "test-a", "test:xs": "xs-a" } }
PKG
cat > "$RXS/packages/b/package.json" <<'PKG'
{ "name": "workspace-b", "scripts": { "test": "test-b", "test:xs": "xs-b" } }
PKG
cat > "$RXS/.github/workflows/ci.yml" <<'YAML'
jobs:
  test-xs:
    env:
      MODDABLE_VERSION: 5.0.0
YAML
cat > "$RXS/yarn-stub.sh" <<'STUB'
#!/bin/bash
case "$1:$2" in
  workspaces:list)
    printf '{"location":".","name":"root"}\n'
    printf '{"location":"packages/a","name":"workspace-a"}\n'
    printf '{"location":"packages/b","name":"workspace-b"}\n'
    ;;
  run:test)
    printf 'test:%s\n' "$PWD" >> "$XS_TRACE"
    ;;
  run:test:xs)
    test -f "$XS_SUBMODULE_MARKER" || { echo "missing XS oracle submodule"; exit 1; }
    printf 'xs:%s:%s\n' "$PWD" "$(xst -v)" >> "$XS_TRACE"
    ;;
  *) exit 0 ;;
esac
STUB

# Put a deliberately wrong xst first on PATH and provide the pinned binary via
# GARDEN_XST. If local-verify ever falls back to PATH, the trace exposes 17.9.1.
XS_TEST_ROOT="${HOME:-/var/tmp}/.cache/lvtest-xs.$$"
BAD_XST="$XS_TEST_ROOT/host-bin"; GOOD_XST="$XS_TEST_ROOT/moddable-5/bin"
mkdir -p "$BAD_XST" "$GOOD_XST"
printf '#!/bin/sh\necho "XS 17.9.1, host mismatch"\n' > "$BAD_XST/xst"
printf '#!/bin/sh\necho "XS 15.5.1, pinned Moddable 5.0.0"\n' > "$GOOD_XST/xst"
chmod +x "$BAD_XST/xst" "$GOOD_XST/xst" "$RXS/yarn-stub.sh"
git -c protocol.file.allow=always -C "$RXS" submodule add -q \
  "$XS_SUBMODULE_SOURCE" c/moddable
git -C "$RXS" add -A; git -C "$RXS" commit -qm init >/dev/null
git -C "$RXS" submodule deinit -q -f -- c/moddable
XS_TRACE="$TR/xs-trace"
XS_SUBMODULE_MARKER="$RXS/c/moddable/xs/sources/xsAll.h"
[ ! -e "$XS_SUBMODULE_MARKER" ] \
  && ok "fixture starts with its XS oracle submodule uninitialized" \
  || bad "fixture submodule was already initialized"
oxs="$(GIT_ALLOW_PROTOCOL=file XS_SUBMODULE_MARKER="$XS_SUBMODULE_MARKER" \
  XS_TRACE="$XS_TRACE" PATH="$BAD_XST:$PATH" GARDEN_XST="$GOOD_XST/xst" \
  GARDEN_YARN="bash $RXS/yarn-stub.sh" "$LV" "$RXS" 2>&1)"; rcxs=$?
[ "$rcxs" -eq 0 ] && [ -z "$oxs" ] \
  && ok "primary + test:xs workspace suites are silent on success" \
  || bad "test:xs success was not silent/zero (rc=$rcxs out=[$oxs])"
[ -f "$XS_SUBMODULE_MARKER" ] \
  && ok "test:xs initializes direct submodules like the CI checkout" \
  || bad "test:xs left its required submodule uninitialized"
[ "$(grep -c '^test:' "$XS_TRACE")" -eq 2 ] \
  && ok "runs every workspace primary test" || bad "primary workspace test count is not 2"
[ "$(grep -c '^xs:' "$XS_TRACE")" -eq 2 ] \
  && ok "runs every workspace test:xs additively" || bad "test:xs workspace count is not 2"
grep -q 'XS 15.5.1, pinned Moddable 5.0.0' "$XS_TRACE" \
  && ok "test:xs sees the provisioned CI-pinned xst" || bad "test:xs did not see pinned xst"
grep -q '17.9.1' "$XS_TRACE" \
  && bad "test:xs used the mismatched host xst" || ok "mismatched host xst is ignored"
grep -q 'root-' "$XS_TRACE" \
  && bad "ran a fail-fast root test aggregator" || ok "workspace suites do not re-run root aggregators"

# Removing the pin must fail rather than silently use the host binary.
mv "$RXS/.github/workflows/ci.yml" "$RXS/.github/workflows/ci.disabled"
XS_TRACE="$TR/xs-unpinned-trace"
oxsu="$(GIT_ALLOW_PROTOCOL=file XS_SUBMODULE_MARKER="$XS_SUBMODULE_MARKER" \
  XS_TRACE="$XS_TRACE" PATH="$BAD_XST:$PATH" GARDEN_XST="$GOOD_XST/xst" \
  GARDEN_YARN="bash $RXS/yarn-stub.sh" "$LV" "$RXS" 2>&1)"; rcxsu=$?
[ "$rcxsu" -ne 0 ] && printf '%s' "$oxsu" | grep -q 'STEP test-xs FAILED' \
  && ok "an unpinned test:xs suite fails loud" || bad "unpinned test:xs did not fail (rc=$rcxsu out=[$oxsu])"
s_xs="$(printf '%s' "$oxsu" | sed -nE 's/.*STEP test-xs FAILED: output blob ([0-9a-f]{40}).*/\1/p' | head -1)"
git -C "$RXS" cat-file -p "$s_xs" 2>/dev/null | grep -q 'refusing to use an unpinned host xst' \
  && ok "failure capture explains that host xst is refused" || bad "unpinned diagnosis missing from blob"
[ "$(grep -c '^xs:' "$XS_TRACE" 2>/dev/null || true)" -eq 0 ] \
  && ok "unpinned test:xs does not execute with the host xst" || bad "unpinned test:xs executed unexpectedly"

# --- 18: additive package-uniformity check ----------------------------------
# endo CI runs, in its lint job and OUTSIDE `yarn lint`, a compound
# "Check package uniformity" step: `yarn test:package-uniformity && node
# scripts/check-package-uniformity.mjs`. The self-test half is a package.json
# script; the enforcement half is a repo-root command NO script wraps, so
# first-match discovery cannot reach it and folding it into `yarn lint` would
# duplicate it in CI's lint leg. The `package-uniformity` step reconstructs CI's
# compound command from the parts present and runs it locally. Regression for job
# `local-verify-parity-endo-package-uniformity-pr1015`
# (endojs/endo-but-for-bots#1015: a tracked `src/types.d.ts` rejected by the repo
# scan while the root-`lint` gate stayed silent).
PU_TRACE="$TR/pu-trace"
make_pu_repo() {  # make_pu_repo <dir> <package.json-scripts-json>
  local dir="$1" scripts="$2"
  mkdir -p "$dir/scripts"; git -C "$dir" init -q
  git -C "$dir" config user.email t@localhost; git -C "$dir" config user.name test
  printf '{ "name": "fixture", "scripts": %s }\n' "$scripts" > "$dir/package.json"
  # A real .mjs repo scan: append "checker" to the trace, then fail if a tracked
  # marker file `BAD` exists (mimicking #1015's tracked-file rejection).
  cat > "$dir/scripts/check-package-uniformity.mjs" <<'MJS'
import { appendFileSync, existsSync } from 'node:fs';
if (process.env.PU_TRACE) appendFileSync(process.env.PU_TRACE, 'checker\n');
if (existsSync(new URL('../BAD', import.meta.url))) {
  console.error('REJECT: packages/x/src/types.d.ts violates *.types.d.* naming');
  process.exit(1);
}
console.log('package uniformity: ok');
MJS
  # The stub runner traces which script it dispatched.
  cat > "$dir/yarn-stub.sh" <<'STUB'
#!/bin/bash
case "$1:$2" in
  run:test:package-uniformity) [ -n "$PU_TRACE" ] && echo selftest >> "$PU_TRACE"; echo "ava: 12 tests passed"; exit 0 ;;
  run:lint:package-uniformity) [ -n "$PU_TRACE" ] && echo wrap >> "$PU_TRACE"; echo "wrapped uniformity: ok"; exit 0 ;;
  *) exit 0 ;;
esac
STUB
  chmod +x "$dir/yarn-stub.sh"
  git -C "$dir" add -A; git -C "$dir" commit -qm init >/dev/null
}

# (a) self-test script + repo-root checker: BOTH run, in CI's order, on a clean
# tree → silent, exit 0.
RPU="$TR/pu-parts"; make_pu_repo "$RPU" '{ "test:package-uniformity": "tpu" }'
: > "$PU_TRACE"
opu="$(PU_TRACE="$PU_TRACE" GARDEN_YARN="bash $RPU/yarn-stub.sh" "$LV" "$RPU" 2>&1)"; rcpu=$?
[ "$rcpu" -eq 0 ] && [ -z "$opu" ] \
  && ok "package-uniformity clean tree: silent, exit 0" \
  || bad "clean package-uniformity not silent/zero (rc=$rcpu out=[$opu])"
[ "$(tr '\n' ' ' <"$PU_TRACE")" = "selftest checker " ] \
  && ok "runs the self-test then the repo scan, in CI's order" \
  || bad "package-uniformity parts/order wrong (trace=[$(tr '\n' '|' <"$PU_TRACE")])"

# (b) the repo-root checker (which NO package.json script wraps) rejects a tracked
# file → the step fails loud, and the blob holds BOTH halves' output.
touch "$RPU/BAD"; git -C "$RPU" add BAD; git -C "$RPU" commit -qm bad >/dev/null
opub="$(PU_TRACE="$PU_TRACE" GARDEN_YARN="bash $RPU/yarn-stub.sh" "$LV" "$RPU" 2>&1)"; rcpub=$?
[ "$rcpub" -ne 0 ] && ok "a tracked-file rejection fails the gate" || bad "checker rejection did not fail the gate"
printf '%s' "$opub" | grep -q 'STEP package-uniformity FAILED' \
  && ok "emits STEP package-uniformity FAILED" || bad "missing STEP package-uniformity FAILED (out=[$opub])"
spu="$(printf '%s' "$opub" | sed -nE 's/.*STEP package-uniformity FAILED: output blob ([0-9a-f]{40}).*/\1/p' | head -1)"
bpu="$(git -C "$RPU" cat-file -p "$spu" 2>/dev/null)"
printf '%s' "$bpu" | grep -q 'REJECT: packages/x/src/types.d.ts' \
  && ok "blob holds the repo scan's rejection" || bad "blob missing the repo-scan rejection"
printf '%s' "$bpu" | grep -q 'ava: 12 tests passed' \
  && ok "blob also holds the self-test output (compound command ran both)" || bad "blob missing the self-test half"

# (c) LOCAL_VERIFY_PACKAGE_UNIFORMITY=- skips the step even with a failing checker.
opuc="$(LOCAL_VERIFY_PACKAGE_UNIFORMITY=- PU_TRACE="$PU_TRACE" \
        GARDEN_YARN="bash $RPU/yarn-stub.sh" "$LV" "$RPU" 2>&1)"; rcpuc=$?
[ "$rcpuc" -eq 0 ] && [ -z "$opuc" ] \
  && ok "LOCAL_VERIFY_PACKAGE_UNIFORMITY=- skips the step" \
  || bad "override skip not honored (rc=$rcpuc out=[$opuc])"

# (d) the preferred durable form: a single wrap script is used VERBATIM, and the
# self-test/checker are NOT separately invoked (no duplication).
RPUW="$TR/pu-wrap"
make_pu_repo "$RPUW" '{ "test:package-uniformity": "tpu", "lint:package-uniformity": "lpu" }'
touch "$RPUW/BAD"; git -C "$RPUW" add BAD; git -C "$RPUW" commit -qm bad >/dev/null  # would fail if the checker ran
: > "$PU_TRACE"
opuw="$(PU_TRACE="$PU_TRACE" GARDEN_YARN="bash $RPUW/yarn-stub.sh" "$LV" "$RPUW" 2>&1)"; rcpuw=$?
[ "$rcpuw" -eq 0 ] && [ -z "$opuw" ] \
  && ok "a wrap script is used and passes (checker not separately run)" \
  || bad "wrap-script form not honored (rc=$rcpuw out=[$opuw])"
[ "$(tr '\n' ' ' <"$PU_TRACE")" = "wrap " ] \
  && ok "the wrap script alone runs — no duplicate self-test/scan" \
  || bad "wrap form did not subsume the parts (trace=[$(tr '\n' '|' <"$PU_TRACE")])"

# (e) a project with neither a self-test script nor a checker file: the step is
# inert (silent), so it never false-fails on projects it does not apply to.
RPUN="$TR/pu-none"; mkdir -p "$RPUN"; git -C "$RPUN" init -q
git -C "$RPUN" config user.email t@localhost; git -C "$RPUN" config user.name test
echo '{ "name": "plain", "scripts": { "lint": "lint" } }' > "$RPUN/package.json"
printf '#!/bin/bash\nexit 0\n' > "$RPUN/yarn-stub.sh"
git -C "$RPUN" add -A; git -C "$RPUN" commit -qm init >/dev/null
opun="$(GARDEN_YARN="bash $RPUN/yarn-stub.sh" "$LV" "$RPUN" 2>&1)"; rcpun=$?
[ "$rcpun" -eq 0 ] && [ -z "$opun" ] \
  && ok "package-uniformity is inert where the project has no uniformity check" \
  || bad "package-uniformity false-fired on an unrelated project (rc=$rcpun out=[$opun])"

echo "----------------------------------------------------------------"
echo "local-verify: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
