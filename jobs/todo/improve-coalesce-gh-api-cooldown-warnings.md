---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/common.sh
`common.sh:5653` warns for every request refused by an already-live shared cooldown; the 2026-10-03T13:40:12Z journal tail shows one quota episode producing repeated warnings. Record a per-latch emission marker under the existing shared cooldown state so only the latch owner or first suppressed caller warns, while later refusals stay quiet and retain their nonzero status. Add coverage for concurrent suppressed callers.
