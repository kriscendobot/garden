The fix is committed, pushed to `main2`, and verified.

## Completion report

**Job:** Self-heal the routine cross-instance contention that made `garden-receipt-watcher@<slug>` instances die with `FATAL: receipt journal prerequisite failed` (empty prerequisite stderr).

**Root cause:** `scripts/jobs/receipt-watcher.sh` defaulted `GARDEN_RECEIPT_WATCH_CLONE` to one shared clone (`$GARDEN_STATE/receipt-watcher/journal`) for all 16 templated instances. They run concurrently (OnUnitActiveSec=300s, RandomizedDelaySec=60s) with 30–100s+ wall times, so their `ensure_clone`/`sync_clone` (fetch + `git reset --hard`) all serialized on the single sibling `clone_lock` — a queued-out loser exited via `set -e` inside the subshell without a diagnostic, producing the empty-stderr FATAL recurring across differing slugs in the same window.

**Fix (`scripts/jobs/receipt-watcher.sh`):**
- Changed the default clone to a **per-slug** path: `$GARDEN_STATE/receipt-watcher/journal-$slug`. Confirmed via `common.sh`'s `_clone_lockfile()` (`${dir}.lock`) that a per-slug clone dir yields a per-slug sibling lockfile, so instances no longer share a lock or race each other's fetch/reset.
- Removed the now-moot `GARDEN_LOCK_RETRIES=12` override (the prior shared-clone mitigation from commit `06b4d5eeff5`); a watcher instance is a systemd singleton per instance name, so its own clone has no concurrent users and `common.sh`'s default budget suffices.
- Rewrote the rationale comment to document the per-slug design and note the clone set is bounded (one per armed slug, reused across ticks — not an unbounded per-id leak).

**Test (`scripts/jobs/test/receipt-watcher-test.sh`):** Added a `run_watch_default` helper (runs without pinning the env var) and an assertion that two distinct slugs land in two distinct `journal-<slug>` clone dirs. Existing 10 checks all still pass (they pin the env var explicitly, so unaffected); total now 11 passed, 0 failed. `bash -n` and `shellcheck -S warning` both clean.

**Verification:** Full test suite green; pushed to `main2` as `05c22e5c0e9`.

**Follow-ups:** None required. Note for operators: on next deploy each host will create up to 16 small per-slug clones under `$GARDEN_STATE/receipt-watcher/` on first tick; the old shared `journal` clone becomes orphaned and can be removed at leisure (harmless if left).
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/self-heal-fix-garden-receipt-watcher-kriscendobot-cosgov-shared-clone-contention.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 40 tokens (1264913 cached reads)
- Output: 14232 tokens
- Cost: $1.6339654999999997
- Wall-clock: 248s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
