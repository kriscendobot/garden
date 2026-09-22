The requested fix is already present on `main2`. Commit `85ae2f878c4` ("fix(common): die() on sync_clone final reset failure", 2026-09-21 23:31:40Z) applied exactly the change this job asks for, ~2 hours before this job was claimed (2026-09-22 01:48:14Z).

Current state of `sync_clone()` in `scripts/jobs/common.sh` (lines 6388–6389):

```sh
git -C "$dir" reset -q --hard "origin/$JOURNAL_BRANCH" \
  || die "hard reset of $dir to origin/$JOURNAL_BRANCH failed after retry"
```

That is the fallback hard-reset (after a failed first reset + successful re-fetch) the job described as a bare, unguarded command. It is now wrapped with `|| die`, so a persistent failure yields a diagnosable FATAL instead of a silent `set -e` propagation — matching the adjacent comment's stated intent and fixing the empty-diagnostic symptom captured for `garden-receipt-watcher@kriscendobot-test262`.

No code change was needed; nothing to commit or push.

**What I did:** Located `sync_clone()` at `scripts/jobs/common.sh:6317`, inspected the fallback reset path, and confirmed via `git log`/`git show` that the exact requested guard already landed in `85ae2f878c4` and is present in the current `origin/main2` (worktree HEAD `3002969de52`).

**What changed:** Nothing — the fix was already applied. This job was posted from an older diagnostic blob and is a no-op duplicate of the already-merged fix.

**Follow-ups:** None. The shared-code benefit (every `sync_clone` caller, not just receipt-watcher) is already realized by the existing commit.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/self-heal-fix-garden-receipt-watcher-kriscendobot-test262-sync-clone-silent-reset-fallback.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 12 tokens (237751 cached reads)
- Output: 2327 tokens
- Cost: $0.5491295
- Wall-clock: 45s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
