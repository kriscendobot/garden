---
posted_at: 2026-11-05T12:22:04Z
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/deploy-garden.sh
scripts/jobs/deploy-garden.sh:507 records an rc=1 suite failure with an empty diagnostic, as the 2026-11-05T11:51:31Z rejection shows. When a captured suite output is empty, append deterministic invocation and gate-state context so deploy failures remain actionable.
