#!/bin/bash
# gauntlet-test.sh — validate the STAGED-GAUNTLET driver (gauntlet.sh) on a throwaway
# journal: a deterministic watcher that walks a PR through clean → panel → fix-loop →
# un-draft ONE claim-sized stage at a time, so no single handler spans the loop
# (designs/staged-gauntlet.md). Modeled on orchestrate-test.sh.
#
# Subtests (all hermetic; no systemd, no network, no `claude -p` — a local bare
# journal, and the fleet is SIMULATED by writing stage tada reports with a marker):
#   1. HAPPY      — clean → panel-1 (pass) → undraft → done, no fixer round.
#   2. FIXLOOP    — panel-1 (must-fix) → fix-1 → panel-2 (pass) → undraft → done.
#   3. REVIEWLIMIT— an all-green fix-loop that exhausts max_iterations becomes a
#                    quiet, non-failing human-decision state (surfaces as INFO).
#   4. STAGEFAIL  — with stage retries disabled, a vanished stage HALTS (surfaces).
#   5. PROBE      — a kind:probe gauntlet passes the panel but NEVER un-drafts (done draft).
#   6. STILLPEND  — a clean stage reporting `still-pending` re-posts the SAME stage.
#   7. NOMARKER   — a `done` stage with NO parseable marker HALTS (fail-closed).
#   8. IDEMPOTENT — a re-tick while a stage is in flight promotes nothing new.
#   9. RESUMEBOUND— endless `still-pending` HALTS at max_resumes (a checkless repo).
#  10. SHARDED    — a stage completed into a date-sharded tada/ path advances.
#  11. PANELERROR RECOVERY — a `panel=panel-error` (sensor failure, not a verdict)
#                    re-posts the SAME panel round under the stage-retry budget;
#                    a following real verdict then proceeds (rec 6, no gauntlet halt).
#  12. PANELERROR EXHAUSTION — repeated `panel=panel-error` HALTS at max_stage_retries.
#  13. COMMENT FAILURE — a failed terminal PR comment does not block the finish,
#                    and a later tick delivers the owed receipt exactly once.
#  14. READ FAILURE — an unreadable comment list (a quota-cooled read) persists a
#                    pending receipt with the finish; retries post it once, clear it.
#  15. COOLDOWN   — terminal receipts finishing under a live gh-api cooldown defer
#                    into pending records WITHOUT a gh read or a per-gauntlet WARN.
#
# Usage: gauntlet-test.sh

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
POSTING_GARDEN_ROOT="$(cd "$JOBS/../.." && pwd)"
BRANCH=journal2
TR=/home/kris/.garden-gauntlet-test
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
hr()  { echo "----------------------------------------------------------------"; }

# Hermetic baseline: a live gardener may invoke this test with the fleet's own
# GARDEN_*/JOURNAL_* exported (see run-test.sh). Scrub them so ONLY the throwaway
# $TR settings are authoritative.
# shellcheck disable=SC2046  # intentional word-split: unset each matched var name
unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_)' || true) 2>/dev/null || true

rm -rf "$TR"; mkdir -p "$TR"
BARE="$TR/journal.git"
git_id=(-c user.name=test -c user.email=test@localhost)
# shellcheck source=test-fixture-helpers.sh
source "$HERE/test-fixture-helpers.sh"

# --- seed the shared origin -------------------------------------------------
git init -q --bare "$BARE"
SEED="$TR/seed"; git init -q "$SEED"
git -C "$SEED" checkout -q -b "$BRANCH"
( cd "$SEED"
  mkdir -p jobs/todo jobs/doin jobs/tada jobs/plan jobs/gauntlet jobs/index work \
           inbox/maintainer/unread inbox/maintainer/read
  for d in jobs/todo jobs/doin jobs/tada jobs/plan jobs/gauntlet jobs/index work \
           inbox/maintainer/unread inbox/maintainer/read; do touch "$d/.gitkeep"; done )
seed_calibrated_test_pool "$SEED" testhost gardener
git -C "$SEED" add -A
git -C "$SEED" "${git_id[@]}" commit -q -m "seed: board + gauntlet structure"
git -C "$SEED" remote add origin "$BARE"
git -C "$SEED" push -q -u origin "$BRANCH"

export JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH="$BRANCH"
export GARDEN=testhost GARDEN_STATE="$TR/state"
export GARDEN_GH="$HERE/gauntlet-gh-stub.sh"
export GAUNTLET_GH_COMMENTS="$TR/pr-comments"
export GAUNTLET_GH_FAIL_WRITES_FILE="$TR/fail-comment-writes"
export GAUNTLET_GH_FAIL_READS_FILE="$TR/fail-comment-reads"
export GAUNTLET_GH_READS_LOG="$TR/pr-comment-reads"
# The host-shared gh-api cooldown latch otherwise defaults under the deployed garden
# root; keep it in the throwaway tree so a live host cooldown cannot leak in.
export GARDEN_API_COOLDOWN_DIR="$TR/gh-api-cooldown"
# Likewise the token meter's local sensor defaults to this host's real Claude
# transcripts; a busy host's weekly spend otherwise exceeds the fixture pool and
# parks every stage in plan/ as over-token-budget.
export GARDEN_CCUSAGE_LOGDIR="$TR/claude-projects"
mkdir -p "$GAUNTLET_GH_COMMENTS" "$GARDEN_API_COOLDOWN_DIR" "$GARDEN_CCUSAGE_LOGDIR"
# The driver's deterministic merge-base-pinning pre-gate makes a live `gh pr view`
# on the first tick of each fresh record. This suite's fixture PRs do not exist on
# GitHub, so point the gate at a fast no-op (exit 0 = pinned = proceed) to keep the
# ticks hermetic and network-free. The gate's own behaviour is proven in
# assert-pinned-base-test.sh and the halt path in gauntlet-pin-gate-test.sh.
export GARDEN_ASSERT_PINNED_BASE=/bin/true
export GARDEN_POST_ATTEMPTS=50
export GARDEN_CLAIM_TTL=14400 GARDEN_HANDLER_KILL_AFTER=60
# Keep the CI-blocking-stage budget line deterministic (not required by the test, but
# stamped into the stage bodies the driver posts).
export GARDEN_SHEPHERD_HANDLER_TIMEOUT=7200
# Leave GARDEN_GAUNTLET_PANEL_HANDLER_TIMEOUT unset: this suite guards the shipped
# 10800s default, including its claim-TTL headroom, rather than merely testing an
# explicit override of the knob.

