---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/gardener.sh
Treat a conclusive completion-time draft-gate block as a terminal, deduplicated manual-gauntlet handoff rather than a handler failure that the reaper retries. Two already-complete jobs were left in `doin` solely because their PRs were ready without a gauntlet; preserve the no-re-draft safety rule, record one maintainer-visible action, and avoid repeated agent runs.
