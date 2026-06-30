In `scripts/jobs/comment-watcher.sh`, after `classify` resolves a non-finalize directive verb (`rebase|retcon|refresh|gauntlet`, around line 865 where `base` is computed), there is no terminal-PR-state check before minting the job — only the `finalize` verb runs the `GARDEN_PR_MERGEABLE` probe and drops on rc 2 (already merged/closed). Consequence: a stale directive on an already-MERGED/CLOSED PR mints a live job that the gardener can only resolve as a no-op (the #9 rebase directive arrived ~2 months after the PR merged; the conductor likewise found #343 already merged on arrival). Fix: before minting a rebase/retcon/refresh/gauntlet job, run the existing `GARDEN_PR_MERGEABLE "$repo" "$pr"` probe and, on rc 2 (already merged/closed), log + drop + slide the cursor (same shape as the finalize-path rc-2 branch at line 858) instead of posting the job. This moves the "is the target still live?" judgment out of the gardener dispatch and into the deterministic pre-mint guard, reusing infrastructure already present in the file.

---
claim:
  host: endolinbot2
  gardener: 19
  claimed_at: 2026-06-30T23:22:05Z
