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
# Explicit positive test-context sentinel: protects this standalone suite even when
# invoked outside the test-tree entrypoint heuristic.
export GARDEN_TEST=1
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
cp "$JOBS_SRC/common.sh" "$JOBS_SRC/usage-meter.sh" "$JOBS_SRC/quota-panel.sh" "$GROOT/scripts/jobs/"
# The DATA common.sh reads, not just the code that reads it. Without these,
# tier_model_for_provider silently resolves to empty (the inventory file is
# absent), so every tier-resolution assertion below fails for a reason that has
# nothing to do with the handler under test.
cp "$JOBS_SRC/model-tier-inventory.tsv" "$JOBS_SRC/model-routing-defaults.tsv" \
   "$JOBS_SRC/rate-card-defaults.md" "$GROOT/scripts/jobs/"
# The Anthropic handler implementation now lives in monk-claude.sh; gardener-claude.sh
# is the warning-free forwarding wrapper onto it (gardener->monk rename). Copy BOTH so
# driving the legacy name exercises the forward path end-to-end (design § handlers).
cp "$JOBS_SRC/handlers/gardener-claude.sh" "$JOBS_SRC/handlers/monk-claude.sh" \
   "$JOBS_SRC/handlers/worker-common.sh" "$GROOT/scripts/jobs/handlers/"
chmod +x "$GROOT/scripts/jobs/handlers/gardener-claude.sh" "$GROOT/scripts/jobs/handlers/monk-claude.sh"
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
sid=""; mode="fresh"; model=""
prev=""
for a in "$@"; do
  case "$prev" in
    --session-id) sid="$a"; mode="fresh" ;;
    --resume)     sid="$a"; mode="resume" ;;
    --model)      model="$a" ;;
  esac
  prev="$a"
done
pwd > "$FAKE_CWD_OUT"
printf '%s\n' "$mode" > "$FAKE_MODE_OUT"
printf '%s\n' "$model" > "${FAKE_MODEL_OUT:-/dev/null}"
# The prompt is the last positional argument the handler passes; capture it so the
# test can assert the resume/fresh/fallback framing the worker actually receives.
printf '%s' "${@: -1}" > "${FAKE_PROMPT_OUT:-/dev/null}"
[ -z "${GARDEN_USAGE_FILE+x}" ] && printf '%s\n' absent > "${FAKE_USAGE_OUT:-/dev/null}" || printf '%s\n' present > "${FAKE_USAGE_OUT:-/dev/null}"
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
# A genuine completion emits the completion marker as its final line (the worker's
# instructed final act); the handler keys the sentinel + teardown on it.
[ -n "${FAKE_COMPLETION_MARKER:-}" ] && printf '%s\n' "$FAKE_COMPLETION_MARKER"
FAKE
chmod +x "$FAKEDIR/claude"

# The completion marker the production handler gates on, read straight from
# common.sh so the test can never drift from the real signal string.
MARKER="$(sed -n "s/^GARDEN_COMPLETION_MARKER='\(.*\)'\$/\1/p" "$JOBS_SRC/common.sh" | head -1)"
[ -n "$MARKER" ] || { echo "  SKIP: could not read GARDEN_COMPLETION_MARKER from common.sh"; exit 0; }
SENTINEL="$TR/completion.sentinel"

