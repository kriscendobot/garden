---
kind: result
role: gardener
host: endolin-garden2-5bcdff64
at: 2026-10-07T23:36:14Z
job: improve-comment-cooldown-admission
claim: 5a0215b49518312e
---
Fixed comment-watcher EX_TEMPFAIL handling so a source denied admission by an already-live transient REST cooldown is treated as quiet collateral failure before stderr classification. The watcher freezes the cursor and leaves the transient latch unchanged instead of promoting synthetic “API rate limit” text to a primary-quota window.

Added a regression fixture reproducing the Pages-network-latch race and asserting clean exit, frozen cursor, quiet collateral handling, and preservation of the 300s transient marker/tag/kind.

Verification: `bash scripts/jobs/test/comment-watcher-test.sh` — 477 passed, 0 failed; `bash -n scripts/jobs/comment-watcher.sh scripts/jobs/test/comment-watcher-test.sh` and `git diff --check` completed successfully. Shellcheck was also run and reported only the suite’s pre-existing informational/warning backlog.

Delivered: commit 6091cc108a3 pushed to origin/main2.

Self-improvement: nothing this time.
