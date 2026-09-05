#!/bin/bash
# followup-posted-gate-test.sh — the re-litigation test for the posted-follow-up
# completion gate (scripts/jobs/assert-followup-posted.sh). Grounding incidents
# (both 2026-08-19): `endojs-endo-but-for-bots-pr910-shepherd` completed
# describing a needed conductor job and settled WITHOUT posting one (the parked
# conductor child then sat unpromoted for 5 days); `endojs-endo-but-for-bots-
# pr876-rebase` completed saying "a fresh shepherd and then conduct are warranted
# now" and settled WITHOUT posting either. Both used bold-prose headers, invisible
# to the async garden-follow-up sweep.
#
# The gate is deterministic (NO LLM): report text plus trusted board/inbox state.
# It refuses completion when a substantive `## Follow-ups` section has no checkable
# disposition, and passes for a verified handoff, an actual maintainer-inbox
# message, an explicit override, or a trivially-empty / absent section.

set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
JOBS="$(cd "$HERE/.." && pwd)"
TR="$(mktemp -d "${TMPDIR:-/tmp}/garden-followup-gate-test.XXXXXX")"
trap 'rm -rf "$TR"' EXIT

git init -q --bare "$TR/journal.git"
git init -q "$TR/seed"
git -C "$TR/seed" checkout -q -b journal2
mkdir -p "$TR/seed/jobs/"{plan,todo,doin,tada,orch,gauntlet,index} \
  "$TR/seed/inbox/maintainer/"{unread,read}
for d in plan todo doin tada orch gauntlet index; do touch "$TR/seed/jobs/$d/.gitkeep"; done
touch "$TR/seed/inbox/maintainer/unread/.gitkeep" "$TR/seed/inbox/maintainer/read/.gitkeep"
git -C "$TR/seed" add -A
git -C "$TR/seed" -c user.name=test -c user.email=test@example.invalid commit -q -m seed
git -C "$TR/seed" remote add origin "$TR/journal.git"
git -C "$TR/seed" push -q origin HEAD:journal2

GARDEN_ROOT="$(cd "$JOBS/../.." && pwd)"; export GARDEN_ROOT
export GARDEN_TEST=1 JOURNAL_REMOTE="$TR/journal.git" JOURNAL_BRANCH=journal2
export GARDEN_STATE="$TR/state" GARDEN=followup-gate-test
# Pin the producer clone the gate reads to a deterministic path we control.
export GARDEN_PRODUCER_CLONE="$TR/producer"

GATE="$JOBS/assert-followup-posted.sh"
fail() { echo "FAIL: $*" >&2; exit 1; }

# Post a job/board artifact directly onto origin/journal2 so the gate's producer
# clone (which it clones+syncs from JOURNAL_REMOTE) sees it.
board_put() {  # board_put <subdir> <base>
  local sub="$1" base="$2" w="$TR/put"
  rm -rf "$w"; git clone -q --single-branch --branch journal2 "$TR/journal.git" "$w" >/dev/null 2>&1
  mkdir -p "$w/jobs/$sub"
  printf -- '---\nrole: gardener\n---\nposted follow-up.\n' >"$w/jobs/$sub/$base.md"
  git -C "$w" add -A
  git -C "$w" -c user.name=t -c user.email=t@t.invalid commit -q -m "put $sub/$base"
  git -C "$w" push -q origin HEAD:journal2
}
# Deposit a maintainer-inbox message tagged reply_to=<base>, as message-user.sh does.
inbox_put() {  # inbox_put <reply-to-base>
  local base="$1" w="$TR/put"
  rm -rf "$w"; git clone -q --single-branch --branch journal2 "$TR/journal.git" "$w" >/dev/null 2>&1
  mkdir -p "$w/inbox/maintainer/unread"
  printf 'from_host: %s\nfrom: gardener:%s\nreply_to: %s\nsent_at: 2026-08-19T00:00:00Z\n---\nPlease decide X.\n' \
    "$GARDEN" "$base" "$base" >"$w/inbox/maintainer/unread/msg-$base.md"
  git -C "$w" add -A
  git -C "$w" -c user.name=t -c user.email=t@t.invalid commit -q -m "inbox msg $base"
  git -C "$w" push -q origin HEAD:journal2
}
# Fresh producer clone each assertion so a prior sync cannot mask a missing artifact.
reset_clone() { rm -rf "$GARDEN_PRODUCER_CLONE"; }

JOB="$TR/job.md"
printf -- '---\nrole: shepherd\n---\nDrive CI to green.\n' >"$JOB"

echo '== (a) BLOCK: a substantive `## Follow-ups` with no disposition is refused =='
# The pr910/pr876 shape, now under the CANONICAL heading.
cat >"$TR/r1.md" <<'EOF'
Shepherded CI to green; the run is passing.

