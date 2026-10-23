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
# durable record whose head, provider, base ref, and PR-body hash equal the current values.
# On an EXACT match with a pass disposition it reconstructs a review-ready receipt,
# prints the single-round terminal contract, and exits 0 WITHOUT dispatching seats.
# A must-fix record never resumes: its titles are compact, truncated audit data,
# so the seats re-run and the fixer receives their complete findings.
#
# SUBTEST 1 — resume fires for an exact-key PASS: no seats run.
# SUBTEST 2 — an exact-key MUST-FIX record does not resume; seats re-run rather
#             than replaying truncated titles to the fixer.
# SUBTEST 3 — GARDEN_PANEL_RESUME=0 disables it: the seats run (round-1.<seat>.md
#             exists), proving the short-circuit is opt-outable and inert when off.
# SUBTEST 4 — body MISMATCH does not resume even though HEAD is unchanged.
# SUBTEST 5 — base MISMATCH does not resume even though HEAD/body are unchanged.
# SUBTEST 6 — head MISMATCH does not resume.
# SUBTEST 7 — provider MISMATCH does not replay a different model-family verdict.
# SUBTEST 8 — classic mode (flag unset) never resumes even with a matching record.
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
BODY="$TR/pr-body.md"
printf '%s\n' 'Original PR description.' > "$BODY"
BODY_HASH="$(sha256sum "$BODY" | awk '{print $1}')"

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
provider: anthropic
base_ref: HEAD~1
pr_body_hash: $BODY_HASH
rounds: 1
disposition: pass
reviewed_head: $HEAD_FULL
must_fix_total: 0
run_id: deadbeef1234
---

# Panel run — $REPO #$PR (code)

## Round 1 — head \`$HSHA\`

seat verdicts (2): assessor=pass typist=pass
must-fix items (0):
EOF

# run_panel <resume-flag-value|unset> <single?0|1> <rundir> [head-override]
run_panel() {
  local resume="$1" single="$2" rundir="$3" repo_over="${4:-$REPO}" provider="${5:-anthropic}"
  local extra=()
  [ "$resume" != "unset" ] && extra=(GARDEN_PANEL_RESUME="$resume")
  env "${extra[@]}" \
    FAN_DIR="$rundir/fan" FAN_SLEEP=0 \
    DECIDE_VERDICT=pass \
    GARDEN_PANEL_SINGLE_ROUND="$single" \
    GARDEN_PANEL_PROVIDER="$provider" \
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
    GARDEN_PANEL_PR_BODY_FILE="$BODY" \
    GARDEN_PANEL_RUNDIR="$rundir" \
      bash "$PANEL" "$WT" "$PR" HEAD~1
}
last_token() { printf '%s\n' "$1" | awk 'NF{l=$0} END{print l}' | awk '{print $NF}'; }

hr; echo "SUBTEST 1 — resume fires for an exact-key pass: no seats run"; hr
out1="$(run_panel unset 1 "$TR/rd1" 2>&1)"; rc1=$?
[ "$rc1" -eq 0 ] && ok "resume exits 0" || bad "resume exited $rc1: $out1"
[ "$(last_token "$out1")" = pass ] \
  && ok "terminal token is the recorded disposition 'pass'" \
  || bad "terminal token was '$(last_token "$out1")' (want pass); out: $out1"
{ [ ! -f "$TR/rd1/round-1.assessor.md" ] && [ ! -f "$TR/rd1/round-1.typist.md" ]; } \
  && ok "no per-seat block written — the seats did NOT run" \
  || bad "a per-seat block exists; the panel re-fanned instead of resuming"
{ [ -f "$TR/rd1/round-1.md" ] && grep -q 'recorded disposition was pass' "$TR/rd1/round-1.md"; } \
  && ok "reconstructed round-1.md records that no fixer evidence was needed" \
  || bad "round-1.md missing the pass receipt: $(cat "$TR/rd1/round-1.md" 2>/dev/null)"
printf '%s' "$out1" | grep -q 'RESUMED from durable record deadbeef1234' \
  && ok "announces the resume + names the source record on stderr" \
  || bad "no resume provenance announced: $out1"

sed -i 's/^disposition: pass$/disposition: must-fix/' "$STORE/$SLUG/deadbeef1234.md"

hr; echo "SUBTEST 2 — must-fix record is lossy audit data: seats re-run"; hr
out2="$(run_panel unset 1 "$TR/rd2" 2>&1)"; rc2=$?
[ "$rc2" -eq 0 ] && ok "must-fix-record run exits 0" || bad "exited $rc2: $out2"
[ -f "$TR/rd2/round-1.assessor.md" ] \
  && ok "seats ran — truncated must-fix titles were not replayed" \
  || bad "no per-seat block; a lossy must-fix record was resumed"

