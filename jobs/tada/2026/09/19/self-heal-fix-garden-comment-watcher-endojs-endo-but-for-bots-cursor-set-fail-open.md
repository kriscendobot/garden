The job is already complete. No further work is needed.

## Completion report

**Status: already done by a prior (reaped) attempt — verified, nothing left to do.**

The prior attempt of this job committed and pushed the fix as `3f6b7911fa` ("fix(jobs): fail open on nonzero cursor-set.sh rc at the cursor-advance step"), now on `origin/main2`/`HEAD`. On re-deriving state from committed history I confirmed it delivers exactly the job spec:

- Applies the same rc-capture-and-fail-open pattern from `df83fca235` (the read-side cursor-get.sh fix) to the cursor-set.sh **write** at the tail of each watcher's tick.
- Covers all three required call sites:
  - `scripts/jobs/comment-watcher.sh`
  - `scripts/jobs/mention-watcher.sh`
  - `scripts/jobs/issue-inbox-watcher.sh`
- Each bare `printf ... | cursor-set.sh "$CURSOR_KEY"` pipe is now wrapped as `if printf ... | cursor-set.sh; then rc=0; else rc=$?; fi`, and on nonzero rc logs `WARN: cursor advance failed for $CURSOR_KEY (rc=$rc); will re-advance next tick` then `exit 0` — falling through cleanly instead of tripping `set -e`/`pipefail` into a silent hard crash.

Verification: all three scripts pass `bash -n`; the working tree is clean (nothing uncommitted to add).

Follow-ups: none.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/self-heal-fix-garden-comment-watcher-endojs-endo-but-for-bots-cursor-set-fail-open.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s) (1 unmetered)
- Input: 8 tokens (136227 cached reads)
- Output: 1572 tokens
- Cost: $0.43773349999999994 (1 engagement(s) unpriced)
- Wall-clock: 36s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
