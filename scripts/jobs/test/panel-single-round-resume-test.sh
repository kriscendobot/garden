#!/bin/bash
# panel-single-round-resume-test.sh — regression guard for panel.sh's SINGLE-ROUND
# RESUME short-circuit (GARDEN_PANEL_RESUME, default on): reuse a durable
# panel-run record for the CURRENT head instead of re-fanning the 29-seat panel.
#
# THE PROBLEM (endojs/endo-but-for-bots#1113 panel round 2): a staged gauntlet's
# panel stage is agent-supervised — run the ~45-minute 29-seat fan-out, then post
# the aggregate as a `gh pr review`. When the gardener dies AFTER the seats
# aggregated and emit_panel_record pushed the durable
# `panel-runs/<slug>/<run-id>.md` record but BEFORE the review posted (a mid-post
# GitHub rate-limit, an exit-0-unsatisfying cut, a reap), the stage requeues and a
# fresh claim re-runs the ENTIRE panel from scratch — non-convergent, ~45 min of
# `claude -p` burned per cycle, up to the reaper's doom threshold.
#
# THE PRIMITIVE: in single-round mode, BEFORE the fan-out, panel.sh looks for a
# durable record whose LAST round head equals the current worktree HEAD. On an
# EXACT match with a parseable disposition it reconstructs a review-ready aggregate
# into the rundir from the record's recorded disposition + must-fix titles, prints
# the single-round terminal contract, and exits 0 WITHOUT dispatching any seats.
# It fails OPEN (missing store / stale clone / moved head / bad record → normal
# panel), so it can never emit a wrong verdict — only skip a recompute.
#
# SUBTEST 1 — resume fires on a head match: exit 0, terminal token `must-fix`, NO
#             per-seat block written (seats did not run), and the reconstructed
#             round-1.md carries the record's must-fix items for the gardener to post.
# SUBTEST 2 — GARDEN_PANEL_RESUME=0 disables it: the seats run (round-1.<seat>.md
#             exists), proving the short-circuit is opt-outable and inert when off.
# SUBTEST 3 — head MISMATCH does not resume: a record for a different head is
#             ignored and the seats run (no wrong verdict from a stale record).
# SUBTEST 4 — classic mode (flag unset) never resumes even with a matching record.
#
# Hermetic: seats/decider are env-stubbed; the "durable store" is a scratch dir.
# A real git worktree gives panel.sh a HEAD to match against.
#
# Usage: panel-single-round-resume-test.sh

# shellcheck disable=SC2015
set -uo pipefail
export GARDEN_TEST=1
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PANEL="$(cd "$HERE/../gardening" && pwd)/panel.sh"
TR="$(mktemp -d "${TMPDIR:-/tmp}/panel-resume.XXXXXX")"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
hr()  { echo "----------------------------------------------------------------"; }
trap 'rm -rf "$TR"' EXIT

STUB_SEAT="$HERE/panel-parallel-fanout-stub.sh"   # writes a per-seat block if called
STUB_DECIDE="$HERE/panel-decide-stub.sh"          # prints $DECIDE_VERDICT (default pass)
SEATS="assessor typist"

# A real git worktree so panel.sh's `git rev-parse HEAD` yields a head to match.
WT="$TR/wt"; mkdir -p "$WT"
git -C "$WT" init -q
git -C "$WT" config user.email t@t; git -C "$WT" config user.name t
echo base > "$WT/f"; git -C "$WT" add f; git -C "$WT" commit -qm base
echo head > "$WT/f"; git -C "$WT" commit -qaqm head 2>/dev/null || git -C "$WT" commit -qm head
HEAD_FULL="$(git -C "$WT" rev-parse HEAD)"; HSHA="${HEAD_FULL:0:8}"

# Plant a durable panel-run record whose round head == the worktree HEAD.
REPO="endojs/endo-but-for-bots"; PR=1113
SLUG="$(printf '%s' "$REPO-$PR" | tr -c 'A-Za-z0-9._-' '-')"
STORE="$TR/store"; mkdir -p "$STORE/$SLUG"
cat > "$STORE/$SLUG/deadbeef1234.md" <<EOF
---
kind: panel-run
repo: $REPO
pr: $PR
panel_kind: code
base_ref: origin/llm
rounds: 1
disposition: must-fix
must_fix_total: 2
run_id: deadbeef1234
---

# Panel run — $REPO #$PR (code)

## Round 1 — head \`$HSHA\`

seat verdicts (2): assessor=must-fix typist=must-fix
must-fix items (2):
- assessor: the ratchet floor was not measured at HEAD
- typist: prefer a spelled-out identifier over the abbreviation
EOF

