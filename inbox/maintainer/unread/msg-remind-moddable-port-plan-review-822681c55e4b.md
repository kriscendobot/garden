from_host: endolin-garden-ece02cb4
from: gardener:remind-moddable-port-plan-review
reply_to: remind-moddable-port-plan-review
msg_key: msg-remind-moddable-port-plan-review-822681c55e4b
notice_count: 1
first_seen: 2026-10-19T17:37:30Z
last_seen: 2026-10-19T17:37:32Z
sent_at: 2026-10-19T17:37:32Z
---
Reminder (scheduled 2026-10-15): review the Moddable SDK 10.0.0 IronHorse port plan now that the Claude pool has reset (2026-10-17 03:00 UTC) and before the Codex pool resets.

- Design PR (draft, Endo changes stay on your review): https://github.com/endojs/endo-but-for-bots/pull/1435
- The design document: https://github.com/endojs/endo-but-for-bots/blob/design/moddable-10-0-0-ironhorse-port-plan/designs/moddable-10-0-0-ironhorse-port-plan.md
- Last panel verdict (round 6, must-fix on prose mechanics; the critic called the design sound): https://github.com/endojs/endo-but-for-bots/pull/1435#pullrequestreview-5480588317
- Open gap in the child 6 gate: its stop rule does not count bulk timeouts, and requiring all five port PRs merged deadlocks the campaign if the R22 child takes its no-go exit.
- Parked implementation jobs, held behind a go-ahead and not started (journal2 branch of kriscendobot/garden):
  - https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/moddable-10-0-0-ironhorse-builtins-order-port.md
  - https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/moddable-10-0-0-ironhorse-callability-port.md
  - https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/moddable-10-0-0-ironhorse-compiler-safety-port.md
  - https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/moddable-10-0-0-ironhorse-immutable-arraybuffer-port.md
  - https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/moddable-10-0-0-ironhorse-typedarray-port.md
  - https://github.com/kriscendobot/garden/blob/journal2/jobs/plan/moddable-10-0-0-ironhorse-oracle-validation.md
- The ports run the full corpus and a five-host matrix, so hold the go-ahead until the pools can afford them.
