#!/bin/bash
# review-miss-record-test.sh — validate the review-miss store writer against a
# throwaway journal2 (design designs/review-retrospective-loop.md, Q2/Q3).
#
# Subtests (all hermetic; a local bare journal, no systemd, no network):
#   1. MINT      — a first miss writes misses/<base>.md and mints its cluster at
#                  count 1, status open, prs [pr].
#   2. JOIN      — a second miss on a DIFFERENT pr joins the cluster (count 2,
#                  two distinct prs); a third crosses the floor (K>=3, >=2 prs).
#   3. IDEMPOTENT — re-recording the same primary base is a no-op (count stable).
#   4. DISMISS   — a not-a-miss writes dismissed/<base>.md and mints no cluster.
#   5. STATUS    — cluster-status advances open→improvement-dispatched→closed and
#                  guards a double-dispatch (already-dispatched is a no-op).
#   6. RECURRENCE — a new miss joining a CLOSED cluster with undeterminable timing
#                  reopens it (recurrence=1) — the conservative default.
#   7. DRAIN-REOPEN — a miss whose review PREDATES the improvement is a backlog-
#                  drain artifact: stays closed, drain_reopen=1, no escalation.
#   8. POST-FIX RECURRENCE — a miss whose review POSTDATES the improvement is a
#                  genuine recurrence: reopens, recurrence=1.
#   9. EVALUATOR-GAMING — the additive `evaluator-gaming` category rides the same
#                  lifecycle: mint at count 1, join a distinct PR (count 2), then
#                  recurrence-reopen after closure, with the category preserved.
#  10. CAS RETRY + IDEMPOTENCY — a genuine recurrence loses its first push race,
#                  then commits and alerts exactly once; a re-run does not alert.
#  11. NOTIFY FAILURE — a failing alert sink does not fail or roll back the
#                  committed recurrence.
#
# Usage: review-miss-record-test.sh

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
BRANCH=journal2
TR=/home/kris/.garden-rmr-test
PASS=0; FAIL=0
ok()  { echo "  PASS: $*"; PASS=$((PASS+1)); }
bad() { echo "  FAIL: $*"; FAIL=$((FAIL+1)); }
hr()  { echo "----------------------------------------------------------------"; }

# Hermetic baseline: scrub the fleet's own env (see run-test.sh) so ONLY $TR wins.
unset $(compgen -v 2>/dev/null | grep -E '^(GARDEN_|JOURNAL_|SELF_HEAL_)' || true) 2>/dev/null || true

rm -rf "$TR"; mkdir -p "$TR"
BARE="$TR/journal.git"
git_id=(-c user.name=test -c user.email=test@localhost)

git init -q --bare "$BARE"
SEED="$TR/seed"; git init -q "$SEED"
git -C "$SEED" checkout -q -b "$BRANCH"
( cd "$SEED"; mkdir -p jobs/todo work; touch jobs/todo/.gitkeep work/.gitkeep )
git -C "$SEED" add -A
git -C "$SEED" "${git_id[@]}" commit -q -m "seed: minimal board"
git -C "$SEED" remote add origin "$BARE"; git -C "$SEED" push -q -u origin "$BRANCH"

export JOURNAL_REMOTE="$BARE" JOURNAL_BRANCH="$BRANCH"
export GARDEN=testhost GARDEN_STATE="$TR/state" GARDEN_POST_ATTEMPTS=50
export GARDEN_ALERT_CMD="$HERE/budget-alert-record-stub.sh"
export GARDEN_ALERT_RECORD="$TR/alerts"
: > "$GARDEN_ALERT_RECORD"

RMR="$JOBS/review-miss-record.sh"

V="$TR/verify"
tip() {  # tip <path-under-journal> → cat file at the committed tip (empty if absent)
  rm -rf "$V"; git clone -q --single-branch --branch "$BRANCH" "$BARE" "$V"
  cat "$V/$1" 2>/dev/null || true
}
exists() { rm -rf "$V"; git clone -q --single-branch --branch "$BRANCH" "$BARE" "$V"; [ -e "$V/$1" ]; }
cfield() { tip "$1" | sed -n "s/^$2:[[:space:]]*//p" | head -1; }