# run_panel <resume-flag-value|unset> <single?0|1> <rundir> [head-override]
run_panel() {
  local resume="$1" single="$2" rundir="$3" repo_over="${4:-$REPO}"
  local extra=()
  [ "$resume" != "unset" ] && extra=(GARDEN_PANEL_RESUME="$resume")
  env "${extra[@]}" \
    FAN_DIR="$rundir/fan" FAN_SLEEP=0 \
    DECIDE_VERDICT=pass \
    GARDEN_PANEL_SINGLE_ROUND="$single" \
    GARDEN_CODE_SEATS="$SEATS" \
    GARDEN_PANEL_CONCURRENCY=2 \
    GARDEN_PANEL_SEAT="$STUB_SEAT" \
    GARDEN_PANEL_DECIDE="$STUB_DECIDE" \
    GARDEN_PANEL_APPELLATE=":" \
    GARDEN_PANEL_SEAT_ATTEMPTS=1 \
    GARDEN_PANEL_SEAT_BACKOFF=0 \
    GARDEN_PANEL_RECORD=":" \
    GARDEN_PANEL_RECORD_STORE="$STORE" \
    GARDEN_PANEL_REPO="$repo_over" \
    GARDEN_PANEL_RUNDIR="$rundir" \
      bash "$PANEL" "$WT" "$PR" HEAD~1
}
last_token() { printf '%s\n' "$1" | awk 'NF{l=$0} END{print l}' | awk '{print $NF}'; }

hr; echo "SUBTEST 1 — resume fires on a head match: no seats run, items reconstructed"; hr
out1="$(run_panel unset 1 "$TR/rd1" 2>&1)"; rc1=$?
[ "$rc1" -eq 0 ] && ok "resume exits 0" || bad "resume exited $rc1: $out1"
[ "$(last_token "$out1")" = must-fix ] \
  && ok "terminal token is the recorded disposition 'must-fix'" \
  || bad "terminal token was '$(last_token "$out1")' (want must-fix); out: $out1"
{ [ ! -f "$TR/rd1/round-1.assessor.md" ] && [ ! -f "$TR/rd1/round-1.typist.md" ]; } \
  && ok "no per-seat block written — the seats did NOT run" \
  || bad "a per-seat block exists; the panel re-fanned instead of resuming"
{ [ -f "$TR/rd1/round-1.md" ] && grep -q 'ratchet floor was not measured' "$TR/rd1/round-1.md"; } \
  && ok "reconstructed round-1.md carries the record's must-fix items" \
  || bad "round-1.md missing the recovered must-fix items: $(cat "$TR/rd1/round-1.md" 2>/dev/null)"
printf '%s' "$out1" | grep -q 'RESUMED from durable record deadbeef1234' \
  && ok "announces the resume + names the source record on stderr" \
  || bad "no resume provenance announced: $out1"

hr; echo "SUBTEST 2 — GARDEN_PANEL_RESUME=0 disables resume: the seats run"; hr
out2="$(run_panel 0 1 "$TR/rd2" 2>&1)"; rc2=$?
[ "$rc2" -eq 0 ] && ok "disabled-resume run exits 0" || bad "exited $rc2: $out2"
[ -f "$TR/rd2/round-1.assessor.md" ] \
  && ok "seats ran (per-seat block present) — resume was opt-outable" \
  || bad "no per-seat block; resume fired despite GARDEN_PANEL_RESUME=0"

hr; echo "SUBTEST 3 — head MISMATCH: a record for another head is ignored, seats run"; hr
# Point at a slug/repo with NO matching-head record (the store has only endojs one).
out3="$(run_panel unset 1 "$TR/rd3" other/repo 2>&1)"; rc3=$?
[ "$rc3" -eq 0 ] && ok "mismatch run exits 0" || bad "exited $rc3: $out3"
[ -f "$TR/rd3/round-1.assessor.md" ] \
  && ok "seats ran — a non-matching store did not resume (fail-open)" \
  || bad "resumed off a non-matching record: $out3"

hr; echo "SUBTEST 4 — classic mode (flag unset) never resumes"; hr
out4="$(run_panel unset 0 "$TR/rd4" 2>&1)"; rc4=$?
[ "$rc4" -eq 0 ] && ok "classic run exits 0" || bad "exited $rc4: $out4"
[ -f "$TR/rd4/round-1.assessor.md" ] \
  && ok "seats ran in classic mode — resume is single-round-only" \
  || bad "classic mode resumed off the record (should be single-round-only): $out4"

hr
echo "RESULT: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
