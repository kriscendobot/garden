---
posted_at: 2026-11-05T03:52:26Z
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/issue-status-pass.sh
`scripts/jobs/issue-status-pass.sh:166,189,204` invokes the source and comment reads without a tick-level remaining-time bound, leaving systemd to terminate the entire pass. `garden-issue-status.service` timed out at 2026-11-05T03:40:44Z amid GitHub API timeouts and quota exhaustion. Add an internal deadline with bounded source/comment calls that exits cleanly before the service timeout, preserves retry-on-next-tick semantics, and test the timeout path.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-11-05T03:53:05Z
