#!/bin/bash
# gardener-worktree-test.sh — prove the gardener handler mechanically enforces
# the per-subagent worktree rule (designs/deliberate-deploy.md § All development
# in per-subagent worktrees; the follow-on job garden-enforce-per-subagent-worktree).
#
# The handler handlers/gardener-claude.sh must launch `claude -p` with its cwd
# already set to a fresh per-job worktree off origin/$GARDEN_MAIN_BRANCH, so a job
# physically cannot edit the deployed root tree. This test drives the handler
# DIRECTLY with a fake `claude` on PATH (the gardener tests stub the whole handler,
# so they never exercise this file). It asserts the contract from the job spec:
#
#   1. A garden-infra job runs with cwd = a per-base worktree, NEVER the root tree.
#   2. The deployed root tree is left clean (no development touched it).
#   3. A successful run tears the worktree down (completion path).
#   4. A failed run LEAVES the worktree (so a requeue can resume), with the
#      in-flight uncommitted work intact.
#   5. A requeue re-enters the SAME worktree and RESUMES the session (the
#      deterministic session id + stable per-base path are reconciled).
#
# Hermetic: a throwaway git origin + garden root, a fake `claude`, no network,
# no systemd.

# The fake-claude body is single-quoted on purpose (SC2016); the A && pass || bad
# assertion idiom is intended (SC2015, bad never fails the chain).
# shellcheck disable=SC2015,SC2016
set -uo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS_SRC="$(cd "$HERE/.." && pwd)"            # the scripts/jobs dir under test

# This test PATH-resolves and execs a fake `claude`, so its temp tree must live on
# an exec-allowed filesystem. The sandbox mounts /tmp noexec, which makes bash skip
# the non-executable fake and silently fall through to the real claude. Probe for
# an exec-allowed base: the standard temp dirs first (exec under normal CI), then
# the garden scratch tree (exec-allowed AND gitignored, so it cannot pollute the
# garden root the way a dir under $HOME would). Never $HOME itself: it is the
# garden repo root, and an untracked dir there wedges the watchman fast-forward.
pick_exec_base() {
  local c probe rc
  for c in "${TMPDIR:-}" /tmp "${GARDEN_SCRATCH:-}" "${GARDEN_ROOT:+$GARDEN_ROOT/scratch}"; do
    [ -n "$c" ] && [ -d "$c" ] && [ -w "$c" ] || continue
    probe="$(mktemp -d "$c/gwt-probe.XXXXXX" 2>/dev/null)" || continue
    printf '#!/bin/sh\nexit 7\n' > "$probe/x"; chmod +x "$probe/x" 2>/dev/null
    "$probe/x" >/dev/null 2>&1; rc=$?
    rm -rf "$probe"
    [ "$rc" -eq 7 ] && { printf '%s\n' "$c"; return 0; }
  done
  return 1
}
EXEC_BASE="$(pick_exec_base)" || { echo "  SKIP: no exec-allowed temp base (needed to run a fake claude)"; exit 0; }
TR="$(mktemp -d "$EXEC_BASE/gardener-wt-test.XXXXXX")"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
trap 'rm -rf "$TR"' EXIT

if ! command -v python3 >/dev/null 2>&1; then
  echo "  SKIP: python3 absent; the deterministic session id (and so resume) needs it"
  exit 0
fi

