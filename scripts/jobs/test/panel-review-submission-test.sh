#!/bin/bash
# panel-review-submission-test.sh — the single-round panel owns its formal review
# submission, including GitHub's self-authored request-changes restriction.
set -uo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PANEL="$(cd "$HERE/../gardening" && pwd)/panel.sh"
TR="$(mktemp -d "${TMPDIR:-/tmp}/panel-review-submission.XXXXXX")"
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
trap 'rm -rf "$TR"' EXIT

git_id=(-c user.name=test -c user.email=test@localhost)
WT="$TR/wt"
git init -q "$WT"
git -C "$WT" remote add origin https://github.com/example/panel-fixture.git
printf 'base\n' > "$WT/file.txt"
git -C "$WT" add file.txt
git -C "$WT" "${git_id[@]}" commit -q -m base
printf 'head\n' >> "$WT/file.txt"
git -C "$WT" add file.txt
git -C "$WT" "${git_id[@]}" commit -q -m head

run_panel() {  # run_panel <author> <tag> [fail]
  local author="$1" tag="$2" fail="${3:-0}"
  PANEL_GH_AUTH_LOGIN='kriscendobot' \
  PANEL_GH_AUTHOR_LOGIN="$author" \
  PANEL_GH_LOG="$TR/$tag.gh.log" \
  PANEL_GH_BODY="$TR/$tag.body.md" \
  PANEL_GH_FAIL_REVIEW="$fail" \
  FAN_DIR="$TR/$tag.fan" FAN_SLEEP=0 \
  DECIDE_VERDICT=must-fix \
  GARDEN_TEST=1 \
  GARDEN_PANEL_SINGLE_ROUND=1 \
  GARDEN_PANEL_REVIEW_SUBMIT=panel_submit_review \
  GARDEN_PANEL_GH="$HERE/panel-review-submit-gh-stub.sh" \
  GARDEN_CODE_SEATS='assessor stylist' \
  GARDEN_PANEL_CONCURRENCY=2 \
  GARDEN_PANEL_SEAT="$HERE/panel-fixer-aggregate-stub.sh" \
  GARDEN_PANEL_DECIDE="$HERE/panel-decide-stub.sh" \
  GARDEN_PANEL_RELATED_DESIGN=: \
  GARDEN_PANEL_APPELLATE=: \
  GARDEN_PANEL_RECORD=: \
  GARDEN_PANEL_RUNDIR="$TR/$tag.rundir" \
    bash "$PANEL" "$WT" 777 HEAD~1
}

echo "SUBTEST 1 — a non-self-authored must-fix requests changes"
out1="$(run_panel human-reviewee normal 2>&1)"; rc1=$?
[ "$rc1" -eq 0 ] && ok "normal review exits 0" || bad "normal review exited $rc1: $out1"
grep -q -- '--request-changes' "$TR/normal.gh.log" \
  && ok "normal review uses --request-changes" \
  || bad "normal review did not request changes: $(cat "$TR/normal.gh.log")"
grep -q '^## Must-fix before merge$' "$TR/normal.body.md" \
  && grep -q '<summary><b>assessor</b>' "$TR/normal.body.md" \
  && grep -q 'This continuation line is required evidence' "$TR/normal.body.md" \
  && ! grep -q 'APPROVING_SEAT_CONTEXT_MUST_NOT_REACH_FIXER' "$TR/normal.body.md" \
  && ok "request-changes body keeps the full blocking-seat findings and omits approving-seat prose" \
  || bad "request-changes body lost or inflated the focused full-text aggregate"
grep -q '<!-- gauntlet-stage-result: panel=must-fix -->' <<<"$out1" \
  && ok "normal success emits the stage marker" \
  || bad "normal success omitted the stage marker: $out1"

echo "SUBTEST 2 — a self-authored must-fix falls back to a comment review"
out2="$(run_panel 'app/kriscendobot' self 2>&1)"; rc2=$?
[ "$rc2" -eq 0 ] && ok "self-authored review exits 0" || bad "self-authored review exited $rc2: $out2"
{ grep -q -- '--comment' "$TR/self.gh.log" && ! grep -q -- '--request-changes' "$TR/self.gh.log"; } \
  && ok "self-authored review uses --comment instead of --request-changes" \
  || bad "self-authored review used the wrong state: $(cat "$TR/self.gh.log")"
grep -q '^## Must-fix before merge$' "$TR/self.body.md" \
  && cmp -s "$TR/normal.body.md" "$TR/self.body.md" \
  && ok "comment fallback preserves the full headed must-fix aggregate" \
  || bad "comment fallback changed or lost the must-fix aggregate"
grep -q '<!-- gauntlet-stage-result: panel=must-fix -->' <<<"$out2" \
  && ok "self-authored fallback emits the stage marker after success" \
  || bad "self-authored fallback omitted the stage marker: $out2"

echo "SUBTEST 3 — a failed review post emits no successful stage marker"
out3="$(run_panel human-reviewee failed 1 2>&1)"; rc3=$?
[ "$rc3" -ne 0 ] && ok "failed review post exits non-zero" || bad "failed review post exited 0"
! grep -q '<!-- gauntlet-stage-result:' <<<"$out3" \
  && ok "failed review post emits no stage marker" \
  || bad "failed review post emitted a false success marker: $out3"

echo "RESULT: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
