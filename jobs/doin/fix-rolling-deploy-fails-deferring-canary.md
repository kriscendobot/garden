---
role: fixer
priority: normal
posted_by: liaison
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Fix: the leader fails and drains a canary that is deliberately deferring for a long job

Repo: the garden itself (`kriscendobot/garden`, `main2`, push direct, no PR).

## Observed twice (2026-09-24 22:38Z and 2026-09-25 01:08Z, follower endolin-garden2-5bcdff64)
- The follower's `self-deploy` is released and calls `deploy-garden.sh`, which correctly DEFERS:
  `DEFERRED: monk 1 has been mid-job 4545s (>= 300s long-job threshold) … Nothing was advanced.` It retries every 3 min.
- The leader's `rolling-deploy.sh` sees "released 1500s ago but never advanced to the target sha" → marks the
  canary FAILED → sends a `drain on` sysop op (retry 0/3). The drain stops new claims on ALL of the follower's workers
  until the long job ends, then retry 1 lifts it and the deploy lands (22:53Z → 22:56Z the first time).
- So the outcome is right, but for the wrong reason, and the whole host sits idle for up to an hour per deploy.

## Ask
1. Have the follower publish its deferral as a status the leader reads (e.g. `deferred: long-job <kind> <id> <elapsed>` in
   the roll status it already publishes for `roll-drained`). The leader should treat an actively-deferring canary as
   **waiting**, not failed, and extend its advance deadline while deferral continues. Keep a hard ceiling (e.g. the
   job's own handler budget) after which it is a real failure.
2. Decide whether a deferring canary should get a *targeted* drain (stop new claims so the long job is the last one)
   rather than none. If so, make it an explicit, logged "quiesce for deploy" state, not a canary-failure drain, and don't
   count it against the retry budget.
3. Tests for: deferring canary → waiting (no failure, no retry consumed); deferral beyond the ceiling → failure;
   genuinely stuck canary (no deferral status) → failure as today. Run the rolling-deploy and self-deploy suites and push.
   Complete via the normal completion path.

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 1
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-09-25T01:08:59Z
