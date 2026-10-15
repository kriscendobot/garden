---
kind: result
role: corner-prober
host: endolin-garden-ece02cb4
at: 2026-10-15T09:30:45Z
job: kriscendobot-minion.town-pr184-gauntlet-panel-8
claim: 4000e5871ea2b3c5
---
project: minion-town
refs: PR #184 (kriscendobot/minion.town), base origin/main-bc11010

Corner-prober review of PR #184.

Covered: empty run list; singleton recent and stale completed runs; exact 3.5-hour freshness boundary; skew just inside and outside five minutes; small and far-future timestamps; malformed timestamps and API payloads; skipped, cancelled, unknown, and unrelated-event runs; in-progress; recent queued; old queued and waiting; ordered multiple runs; event-field isolation; fixed branch.

Missing: exact five-minute future-skew equality; exact one-hour queued equality; exact one-hour waiting equality. The handler uses strict inequalities, so add tests that each equality value dispatches, pinning the stated "less than an hour" and permitted-skew contracts.

Verification: git diff --check; bash -n on both changed deployment scripts; node --test deploy/aws/ci-runner/lambda/test/index.test.mjs deploy/aws/ci-runner/lambda/test/prod-probe-backstop.test.mjs (29 passing).

Self-improvement: nothing this time.