# Build a miss record file. Optional 6th arg sets `review_at:` (the reopening
# miss's review/comment timestamp; only consulted when joining a CLOSED cluster).
mk_miss() {  # mk_miss <out> <base> <pr> <cluster> <category> [review_at]
  cat > "$1" <<EOF
---
kind: review-miss
ts: 2026-07-03T18:00:00Z
repo: endojs/endo-but-for-bots
pr: $3
comment_url: https://github.com/endojs/endo-but-for-bots/pull/$3#x
identity: endojs/endo-but-for-bots#$3:review:$3
primary_job: $2
producing_role: builder
category: $5
missed_by: [corner-prober]
severity: moderate
verdict: miss
cluster: $4
cluster_pattern: Empty-input boundaries keep slipping past the panel.
${6:+review_at: $6}
---
Paraphrase: the change did not guard the empty-input boundary; the panel should
have run corner-prober here.
EOF
}
mk_dismiss() {  # mk_dismiss <out> <base> <pr>
  cat > "$1" <<EOF
---
kind: review-miss-dismissed
ts: 2026-07-03T18:00:00Z
repo: endojs/endo-but-for-bots
pr: $3
primary_job: $2
category: new-direction
verdict: not-a-miss
grounds: >
  New direction first stated in the comment; nothing the review could anticipate.
---
Paraphrase: the maintainer asked for a new capability not previously specified.
EOF
}

# ============================================================================
hr; echo "1 — MINT: first miss writes the record + mints the cluster"; hr
M1="$TR/m1.md"; mk_miss "$M1" endojs-ebfb-pr594-review-aa11 594 empty-input-boundaries missed-edge-case
out="$("$RMR" record "$M1")"
exists "review-misses/misses/endojs-ebfb-pr594-review-aa11.md" && ok "miss record written" || bad "miss record missing"
exists "review-misses/README.md" && ok "store README seeded on first write" || bad "README not seeded"
[ "$(cfield review-misses/clusters/empty-input-boundaries.md status)" = open ] && ok "cluster status open" || bad "cluster status wrong"
[ "$(cfield review-misses/clusters/empty-input-boundaries.md count)" = 1 ] && ok "cluster count 1" || bad "count not 1 ($out)"
echo "$out" | grep -q 'count=1 status=open prs=594 recurrence=0' && ok "summary line correct" || bad "summary wrong: $out"

# ============================================================================
hr; echo "2 — JOIN: second/third misses on distinct PRs cross the floor"; hr
M2="$TR/m2.md"; mk_miss "$M2" endojs-ebfb-pr601-review-bb22 601 empty-input-boundaries missed-edge-case
out2="$("$RMR" record "$M2")"
[ "$(cfield review-misses/clusters/empty-input-boundaries.md count)" = 2 ] && ok "count 2 after join" || bad "count not 2 ($out2)"
echo "$out2" | grep -q 'prs=594,601' && ok "two distinct prs recorded" || bad "prs wrong: $out2"
M3="$TR/m3.md"; mk_miss "$M3" endojs-ebfb-pr594-review-cc33 594 empty-input-boundaries missed-edge-case
out3="$("$RMR" record "$M3")"
[ "$(cfield review-misses/clusters/empty-input-boundaries.md count)" = 3 ] && ok "count 3 (floor K>=3 met)" || bad "count not 3 ($out3)"
# prs stays two distinct (594 repeated) — the two-PR floor is about DISTINCT prs.
echo "$out3" | grep -q 'prs=594,601' && ok "distinct-pr set stays {594,601}" || bad "prs set drifted: $out3"

# ============================================================================
hr; echo "3 — IDEMPOTENT: re-recording the same base is a no-op"; hr
out_i="$("$RMR" record "$M1")"
echo "$out_i" | grep -q 'verdict=already' && ok "re-record reported as already-recorded" || bad "not idempotent: $out_i"
[ "$(cfield review-misses/clusters/empty-input-boundaries.md count)" = 3 ] && ok "count unchanged by re-record" || bad "count moved on re-record"

# ============================================================================
hr; echo "4 — DISMISS: a not-a-miss writes dismissed/, mints no cluster"; hr
D1="$TR/d1.md"; mk_dismiss "$D1" endojs-ebfb-pr700-review-dd44 700
outd="$("$RMR" record "$D1")"
exists "review-misses/dismissed/endojs-ebfb-pr700-review-dd44.md" && ok "dismissal record written" || bad "dismissal missing"
exists "review-misses/clusters/new-direction.md" && bad "a dismissal wrongly minted a cluster" || ok "no cluster minted for a dismissal"
echo "$outd" | grep -q 'verdict=not-a-miss' && ok "dismissal summary correct" || bad "dismissal summary wrong: $outd"

