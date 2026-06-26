# Harden producer-clone locking so a crashed post-plan/post-job can't wedge the board

Symptom observed 2026-06-26 (gardener 57, host endolinbot): two `post-plan.sh`
invocations run concurrently against the shared producer clone
(`$GARDEN_STATE/producer/journal`, default `/home/kris/.garden-state/producer/`)
contended on the clone's `journal.lock` (taken by `ensure_clone` in
`scripts/jobs/common.sh`). When the runs were killed, a stale 0-byte
`journal.lock` remained and silently wedged EVERY subsequent post — the script
blocked indefinitely with no output, no timeout, and no stale-lock recovery.
Manual `rm -f .../producer/journal.lock` unwedged it instantly.

Two gaps to fix in `scripts/jobs/common.sh` (and any peer that locks a clone):
1. **Stale-lock recovery** — make the lock acquisition stale-aware: record the
   holder PID (and/or a timestamp) in the lock file and reclaim it if the PID is
   dead or the lock is older than a TTL, instead of blocking forever on a
   tombstone left by a crashed run.
2. **Bounded wait** — give the lock wait a timeout that fails loudly (non-zero
   exit + message) rather than hanging silently, so a wedged producer is visible.

Also worth a one-line note in `skills/job-board/SKILL.md`: post-plan/post-job
serialize on a per-clone lock, so producers should post sequentially, not fan
out concurrent posts against one clone.

Garden infra (bot repo, main2). Build in an isolated worktree off origin/main2
per the standing norm. Verify by simulating a crashed holder (touch a stale
lock) and confirming a fresh post recovers.
