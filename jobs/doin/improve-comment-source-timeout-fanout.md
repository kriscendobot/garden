---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/handlers/comment-source-gh.sh
scripts/jobs/handlers/comment-source-gh.sh:366-377 serially makes two paginated REST reads per recently updated PR, exhausting comment-watcher.sh’s 180s source deadline three times at 05:56:42, 06:06:57, and 06:19:19. Batch or bounded-concurrently fetch the per-PR review metadata while retaining complete coverage and the fail-closed cursor contract. Add a regression test with enough active PRs to prove the source completes before its deadline without silently omitting review surfaces.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 3
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-10-06T07:09:21Z
