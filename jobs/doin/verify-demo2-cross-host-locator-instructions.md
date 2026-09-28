---
role: gardener
tier: mentor
fallback-tier: minion
dispatch: automatic
handler-timeout: 14400
token-budget: 800000
---
# Verify demo 2: adopt a live capability across the network, from your own laptop

Maintainer request (kriskowal, comment on
https://github.com/kriscendobot/garden/issues/114#issuecomment-5864051232):
"Please expand all of these into verified step-by-step instructions." This
job covers demo idea #2 from that issue's body only — read the full issue
first for the exact pitch and script sketch.

## The pitch (issue #114, demo 2)

Sign into minion.town, reveal your guest's locator, paste it into your own
local `endo adopt-locator` (`endojs/endo-but-for-bots`#1333, currently
**draft**), call a method on your minion.town guest live over OCapN-Noise
from a machine that has never talked to that daemon before. The issue body
itself already notes: "the underlying connectivity is proven live (two real
daemons, survives a restart), but production activation on minion.town is
gated on a security review in flight (session-binding fix, #1335)." Verify
this is still current before proceeding — check #1333 and #1335's live
state.

## What "verified" means here — two distinct claims to check separately

1. **The bench/dev claim** ("two real daemons, survives a restart"): find
   and actually re-run whatever proved this (a prior press/job record, a
   test) rather than trusting the issue body's summary. Confirm it still
   holds on current code.
2. **The production-on-minion.town claim**: this is explicitly gated on
   #1335 landing and being activated. Do not attempt to force or bypass that
   gate. If #1335 is still draft/unreviewed when you run this (it has been
   for two days as of 2026-09-28, awaiting the maintainer's own review),
   report the demo as NOT YET runnable in production, name #1335 as the
   exact blocker, and produce the verified steps for whichever environment
   you CAN actually exercise (a local/bench two-daemon setup is a legitimate
   partial answer here, clearly labeled as such).

## Deliverable

1. A precise, reproducible step-by-step runbook for whatever you could
   actually verify, clearly labeled dev/bench vs. production, with the exact
   commands (`endo adopt-locator minion-town`, `endo eval`, etc. — verify
   the real current CLI surface, don't guess from the issue body's
   shorthand).
2. Post it as a REPLY COMMENT on
   https://github.com/kriscendobot/garden/issues/114 (issue-inbox routed
   work; reply on the thread per `skills/issue-inbox/SKILL.md`, do not close
   the issue). Lead with a one-line verdict (fully verified / bench-only /
   not yet verifiable, and why) before the runbook.
3. Your job completion report: the same content, plus the comment URL.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-28T14:26:38Z
