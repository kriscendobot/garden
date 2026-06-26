# Completion report — garden-harden-producer-clone-lock

## What was wrong
The producer-clone lock (`clone_lock`/`ensure_clone` in `scripts/jobs/common.sh`) already had **bounded waits** — the 2026-06-25 fetch hardening added `flock -w` + retries, so the "bounded wait that fails loudly" half of the job was already done. The real, still-open gap was **stale-lock recovery**: flock frees a *dead* holder on fd close, but a **killed** producer whose child inherited the open lock fd keeps the lock alive (an orphan). Every later post then blocked the full window and died, and the operator only ever saw a 0-byte `journal.lock` tombstone — `rm -f` was the only recovery. That is exactly the 2026-06-26 symptom.

## What I changed (commit `1e9b11138` on `main2`)
- **`scripts/jobs/common.sh`** — made the clone lock **stale-aware** on top of the existing bounded wait:
  - The acquirer **stamps `"PID EPOCH"`** into the lock file; the file is now opened **non-truncating (`<>`)** so a peeking waiter never wipes the stamp.
  - A waiter that times out **reclaims** the lock when the recorded holder is **dead** (`kill -0` fails — the orphaned-child case) **or** the stamp is older than **`GARDEN_LOCK_TTL`** (new, default 300s — comfortably above the worst legitimate hold of `FETCH_TIMEOUT × RETRIES + push`), then retries on a fresh inode.
  - Reclaim is bounded by **`GARDEN_LOCK_STEALS`** (new, default 2); the give-up path still **dies loudly** with the exact `rm -f` hint. A genuinely-busy live holder is **never** stolen from, and a wedge is never silent.
- **`scripts/jobs/test/stale-lock-test.sh`** (new, 7 checks, all pass) — a fresh live holder is never stolen from (exclusion preserved), a dead-PID holder is reclaimed, a live-but-`>TTL` holder is reclaimed via the TTL, and a stale tombstone on a real producer clone does not wedge a fresh `post-job`.
- **`skills/job-board/SKILL.md`** — one-paragraph note that `post-job`/`post-plan` serialize on a per-clone lock, so producers should post **sequentially**, not fan out concurrent posts.

## Verification
- New `stale-lock-test.sh`: **7/7 pass** (incl. the exclusion-preserved safety check).
- Existing `fetch-timeout-test.sh` (the lock/fetch regression guard): **4/4 pass** — unchanged behavior for a live holder.
- `run-test.sh` lock-using subtests (message bus, scaler) pass. SUBTEST 1 (gardener-fleet concurrency) and the claim path fail in this sandbox, but I confirmed they fail **identically on the unmodified `origin/main2` baseline** — sandbox-environmental, not introduced by this change.
- Built in an isolated worktree off `origin/main2`, rebased cleanly over a concurrent push (`a59ed7740`, no file overlap), pushed, worktree torn down.

## Follow-ups / notes
- The deeper root cause — a lock fd inherited across `exec` by children — isn't fully fixable from bash (no portable `FD_CLOEXEC` builtin, and the env-var borrow mechanism deliberately relies on child cooperation). The stale-reclaim layer is the correct remediation and now self-heals the wedge instead of needing a human with `rm -f`. No further action required unless a non-bash producer is introduced.
