Pushed to main2 (`762390ec8e4..2b02aa1ae38`). The remote-moved notice is the documented `kriskowal/garden`→`kriscendobot/garden` redirect, harmless.

## Completion report

**Job:** `improve-triager-pace-lock-contention` — make the optional triager pacing-clone refresh fail fast under live clone-lock contention.

**Problem:** `triager_pace_schedule` runs `ensure_clone` + `sync_clone` on the shared pacing clone purely to compute a nonessential next wake. Both take `clone_lock`, which under a busy live holder paid the default ladder (3 × 60s waits) and then `die`d FATAL — recurring FATAL log noise plus otherwise-complete ticks delayed ~180s just to schedule a wake.

**Change (commit `2b02aa1ae38` on main2):**
- `scripts/jobs/common.sh` — added a SOFT clone-lock mode. New knob `GARDEN_LOCK_SOFT_WAIT` (default 5s). When `GARDEN_CLONE_LOCK_SOFT=1`, `clone_lock` makes ONE short bounded attempt (no 3×60s ladder) and, on a busy live holder, logs a single WARN and `exit`s `GARDEN_OFFLINE_RC` (temporary/retry-next-tick) instead of the FATAL give-up. Stale-lock reclaim still runs; all other callers are unchanged (default wait/retries preserved via locals).
- `scripts/jobs/triager.sh` — the pacing subshell exports `GARDEN_CLONE_LOCK_SOFT=1`. The soft `exit` aborts the optional refresh cleanly; the nonzero subshell then hits the **existing fail-open warning latch** (`triager_pace_note_warning`) and keeps the fixed timer cadence for that tick.
- `scripts/jobs/test/triager-pacing-test.sh` — added a regression test: a live pacing-clone lock holder makes the tick take the soft path (asserts the soft WARN, the fail-open latch, no FATAL, and completion within a fast bound — well under the old ~180s).

**Verification:** `triager-pacing-test` 6/6 (incl. new case), `triager-test` 143/143, `stale-lock-test` 9/9, `cursor-set-concurrency-test` 8/8; `bash -n` clean on both scripts.

**Note / process incident (resolved):** My first pass mistakenly targeted the **deployed garden root** paths (`/home/kris/garden2/scripts/jobs/...`) instead of the per-job worktree, briefly leaving experimental edits live on this host's fleet scripts. I caught it, confirmed the deployed root was at the identical commit (`762390ec8e4`), restored both files byte-for-byte from the committed blobs (verified via `diff`), and only ran read-only git there. No git was ever run in the deployed root and no journal/repo corruption occurred; the real work was then done and committed from the worktree.

**Follow-ups:** none required.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-triager-pace-lock-contention.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 92 tokens (4038279 cached reads)
- Output: 43024 tokens
- Cost: $4.2301425
- Wall-clock: 661s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