# Common env for a handler run. HOME is redirected into $TR so the fake claude's
# transcript (and the handler's resume probe) stay hermetic.
run_handler() {  # run_handler <base> <jobfile> <report> ; sets global RC
  # Pin the throwaway garden explicitly: GARDEN_ROOT/GARDEN_SCRATCH are commonly
  # exported in a developer/fleet shell, and common.sh only fills them when unset,
  # so without overriding here the handler would build a worktree in the REAL
  # garden's scratch. Invoke via `bash` rather than execute directly: the sandbox
  # can mount the temp tree noexec, so a copied +x script still fails with rc=126.
  #
  # gardener.sh always passes GARDEN_COMPLETION_SENTINEL and the handler keys its
  # teardown on that sentinel (written only on a genuine, marker-signaled
  # completion), so mirror that contract here: a fresh sentinel path per run, plus
  # the marker the fake claude emits on success.
  rm -f "$SENTINEL"
  HOME="$TR/home" PATH="$FAKEDIR:$PATH" \
    GARDEN_ROOT="$GROOT" GARDEN_SCRATCH="$SCRATCH" GARDEN_STATE="$TR/state" \
    GARDEN_NO_MAINTAINER_ALERT=1 GARDEN_STALE_HANDLER_KILL_GRACE=1 \
    GARDEN_COMPLETION_SENTINEL="$SENTINEL" GARDEN_USAGE_FILE="$TR/usage.json" FAKE_COMPLETION_MARKER="$MARKER" \
    FAKE_CWD_OUT="$TR/cwd.out" FAKE_MODE_OUT="$TR/mode.out" FAKE_MODEL_OUT="$TR/model.out" FAKE_USAGE_OUT="$TR/usage.out" \
    FAKE_PROMPT_OUT="$TR/prompt.out" \
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
# The fresh framing neither claims a resume nor warns of lost state (there is none).
grep -q 'carried forward to you intact' "$TR/prompt.out" 2>/dev/null \
  && bad "fresh prompt falsely claims a carried-forward resume" \
  || ok "fresh prompt makes no resume claim"
grep -q 'BOTH LOST' "$TR/prompt.out" 2>/dev/null \
  && bad "fresh prompt falsely warns of lost prior state on a first claim" \
  || ok "fresh prompt makes no lost-state warning"
[ "$(cat "$TR/usage.out" 2>/dev/null)" = absent ] && ok "Claude cannot see the private usage handoff" \
  || bad "Claude inherited GARDEN_USAGE_FILE and could forge accounting"
# The marker-signaled completion wrote the sentinel gardener.sh gates doin→tada on.
[ -e "$SENTINEL" ] && ok "marker-signaled completion wrote the completion sentinel" \
  || bad "completion sentinel not written on a genuine completion"
# The machine marker is stripped from the human-facing report.
grep -qF "$MARKER" "$REPORT" \
  && bad "completion marker leaked into the tada report (should be stripped)" \
  || ok "completion marker stripped from the report"
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
# A TRUE resume (transcript present, same host) keeps the "carried forward intact"
# framing — the prior session and its uncommitted worktree really did survive.
grep -q 'carried forward to you intact' "$TR/prompt.out" 2>/dev/null \
  && ok "a true resume tells the worker its session was carried forward intact" \
  || bad "resume prompt dropped the carried-forward framing"
grep -q 'BOTH LOST' "$TR/prompt.out" 2>/dev/null \
  && bad "a true resume must not warn of lost state (nothing was lost)" \
  || ok "a true resume makes no lost-state warning"
# The teardown-on-success removed the worktree, so the sentinel must be gone now —
# but it had to exist WHEN the resumed claude ran. The fake records cwd, and the
# resume-mode proves the same-path transcript was found, which is only possible if
# the sentinel'd worktree was the one entered. Belt: it is torn down again now.
[ ! -e "$WT" ] && ok "the resumed run tears the worktree down on its completion" \
  || bad "worktree survived the resumed run's completion: $WT"

# === 5b: a requeue with NO local transcript (cross-host / pruned) gets the =====
# HONEST "fallback" framing, not the false "carried forward intact" resume text.
# This is the issue-#62 gap: a reaped job (garden-reaped marker present) re-claimed
# where its session transcript does not exist recreated a FRESH worktree and lost
# its in-progress state, so the worker must be told plainly rather than told to
# trust a memory and hunt for uncommitted edits that are gone. A fresh $HOME (no
# transcript anywhere) + a reap marker on the job reproduces the cross-host case.
FBASE="garden-fallback-demo"
FWT="$SCRATCH/gardener-wt-$FBASE"
FJOB="$TR/$FBASE.job"
printf 'Map: build (garden infra), branch main2. Do a thing.\n\n<!-- garden-reaped: 2 -->\n' > "$FJOB"
rm -f "$TR/cwd.out" "$TR/mode.out" "$TR/prompt.out"
run_handler "$FBASE" "$FJOB" "$REPORT"
[ "$RC" -eq 0 ] && ok "lost-transcript requeue completes (exit 0)" \
  || bad "lost-transcript requeue should exit 0 (got $RC)"
# No transcript existed, so the handler pins a FRESH session (never --resume).
[ "$(cat "$TR/mode.out" 2>/dev/null)" = "fresh" ] && ok "lost-transcript requeue starts a fresh session (no false --resume)" \
  || bad "lost-transcript requeue should start fresh, not resume (mode='$(cat "$TR/mode.out" 2>/dev/null)')"
# It must NOT assert the resume it does not have...
grep -q 'carried forward to you intact' "$TR/prompt.out" 2>/dev/null \
  && bad "fallback prompt falsely claims a carried-forward resume" \
  || ok "fallback prompt does NOT claim a carried-forward resume"
# ...and it MUST tell the worker its prior state was lost and to re-derive.
grep -q 'BOTH LOST' "$TR/prompt.out" 2>/dev/null \
  && ok "fallback prompt states the prior session and worktree were lost" \
  || bad "fallback prompt failed to warn that prior state was lost"
grep -qi 're-derive' "$TR/prompt.out" 2>/dev/null \
  && ok "fallback prompt tells the worker to re-derive state from committed work" \
  || bad "fallback prompt did not instruct the worker to re-derive state"
# The two framings are genuinely different text on the resume vs fallback path.
[ -e "$FWT" ] && scratch_leftover=1 || scratch_leftover=0   # completed => torn down
[ "$scratch_leftover" -eq 0 ] && ok "completed lost-transcript run tears its fresh worktree down" \
  || bad "fallback run left its worktree behind: $FWT"

# === 6: a job with `model: fable` threads --model claude-fable-5 ==============
# A per-job `model:` frontmatter field is honored: the short tier name is mapped
# to its concrete model id and passed through as `claude -p --model <id>`. The
# short names are the same canonical set as skills/model-selection.
MBASE="garden-infra-model"
MJOB="$TR/$MBASE.job"          # leading YAML frontmatter carrying the model field
# `dispatch: manual` is REQUIRED for any Fable/mentat selection and is stamped by
# post-manual-job.sh, the sole sanctioned mentat dispatch path (it emits
# `tier: mentat` + `dispatch: manual`). A bare `model: fable` with no dispatch
# field is not a shape any producer can post: mentat is an authorization
# boundary, not a price point (skills/model-selection/SKILL.md).
printf -- '---\nmodel: fable\ndispatch: manual\n---\nMap: build (garden infra). Run this one on Fable.\n' > "$MJOB"
rm -f "$TR/model.out"
run_handler "$MBASE" "$MJOB" "$REPORT"
[ "$RC" -eq 0 ] && ok "model-selecting run exits 0" || bad "model run should exit 0 (got $RC)"
[ "$(cat "$TR/model.out" 2>/dev/null)" = "claude-fable-5" ] \
  && ok "model: fable maps to --model claude-fable-5" \
  || bad "expected --model claude-fable-5, got '$(cat "$TR/model.out" 2>/dev/null)'"

# === 7: a job with NO model field passes NO --model (default unchanged) ========
NBASE="garden-infra-nomodel"
NJOB="$TR/$NBASE.job"
printf 'Map: build (garden infra). No model field; default behavior.\n' > "$NJOB"
rm -f "$TR/model.out"
run_handler "$NBASE" "$NJOB" "$REPORT"
[ "$RC" -eq 0 ] && ok "no-model run exits 0" || bad "no-model run should exit 0 (got $RC)"
[ -z "$(cat "$TR/model.out" 2>/dev/null)" ] \
  && ok "absent model field passes NO --model (default preserved)" \
  || bad "expected no --model, got '$(cat "$TR/model.out" 2>/dev/null)'"

# === 8: a bad/unknown model value falls back to the default (no --model) =======
BBASE="garden-infra-badmodel"
BJOB="$TR/$BBASE.job"
printf -- '---\nmodel: gpt-9-turbo\n---\nMap: build (garden infra). Bogus model name.\n' > "$BJOB"
rm -f "$TR/model.out"
run_handler "$BBASE" "$BJOB" "$REPORT"
[ "$RC" -eq 0 ] && ok "unknown-model run does not crash (exit 0)" || bad "unknown-model run should exit 0 (got $RC)"
[ -z "$(cat "$TR/model.out" 2>/dev/null)" ] \
  && ok "unknown model falls back to the default (no --model)" \
  || bad "expected fallback to no --model, got '$(cat "$TR/model.out" 2>/dev/null)'"

# === 9: role: designer defaults to Opus; role: builder defaults to Opus ========
# With NO explicit `model:` field, a job's `role:` selects the per-role default
# model (common.sh role_default_model): designer -> claude-opus-4-8, builder ->
# claude-opus-4-8. This is the standing policy (2026-07-13; designer moved off
# Fable to Opus, the same tier builder uses).
DRBASE="garden-infra-designer-role"
DRJOB="$TR/$DRBASE.job"
printf -- '---\nrole: designer\n---\nDesign X. No explicit model; role picks the default.\n' > "$DRJOB"
rm -f "$TR/model.out"
run_handler "$DRBASE" "$DRJOB" "$REPORT"
[ "$RC" -eq 0 ] && ok "role: designer run exits 0" || bad "designer-role run should exit 0 (got $RC)"
[ "$(cat "$TR/model.out" 2>/dev/null)" = "claude-opus-4-8" ] \
  && ok "role: designer defaults to --model claude-opus-4-8" \
  || bad "expected claude-opus-4-8, got '$(cat "$TR/model.out" 2>/dev/null)'"

BRBASE="garden-infra-builder-role"
BRJOB="$TR/$BRBASE.job"
printf -- '---\nrole: builder\n---\nBuild X. No explicit model; role picks the default.\n' > "$BRJOB"
rm -f "$TR/model.out"
run_handler "$BRBASE" "$BRJOB" "$REPORT"
[ "$RC" -eq 0 ] && ok "role: builder run exits 0" || bad "builder-role run should exit 0 (got $RC)"
[ "$(cat "$TR/model.out" 2>/dev/null)" = "claude-opus-4-8" ] \
  && ok "role: builder defaults to --model claude-opus-4-8" \
  || bad "expected claude-opus-4-8, got '$(cat "$TR/model.out" 2>/dev/null)'"

# === 10: explicit model: overrides the role default ============================
# A designer job that ALSO names `model: fable` must run on Fable — the explicit
# per-job model wins over the role's Opus default.
ORBASE="garden-infra-role-override"
ORJOB="$TR/$ORBASE.job"
printf -- '---\nrole: designer\nmodel: fable\ndispatch: manual\n---\nDesign X, but on Fable for this one.\n' > "$ORJOB"
rm -f "$TR/model.out"
run_handler "$ORBASE" "$ORJOB" "$REPORT"
[ "$RC" -eq 0 ] && ok "role+explicit-model run exits 0" || bad "override run should exit 0 (got $RC)"
[ "$(cat "$TR/model.out" 2>/dev/null)" = "claude-fable-5" ] \
  && ok "explicit model: fable overrides the designer Opus default" \
  || bad "expected claude-fable-5 (override), got '$(cat "$TR/model.out" 2>/dev/null)'"

# === 11: an unpinned role passes NO --model (fleet default) ====================
URBASE="garden-infra-unpinned-role"
URJOB="$TR/$URBASE.job"
printf -- '---\nrole: fixer\n---\nFix X. Unpinned role; rides the fleet default.\n' > "$URJOB"
rm -f "$TR/model.out"
run_handler "$URBASE" "$URJOB" "$REPORT"
[ "$RC" -eq 0 ] && ok "unpinned-role run exits 0" || bad "unpinned-role run should exit 0 (got $RC)"
[ -z "$(cat "$TR/model.out" 2>/dev/null)" ] \
  && ok "unpinned role passes NO --model (fleet default)" \
  || bad "expected no --model, got '$(cat "$TR/model.out" 2>/dev/null)'"

# === 12: a re-claim KILLS a live predecessor still in the worktree ============
# The two-writer guard (reaper-requeue-kills-or-waits-for-live-handler): a requeue
# can re-claim a base on this host while a PRIOR incarnation's process is still
# running in the deterministic per-base worktree (a reap-now hint / TTL fired while
# it was alive, or an orphan the wrapper's `timeout` left behind). Launching a
# second claude then would put two live writers on one tree. The handler must reap
# any such predecessor BEFORE it touches the worktree. We simulate the predecessor
# with a `setsid sleep` whose cwd is the worktree (its OWN process group, so the
# group-kill path is exercised), then run the handler and assert the predecessor is
# dead. Requires /proc (the kill enumerates it); skip cleanly without it.
if [ -d /proc ] && command -v setsid >/dev/null 2>&1; then
  PBASE="garden-infra-predecessor"
  PWT="$SCRATCH/gardener-wt-$PBASE"
  PJOB="$TR/$PBASE.job"
  printf 'Map: build (garden infra). Two-writer guard.\n' > "$PJOB"
  # A failed first run creates and LEAVES the worktree (and its transcript), the
  # in-flight state a requeue would re-enter.
  FAKE_CLAUDE_FAIL=9 run_handler "$PBASE" "$PJOB" "$REPORT"
  if [ -d "$PWT" ]; then
    # Spawn a live predecessor rooted in the worktree, in its own session/group.
    setsid bash -c "cd '$PWT' && exec sleep 300" &
    PRED=$!
    sleep 0.4
    pred_cwd="$(readlink "/proc/$PRED/cwd" 2>/dev/null || true)"
    if kill -0 "$PRED" 2>/dev/null && [ "$pred_cwd" = "$PWT" ]; then
      ok "spawned a live predecessor (pid $PRED) rooted in the worktree"
      # The re-claim must kill it before launching its own claude.
      run_handler "$PBASE" "$PJOB" "$REPORT"
      [ "$RC" -eq 0 ] && ok "re-claim over a live predecessor completes (exit 0)" \
        || bad "re-claim run should exit 0 (got $RC)"
      # Give the reaped process a beat to be collected, then assert it is gone.
      sleep 0.3
      if kill -0 "$PRED" 2>/dev/null; then
        bad "predecessor pid $PRED SURVIVED the re-claim (two-writer window still open)"
        kill -KILL "$PRED" 2>/dev/null || true
      else
        ok "the re-claim SIGKILLed the live predecessor before launching a fresh handler"
      fi
    else
      echo "  SKIP: could not stage a live predecessor in the worktree"
      kill -KILL "$PRED" 2>/dev/null || true
    fi
  else
    bad "failed first run did not leave the worktree to stage the predecessor test"
  fi
else
  echo "  SKIP: /proc or setsid unavailable; cannot exercise the predecessor-kill guard"
fi

echo
echo "gardener-worktree-test: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