# --- board inspection helpers (fresh clone each call) -----------------------
V="$TR/verify"
board() {  # board <subdir> → basenames present (no .gitkeep, no .md suffix)
  rm -rf "$V"; git clone -q --single-branch --branch "$BRANCH" "$BARE" "$V"
  find "$V/$1" -type f ! -name .gitkeep -printf '%f\n' 2>/dev/null \
    | sed 's/\.md$//' | sort | tr '\n' ' '
}
in_dir() { board "$1" | tr ' ' '\n' | grep -qx "$2"; }   # in_dir <subdir> <base>
record_field() {  # record_field <g> <key>
  rm -rf "$V"; git clone -q --single-branch --branch "$BRANCH" "$BARE" "$V"
  sed -n "s/^$2:[[:space:]]*//p" "$V/jobs/gauntlet/$1.md" 2>/dev/null | head -1
}
tada_body() {
  local path
  rm -rf "$V"; git clone -q --single-branch --branch "$BRANCH" "$BARE" "$V"
  path="$(fixture_tada_file "$V" "$1" || true)"
  [ -n "$path" ] && cat "$path"
}
terminal_comment_count() {  # terminal_comment_count <base> <state>
  grep -rlF -- "<!-- garden-gauntlet-terminal-status: base=$1 state=$2 -->" \
    "$GAUNTLET_GH_COMMENTS" 2>/dev/null | wc -l
}
terminal_comment_body() {  # terminal_comment_body <base> <state>
  local hit
  hit="$(grep -rlF -- "<!-- garden-gauntlet-terminal-status: base=$1 state=$2 -->" \
    "$GAUNTLET_GH_COMMENTS" 2>/dev/null | head -1)"
  [ -n "$hit" ] && cat "$hit"
}
terminal_comment_nollm() {  # terminal_comment_nollm <base> <state> → GARDEN_NO_LLM seen by gh
  local hit
  hit="$(grep -rlF -- "<!-- garden-gauntlet-terminal-status: base=$1 state=$2 -->" \
    "$GAUNTLET_GH_COMMENTS" 2>/dev/null | head -1)"
  [ -n "$hit" ] && cat "${hit%.md}.nollm" 2>/dev/null
}
todo_body() { rm -rf "$V"; git clone -q --single-branch --branch "$BRANCH" "$BARE" "$V"; cat "$V/jobs/todo/$1.md" 2>/dev/null; }
# handler_timeout <todo-base> → the handler-timeout header value, or empty if none.
handler_timeout() { todo_body "$1" | sed -n 's/^handler-timeout:[[:space:]]*//p' | head -1; }
handler_budget_role() { todo_body "$1" | sed -n 's/^handler-budget-role:[[:space:]]*//p' | head -1; }

# Simulate a gardener COMPLETING a stage with a stage-result MARKER: remove it from
# todo/doin and write a tada report ending in the deterministic marker line.
complete_stage() {  # complete_stage <base> <marker-body>  (e.g. "clean=done")
  local wt; wt="$(mktemp -d "$TR/edit.XXXXXX")"
  git clone -q --single-branch --branch "$BRANCH" "$BARE" "$wt"
  git -C "$wt" rm -q "jobs/todo/$1.md" 2>/dev/null || true
  git -C "$wt" rm -q "jobs/doin/$1.md" 2>/dev/null || true
  { printf '# %s complete\n\nstage work done.\n\n' "$1"
    [ "$2" != panel=must-fix ] || printf 'must-fix items (2):\n- fixture item one\n- fixture item two\n\n'
    printf '<!-- gauntlet-stage-result: %s -->\n' "$2"; } > "$wt/jobs/tada/$1.md"
  git -C "$wt" add "jobs/tada/$1.md"
  git -C "$wt" "${git_id[@]}" commit -q -m "tada($1) $2"
  git -C "$wt" push -q origin "HEAD:$BRANCH"
  rm -rf "$wt"
}

complete_stage_sharded() {  # complete_stage_sharded <base> <marker-body>
  local wt shard; wt="$(mktemp -d "$TR/edit.XXXXXX")"
  shard="$(date -u +%Y/%m/%d)"
  git clone -q --single-branch --branch "$BRANCH" "$BARE" "$wt"
  git -C "$wt" rm -q "jobs/todo/$1.md" 2>/dev/null || true
  git -C "$wt" rm -q "jobs/doin/$1.md" 2>/dev/null || true
  mkdir -p "$wt/jobs/tada/$shard"
  { printf '# %s complete\n\nstage work done.\n\n' "$1"
    printf '<!-- gauntlet-stage-result: %s -->\n' "$2"; } > "$wt/jobs/tada/$shard/$1.md"
  git -C "$wt" add "jobs/tada/$shard/$1.md"
  git -C "$wt" "${git_id[@]}" commit -q -m "tada($1) $2 sharded"
  git -C "$wt" push -q origin "HEAD:$BRANCH"
  rm -rf "$wt"
}
# A stage that finishes WITHOUT a parseable marker (fail-closed → halt).
complete_stage_nomarker() {  # complete_stage_nomarker <base>
  local wt; wt="$(mktemp -d "$TR/edit.XXXXXX")"
  git clone -q --single-branch --branch "$BRANCH" "$BARE" "$wt"
  git -C "$wt" rm -q "jobs/todo/$1.md" 2>/dev/null || true
  git -C "$wt" rm -q "jobs/doin/$1.md" 2>/dev/null || true
  printf '# %s finished\n\nno marker here.\n' "$1" > "$wt/jobs/tada/$1.md"
  git -C "$wt" add "jobs/tada/$1.md"
  git -C "$wt" "${git_id[@]}" commit -q -m "tada($1) no-marker"
  git -C "$wt" push -q origin "HEAD:$BRANCH"
  rm -rf "$wt"
}
# A stage FAILING: the reaper doomed/dropped it — it vanishes WITHOUT a tada report.
fail_stage() {  # fail_stage <base>
  local wt; wt="$(mktemp -d "$TR/edit.XXXXXX")"
  git clone -q --single-branch --branch "$BRANCH" "$BARE" "$wt"
  git -C "$wt" rm -q "jobs/todo/$1.md" 2>/dev/null || true
  git -C "$wt" rm -q "jobs/doin/$1.md" 2>/dev/null || true
  git -C "$wt" "${git_id[@]}" commit -q -m "doom-drop($1)"
  git -C "$wt" push -q origin "HEAD:$BRANCH"
  rm -rf "$wt"
}

