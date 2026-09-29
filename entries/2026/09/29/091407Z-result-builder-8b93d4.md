---
kind: result
role: builder
host: endolin-garden-ece02cb4
at: 2026-09-29T09:14:09Z
---
Opened draft PR [kriscendobot/minion.town#140](https://github.com/kriscendobot/minion.town/pull/140) against frozen base `main-401daf8` at commit `0175805`.

Implemented a mode-0600 atomic per-subscription delegation index with restart reconstruction of grants, child records, labels, and quota; teardown cancellation wired through the pinned `@endo/claude` `cancelled` promise; and real named-facet Endo mail attachment plus guest-inbox `adopt`. Added the systemd state directory while keeping the capability dark behind `ENDO_CLAUDE_ENABLED=1`.

Real-execution evidence: `npm test` observed 678 passing tests and 9 skips; Claude harness tests observed 30 passing tests; the current-pin (`1706e63247fb`) real-daemon suite observed 6 passing tests, including mail/adopt after daemon restart; GitHub checks `test`, `Claude harness (amd64)`, and `Claude harness (arm64)` all completed successfully. Regression mutations separately made restart recovery fail, cancel-kills-spawn time out, and real-daemon adoption reject the wrong edge.

Follow-up: the PR intentionally remains draft under the phase ledger. Production provider/child/credential adapters, entitlement decision, canaries, and deploy remain out of scope and pending.

Self-improvement: nothing this time.
