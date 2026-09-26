Inbox empty. Work complete.

## Completion report

**Job:** Reaper requeues a claim while its handler is still alive (duplicate live incarnations).

**Diagnosis (from the journal + host journalctl for the 2026-07-05 window):**
- `GARDEN_CLAIM_TTL` is *not* misconfigured on endolinbot — it's the default 3600s. So the ~17-minute requeue cadence was **not** a TTL/handler-wall violation.
- `journalctl -u garden-reaper` proved the trigger: the reaper requeued `fable-review-fix-garden-scripts` because it carried a **gardener reap-now hint** (`age 1028s`, well under TTL). The reap-now hint is stamped by the gardener's *exit-0-unsatisfying* and *transient-failure* branches so a requeue can fire **below** the TTL by design.
- Confirmed via `/proc` that every live `claude -p` has cwd = its **deterministic** per-job worktree `/home/kris/scratch/gardener-wt-<base>`. So a re-claim of the same base on the same host re-enters the identical worktree.
- **Root cause:** the documented `GARDEN_HANDLER_TIMEOUT + KILL_AFTER < GARDEN_CLAIM_TTL` invariant only closes the *TTL* path. It does nothing for the reap-now path (or an orphan the wrapper's `timeout` reaped only at its direct child). When the prior `claude -p` was still live, the re-claim launched a second one → two writers on one worktree (the endo-but-for-bots #58 corruption class). The reaper can't fix it — it may run on a different host than the orphan.

**Fix (chose "requeue kills the old handler" — the robust closer):**
- New `common.sh` `kill_stale_worktree_handlers <worktree>`: enumerates `/proc` for pids whose cwd is the per-job worktree (every such process is by construction a stale predecessor) and SIGTERM→SIGKILLs their **process groups**, excluding our own process tree and group. Best-effort, Linux/`/proc` only, `GARDEN_STALE_HANDLER_KILL_GRACE` (default 5s) between TERM and KILL.
- `gardener-claude.sh` calls it **just before `ensure_worktree`**, so both a fresh claim's rm-and-recreate and a resume's reuse are protected. This makes automatic/deterministic the "SIGTERM your predecessor" dance a resumed session previously had to do by hand. Same-host by construction — the only case a worktree is shared (a cross-host re-claim gets a fresh worktree and can't collide).

**Verification:** `gardener-worktree-test.sh` — added case 12: stages a live `setsid sleep` rooted in the worktree, runs a re-claim, asserts the predecessor is killed before the new handler launches. Full suite **33 passed, 0 failed**. shellcheck clean (only the file's pre-existing `&& … || …` idiom notes remain).

**Landed:** commit `c5b61affc` on `origin/main2`.

**Follow-ups (optional):** The gardener-side comment in `gardener.sh` still frames the TTL invariant as the sole duplicate-execution guard; it remains true for the TTL path, and the new `kill_stale_worktree_handlers` doc is the authoritative reference for the reap-now/orphan path — no change made to avoid over-editing. If a future host disables `/proc`, the guard degrades to a no-op (resume/worktree machinery is already Linux-specific).
