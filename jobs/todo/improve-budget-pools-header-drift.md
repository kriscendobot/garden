---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/set-budget-pool.sh
When promoting a cap, update or remove mutable calibration values in the config header as well as the authoritative pool row. The current verbatim-comment preservation left a superseded 595M calibration claim beside a live 143M cap, creating misleading operational state; add regression coverage for this synchronization.
