---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
scripts/jobs/comment-watcher.sh
The comment source's `gh api .../pulls?state=open...` call timed out (rc=124) at 18:28:35 and was logged as "definitive; not retrying". The watcher then died with FATAL rc=1 (18:28:44), which left `garden-comment-watcher@kriscendobot-garden.service` in a failed state. A timeout says nothing about the repo, so it should not be treated as definitive. Classify rc=124 as transient: retry once with backoff, and if it still fails, log a WARN and exit 0 with the cursor frozen. That matches how the rc=75 quota path behaves. This stops the failed-unit noise and the extra mentor and self-heal work it triggers.

---
claim:
  host: oros-studio-garden-ce242c49
  gardener: 3
  worker_kind: monk
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-10-16T00:36:03Z
