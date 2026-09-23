Pushed cleanly to main2.

## Completion report

**Problem:** All 16 armed `garden-receipt-watcher@<slug>` instances share one journal clone (`$GARDEN_STATE/receipt-watcher/journal`) and serialize on its sibling `clone_lock`. Under ordinary fan-out the whole herd wakes and queues on that lock; `common.sh`'s default budget (`GARDEN_LOCK_RETRIES=3` × `GARDEN_LOCK_WAIT=60s`) is explicitly sized for "per-service clones with no concurrent users" and lets a queued-out loser die loudly with `FATAL: receipt journal prerequisite failed` — which fired for kriscendobot-test262 at 00:33:48.

**Fix:** In `scripts/jobs/receipt-watcher.sh`, exported `GARDEN_LOCK_RETRIES=12` **before** `source "$HERE/common.sh"`, scoped to this script only. common.sh's `: "${GARDEN_LOCK_RETRIES:=3}"` defers to the pre-set export, so a queued instance now waits through up to ~15 peers' short journal-sync turns instead of dying on routine contention. Added a comment explaining the shared-clone fan-out and the scoping rationale.

**Why 12 (not a larger `GARDEN_LOCK_WAIT`):**
- Kept `GARDEN_LOCK_WAIT` at 60s so the 300s-TTL stale-reclaim (a genuinely hung/dead holder) still triggers within one wait window.
- Worst-case blocking is 12×60s + ≤24s backoff (2s cap × 12) ≈ 744s, safely under the unit's `TimeoutStartSec=900`. In practice a waiter acquires within the first 60s window since each peer holds the lock only for a brief fetch+sync; the extra retries are headroom for repeated flock wakeup-race losses, not steady-state cost.
- Global common.sh defaults left untouched — every other producer shares them and their clones are not fanned out.

**Verification:** `bash -n` clean; `scripts/jobs/test/receipt-watcher-test.sh` → 10 passed, 0 failed.

**Changed:** `scripts/jobs/receipt-watcher.sh` (commit `06b4d5eeff` on main2).

**Follow-ups:** None required. A deeper structural fix (parameterizing the receipt-watcher journal clone per-slug so instances stop sharing one lock entirely) would eliminate the contention rather than absorb it, but that is a larger change beyond this self-heal's scope.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/self-heal-fix-garden-receipt-watcher-kriscendobot-test262-shared-clone-lock-retries.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 24 tokens (592400 cached reads)
- Output: 5713 tokens
- Cost: $0.9009569999999999
- Wall-clock: 103s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