# Preserve/restore an active record around a terminal tick. Restoring it models a
# lost finish CAS after the GitHub comment already landed: the next tick re-drives
# the SAME terminal transition, and the hidden marker must suppress a second post.
save_gauntlet_record() {  # save_gauntlet_record <base>
  rm -rf "$V"; git clone -q --single-branch --branch "$BRANCH" "$BARE" "$V"
  cp "$V/jobs/gauntlet/$1.md" "$TR/$1-record.md"
}
restore_gauntlet_record() {  # restore_gauntlet_record <base>
  local wt tada_path
  wt="$(mktemp -d "$TR/edit.XXXXXX")"
  git clone -q --single-branch --branch "$BRANCH" "$BARE" "$wt"
  tada_path="$(fixture_tada_file "$wt" "$1" || true)"
  [ -z "$tada_path" ] || git -C "$wt" rm -q "${tada_path#"$wt/"}"
  cp "$TR/$1-record.md" "$wt/jobs/gauntlet/$1.md"
  git -C "$wt" add "jobs/gauntlet/$1.md"
  git -C "$wt" "${git_id[@]}" commit -q -m "fixture: restore gauntlet $1 after lost finish CAS"
  git -C "$wt" push -q origin "HEAD:$BRANCH"
  rm -rf "$wt"
}

tick() { "$JOBS/gauntlet.sh" >"$TR/tick.log" 2>&1 || { echo "  (gauntlet.sh rc=$? — see below)"; cat "$TR/tick.log"; }; }

post_gauntlet() {  # [options] <g> <pr-url>
  local base="${*: -2:1}"
  "$JOBS/post-gauntlet.sh" "$@" >/dev/null
  # Every current gauntlet starts with the cheap viability gate. Complete that
  # prerequisite as fixture setup so the historical stage-machine assertions
  # below continue to begin at clean. The earlier `todo=[g1-viability]` failure
  # was expectation drift, not budget-pool admission: gauntlet.sh had correctly
  # posted the newly introduced first stage without invoking a worker claim.
  tick
  complete_stage "$base-viability" viability=proceed
}

# ============================================================================
hr; echo "SUBTEST 1 — HAPPY: clean → panel-1 (pass) → undraft → done"; hr
post_gauntlet --build-job build-1 g1 https://github.com/testowner/testrepo/pull/1

tick   # fresh record → post clean
{ in_dir jobs/todo g1-clean && [ "$(record_field g1 current_child)" = g1-clean ] && [ "$(record_field g1 stage)" = clean ]; } \
  && ok "tick 1: posted g1-clean, record at stage=clean" \
  || bad "tick 1: todo=[$(board jobs/todo)] stage=$(record_field g1 stage) child=$(record_field g1 current_child)"
clean_body="$(todo_body g1-clean)"
{ printf '%s' "$clean_body" | grep -q 'scripts/jobs/ensure-project-worktree.sh' \
    && ! printf '%s' "$clean_body" | grep -Fq "$POSTING_GARDEN_ROOT/"; } \
  && ok "clean stage emits repo-relative garden script paths (no posting-host root)" \
  || bad "clean stage baked the posting host's garden root into its body"
[ "$(handler_timeout g1-clean)" = 7200 ] \
  && ok "clean stage carries the CI-sized handler-timeout (7200)" \
  || bad "clean handler-timeout=[$(handler_timeout g1-clean)] (expected 7200)"
[ "$(handler_budget_role g1-clean)" = shepherd ] \
  && ok "clean stage is protected by the shepherd budget role" \
  || bad "clean handler-budget-role=[$(handler_budget_role g1-clean)] (expected shepherd)"

complete_stage g1-clean clean=done
tick   # clean done → post panel-1
{ in_dir jobs/todo g1-panel-1 && [ "$(record_field g1 stage)" = panel ] && [ "$(record_field g1 iteration)" = 1 ]; } \
  && ok "tick 2: clean=done → posted g1-panel-1 (iteration 1)" \
  || bad "tick 2: todo=[$(board jobs/todo)] stage=$(record_field g1 stage) iter=$(record_field g1 iteration)"
panel_body="$(todo_body g1-panel-1)"
{ printf '%s' "$panel_body" | grep -q 'scripts/jobs/gardening/panel.sh' \
    && ! printf '%s' "$panel_body" | grep -Fq "$POSTING_GARDEN_ROOT/"; } \
  && ok "panel stage emits repo-relative garden script paths (no posting-host root)" \
  || bad "panel stage baked the posting host's garden root into its body"
panel_timeout="$(handler_timeout g1-panel-1)"
[ "$panel_timeout" = 10800 ] \
  && ok "panel stage carries its dedicated 10800s handler-timeout (above the old 7200s wall)" \
  || bad "panel handler-timeout=[$panel_timeout] (expected 10800)"
[ $((panel_timeout + GARDEN_HANDLER_KILL_AFTER)) -lt "$GARDEN_CLAIM_TTL" ] \
  && ok "panel round remains claim-sized (${panel_timeout}s + ${GARDEN_HANDLER_KILL_AFTER}s < ${GARDEN_CLAIM_TTL}s TTL)" \
  || bad "panel round exhausts claim TTL (${panel_timeout}s + ${GARDEN_HANDLER_KILL_AFTER}s >= ${GARDEN_CLAIM_TTL}s)"
[ "$(handler_budget_role g1-panel-1)" = panel ] \
  && ok "panel stage is protected by the panel budget role" \
  || bad "panel handler-budget-role=[$(handler_budget_role g1-panel-1)] (expected panel)"

