Pushed cleanly to `origin/main2` as `3f6b7911fa`.

## Completion report

**What the job asked:** Guard the `cursor-set.sh` cursor-advance invocation in the three garden watchers the same way commit `df83fca235` had already guarded the read-side `cursor-get.sh`, so a failed journal-push CAS (exhausted 50-attempt retry loop under contention, or a `GARDEN_OFFLINE_RC=75` outage) fails open with a WARN instead of tripping `set -euo pipefail` and silently crashing the whole tick.

**What I did:**
- Wrapped the `printf ... | cursor-set.sh "$CURSOR_KEY"` pipe in each watcher with `if printf ... | cursor-set.sh; then rc=0; else rc=$?; fi`. Under `pipefail`, `rc` captures `cursor-set.sh`'s nonzero exit; on any nonzero rc the watcher logs `WARN: cursor advance failed for $CURSOR_KEY (rc=$rc); will re-advance next tick` and `exit 0` rather than crashing. Added an explanatory comment at each site mirroring the read-side commit.
- Files changed (worktree, on `main2`):
  - `scripts/jobs/issue-inbox-watcher.sh` (~line 675)
  - `scripts/jobs/comment-watcher.sh` (~line 2096)
  - `scripts/jobs/mention-watcher.sh` (~line 491)
- All three pass `bash -n`. Committed as `3f6b7911fa` and pushed to `origin/main2`.

**Note on process:** My first three `Edit` calls landed in the **deployed garden root** (`/home/kris/garden2/scripts/...`) instead of my job worktree, because I passed the root's absolute path. I caught this immediately (the worktree commit came back "nothing to commit"), reverse-edited the three root files back to byte-identical committed state (verified via `diff` against the clean worktree; 0 residual hits), and re-applied the changes in the worktree. No git command was ever run in the deployed root, so journal sync is uncorrupted. Final state: deployed root clean, fix committed and pushed from the worktree only.

**Safety rationale (unchanged from spec):** a stalled cursor loses no data — a subsequent tick re-derives and re-advances it, and dispatch is idempotent by spine (issues) or GitHub comment id (comments/mentions).

**Follow-ups:** none. The fix takes effect on the next watcher tick after deploy; no units reconcile needed for the source change itself (it deploys with the next `deploy-garden.sh`).
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/self-heal-fix-garden-issue-inbox-cursor-set-fail-open.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 44 tokens (1143107 cached reads)
- Output: 14570 tokens
- Cost: $1.4546824999999999
- Wall-clock: 181s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
