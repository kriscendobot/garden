---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
`scripts/jobs/ci-watcher.sh`'s `verify_fetch` (around line 199) calls `ensure_clone_or_latch_outage "$VERIFY" ci-watcher-verify` and `journal_fetch "$VERIFY"` back-to-back with no `clone_lock` held across both calls. With ~15+ per-repo ci-watcher instances sharing the single `$GARDEN_STATE/ci-watcher/verify` clone, concurrent ticks can race a clone-check against a fetch on the same clone unlocked, producing corrupt/missing clones that force repeated full reclones — which then exhaust sibling instances' `clone_lock` wait budget (3×60s) and FATAL with "cannot acquire clone lock ... verify.lock" (exit 1, e.g. garden-ci-watcher@kriscendobot-ymax-stdio-mcp, 2026-09-26T23:56Z).

This is the identical bug class already fixed in `scripts/jobs/comment-watcher.sh`'s `verify_fetch` on 2026-09-25 (commit `46e100b6641`, job `improve-comment-watcher-verify-fetch-lock-window`): wrap the clone-check + fetch in `clone_lock "$VERIFY"` / `clone_unlock "$VERIFY"`, running `ensure_clone_or_latch_outage` in a subshell (so its internal `clone_unlock` only drops the subshell's fd copy) and re-raising its offline exit code after unlocking. Apply the same fix to `ci-watcher.sh`'s `verify_fetch`, and add the analogous VLOCK regression-test section to `scripts/jobs/test/ci-watcher-test.sh` (comment-watcher-test.sh has the reference pattern: assert every VERIFY fetch runs while the lock is held, and that the lock is released after the run).