## Follow-ups
- The maintainer's latest comment is "Conduct." — a conductor job is warranted
  now to merge this PR. Out of this shepherd's scope.
EOF
reset_clone
if "$GATE" pr910-shepherd "$JOB" "$TR/r1.md"; then
  fail 'gate did NOT block a substantive follow-up with no posted job / inbox / override'
fi
echo '   gate correctly blocked (rc 1)'

echo '== (b) PASS: a verified handoff naming a real board artifact succeeds =='
board_put todo endo-pr910-conduct
cat >"$TR/r2.md" <<'EOF'
Shepherded CI to green.

## Follow-ups
- Posted a conductor job to merge this PR now that CI is green.

<<<GARDEN-JOB-HANDED-OFF: endo-pr910-conduct>>>
EOF
reset_clone
"$GATE" pr910-shepherd "$JOB" "$TR/r2.md" \
  || fail 'gate wrongly blocked a report whose handoff successor IS on the board'
echo '   gate passed on a verified handoff'

echo '== (b2) BLOCK: a handoff naming a successor NOT on the board is refused =='
cat >"$TR/r2b.md" <<'EOF'
Shepherded CI to green.

## Follow-ups
- Conduct next.

<<<GARDEN-JOB-HANDED-OFF: endo-pr910-nonexistent>>>
EOF
reset_clone
if "$GATE" pr910-shepherd "$JOB" "$TR/r2b.md"; then
  fail 'gate did NOT block a handoff whose successor is absent from the board'
fi
echo '   gate correctly blocked an unposted handoff (rc 1)'

echo '== (b3) BLOCK: an unposted handoff with NO Follow-ups section is refused =='
cat >"$TR/r2c.md" <<'EOF'
Partial work is complete; the named successor owns the remainder.

<<<GARDEN-JOB-HANDED-OFF: endo-pr910-unposted-no-section>>>
EOF
reset_clone
if "$GATE" pr910-shepherd "$JOB" "$TR/r2c.md"; then
  fail 'gate did NOT block an absent handoff successor when the report omitted Follow-ups'
fi
echo '   gate unconditionally checked the declared handoff and blocked it (rc 1)'

echo '== (c) PASS: an orchestration record also satisfies the handoff =='
board_put orch pr876-chain-orch
cat >"$TR/r3.md" <<'EOF'
Rebased the PR.

## Follow-ups
- A fresh shepherd then conduct are warranted; posted an orchestration.

<<<GARDEN-JOB-HANDED-OFF: pr876-chain-orch>>>
EOF
reset_clone
"$GATE" pr876-rebase "$JOB" "$TR/r3.md" \
  || fail 'gate wrongly blocked a handoff to a real orchestration record'
echo '   gate passed on an orchestration handoff'

echo '== (c2) PASS: an active staged-gauntlet record also satisfies the handoff =='
board_put gauntlet ironhorse-fuzz-case-gauntlet
cat >"$TR/r3b.md" <<'EOF'
Fixed the Ironhorse finding and amended the standing PR.

## Follow-ups
- The staged gauntlet owns clean, panel, fix-loop, and un-draft.

<<<GARDEN-JOB-HANDED-OFF: ironhorse-fuzz-case-gauntlet>>>
EOF
reset_clone
"$GATE" ironhorse-fuzz-case-repair "$JOB" "$TR/r3b.md" \
  || fail 'gate wrongly blocked a handoff to a durable staged-gauntlet record'
echo '   gate passed on a staged-gauntlet handoff'

echo '== (d) PASS: an actual maintainer-inbox message (reply_to=base) satisfies the gate =='
inbox_put pr876-rebase
cat >"$TR/r4.md" <<'EOF'
Rebased the PR; a conflict-resolution judgment call remains.

## Follow-ups
- Routed the merge-vs-hold decision to the maintainer inbox for a judgment call.
EOF
reset_clone
"$GATE" pr876-rebase "$JOB" "$TR/r4.md" \
  || fail 'gate wrongly blocked a report with a real maintainer-inbox message'
echo '   gate passed on an actual inbox message'

echo '== (d2) BLOCK: a prose "sent to inbox" claim with NO actual message is refused =='
cat >"$TR/r4b.md" <<'EOF'
Rebased the PR.

## Follow-ups
- Sent the decision to the maintainer inbox. (no message was actually sent)
EOF
reset_clone
if "$GATE" pr876-rebase-unsent "$JOB" "$TR/r4b.md"; then
  fail 'gate accepted a BARE PROSE inbox claim with no actual message (must not)'
fi
echo '   gate correctly blocked a bare prose inbox claim (rc 1)'

