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
#   3. NONCONVERGE— the fix-loop that never passes HALTS at max_iterations (surfaces).
#   4. STAGEFAIL  — a stage that VANISHES without a tada report HALTS the run (surfaces).
#   5. PROBE      — a kind:probe gauntlet passes the panel but NEVER un-drafts (done draft).
#   6. STILLPEND  — a clean stage reporting `still-pending` re-posts the SAME stage.
#   7. NOMARKER   — a `done` stage with NO parseable marker HALTS (fail-closed).
#   8. IDEMPOTENT — a re-tick while a stage is in flight promotes nothing new.
#   9. RESUMEBOUND— endless `still-pending` HALTS at max_resumes (a checkless repo).
#
# Usage: gauntlet-test.sh

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
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

# --- seed the shared origin -------------------------------------------------
git init -q --bare "$BARE"
SEED="$TR/seed"; git init -q "$SEED"
git -C "$SEED" checkout -q -b "$BRANCH"
( cd "$SEED"
  mkdir -p jobs/todo jobs/doin jobs/tada jobs/plan jobs/gauntlet jobs/index work \
           inbox/maintainer/unread inbox/maintainer/read
  for d in jobs/todo jobs/doin jobs/tada jobs/plan jobs/gauntlet jobs/index work \
           inbox/maintainer/unread inbox/maintainer/read; do touch "$d/.gitkeep"; done )
git -C "$SEED" add -A
git -C "$SEED" "${git_id[@]}" commit -q -m "seed: board + gauntlet structure"
git -C "$SEED" remote add origin "$BARE"
git -C "$SEED" push -q -u origin "$BRANCH"

export JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH="$BRANCH"
export GARDEN=testhost GARDEN_STATE="$TR/state"
export GARDEN_POST_ATTEMPTS=50
# Keep the CI-blocking-stage budget line deterministic (not required by the test, but
# stamped into the stage bodies the driver posts).
export GARDEN_SHEPHERD_HANDLER_TIMEOUT=7200
# The panel stage carries its OWN CI-sized budget (above the plain 2400s default), so a
# long single round is budgeted rather than doomed after one deterministic wall hit.
export GARDEN_GAUNTLET_PANEL_HANDLER_TIMEOUT=7200

# --- board inspection helpers (fresh clone each call) -----------------------
V="$TR/verify"
board() {  # board <subdir> → basenames present (no .gitkeep, no .md suffix)
  rm -rf "$V"; git clone -q --single-branch --branch "$BRANCH" "$BARE" "$V"
  # shellcheck disable=SC2010  # test-only convenience over a controlled dir
  ls -1 "$V/$1" 2>/dev/null | grep -v -x '.gitkeep' | sed 's/\.md$//' | sort | tr '\n' ' '
}
in_dir() { board "$1" | tr ' ' '\n' | grep -qx "$2"; }   # in_dir <subdir> <base>
record_field() {  # record_field <g> <key>
  rm -rf "$V"; git clone -q --single-branch --branch "$BRANCH" "$BARE" "$V"
  sed -n "s/^$2:[[:space:]]*//p" "$V/jobs/gauntlet/$1.md" 2>/dev/null | head -1
}
tada_body() { rm -rf "$V"; git clone -q --single-branch --branch "$BRANCH" "$BARE" "$V"; cat "$V/jobs/tada/$1.md" 2>/dev/null; }
todo_body() { rm -rf "$V"; git clone -q --single-branch --branch "$BRANCH" "$BARE" "$V"; cat "$V/jobs/todo/$1.md" 2>/dev/null; }
# handler_timeout <todo-base> → the handler-timeout header value, or empty if none.
handler_timeout() { todo_body "$1" | sed -n 's/^handler-timeout:[[:space:]]*//p' | head -1; }

