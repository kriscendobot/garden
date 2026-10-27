---
posted_at: 2026-10-27T12:20:56Z
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/dependabot-watcher.sh
`scripts/jobs/dependabot-watcher.sh:193` uses the all-scope cooldown although its PR source is REST, unnecessarily silencing it after an unrelated GraphQL quota latch. Use `api_cooldown_active rest` (and cover it in the watcher test) so the REST source remains available; the 2026-10-27T12:19:42 REST quota warning still correctly blocks it through the host REST latch.
