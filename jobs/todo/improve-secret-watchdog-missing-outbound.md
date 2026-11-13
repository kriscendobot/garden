---
posted_at: 2026-11-13T03:50:57Z
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/secrets/watchdog.sh
scripts/secrets/watchdog.sh:40 exits under `set -euo pipefail` when an installed key has no `outbound/<kind>` directory; the 2026-11-13T03:21:00Z secret watchdog failure coincides with `typesafe.key` installed but no `outbound/typesafe`. Treat a missing per-kind directory as zero accepted uses and continue to issue the idle alert; add regression coverage.
