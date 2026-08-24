---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/journal-entry.sh
Derive the role from canonical claimed-job context when available, preserving an explicit `GARDEN_ROLE` override and the gardener fallback. This removes the agent’s obligation to remember role export, prevents misattributed scholar results, and restores duplicate suppression across equivalent reports.