complete_stage g1-panel-1 panel=pass
tick   # panel pass (feature) → post undraft
{ in_dir jobs/todo g1-undraft && [ "$(record_field g1 stage)" = undraft ]; } \
  && ok "tick 3: panel=pass → posted g1-undraft" \
  || bad "tick 3: todo=[$(board jobs/todo)] stage=$(record_field g1 stage)"
[ -z "$(handler_timeout g1-undraft)" ] \
  && ok "undraft stage carries NO handler-timeout (short stage takes the plain default)" \
  || bad "undraft handler-timeout=[$(handler_timeout g1-undraft)] (expected none)"

complete_stage g1-undraft undraft=done
tick   # undraft done → finish
{ in_dir jobs/tada g1 && ! in_dir jobs/gauntlet g1; } \
  && ok "tick 4: undraft=done → gauntlet complete (tada/g1, record removed)" \
  || bad "tick 4: tada=[$(board jobs/tada)] gauntlet=[$(board jobs/gauntlet)]"
printf '%s' "$(tada_body g1)" | grep -qi 'gauntlet-status: complete' \
  && ok "the completion summary marks gauntlet-status: complete" \
  || bad "completion summary missing the complete marker"
printf '%s' "$(tada_body g1)" | grep -qx "panel_head: $(printf '%040d' 1)" \
  && printf '%s' "$(tada_body g1)" | grep -qx 'repo: testowner/testrepo' \
  && printf '%s' "$(tada_body g1)" | grep -qx 'pr_number: 1' \
  && ok "the completion summary binds the passing panel to repo, PR, and head (panel_head)" \
  || bad "completion summary missing repo/pr_number/panel_head: $(tada_body g1 | head -5)"

# ============================================================================
hr; echo "SUBTEST 2 — FIXLOOP: panel-1 must-fix → fix-1 → panel-2 pass → undraft → done"; hr
post_gauntlet g2 https://github.com/testowner/testrepo/pull/2

tick; complete_stage g2-clean clean=done
tick   # → panel-1
in_dir jobs/todo g2-panel-1 || bad "fixloop: g2-panel-1 not posted"
complete_stage g2-panel-1 panel=must-fix
tick   # panel must-fix → fix-1 (same iteration)
{ in_dir jobs/todo g2-fix-1 && [ "$(record_field g2 stage)" = fix ] && [ "$(record_field g2 iteration)" = 1 ]; } \
  && ok "panel-1 must-fix → posted g2-fix-1 (iteration stays 1)" \
  || bad "fixloop: todo=[$(board jobs/todo)] stage=$(record_field g2 stage) iter=$(record_field g2 iteration)"
fix_body="$(todo_body g2-fix-1)"
{ printf '%s' "$fix_body" | grep -q 'scripts/jobs/gardening/safe-push-pr-head.sh' \
    && ! printf '%s' "$fix_body" | grep -Fq "$POSTING_GARDEN_ROOT/"; } \
  && ok "fix stage emits repo-relative garden script paths (no posting-host root)" \
  || bad "fix stage baked the posting host's garden root into its body"
complete_stage g2-fix-1 fix=done
tick   # fix-1 done → panel-2 (iteration+1)
{ in_dir jobs/todo g2-panel-2 && [ "$(record_field g2 iteration)" = 2 ]; } \
  && ok "fix-1 done → posted g2-panel-2 (iteration advanced to 2)" \
  || bad "fixloop: todo=[$(board jobs/todo)] iter=$(record_field g2 iteration)"
complete_stage g2-panel-2 panel=pass
tick   # panel-2 pass → undraft
in_dir jobs/todo g2-undraft || bad "fixloop: g2-undraft not posted after panel-2 pass"
complete_stage g2-undraft undraft=done
tick   # → done
{ in_dir jobs/tada g2 && ! in_dir jobs/gauntlet g2; } \
  && ok "fix-loop converged: gauntlet complete after one fixer round" \
  || bad "fixloop: not complete (tada=[$(board jobs/tada)] gauntlet=[$(board jobs/gauntlet)])"

# ============================================================================
hr; echo "SUBTEST 3 — REVIEWLIMIT: a green fix-loop reaches a non-failing human-decision state"; hr
post_gauntlet --max-iterations 2 g3 https://github.com/testowner/testrepo/pull/3

tick; complete_stage g3-clean clean=done
tick   # panel-1
complete_stage g3-panel-1 panel=must-fix
tick   # fix-1
complete_stage g3-fix-1 fix=done
tick   # panel-2 (iteration 2 == max)
{ in_dir jobs/todo g3-panel-2; } || bad "nonconverge: g3-panel-2 not posted"
complete_stage g3-panel-2 panel=must-fix
tick   # fix-2
{ in_dir jobs/todo g3-fix-2; } || bad "nonconverge: g3-fix-2 not posted"
complete_stage g3-fix-2 fix=done
save_gauntlet_record g3
tick   # fix-2 done + CI green → panel-3 would exceed the review budget
{ ! in_dir jobs/todo g3-panel-3 && in_dir jobs/tada g3 && ! in_dir jobs/gauntlet g3; } \
  && ok "did NOT post panel-3 (> max_iterations); closed the record for human decision" \
  || bad "nonconverge: todo=[$(board jobs/todo)] tada=[$(board jobs/tada)] gauntlet=[$(board jobs/gauntlet)]"
g3_summary="$(tada_body g3)"
{ printf '%s' "$g3_summary" | grep -qi '^gauntlet-status: review-budget-reached$' \
    && ! printf '%s' "$g3_summary" | grep -qi '^orchestration-status:' \
    && ! printf '%s' "$g3_summary" | grep -qi '^orchestration-failed:'; } \
  && ok "review exhaustion is review-budget-reached, not an orchestration failure" \
  || bad "nonconverge: wrong terminal classification: [$g3_summary]"
printf '%s' "$g3_summary" | grep -qi 'changes pushed and CI green' \
  && ok "review-budget summary records the final fix's usable CI-green outcome" \
  || bad "nonconverge: summary does not record the CI-green final fix"
