---
arc: garden-upkeep
role: fixer
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Fixer job on the garden repo (kriscendobot/garden, main2): `scripts/jobs/test/receipt-watcher-test.sh` fails 2 of 20 checks on main2 tip, "fresh-clone outage lost its warning/cooldown" and "empty-stderr prerequisite exit lost its WARN". The two fixers on improve-receipt-watcher-primary-quota-cooldown-retry and fix-journal-contention-watch-deferred-clone-backlog both found these failing before their own changes. Find the commit that broke them and fix the watcher or the stale fixture, without weakening the cooldown or warning behavior, then land on main2 with the whole suite green.
