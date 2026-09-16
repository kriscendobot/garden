---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Add a gate for work that is PENDING A MAINTAINER DECISION, so such a job is never
auto-promoted off the foreman's deferred queue into a no-op that burns budget.

THE BUG, reported independently by two gardeners on the same day (2026-09-16),
each of which had to work around it by hand:

1. `wire-siwe-onchain-authz-minion-town-followup`: "the predecessor parked this
   remainder as `--deferred`, but a deferred maintainer-gated job is
   FOREMAN-AUTO-PROMOTABLE — the foreman pulled it off the reservoir at
   2026-09-16T14:19:14Z (decisions.log `guard=promoted`, gate `cleared=none`, no
   maintainer answer) into a claimed no-op that could only re-message you and burn
   budget. That's happened TWICE now." It re-parked as `--blocked` with a synthetic
   `blocked_on` predecessor purely to make the job foreman-immune.
2. `minion-town-guest-peer-fetch-verify`: auto-promoted off the deferred queue and
   claimed, but its precondition (a maintainer decision on kriscendobot/garden#58,
   comment 5447765615, unanswered since 2026-08-28) was unmet. "The promotion
   metadata itself records `cleared=none`." It re-parked as `--go-ahead`.

ROOT CAUSE: the gate vocabulary has no way to say "this waits on a HUMAN ANSWER."
`--deferred` means merely lower-priority and IS foreman-auto-promotable; the
prose condition in the body is invisible to the foreman. Producers therefore reach
for whichever gate happens to be foreman-immune (`--go-ahead`, or a fabricated
`--blocked` edge), which overloads gates that mean other things and makes the
board's state unreadable.

This matters more now than it did last week: the foreman was quiesced
(GARDEN_FOREMAN_ACTIVE_TARGET=0) from 2026-07-14 until 2026-09-16, so the deferred
reservoir was never drawn down and the bug was dormant. It is now live against a
125-job reservoir, and every mis-gated job in it is a claimed no-op that costs a
handler engagement to discover.

TASK:
1. Add a first-class gate for pending-maintainer-decision (name it well —
   `awaiting-maintainer` or similar) that is never foreman-auto-promotable and is
   cleared only by an explicit maintainer promotion, and wire it through
   `post-plan.sh` / `annotate-plan.sh` / `promote-plan.sh` and the foreman's
   selection predicate.
2. Make it carry the QUESTION: the gate should record what decision is pending and
   where it was asked (issue/PR/comment URL), so the bulletin's Plan queue can
   surface it as an answerable item rather than an opaque hold.
3. Audit the existing 125 deferred jobs for ones that are actually
   maintainer-gated and re-gate them, so the reservoir does not keep producing
   no-op claims as it drains. Report how many you moved.
4. Regression test: a job on the new gate must survive a foreman tick unclaimed.

Both reporting gardeners suggested exactly this general gate; you are implementing
their recommendation, not inventing it.