board inbox/maintainer/unread >/dev/null
{ grep -rqi 'INFO:.*review budget reached' "$V/inbox/maintainer/unread" 2>/dev/null \
    && ! grep -rqi 'HALTED' "$V/inbox/maintainer/unread" 2>/dev/null; } \
  && ok "review exhaustion surfaced as a quiet INFO human-decision notice" \
  || bad "nonconverge: no quiet review-budget notice (inbox: $(ls "$V/inbox/maintainer/unread" 2>/dev/null))"
g3_comment="$(terminal_comment_body g3 review-budget-reached)"
{ [ "$(terminal_comment_count g3 review-budget-reached)" = 1 ] \
    && printf '%s' "$g3_comment" | grep -Fq '**Gauntlet terminal — review-budget-reached**' \
    && printf '%s' "$g3_comment" | grep -Fq 'rounds run: 2' \
    && printf '%s' "$g3_comment" | grep -Eq 'head `[0-9]{40}`' \
    && printf '%s' "$g3_comment" | grep -Fq 'CI: green' \
    && printf '%s' "$g3_comment" | grep -Fq 'last panel unaddressed must-fix: 2' \
    && printf '%s' "$g3_comment" | grep -Fq 'awaiting maintainer merge/undraft or re-run decision'; } \
  && ok "review-budget terminal status posted once with the visible loop-status floor" \
  || bad "nonconverge: wrong/missing terminal PR comment: [$g3_comment]"
[ "$(terminal_comment_nollm g3 review-budget-reached)" = 1 ] \
  && ok "terminal status posts as machine-authored (GARDEN_NO_LLM=1), not a provenance gap" \
  || bad "nonconverge: terminal PR comment posted without GARDEN_NO_LLM=1 (provenance-gap alert)"
restore_gauntlet_record g3
tick   # same terminal transition re-driven after a simulated lost finish CAS
[ "$(terminal_comment_count g3 review-budget-reached)" = 1 ] \
  && ok "review-budget marker keeps the comment single when a later tick re-drives the terminal transition" \
  || bad "nonconverge: terminal PR comment duplicated across ticks"

# ============================================================================
hr; echo "SUBTEST 4 — STAGEFAIL: a vanished stage halts the run + surfaces"; hr
post_gauntlet --max-stage-retries 0 g4 https://github.com/testowner/testrepo/pull/4

tick   # post g4-clean
in_dir jobs/todo g4-clean || bad "stagefail: g4-clean not posted"
save_gauntlet_record g4
fail_stage g4-clean   # vanishes without a tada report (reaper doomed it)
tick   # detect failure → HALT
{ in_dir jobs/tada g4 && ! in_dir jobs/gauntlet g4; } \
  && ok "a vanished stage halted the run and closed the record" \
  || bad "stagefail: tada=[$(board jobs/tada)] gauntlet=[$(board jobs/gauntlet)]"
printf '%s' "$(tada_body g4)" | grep -qi 'gauntlet-status: halted' \
  && ok "stage-failure halt marks gauntlet-status: halted" \
  || bad "stagefail: halt summary missing status marker"
board inbox/maintainer/unread >/dev/null
grep -rqi 'HALTED' "$V/inbox/maintainer/unread" 2>/dev/null \
  && ok "stage failure surfaced to the maintainer inbox" \
  || bad "stagefail: no maintainer note"
g4_comment="$(terminal_comment_body g4 halted)"
{ [ "$(terminal_comment_count g4 halted)" = 1 ] \
    && printf '%s' "$g4_comment" | grep -Fq '**Gauntlet terminal — halted**' \
    && printf '%s' "$g4_comment" | grep -Fq 'rounds run: 0' \
    && printf '%s' "$g4_comment" | grep -Fq 'CI: green' \
    && printf '%s' "$g4_comment" | grep -Fq 'halt reason:'; } \
  && ok "halt terminal status posted once with its reason and visible loop status" \
  || bad "stagefail: wrong/missing terminal PR comment: [$g4_comment]"
restore_gauntlet_record g4
tick   # same terminal transition re-driven after a simulated lost finish CAS
[ "$(terminal_comment_count g4 halted)" = 1 ] \
  && ok "halt marker keeps the comment single when a later tick re-drives the terminal transition" \
  || bad "stagefail: terminal PR comment duplicated across ticks"

# ============================================================================
hr; echo "SUBTEST 5 — PROBE: a kind:probe gauntlet passes the panel but NEVER un-drafts"; hr
post_gauntlet --probe g5 https://github.com/testowner/testrepo/pull/5

tick; complete_stage g5-clean clean=done
tick   # → panel-1
in_dir jobs/todo g5-panel-1 || bad "probe: g5-panel-1 not posted"
[ "$(record_field g5 kind)" = probe ] && ok "the record is kind: probe" || bad "probe: kind=$(record_field g5 kind)"
complete_stage g5-panel-1 panel=pass
tick   # panel pass on a PROBE → done WITHOUT an undraft stage
{ ! in_dir jobs/todo g5-undraft && in_dir jobs/tada g5 && ! in_dir jobs/gauntlet g5; } \
  && ok "probe panel=pass → complete WITHOUT posting an undraft stage (stays draft)" \
  || bad "probe: todo=[$(board jobs/todo)] tada=[$(board jobs/tada)] gauntlet=[$(board jobs/gauntlet)]"
printf '%s' "$(tada_body g5)" | grep -qi 'stays DRAFT' \
  && ok "the probe completion notes it stays draft by design" \
  || bad "probe: completion summary does not note the draft-by-design outcome"

# ============================================================================
hr; echo "SUBTEST 6 — STILLPEND: a clean stage reporting still-pending re-posts the SAME stage"; hr
post_gauntlet g6 https://github.com/testowner/testrepo/pull/6

tick   # post g6-clean
in_dir jobs/todo g6-clean || bad "stillpend: g6-clean not posted"
complete_stage g6-clean clean=still-pending
tick   # still-pending → re-post the SAME stage (tada swapped back to todo), record unchanged
{ in_dir jobs/todo g6-clean && ! in_dir jobs/tada g6-clean && [ "$(record_field g6 stage)" = clean ] && [ "$(record_field g6 current_child)" = g6-clean ]; } \
  && ok "still-pending re-posted g6-clean (fresh todo, old tada removed, record still at clean)" \
  || bad "stillpend: todo=[$(board jobs/todo)] tada=[$(board jobs/tada)] stage=$(record_field g6 stage)"
