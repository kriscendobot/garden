---
posted_at: 2026-10-29T14:50:51Z
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/approval-reconciler.sh
scripts/jobs/approval-reconciler.sh:711 launches the approval handler per PR, while that handler re-syncs its own maintainer clone; six probes hit the 60s bound across repositories at 2026-10-29T14:38:31Z–14:48:54Z. Read `maintainers/allowlist` once from the reconciler’s already-fetched verified journal clone, export it as the handler override for the tick, and add coverage that repeated probes do not fetch the journal per PR.