# ============================================================================
hr; echo "5 — STATUS: dispatch lifecycle + double-dispatch guard"; hr
RAT="$TR/rat.txt"; printf 'Floor met (3 misses, 2 PRs); the pattern is systemic.\n' > "$RAT"
"$RMR" cluster-status empty-input-boundaries improvement-dispatched --job review-improve-empty-input-boundaries --rationale-file "$RAT" >/dev/null
[ "$(cfield review-misses/clusters/empty-input-boundaries.md status)" = improvement-dispatched ] && ok "status → improvement-dispatched" || bad "status not advanced"
[ "$(cfield review-misses/clusters/empty-input-boundaries.md improvement_job)" = review-improve-empty-input-boundaries ] && ok "improvement_job recorded" || bad "improvement_job missing"
tip review-misses/clusters/empty-input-boundaries.md | grep -q 'Threshold rationale:' && ok "threshold rationale appended" || bad "rationale not appended"
guard="$("$RMR" cluster-status empty-input-boundaries improvement-dispatched --job other)"
echo "$guard" | grep -q 'already improvement-dispatched' && ok "double-dispatch guarded (no-op)" || bad "double-dispatch not guarded: $guard"
"$RMR" cluster-status empty-input-boundaries closed --improved-by "roles/jurors/corner-prober/AGENT.md, skills/panel-hints/probes/empty-input.sh" >/dev/null
[ "$(cfield review-misses/clusters/empty-input-boundaries.md status)" = closed ] && ok "status → closed" || bad "status not closed"

# ============================================================================
hr; echo "6 — RECURRENCE: a new miss joining a CLOSED cluster reopens it"; hr
M4="$TR/m4.md"; mk_miss "$M4" endojs-ebfb-pr710-review-ee55 710 empty-input-boundaries missed-edge-case
out4="$("$RMR" record "$M4")"
[ "$(cfield review-misses/clusters/empty-input-boundaries.md status)" = open ] && ok "closed cluster reopened by a new miss" || bad "cluster not reopened"
echo "$out4" | grep -q 'recurrence=1' && ok "recurrence flagged in summary" || bad "recurrence not flagged: $out4"
[ "$(cfield review-misses/clusters/empty-input-boundaries.md count)" = 4 ] && ok "count continues (4)" || bad "count did not continue"
grep -qx 'KEY=review-miss-recurrence-empty-input-boundaries' "$GARDEN_ALERT_RECORD" \
  && ok "committed recurrence alerted under the cluster dedup key" \
  || bad "recurrence alert key missing ($(tr '\n' '|' < "$GARDEN_ALERT_RECORD"))"

# ============================================================================
hr; echo "7 — DRAIN-REOPEN: a pre-improvement miss re-closes, no escalation"; hr
# Mint a fresh cluster and drive it closed, naming a REAL commit as the
# improvement so its committer date is the improvement instant.
M7a="$TR/m7a.md"; mk_miss "$M7a" endojs-ebfb-pr800-review-ff66 800 drain-input missed-edge-case
"$RMR" record "$M7a" >/dev/null
rm -rf "$V"; git clone -q --single-branch --branch "$BRANCH" "$BARE" "$V"
IMPSHA="$(git -C "$V" rev-parse HEAD)"
IMPEPOCH="$(git -C "$V" show -s --format=%ct "$IMPSHA")"
"$RMR" cluster-status drain-input improvement-dispatched --job review-improve-drain-input >/dev/null
"$RMR" cluster-status drain-input closed --improved-by "$IMPSHA" >/dev/null
[ "$(cfield review-misses/clusters/drain-input.md status)" = closed ] && ok "cluster closed" || bad "cluster not closed"
# A miss whose review PREDATES the improvement is a backlog-drain artifact.
BEFORE="$(date -u -d "@$((IMPEPOCH - 3600))" +%Y-%m-%dT%H:%M:%SZ)"
M7b="$TR/m7b.md"; mk_miss "$M7b" endojs-ebfb-pr801-review-aa77 801 drain-input missed-edge-case "$BEFORE"
alerts_before="$(grep -c '^KEY=' "$GARDEN_ALERT_RECORD" || true)"
out7="$("$RMR" record "$M7b")"
[ "$(cfield review-misses/clusters/drain-input.md status)" = closed ] && ok "pre-improvement miss did NOT reopen" || bad "cluster wrongly reopened"
echo "$out7" | grep -q 'recurrence=0 drain_reopen=1' && ok "drain_reopen=1, recurrence=0 in summary" || bad "flags wrong: $out7"
[ "$(cfield review-misses/clusters/drain-input.md count)" = 2 ] && ok "member still recorded (count 2)" || bad "member not recorded"
[ "$(grep -c '^KEY=' "$GARDEN_ALERT_RECORD" || true)" -eq "$alerts_before" ] \
  && ok "drain reopen did not alert" || bad "drain reopen emitted a recurrence alert"