sed -i 's/^disposition: must-fix$/disposition: pass/' "$STORE/$SLUG/deadbeef1234.md"

hr; echo "SUBTEST 3 — GARDEN_PANEL_RESUME=0 disables resume: the seats run"; hr
out3="$(run_panel 0 1 "$TR/rd3" 2>&1)"; rc3=$?
[ "$rc3" -eq 0 ] && ok "disabled-resume run exits 0" || bad "exited $rc3: $out3"
[ -f "$TR/rd3/round-1.assessor.md" ] \
  && ok "seats ran (per-seat block present) — resume was opt-outable" \
  || bad "no per-seat block; resume fired despite GARDEN_PANEL_RESUME=0"

hr; echo "SUBTEST 4 — body MISMATCH: unchanged HEAD does not replay a stale body verdict"; hr
printf '%s\n' 'Trimmed PR description.' > "$BODY"
out4="$(run_panel unset 1 "$TR/rd4" 2>&1)"; rc4=$?
[ "$rc4" -eq 0 ] && ok "body-mismatch run exits 0" || bad "exited $rc4: $out4"
[ -f "$TR/rd4/round-1.assessor.md" ] \
  && ok "seats ran — a body-only edit invalidated resume" \
  || bad "resumed despite a changed PR body and unchanged HEAD: $out4"
printf '%s\n' 'Original PR description.' > "$BODY"

hr; echo "SUBTEST 5 — base MISMATCH: unchanged HEAD/body does not resume"; hr
BASE_COMMIT="$(git -C "$WT" rev-parse HEAD~1)"
out5="$(env GARDEN_PANEL_RESUME=1 GARDEN_PANEL_SINGLE_ROUND=1 \
  GARDEN_CODE_SEATS="$SEATS" GARDEN_PANEL_CONCURRENCY=2 \
  GARDEN_PANEL_SEAT="$STUB_SEAT" GARDEN_PANEL_DECIDE="$STUB_DECIDE" \
  GARDEN_PANEL_APPELLATE=: GARDEN_PANEL_SEAT_ATTEMPTS=1 GARDEN_PANEL_SEAT_BACKOFF=0 \
  GARDEN_PANEL_RECORD=: GARDEN_PANEL_RECORD_STORE="$STORE" GARDEN_PANEL_REPO="$REPO" \
  GARDEN_PANEL_PR_BODY_FILE="$BODY" GARDEN_PANEL_RUNDIR="$TR/rd5" \
  FAN_DIR="$TR/rd5/fan" FAN_SLEEP=0 DECIDE_VERDICT=pass \
  bash "$PANEL" "$WT" "$PR" "$BASE_COMMIT" 2>&1)"; rc5=$?
[ "$rc5" -eq 0 ] && ok "base-mismatch run exits 0" || bad "exited $rc5: $out5"
[ -f "$TR/rd5/round-1.assessor.md" ] \
  && ok "seats ran — a changed base ref invalidated resume" \
  || bad "resumed despite a changed base ref: $out5"

hr; echo "SUBTEST 6 — head MISMATCH: a record for another head is ignored, seats run"; hr
# Point at a slug/repo with NO matching-head record (the store has only endojs one).
out6="$(run_panel unset 1 "$TR/rd6" other/repo 2>&1)"; rc6=$?
[ "$rc6" -eq 0 ] && ok "mismatch run exits 0" || bad "exited $rc6: $out6"
[ -f "$TR/rd6/round-1.assessor.md" ] \
  && ok "seats ran — a non-matching store did not resume (fail-open)" \
  || bad "resumed off a non-matching record: $out6"

hr; echo "SUBTEST 7 — provider MISMATCH: an Anthropic record is not resumed by OpenAI"; hr
out7="$(run_panel unset 1 "$TR/rd7" "$REPO" openai 2>&1)"; rc7=$?
[ "$rc7" -eq 0 ] && ok "provider-mismatch run exits 0" || bad "exited $rc7: $out7"
[ -f "$TR/rd7/round-1.assessor.md" ] \
  && ok "seats ran — a different provider invalidated resume" \
  || bad "resumed an Anthropic record from an OpenAI panel: $out7"

hr; echo "SUBTEST 8 — classic mode (flag unset) never resumes"; hr
out8="$(run_panel unset 0 "$TR/rd8" 2>&1)"; rc8=$?
[ "$rc8" -eq 0 ] && ok "classic run exits 0" || bad "exited $rc8: $out8"
[ -f "$TR/rd8/round-1.assessor.md" ] \
  && ok "seats ran in classic mode — resume is single-round-only" \
  || bad "classic mode resumed off the record (should be single-round-only): $out8"

hr
echo "RESULT: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