# and it can now proceed normally
complete_stage g6-clean clean=done
tick
in_dir jobs/todo g6-panel-1 \
  && ok "after re-post, a real clean=done advances to panel-1" \
  || bad "stillpend: g6-panel-1 not posted after clean=done (todo=[$(board jobs/todo)])"
# drive to completion so the record does not linger for later ticks
complete_stage g6-panel-1 panel=pass; tick
complete_stage g6-undraft undraft=done; tick
in_dir jobs/tada g6 || bad "stillpend: g6 did not complete"

# ============================================================================
hr; echo "SUBTEST 7 — NOMARKER: a done stage with NO parseable marker halts (fail-closed)"; hr
post_gauntlet g7 https://github.com/testowner/testrepo/pull/7

tick   # post g7-clean
in_dir jobs/todo g7-clean || bad "nomarker: g7-clean not posted"
complete_stage_nomarker g7-clean   # completes but no marker
tick   # → HALT (never a guessed disposition)
{ in_dir jobs/tada g7 && ! in_dir jobs/gauntlet g7; } \
  && ok "a marker-less completed stage halted the run (fail-closed)" \
  || bad "nomarker: tada=[$(board jobs/tada)] gauntlet=[$(board jobs/gauntlet)]"
printf '%s' "$(tada_body g7)" | grep -qi 'NO parseable' \
  && ok "the halt names the missing marker" \
  || bad "nomarker: halt summary does not explain the missing marker"

# ============================================================================
hr; echo "SUBTEST 8 — IDEMPOTENT: a re-tick while a stage is in flight promotes nothing new"; hr
post_gauntlet g8 https://github.com/testowner/testrepo/pull/8

tick   # post g8-clean
in_dir jobs/todo g8-clean || bad "idempotent: g8-clean not posted"
before="$(board jobs/todo)"
tick   # g8-clean still active (never completed) → no advance
after="$(board jobs/todo)"
{ [ "$before" = "$after" ] && ! in_dir jobs/todo g8-panel-1 && [ "$(record_field g8 current_child)" = g8-clean ]; } \
  && ok "re-tick while g8-clean is in flight promoted nothing new (idempotent wait)" \
  || bad "idempotent: before=[$before] after=[$after]"

# ============================================================================
hr; echo "SUBTEST 9 — RESUMEBOUND: endless still-pending halts at max_resumes"; hr
# A repo whose PRs attach no checks at all reports still-pending EVERY round, so the
# re-post is bounded; with --max-resumes 2 the third still-pending must halt.
post_gauntlet --max-resumes 2 g9 https://github.com/testowner/testrepo/pull/9

tick   # post g9-clean
in_dir jobs/todo g9-clean || bad "resumebound: g9-clean not posted"
complete_stage g9-clean clean=still-pending
tick   # resume 1/2
{ in_dir jobs/todo g9-clean && [ "$(record_field g9 resumes)" = 1 ]; } \
  && ok "first still-pending re-posted g9-clean (resumes=1)" \
  || bad "resumebound: todo=[$(board jobs/todo)] resumes=$(record_field g9 resumes)"
complete_stage g9-clean clean=still-pending
tick   # resume 2/2
{ in_dir jobs/todo g9-clean && [ "$(record_field g9 resumes)" = 2 ]; } \
  && ok "second still-pending re-posted g9-clean (resumes=2)" \
  || bad "resumebound: todo=[$(board jobs/todo)] resumes=$(record_field g9 resumes)"
complete_stage g9-clean clean=still-pending
tick   # bound spent → HALT rather than re-post a third time
{ in_dir jobs/tada g9 && ! in_dir jobs/gauntlet g9 && ! in_dir jobs/todo g9-clean; } \
  && ok "the third still-pending halted the run instead of re-posting forever" \
  || bad "resumebound: tada=[$(board jobs/tada)] gauntlet=[$(board jobs/gauntlet)] todo=[$(board jobs/todo)]"
printf '%s' "$(tada_body g9)" | grep -qi 'max_resumes=2' \
  && ok "the halt names the spent re-post bound" \
  || bad "resumebound: halt summary does not name max_resumes"
printf '%s' "$(tada_body g9)" | grep -qi 'GARDEN_CI_ALLOW_NO_CHECKS' \
  && ok "the halt names the checkless-repo opt-out" \
  || bad "resumebound: halt summary does not name the checkless-repo opt-out"

# A stage that advances RESETS the count: the bound is per stage, not per gauntlet.
post_gauntlet --max-resumes 2 g10 https://github.com/testowner/testrepo/pull/10
tick
complete_stage g10-clean clean=still-pending; tick     # resumes=1
complete_stage g10-clean clean=done;          tick     # advance to panel-1
[ "$(record_field g10 resumes)" = 0 ] \
  && ok "advancing to a new stage reset the re-post count (per-stage bound)" \
  || bad "resumebound: resumes=$(record_field g10 resumes) after advancing to panel-1"

# ============================================================================
hr; echo "SUBTEST 10 — SHARDED TADA: a sharded stage completion advances the gauntlet"; hr
post_gauntlet g11 https://github.com/testowner/testrepo/pull/11
tick
complete_stage_sharded g11-clean clean=done
tick
in_dir jobs/todo g11-panel-1 \
  && ok "a stage completed into a date shard read as done and advanced to panel" \
  || bad "sharded stage completion did not advance (todo=[$(board jobs/todo)])"