# ============================================================================
hr; echo "8 — POST-FIX RECURRENCE: a miss after the fix reopens + escalates"; hr
AFTER="$(date -u -d "@$((IMPEPOCH + 3600))" +%Y-%m-%dT%H:%M:%SZ)"
M8="$TR/m8.md"; mk_miss "$M8" endojs-ebfb-pr802-review-bb88 802 drain-input missed-edge-case "$AFTER"
out8="$("$RMR" record "$M8")"
[ "$(cfield review-misses/clusters/drain-input.md status)" = open ] && ok "post-improvement miss reopened cluster" || bad "cluster not reopened"
echo "$out8" | grep -q 'recurrence=1 drain_reopen=0' && ok "recurrence=1, drain_reopen=0 in summary" || bad "flags wrong: $out8"
grep -qx 'KEY=review-miss-recurrence-drain-input' "$GARDEN_ALERT_RECORD" \
  && ok "genuine post-fix recurrence alerted" || bad "genuine recurrence alert missing"

# ============================================================================
hr; echo "9 — EVALUATOR-GAMING: the new category through mint/join/recurrence"; hr
# Additive: the category is a free-form label the writer stores and preserves; it
# rides the identical mint / join / K-floor / recurrence-reopen lifecycle.
G1="$TR/g1.md"; mk_miss "$G1" endojs-ebfb-pr900-review-gg11 900 gaming-pattern evaluator-gaming
outg1="$("$RMR" record "$G1")"
[ "$(cfield review-misses/clusters/gaming-pattern.md category)" = evaluator-gaming ] && ok "cluster minted with category evaluator-gaming" || bad "category wrong ($outg1)"
[ "$(cfield review-misses/clusters/gaming-pattern.md count)" = 1 ] && ok "gaming cluster count 1" || bad "count not 1 ($outg1)"
echo "$outg1" | grep -q 'count=1 status=open prs=900' && ok "gaming mint summary correct" || bad "summary wrong: $outg1"
G2="$TR/g2.md"; mk_miss "$G2" endojs-ebfb-pr901-review-gg22 901 gaming-pattern evaluator-gaming
outg2="$("$RMR" record "$G2")"
[ "$(cfield review-misses/clusters/gaming-pattern.md count)" = 2 ] && ok "gaming cluster count 2 after join" || bad "count not 2 ($outg2)"
echo "$outg2" | grep -q 'prs=900,901' && ok "two distinct prs on gaming cluster" || bad "prs wrong: $outg2"
# Recurrence: dispatch + close, then a new miss with undeterminable timing reopens.
"$RMR" cluster-status gaming-pattern improvement-dispatched --job review-improve-gaming-pattern >/dev/null
"$RMR" cluster-status gaming-pattern closed --improved-by "roles/prosecutor/AGENT.md" >/dev/null
[ "$(cfield review-misses/clusters/gaming-pattern.md status)" = closed ] && ok "gaming cluster closed" || bad "gaming cluster not closed"
G3="$TR/g3.md"; mk_miss "$G3" endojs-ebfb-pr902-review-gg33 902 gaming-pattern evaluator-gaming
outg3="$("$RMR" record "$G3")"
[ "$(cfield review-misses/clusters/gaming-pattern.md status)" = open ] && ok "gaming cluster reopened on recurrence" || bad "not reopened ($outg3)"
echo "$outg3" | grep -q 'recurrence=1' && ok "gaming recurrence flagged" || bad "recurrence not flagged: $outg3"
[ "$(cfield review-misses/clusters/gaming-pattern.md category)" = evaluator-gaming ] && ok "category preserved across full lifecycle" || bad "category drifted"

