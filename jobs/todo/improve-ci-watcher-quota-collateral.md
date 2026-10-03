---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/ci-watcher.sh
scripts/jobs/ci-watcher.sh:464-507 fatals on an rc=75 collateral source failure after comment-watcher latched the REST primary-quota cooldown at 2026-10-03 19:39:40Z. Add the same live primary-quota-latch degradation guard used by comment-watcher.sh:1762-1767/1849 before `die`, so concurrent CI ticks exit cleanly without advancing state or restarting their units.
