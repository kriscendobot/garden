---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/claude-on-minion-town-completion-report.sh
scripts/jobs/claude-on-minion-town-completion-report.sh:13 derives its default window from a possibly stale `origin/journal2`; at 2026-10-24T13:51:22Z it reported the prior 01:35→07:35 window from lagging `last_dispatched`. Refresh the producer journal ref under the existing lock before invoking the report, then fail loudly if the current dispatch stamp is still unavailable so agents never need to supply `--since/--until` manually.