# Simulate a gardener COMPLETING a stage with a stage-result MARKER: remove it from
# todo/doin and write a tada report ending in the deterministic marker line.
complete_stage() {  # complete_stage <base> <marker-body>  (e.g. "clean=done")
  local wt; wt="$(mktemp -d "$TR/edit.XXXXXX")"
  git clone -q --single-branch --branch "$BRANCH" "$BARE" "$wt"
  git -C "$wt" rm -q "jobs/todo/$1.md" 2>/dev/null || true
  git -C "$wt" rm -q "jobs/doin/$1.md" 2>/dev/null || true
  { printf '# %s complete\n\nstage work done.\n\n' "$1"
    printf '<!-- gauntlet-stage-result: %s -->\n' "$2"; } > "$wt/jobs/tada/$1.md"
  git -C "$wt" add "jobs/tada/$1.md"
  git -C "$wt" "${git_id[@]}" commit -q -m "tada($1) $2"
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

tick() { "$JOBS/gauntlet.sh" >"$TR/tick.log" 2>&1 || { echo "  (gauntlet.sh rc=$? — see below)"; cat "$TR/tick.log"; }; }

post_gauntlet() {  # post_gauntlet <g> <pr-url> [extra-args...]
  "$JOBS/post-gauntlet.sh" "$@" >/dev/null
}

# ============================================================================
hr; echo "SUBTEST 1 — HAPPY: clean → panel-1 (pass) → undraft → done"; hr
post_gauntlet --build-job build-1 g1 https://github.com/testowner/testrepo/pull/1

tick   # fresh record → post clean
{ in_dir jobs/todo g1-clean && [ "$(record_field g1 current_child)" = g1-clean ] && [ "$(record_field g1 stage)" = clean ]; } \
  && ok "tick 1: posted g1-clean, record at stage=clean" \
  || bad "tick 1: todo=[$(board jobs/todo)] stage=$(record_field g1 stage) child=$(record_field g1 current_child)"
[ "$(handler_timeout g1-clean)" = 7200 ] \
  && ok "clean stage carries the CI-sized handler-timeout (7200)" \
  || bad "clean handler-timeout=[$(handler_timeout g1-clean)] (expected 7200)"

complete_stage g1-clean clean=done
tick   # clean done → post panel-1
{ in_dir jobs/todo g1-panel-1 && [ "$(record_field g1 stage)" = panel ] && [ "$(record_field g1 iteration)" = 1 ]; } \
  && ok "tick 2: clean=done → posted g1-panel-1 (iteration 1)" \
  || bad "tick 2: todo=[$(board jobs/todo)] stage=$(record_field g1 stage) iter=$(record_field g1 iteration)"
[ "$(handler_timeout g1-panel-1)" = 7200 ] \
  && ok "panel stage carries its dedicated CI-sized handler-timeout (7200, above the 2400 default)" \
  || bad "panel handler-timeout=[$(handler_timeout g1-panel-1)] (expected 7200)"

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
hr; echo "SUBTEST 3 — NONCONVERGE: the fix-loop halts at max_iterations"; hr
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
tick   # fix-2 done → panel-3 would exceed max_iterations=2 → HALT
{ ! in_dir jobs/todo g3-panel-3 && in_dir jobs/tada g3 && ! in_dir jobs/gauntlet g3; } \
  && ok "did NOT post panel-3 (> max_iterations); halted and closed the record" \
  || bad "nonconverge: todo=[$(board jobs/todo)] tada=[$(board jobs/tada)] gauntlet=[$(board jobs/gauntlet)]"
printf '%s' "$(tada_body g3)" | grep -qi 'gauntlet-status: halted' \
  && ok "non-convergence halt marks gauntlet-status: halted" \
  || bad "nonconverge: halt summary missing status marker"
board inbox/maintainer/unread >/dev/null
grep -rqi 'did not converge' "$V/inbox/maintainer/unread" 2>/dev/null \
  && ok "non-convergence surfaced to the maintainer inbox" \
  || bad "nonconverge: no maintainer note (inbox: $(ls "$V/inbox/maintainer/unread" 2>/dev/null))"

# ============================================================================
hr; echo "SUBTEST 4 — STAGEFAIL: a vanished stage halts the run + surfaces"; hr
post_gauntlet g4 https://github.com/testowner/testrepo/pull/4

tick   # post g4-clean
in_dir jobs/todo g4-clean || bad "stagefail: g4-clean not posted"
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
hr
echo "RESULTS: $PASS passed, $FAIL failed"
hr
[ "$FAIL" -eq 0 ]
