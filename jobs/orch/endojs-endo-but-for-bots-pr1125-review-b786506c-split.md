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

split-indivisible-reason: Single design directive on endojs/endo-but-for-bots#1125 (minimize formula types: eliminate the new readable-directory formula type by expressing EndoDirectory.readOnly() as an evaluation formula that accepts a hub and calls readOnly) whose feasibility-assessment and implementation are one inseparable rework of a single slice of one PR head (bot/build/endo-guest-invite-primitive); there is no independently-specifiable second deliverable to hand a separate worker, so a designer->builder split would only yield a builder child whose body cannot be written until the designer finishes, and the single 7200s overrun reflects the slow multiplayer/SES/CapTP test loop rather than multi-part structure.

split-indivisible-handler-timeout: 14339

Single child: `endojs-endo-but-for-bots-pr1125-review-b786506c-expanded-window`
re-runs the identical work under a `handler-timeout: 14339` (> the prior 7200s
wall, at the safe single-claim ceiling of GARDEN_CLAIM_TTL -
GARDEN_HANDLER_KILL_AFTER - 1). Serial, on-child-failure halt.
