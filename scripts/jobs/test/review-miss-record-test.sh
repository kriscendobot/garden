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
#   6. RECURRENCE — a new miss joining a CLOSED cluster reopens it (recurrence=1).
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

RMR="$JOBS/review-miss-record.sh"

V="$TR/verify"
tip() {  # tip <path-under-journal> → cat file at the committed tip (empty if absent)
  rm -rf "$V"; git clone -q --single-branch --branch "$BRANCH" "$BARE" "$V"
  cat "$V/$1" 2>/dev/null || true
}
exists() { rm -rf "$V"; git clone -q --single-branch --branch "$BRANCH" "$BARE" "$V"; [ -e "$V/$1" ]; }
cfield() { tip "$1" | sed -n "s/^$2:[[:space:]]*//p" | head -1; }

# Build a miss record file.
mk_miss() {  # mk_miss <out> <base> <pr> <cluster> <category>
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

hr
echo "review-miss-record: $PASS passed, $FAIL failed"
[ "$FAIL" -eq 0 ]
