---
arc: garden-upkeep
role: fixer
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Fixer job on the garden repo (kriscendobot/garden, main2): the bounded-tick fix from `25d00928de4` is deployed, but on endolin-garden-ece02cb4 `scripts/jobs/journal-contention-watch.sh` still reports `journal-contention-watch-overrun` on every tick. The coalesced notice has fired 77 times since 2026-10-04, most recently at 16:38Z, and shows a backlog of 102 deferred clone inspections that never shrinks. Make the deferred clone inspections drain across ticks: rotate through the clones and persist a cursor so each tick makes progress, skip or cheaply re-check clones that are busy. Raise the overrun notice only when a tick makes no progress. Add a regression test in `scripts/jobs/test/journal-contention-watch-test.sh` that checks a backlog of about 100 clones drains over a bounded number of ticks.