# --- build a throwaway garden whose root checkout has origin/main2 ------------
ORIGIN="$TR/origin.git"
GROOT="$TR/garden"
git init -q --bare "$ORIGIN"
mkdir -p "$GROOT/scripts/jobs/handlers" "$GROOT/scripts/jobs/test" "$GROOT/roles/gardener"
git -C "$GROOT" init -q
git -C "$GROOT" config user.email t@localhost
git -C "$GROOT" config user.name test
# Copy the real scripts the handler sources, plus the handler under test.
cp "$JOBS_SRC/common.sh" "$JOBS_SRC/usage-meter.sh" "$GROOT/scripts/jobs/"
cp "$JOBS_SRC/handlers/gardener-claude.sh" "$GROOT/scripts/jobs/handlers/"
chmod +x "$GROOT/scripts/jobs/handlers/gardener-claude.sh"
printf '# gardener role (test stub)\n' > "$GROOT/roles/gardener/AGENT.md"
printf '/scratch/\n' > "$GROOT/.gitignore"
git -C "$GROOT" add -A
git -C "$GROOT" commit -qm init
git -C "$GROOT" branch -M main2
git -C "$GROOT" remote add origin "$ORIGIN"
git -C "$GROOT" push -q -u origin main2
git -C "$GROOT" fetch -q origin                 # materialize the origin/main2 tracking ref

HANDLER="$GROOT/scripts/jobs/handlers/gardener-claude.sh"
SCRATCH="$GROOT/scratch"

# --- a fake `claude` that records cwd + resume-mode and mimics the transcript --
# It writes its launch cwd and whether it was --resume'd to recorder files, then
# (mimicking the real Claude) creates the session transcript under
# $HOME/.claude/projects/<encoded-cwd>/<sid>.jsonl so a later run's resume probe
# finds it. FAKE_CLAUDE_FAIL=<rc> makes it leave an uncommitted-work marker in the
# worktree and exit non-zero (the die-mid-job case).
FAKEDIR="$TR/bin"; mkdir -p "$FAKEDIR"
cat > "$FAKEDIR/claude" <<'FAKE'
#!/bin/bash
set -uo pipefail
sid=""; mode="fresh"
prev=""
for a in "$@"; do
  case "$prev" in --session-id) sid="$a"; mode="fresh" ;; --resume) sid="$a"; mode="resume" ;; esac
  prev="$a"
done
pwd > "$FAKE_CWD_OUT"
printf '%s\n' "$mode" > "$FAKE_MODE_OUT"
# Mimic Claude writing its session transcript into the launch cwd's project dir.
if [ -n "$sid" ]; then
  pd="$HOME/.claude/projects/$(printf '%s' "$PWD" | sed 's#/#-#g')"
  mkdir -p "$pd"; printf '{"transcript":"stub"}\n' >> "$pd/$sid.jsonl"
fi
if [ -n "${FAKE_CLAUDE_FAIL:-}" ]; then
  printf 'uncommitted work\n' > "$PWD/in-flight-marker"   # simulate mid-job edit
  printf 'simulated mid-job death\n' >&2
  exit "$FAKE_CLAUDE_FAIL"
fi
printf 'job done\n'
FAKE
chmod +x "$FAKEDIR/claude"

# Common env for a handler run. HOME is redirected into $TR so the fake claude's
# transcript (and the handler's resume probe) stay hermetic.
run_handler() {  # run_handler <base> <jobfile> <report> ; sets global RC
  # Pin the throwaway garden explicitly: GARDEN_ROOT/GARDEN_SCRATCH are commonly
  # exported in a developer/fleet shell, and common.sh only fills them when unset,
  # so without overriding here the handler would build a worktree in the REAL
  # garden's scratch. Invoke via `bash` rather than execute directly: the sandbox
  # can mount the temp tree noexec, so a copied +x script still fails with rc=126.
  HOME="$TR/home" PATH="$FAKEDIR:$PATH" \
    GARDEN_ROOT="$GROOT" GARDEN_SCRATCH="$SCRATCH" GARDEN_STATE="$TR/state" \
    GARDEN_NO_MAINTAINER_ALERT=1 \
    FAKE_CWD_OUT="$TR/cwd.out" FAKE_MODE_OUT="$TR/mode.out" \
    bash "$HANDLER" "$1" "$2" "$3"
  RC=$?
}

