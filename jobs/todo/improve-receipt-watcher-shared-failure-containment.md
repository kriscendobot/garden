---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/receipt-watcher.sh
Harden the shared prerequisite/source failure path so a fleet-wide `gh`/journal availability problem yields a bounded, cooldown-backed skipped tick rather than simultaneous exit-code failures for every per-repo receipt watcher; preserve a clear diagnostic for persistent non-transient failures.