# ============================================================================
hr; echo "10 — CAS RETRY + IDEMPOTENCY: recurrence alerts exactly once"; hr
R1="$TR/r1.md"; mk_miss "$R1" endojs-ebfb-pr950-review-rr11 950 retry-pattern missed-edge-case
"$RMR" record "$R1" >/dev/null
rm -rf "$V"; git clone -q --single-branch --branch "$BRANCH" "$BARE" "$V"
RETRYSHA="$(git -C "$V" rev-parse HEAD)"
RETRY_EPOCH="$(git -C "$V" show -s --format=%ct "$RETRYSHA")"
"$RMR" cluster-status retry-pattern improvement-dispatched --job review-improve-retry-pattern >/dev/null
"$RMR" cluster-status retry-pattern closed --improved-by "$RETRYSHA" >/dev/null
R2="$TR/r2.md"; mk_miss "$R2" endojs-ebfb-pr951-review-rr22 951 retry-pattern missed-edge-case \
  "$(date -u -d "@$((RETRY_EPOCH + 3600))" +%Y-%m-%dT%H:%M:%SZ)"
RACE_MARKER="$TR/race.once"; RACE_COUNT="$TR/race.count"; printf '0\n' > "$RACE_COUNT"
out10="$(GARDEN_PUSH_CMD="$HERE/review-miss-record-race-push-stub.sh" \
  GARDEN_RMR_RACE_BARE="$BARE" GARDEN_RMR_RACE_BRANCH="$BRANCH" \
  GARDEN_RMR_RACE_MARKER="$RACE_MARKER" GARDEN_RMR_RACE_COUNT="$RACE_COUNT" \
  "$RMR" record "$R2")"
[ "$(cat "$RACE_COUNT")" -ge 2 ] && ok "recurrence retried after losing its first CAS push" || bad "CAS retry was not exercised"
echo "$out10" | grep -q 'recurrence=1 drain_reopen=0' && ok "retried recurrence committed" || bad "retried recurrence summary wrong: $out10"
[ "$(grep -c '^KEY=review-miss-recurrence-retry-pattern$' "$GARDEN_ALERT_RECORD" || true)" -eq 1 ] \
  && ok "CAS retry emitted one per-cluster alert" || bad "CAS retry alert count was not one"
out10i="$("$RMR" record "$R2")"
echo "$out10i" | grep -q 'verdict=already' && ok "recurrence re-run was idempotent" || bad "recurrence re-run was not idempotent: $out10i"
[ "$(grep -c '^KEY=review-miss-recurrence-retry-pattern$' "$GARDEN_ALERT_RECORD" || true)" -eq 1 ] \
  && ok "idempotent re-run did not duplicate the alert" || bad "re-run duplicated recurrence alert"

# ============================================================================
hr; echo "11 — NOTIFY FAILURE: alert delivery remains best-effort"; hr
F1="$TR/f1.md"; mk_miss "$F1" endojs-ebfb-pr960-review-nf11 960 notify-fail-pattern missed-edge-case
"$RMR" record "$F1" >/dev/null
rm -rf "$V"; git clone -q --single-branch --branch "$BRANCH" "$BARE" "$V"
FAILSHA="$(git -C "$V" rev-parse HEAD)"
FAIL_EPOCH="$(git -C "$V" show -s --format=%ct "$FAILSHA")"
"$RMR" cluster-status notify-fail-pattern improvement-dispatched --job review-improve-notify-fail-pattern >/dev/null
"$RMR" cluster-status notify-fail-pattern closed --improved-by "$FAILSHA" >/dev/null
F2="$TR/f2.md"; mk_miss "$F2" endojs-ebfb-pr961-review-nf22 961 notify-fail-pattern missed-edge-case \
  "$(date -u -d "@$((FAIL_EPOCH + 3600))" +%Y-%m-%dT%H:%M:%SZ)"
set +e
out11="$(GARDEN_ALERT_CMD=/bin/false "$RMR" record "$F2")"; rc11=$?
set -e
[ "$rc11" -eq 0 ] && ok "failing notification sink did not fail the writer" || bad "notification failure escaped as rc=$rc11"
echo "$out11" | grep -q 'recurrence=1 drain_reopen=0' && ok "recurrence still reported after notify failure" || bad "notify failure lost recurrence summary: $out11"
[ "$(cfield review-misses/clusters/notify-fail-pattern.md status)" = open ] \
  && ok "recurrence commit remained durable after notify failure" || bad "notify failure rolled back recurrence"

hr
echo "review-miss-record: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
