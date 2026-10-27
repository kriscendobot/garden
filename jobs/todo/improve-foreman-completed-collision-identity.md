---
posted_at: 2026-10-27T18:22:05Z
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/foreman.sh
scripts/jobs/foreman.sh:615 posts LLM-selected milestone basenames without an identity, so the 2026-10-27T18:10:12Z completed-job collision rejected `endojs-endo-but-for-bots-pr1425-fix-panel-findings-ci` (rc=79).
Derive and pass a deterministic foreman decision identity from the normalized milestone context, so an unchanged decision remains idempotent while a fresh recurrence can post despite an old `tada/` basename.
Keep the existing one-reprompt fallback for malformed or duplicate proposals, but make recurrence disambiguation scripted rather than dependent on agent naming.
