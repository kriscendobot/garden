Everything is confirmed intact — no work to redo.

## Completion report (resumed session)

**Job:** `improve-xs2rust-press-deterministic-stall-preflight` — resumed after a reaper requeue.

**Finding on resume:** The job was already fully complete before the requeue. The reaper requeued it because the prior session was interrupted during teardown (a claim-record race), not because work was lost. The commit `911226b42` is present on `origin/main2` and carries both changes intact; the worktree is clean.

**What the change delivers (unchanged from the completed work):**
- `scripts/jobs/gardening/xs2rust-endor-press-preflight.sh` now encodes the mechanical stall bar. It persists the last-seen `xs2rust-endor` branch HEAD per-host under `$GARDEN_STATE/xs2rust-endor-press-preflight/last-head` (recorded every tick), and:
  - **Exit 2 (defer)** while the chain is advancing/owned: HEAD moved since the previous tick, a `xs2rust-endor-build-stage2*/-stage3*` child is live in `doin/` or on the bus, or a successor is queued in `todo/` (mid-handoff).
  - **Exit 0 (dispatch Fable driver)** only when the stall bar is met: HEAD unchanged across two consecutive ticks **AND** no live build child in `doin/`/bus **AND** no successor promoted into `todo/`.
  - Fails open (dispatch) on an unreadable HEAD or the first observation, to never starve a possible stall.
- `scripts/jobs/test/run-test.sh` SUBTEST 8c exercises all seven branches.

**Verification (re-run this session):** Isolated harness passes 9/9. Committed tree confirmed to contain both files. `origin/main2` HEAD == my commit; local worktree clean.

**Follow-up (not blocking, unchanged):** `run-test.sh` currently dies at the pre-existing SUBTEST 6 `maintainer-reply` FATAL under live fleet load (confirmed on the clean tree, upstream of and unrelated to this change) — worth a separate hardening job so the full suite runs to completion on a busy host.
