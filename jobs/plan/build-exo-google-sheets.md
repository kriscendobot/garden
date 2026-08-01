---
gate: deferred
priority: normal
posted_by: liaison
posted_at: 2026-08-01T09:39:01Z
---
# EMPTY JOB — held, needs re-specification

Body was LOST through the poison/requeue cycle (0 bytes of spec). Re-posted here by the liaison 2026-08-01 after being promoted in error during the outage-recovery sweep: an empty job can only misfire or spawn a duplicate. Re-post with a real spec if the work is still wanted. SUPERSEDED per the esheets supervisor (2026-08-01): the actual client+exo implementations are endojs/endo-but-for-bots#874 (Phase 1, DRAFT/green) and #881 (Phase 2, DRAFT/CONFLICTING, stacked on #874). Recommend cancelling rather than re-specifying.
