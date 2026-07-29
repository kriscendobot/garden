In the garden's own repo (kriscendobot/garden), investigate why the job `endojs-endo-but-for-bots-pr882-shepherd` carried `garden-reaped: 4` — it was claimed and reaped four times even though the PR's CI was green (22:27Z) well before the first claim (01:23Z), suggesting worker death rather than shepherd overrun. Check the reaper and gardener-worker logs across hosts, identify the failure mode, and report findings (fix only if the cause is clear and low-risk).

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 3
  worker_kind: gardener
  claimed_at: 2026-07-29T01:29:31Z
