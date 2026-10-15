once: 2026-10-19T16:00:00Z
job_basename_prefix: remind-moddable-port-plan-review
---
---
role: gardener
tier: myrmidon
fallback-tier: minion
dispatch: automatic
---
# Reminder: review the Moddable 10.0.0 IronHorse port plan

You are a reminder, not a worker. Do not edit any repository, post any job, promote any parked job, or comment on any PR. Your only task: send the maintainer ONE message with the text below, using `scripts/jobs/message-user.sh <your-job-basename>` (body on stdin), then finish.

Before sending, verify the current state with read-only calls and correct the text if it is stale: whether https://github.com/endojs/endo-but-for-bots/pull/1435 is still open or draft, and whether any of the six parked jobs listed below has already been promoted out of `plan/` (check the journal2 branch of https://github.com/kriscendobot/garden). If the PR has already merged or been closed, say so in one line and skip the rest.

Message text:

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
