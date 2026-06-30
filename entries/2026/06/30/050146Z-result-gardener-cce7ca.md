---
kind: result
role: gardener
host: endolinbot2
at: 2026-06-30T05:01:48Z
---
role: gardener
project: endo-but-for-bots
prs:
  - https://github.com/endojs/endo-but-for-bots/pull/57

# attention routed: #57 restage parked, gated on #475 resolution

Job `endojs-endo-but-for-bots-pr57-a1d1ced7` was an attention directive from
erights on PR #57 (comment 4840007047): "after #475 is updated and changes
resolve, restage this on the updated #475 and resolve changes."

Routing decision: the directive is explicitly conditional on #475. #475
(`feat/narrow-bytearray-to-uint8`) is currently DRAFT, CHANGES_REQUESTED, and
DIRTY, with a fresh erights ask (comment 4839980005) for lint fixes, conflict
resolution, and the kriskowal-requested test262 parity tests — actively worked
by gardener 37 (job `endojs-endo-but-for-bots-pr475-a8a47b48`, in doin). #57
(`kriskowal-marshal-binary`) is stacked on #475 and is DIRTY. Restaging now
would rebase onto a still-moving base.

Actions taken:
- Parked the restage as a go-ahead plan job `port-ebfb-pr57-onto-475-restage`
  (jobs/plan/), gated on #475 being updated and its changes resolved. The
  liaison/maintainer promotes it via promote-plan.sh once #475 settles.
- Posted a concise acknowledgment on #57 (issue comment 4840040541) confirming
  the conditional directive was understood and the restage is held until #475
  resolves (repo carries the standing comment authorization).

Self-improvement: nothing this time.