echo '== (e) PASS: an explicit override marker with a reason is the safety valve =='
cat >"$TR/r5.md" <<'EOF'
Fixed the bug and pushed.

## Follow-ups
- Someone might later want to tidy the adjacent helper; purely nice-to-have.

<<<GARDEN-FOLLOWUP-GATE-OVERRIDE: the follow-up is an optional nicety, not unfinished chained work>>>
EOF
reset_clone
"$GATE" some-fix "$JOB" "$TR/r5.md" \
  || fail 'gate wrongly blocked a report carrying a valid override marker'
echo '   gate passed on an explicit override'

echo '== (e2) BLOCK: an override marker with an EMPTY reason does not count =='
printf 'Done.\n\n## Follow-ups\n- Conduct next.\n\n<<<GARDEN-FOLLOWUP-GATE-OVERRIDE: >>>\n' >"$TR/r5b.md"
reset_clone
if "$GATE" some-fix "$JOB" "$TR/r5b.md"; then
  fail 'gate accepted an override marker with an empty reason (must not)'
fi
echo '   gate correctly ignored an empty-reason override (rc 1)'

echo '== (f) NO-OP: a trivially-empty `## Follow-ups` (None.) never gates =='
printf 'All done.\n\n## Follow-ups\nNone.\n' >"$TR/r6.md"
reset_clone
"$GATE" clean-job "$JOB" "$TR/r6.md" \
  || fail 'gate wrongly blocked a None. follow-up section'
printf 'All done.\n\n## Follow-up\nNothing this time.\n' >"$TR/r6b.md"
reset_clone
"$GATE" clean-job "$JOB" "$TR/r6b.md" \
  || fail 'gate wrongly blocked a "Nothing this time." section (singular heading)'
echo '   gate is a no-op for a null-signal section'

echo '== (f2) PASS: a completed gauntlet fix stage leaves its next panel to the driver =='
cat >"$TR/r6c.md" <<'EOF'
Fixed the panel findings, pushed, and observed green CI.

## Follow-ups / notes
- The gauntlet driver posts the next panel stage.

<!-- gauntlet-stage-result: fix=done -->
EOF
reset_clone
"$GATE" example-gauntlet-fix-1 "$JOB" "$TR/r6c.md" \
  || fail 'gate wrongly blocked the deterministic gauntlet driver from owning the next panel stage'
echo '   gate passed on the driver-owned gauntlet continuation'

echo '== (f3) BLOCK: driver-owned continuation does not hide other unposted work =='
cat >"$TR/r6d.md" <<'EOF'
Fixed the panel findings, pushed, and observed green CI.

## Follow-ups / notes
- The gauntlet driver posts the next panel stage.
- Post a conductor job after that panel finishes.

<!-- gauntlet-stage-result: fix=done -->
EOF
reset_clone
if "$GATE" example-gauntlet-fix-1-extra "$JOB" "$TR/r6d.md"; then
  fail 'gate accepted actual unposted successor work beside a driver-owned transition'
fi
echo '   gate correctly blocked additional unposted successor work (rc 1)'

echo '== (f4) BLOCK: driver prose without a completed stage marker remains actionable =='
cat >"$TR/r6e.md" <<'EOF'
Work stopped before the stage completed.

## Follow-ups / notes
- The gauntlet driver posts the next panel stage.
EOF
reset_clone
if "$GATE" incomplete-gauntlet-fix "$JOB" "$TR/r6e.md"; then
  fail 'gate accepted driver prose without the fix=done stage marker'
fi
echo '   gate correctly required the completed gauntlet-stage marker (rc 1)'

echo '== (g) NO-OP: a report with NO follow-up section, and a bold-prose header, never gates =='
printf 'All done. Clean completion.\n' >"$TR/r7.md"
reset_clone
"$GATE" no-section "$JOB" "$TR/r7.md" \
  || fail 'gate wrongly blocked a report with no follow-up section at all'
# A bold-prose "**Follow-up:**" header is (by design) NOT the canonical heading, so
# the gate does not see it — this documents the gap the house-style rule closes:
# the fix is the heading convention, not making the gate parse bold prose.
printf 'Done.\n\n**Follow-up:** a conductor job is warranted.\n' >"$TR/r7b.md"
reset_clone
"$GATE" bold-prose "$JOB" "$TR/r7b.md" \
  || fail 'gate unexpectedly reacted to a bold-prose header (it anchors ONLY on the canonical heading)'
echo '   gate anchors only on the canonical `## Follow-ups` heading (house-style rule closes the bold-prose gap)'

echo 'PASS: the posted-follow-up gate blocks described-but-unposted follow-ups and passes verified handoffs, real inbox messages, overrides, null sections, and driver-owned gauntlet continuation'