BASE="garden-infra-demo"
WT="$SCRATCH/gardener-wt-$BASE"
JOB="$TR/$BASE.job"          # outside $GROOT so it cannot dirty the deployed tree
printf 'Map: build (garden infra), branch main2. Do a thing.\n' > "$JOB"
REPORT="$TR/report.txt"

# === 1+2+3: a fresh successful run uses the worktree, not the root, then cleans up
run_handler "$BASE" "$JOB" "$REPORT"
[ "$RC" -eq 0 ] && ok "fresh run exits 0" || bad "fresh run should exit 0 (got $RC)"
cwd1="$(cat "$TR/cwd.out" 2>/dev/null)"
[ "$cwd1" = "$WT" ] && ok "claude cwd is the per-base worktree ($WT)" \
  || bad "claude cwd was '$cwd1', expected the worktree '$WT'"
[ "$cwd1" != "$GROOT" ] && ok "claude cwd is NOT the deployed root tree" \
  || bad "claude ran in the root tree '$GROOT'"
[ "$(cat "$TR/mode.out" 2>/dev/null)" = "fresh" ] && ok "fresh claim starts a fresh session" \
  || bad "fresh claim should start a fresh session, not resume"
# The deployed root tree is untouched by the job's development.
[ -z "$(git -C "$GROOT" status --porcelain)" ] && ok "deployed root tree left clean" \
  || bad "root tree dirtied: $(git -C "$GROOT" status --porcelain | tr '\n' ';')"
# A completed job's worktree is torn down (and deregistered).
[ ! -e "$WT" ] && ok "successful run tears the worktree down" \
  || bad "worktree survived a successful run: $WT"
git -C "$GROOT" worktree list --porcelain | grep -q "$WT" \
  && bad "worktree still registered after teardown" \
  || ok "worktree deregistered from the root repo"

# === 4: a failed run LEAVES the worktree with in-flight work, for a requeue ====
rm -f "$TR/cwd.out" "$TR/mode.out"
FAKE_CLAUDE_FAIL=42 run_handler "$BASE" "$JOB" "$REPORT"
[ "$RC" -eq 42 ] && ok "failed run propagates the handler rc (42)" \
  || bad "failed run should exit 42 (got $RC)"
[ -d "$WT" ] && ok "failed run LEAVES the worktree (requeue can resume into it)" \
  || bad "worktree was torn down on failure; a requeue could not resume"
[ -f "$WT/in-flight-marker" ] && ok "the in-flight uncommitted work survived in the worktree" \
  || bad "in-flight marker missing from the left-behind worktree"

# === 5: the requeue re-enters the SAME worktree and RESUMES ====================
# Stamp an identity sentinel so we can prove the next run re-enters THIS dir.
echo "sentinel-$$" > "$WT/.identity"
rm -f "$TR/cwd.out" "$TR/mode.out"
run_handler "$BASE" "$JOB" "$REPORT"            # succeeds this time (no FAIL set)
[ "$RC" -eq 0 ] && ok "requeue run completes (exit 0)" || bad "requeue run should exit 0 (got $RC)"
cwd2="$(cat "$TR/cwd.out" 2>/dev/null)"
[ "$cwd2" = "$WT" ] && ok "requeue re-enters the SAME per-base worktree" \
  || bad "requeue cwd was '$cwd2', expected '$WT'"
[ "$(cat "$TR/mode.out" 2>/dev/null)" = "resume" ] && ok "requeue RESUMES the deterministic session" \
  || bad "requeue should resume the session (mode='$(cat "$TR/mode.out" 2>/dev/null)')"
# The teardown-on-success removed the worktree, so the sentinel must be gone now —
# but it had to exist WHEN the resumed claude ran. The fake records cwd, and the
# resume-mode proves the same-path transcript was found, which is only possible if
# the sentinel'd worktree was the one entered. Belt: it is torn down again now.
[ ! -e "$WT" ] && ok "the resumed run tears the worktree down on its completion" \
  || bad "worktree survived the resumed run's completion: $WT"

echo
echo "gardener-worktree-test: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