# ============================================================================
hr; echo "SUBTEST 11 — PANELERROR RECOVERY: a panel-error retries the round, then a real verdict proceeds"; hr
# A seat/decider error or an interruption makes panel.sh exit non-zero; the panel
# stage reports panel=panel-error (a SENSOR failure, NOT a review verdict). The
# driver must re-post the SAME panel round under the stage-retry budget — a
# transient blip must not halt the whole gauntlet (cybernetics-audit.md § 7 rec 6).
post_gauntlet g12 https://github.com/testowner/testrepo/pull/12
tick; complete_stage g12-clean clean=done
tick   # → panel-1
in_dir jobs/todo g12-panel-1 || bad "panelerror: g12-panel-1 not posted"
complete_stage g12-panel-1 panel=panel-error
tick   # panel-error → re-post the SAME panel round under the stage budget
{ in_dir jobs/todo g12-panel-1 && ! in_dir jobs/tada g12-panel-1 \
    && [ "$(record_field g12 stage)" = panel ] && [ "$(record_field g12 iteration)" = 1 ] \
    && [ "$(record_field g12 stage_retries)" = 1 ]; } \
  && ok "panel-error re-posted g12-panel-1 under the stage budget (stage_retries=1), did NOT halt" \
  || bad "panelerror: todo=[$(board jobs/todo)] tada=[$(board jobs/tada)] stage=$(record_field g12 stage) retries=$(record_field g12 stage_retries)"
{ in_dir jobs/gauntlet g12 && [ "$(record_field g12 state)" != halted ]; } \
  && ok "the gauntlet record survived the panel-error (not halted)" \
  || bad "panelerror: record halted or removed on a transient sensor error"
# the retry now returns a real verdict → the gauntlet proceeds normally
complete_stage g12-panel-1 panel=pass
tick   # panel pass → undraft
in_dir jobs/todo g12-undraft \
  && ok "after the retry a real panel=pass advanced to undraft (recovered)" \
  || bad "panelerror: g12-undraft not posted after recovery (todo=[$(board jobs/todo)])"
complete_stage g12-undraft undraft=done; tick
in_dir jobs/tada g12 || bad "panelerror: g12 did not complete after recovery"

# ============================================================================
hr; echo "SUBTEST 12 — PANELERROR EXHAUSTION: repeated panel-error halts at max_stage_retries"; hr
post_gauntlet --max-stage-retries 2 g13 https://github.com/testowner/testrepo/pull/13
tick; complete_stage g13-clean clean=done
tick   # → panel-1
in_dir jobs/todo g13-panel-1 || bad "panelerror-exhaust: g13-panel-1 not posted"
complete_stage g13-panel-1 panel=panel-error
tick   # retry 1/2
{ [ "$(record_field g13 stage_retries)" = 1 ] && in_dir jobs/todo g13-panel-1; } \
  && ok "panel-error #1 → retry 1/2 (stage_retries=1)" \
  || bad "panelerror-exhaust: retries=$(record_field g13 stage_retries) todo=[$(board jobs/todo)]"
complete_stage g13-panel-1 panel=panel-error
tick   # retry 2/2
{ [ "$(record_field g13 stage_retries)" = 2 ] && in_dir jobs/todo g13-panel-1; } \
  && ok "panel-error #2 → retry 2/2 (stage_retries=2)" \
  || bad "panelerror-exhaust: retries=$(record_field g13 stage_retries) todo=[$(board jobs/todo)]"
complete_stage g13-panel-1 panel=panel-error
tick   # budget spent → HALT
{ in_dir jobs/tada g13 && ! in_dir jobs/gauntlet g13 && ! in_dir jobs/todo g13-panel-1; } \
  && ok "a third panel-error exhausted max_stage_retries=2 → halt (not an infinite retry)" \
  || bad "panelerror-exhaust: tada=[$(board jobs/tada)] gauntlet=[$(board jobs/gauntlet)] todo=[$(board jobs/todo)]"
g13_halt="$(tada_body g13)"
{ printf '%s' "$g13_halt" | grep -qi 'gauntlet-status: halted' \
    && printf '%s' "$g13_halt" | grep -qi 'stage retry budget is exhausted' \
    && printf '%s' "$g13_halt" | grep -qi 'panel-error'; } \
  && ok "the exhaustion halt names the spent stage budget and the panel-error sensor failure" \
  || bad "panelerror-exhaust: halt summary does not name the budget/sensor failure: [$g13_halt]"

# ============================================================================
hr; echo "SUBTEST 13 — COMMENT FAILURE: a gh write failure never blocks terminal finish"; hr
post_gauntlet --max-stage-retries 0 g14 https://github.com/testowner/testrepo/pull/14
tick   # post g14-clean
fail_stage g14-clean
touch "$GAUNTLET_GH_FAIL_WRITES_FILE"
tick   # halt; comment write fails, journal finish must still land
rm -f "$GAUNTLET_GH_FAIL_WRITES_FILE"
{ in_dir jobs/tada g14 && ! in_dir jobs/gauntlet g14; } \
  && ok "failed terminal PR comment did not block halt finish" \
  || bad "comment-failure: gauntlet did not finish after gh write failure"
[ "$(terminal_comment_count g14 halted)" = 0 ] \
  && ok "failed gh write left no false terminal-comment receipt" \
  || bad "comment-failure: stub unexpectedly recorded a comment"
grep -q "WARN: gauntlet 'g14': terminal PR status comment failed" "$TR/tick.log" \
  && ok "failed terminal PR comment surfaced a WARN" \
  || bad "comment-failure: missing WARN in tick log"
in_dir jobs/gauntlet-terminal-pending g14--halted \
  && ok "failed terminal PR comment persisted a pending receipt with the finish" \
  || bad "comment-failure: no pending receipt: [$(board jobs/gauntlet-terminal-pending)]"
tick   # retry the owed receipt now that writes succeed
{ [ "$(terminal_comment_count g14 halted)" = 1 ] \
    && ! in_dir jobs/gauntlet-terminal-pending g14--halted; } \
  && ok "a later tick delivered the owed receipt and cleared the pending record" \
  || bad "comment-failure: retry count=$(terminal_comment_count g14 halted) pending=[$(board jobs/gauntlet-terminal-pending)]"
tick
[ "$(terminal_comment_count g14 halted)" = 1 ] \
  && ok "a delivered receipt is not re-posted" \
  || bad "comment-failure: receipt duplicated after delivery"

