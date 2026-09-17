---
child-endojs-endo-but-for-bots-pr1125-review-b786506c-expanded-window-host: endolin-garden-ece02cb4
child-endojs-endo-but-for-bots-pr1125-review-b786506c-expanded-window-reap-count: 0
order: serial
children: endojs-endo-but-for-bots-pr1125-review-b786506c-expanded-window
on-child-failure: halt
state: running
created_by: producer
created_at: 2026-09-17T07:59:30Z
---

# Split orchestration: endojs-endo-but-for-bots-pr1125-review-b786506c

Deliberate deadline-overrun split of the indivisible review-address job
`endojs-endo-but-for-bots-pr1125-review-b786506c`, which hit its applied 7200s
handler wall once without productive progress.

split-indivisible-reason: The review on endojs/endo-but-for-bots#1125 carries a
SINGLE design directive and no inline comments — minimize formula types by
eliminating the new `readable-directory` formula type, expressing
`EndoDirectory.readOnly()` instead as an evaluation formula that accepts a hub
and calls `readOnly`. Determining feasibility and implementing it are
inseparable: the implementation scope (which of directory.js / formula-record.js
/ formula-type.js change, and whether the elimination is feasible at all) is
defined by the investigation's own outcome and lives in the same files on the
same PR head branch (bot/build/endo-guest-invite-primitive). There is no
independently-specifiable second deliverable to hand a separate worker; a
designer->builder split would produce a builder child whose body cannot be
written until the designer finishes. It is one worker's continuous rework of a
single narrow slice of one PR plus a reply to the review thread; the prior
overrun reflects the slow multiplayer/SES/CapTP test loop, not multi-part
structure.

split-indivisible-handler-timeout: 14339

Single child: `endojs-endo-but-for-bots-pr1125-review-b786506c-expanded-window`
re-runs the identical work under a `handler-timeout: 14339` (> the prior 7200s
wall, at the safe single-claim ceiling of GARDEN_CLAIM_TTL -
GARDEN_HANDLER_KILL_AFTER - 1). Serial, on-child-failure halt.
