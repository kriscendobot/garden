---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/handlers/foreman-claude.sh
scripts/jobs/handlers/foreman-claude.sh:124 fatals on a retired `local` entry, leaving the foreman unavailable at 18:09, 18:14, and 18:19. Filter retired `local` from the provider order with a one-time warning, then continue with remaining valid providers; fail only if none remain.