# ============================================================================
hr; echo "SUBTEST 14 — READ FAILURE: a quota-cooled comment read defers, then retries once"; hr
post_gauntlet --max-stage-retries 0 g15 https://github.com/testowner/testrepo/pull/15
tick   # post g15-clean
fail_stage g15-clean
touch "$GAUNTLET_GH_FAIL_READS_FILE"
tick   # halt; the comment read fails → no post, pending receipt lands with the finish
{ in_dir jobs/tada g15 && ! in_dir jobs/gauntlet g15 \
    && in_dir jobs/gauntlet-terminal-pending g15--halted \
    && [ "$(terminal_comment_count g15 halted)" = 0 ]; } \
  && ok "unreadable comments deferred the receipt into a pending record committed with the finish" \
  || bad "read-failure: tada=[$(board jobs/tada)] pending=[$(board jobs/gauntlet-terminal-pending)] count=$(terminal_comment_count g15 halted)"
rm -rf "$V"; git clone -q --single-branch --branch "$BRANCH" "$BARE" "$V"
g15_pending="$(cat "$V/jobs/gauntlet-terminal-pending/g15--halted.md" 2>/dev/null || true)"
{ printf '%s' "$g15_pending" | grep -qx 'repo: testowner/testrepo' \
    && printf '%s' "$g15_pending" | grep -qx 'pr_number: 15'; } \
  && ok "pending receipt carries the PR identity the retired record held" \
  || bad "read-failure: pending receipt lacks PR identity: [$g15_pending]"
tick   # reads still failing → still owed
{ in_dir jobs/gauntlet-terminal-pending g15--halted \
    && [ "$(terminal_comment_count g15 halted)" = 0 ]; } \
  && ok "a retry while reads still fail keeps the receipt pending without posting" \
  || bad "read-failure: retry under failing reads misbehaved"
rm -f "$GAUNTLET_GH_FAIL_READS_FILE"
tick   # cooldown over → posted once and cleared
{ [ "$(terminal_comment_count g15 halted)" = 1 ] \
    && ! in_dir jobs/gauntlet-terminal-pending g15--halted; } \
  && ok "after the read recovers the receipt is posted once and its pending record cleared" \
  || bad "read-failure: count=$(terminal_comment_count g15 halted) pending=[$(board jobs/gauntlet-terminal-pending)]"
g15_comment="$(terminal_comment_body g15 halted)"
printf '%s' "$g15_comment" | grep -Fq 'halt reason:' \
  && ok "the retried receipt keeps the persisted halt reason" \
  || bad "read-failure: retried receipt lost its reason: [$g15_comment]"
# A pending receipt whose comment already landed (lost clear CAS) must not re-post.
wt="$(mktemp -d "$TR/edit.XXXXXX")"
git clone -q --single-branch --branch "$BRANCH" "$BARE" "$wt"
mkdir -p "$wt/jobs/gauntlet-terminal-pending"
printf '%s\n' "$g15_pending" > "$wt/jobs/gauntlet-terminal-pending/g15--halted.md"
git -C "$wt" add jobs/gauntlet-terminal-pending
git -C "$wt" "${git_id[@]}" commit -q -m "fixture: re-owe g15 receipt after lost clear CAS"
git -C "$wt" push -q origin "HEAD:$BRANCH"; rm -rf "$wt"
tick
{ [ "$(terminal_comment_count g15 halted)" = 1 ] \
    && ! in_dir jobs/gauntlet-terminal-pending g15--halted; } \
  && ok "marker dedup clears a re-owed receipt without a second post" \
  || bad "read-failure: dedup count=$(terminal_comment_count g15 halted) pending=[$(board jobs/gauntlet-terminal-pending)]"

# ============================================================================
hr; echo "SUBTEST 15 — COOLDOWN: terminal receipts under a live gh-api cooldown defer quietly"; hr
post_gauntlet --max-stage-retries 0 g16 https://github.com/testowner/testrepo/pull/16
post_gauntlet --max-stage-retries 0 g17 https://github.com/testowner/testrepo/pull/17
tick   # post g16-clean + g17-clean
fail_stage g16-clean
fail_stage g17-clean
# Arm the host-wide (REST) latch as its owner would: expiry on line 1, tag on line 2.
printf '%s\nprimary-quota test\n' "$(( $(date +%s) + 600 ))" > "$GARDEN_API_COOLDOWN_DIR/marker"
: > "$GAUNTLET_GH_READS_LOG"
tick   # both halt under the cooldown
{ in_dir jobs/tada g16 && in_dir jobs/tada g17 \
    && in_dir jobs/gauntlet-terminal-pending g16--halted \
    && in_dir jobs/gauntlet-terminal-pending g17--halted \
    && [ "$(terminal_comment_count g16 halted)" = 0 ] \
    && [ "$(terminal_comment_count g17 halted)" = 0 ]; } \
  && ok "both terminal receipts under cooldown persisted pending records with their finishes" \
  || bad "cooldown: tada=[$(board jobs/tada)] pending=[$(board jobs/gauntlet-terminal-pending)]"
! grep -q "WARN: gauntlet 'g1[67]'" "$TR/tick.log" \
  && ok "no per-gauntlet WARN for receipts deferred by the cooldown" \
  || bad "cooldown: per-gauntlet warning spam: [$(grep WARN "$TR/tick.log")]"
[ ! -s "$GAUNTLET_GH_READS_LOG" ] \
  && ok "no comment read was attempted while the cooldown was live" \
  || bad "cooldown: gh comment reads issued under cooldown: [$(cat "$GAUNTLET_GH_READS_LOG")]"
rm -f "$GARDEN_API_COOLDOWN_DIR/marker"
tick   # cooldown over → both delivered once and cleared
{ [ "$(terminal_comment_count g16 halted)" = 1 ] && [ "$(terminal_comment_count g17 halted)" = 1 ] \
    && ! in_dir jobs/gauntlet-terminal-pending g16--halted \
    && ! in_dir jobs/gauntlet-terminal-pending g17--halted; } \
  && ok "after the cooldown lapses both owed receipts post once and clear" \
  || bad "cooldown: counts=$(terminal_comment_count g16 halted)/$(terminal_comment_count g17 halted) pending=[$(board jobs/gauntlet-terminal-pending)]"

# ============================================================================
hr
echo "RESULTS: $PASS passed, $FAIL failed"
hr
[ "$FAIL" -eq 0 ]
