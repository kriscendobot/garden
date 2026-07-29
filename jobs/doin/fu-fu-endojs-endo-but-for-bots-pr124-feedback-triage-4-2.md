In the garden's own repo (kriscendobot/garden, branch `main2`, no PR workflow), wire `scripts/jobs/annotate-plan.sh --key <comment-id>` into the PR-comment-driven triage path (`scripts/jobs/comment-watcher.sh` and whatever posts plan entries from it) so a re-posted comment annotates the existing plan entry instead of silently no-opping through `post-plan.sh` or hand-rolling an append. Keep the change idempotent and land it directly on `main2`.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 7
  worker_kind: gardener
  claimed_at: 2026-07-29T02:18:48Z
