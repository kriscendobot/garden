# Deterministic requeue when claude exits without completing a job (incl. exit-0-unsatisfying)
Maintainer directive (2026-07-01): deterministically watch for `claude` exiting WITHOUT completing a
claimed job — **API error, rate limit, quota exhaustion, or ordinary "did not reach a satisfying
conclusion"** — and **automatically move the job back to todo.**
**Diagnosis (confirmed):** completion is currently gated on **handler exit code**, not on real
completion. `gardener.sh:206` runs `complete-job.sh` whenever the handler exits 0; `complete-job.sh:34-35`
moves doin→tada with **no validation that the work was finished**. So a `claude` that exits 0 without
completing (quota mid-response, or just didn't finish) is **marked done and lost in tada** — the reaper
never requeues it. (Non-zero transient exits — signal-kill/timeout/empty/claude-API-signature — are
already reap-now-requeued via gardener.sh:272-355 / reaper.sh:267; keep that.)
**Task — make COMPLETION an explicit deterministic signal, not "exit 0":**
1. The worker (the `claude -p` that works a claimed job) must emit an **explicit completion signal** as
   its final deterministic act (e.g. write a completion sentinel / the report carries a required
   completion marker / it calls `complete-job.sh` itself). Define one unambiguous signal.
2. `gardener.sh` completes the job (doin→tada) **only if that signal is present.** If the handler exits
   with **ANY** code (0 or non-zero) and the signal is **absent**, deterministically **requeue** the job
   doin→todo. This closes the exit-0-unsatisfying gap while preserving the existing transient handling.
3. Cover all four named modes: API error, rate limit, quota (non-zero — keep current transient path),
   AND clean-but-unsatisfying exit-0 (new). All lead to requeue.
4. Keep the **poison counter / escalation** (reaper.sh:320-342, threshold default 5) so a genuinely
   stuck job that keeps not completing is escalated to the maintainer after N requeues — never silently
   lost, never infinitely requeued.
**Verify:** tests — (a) worker exits 0 WITHOUT the completion signal → job requeued to todo, NOT in tada;
(b) worker emits the signal → job in tada; (c) each of the four exit modes → requeue, bounded by the
poison threshold. Where: gardener.sh, complete-job.sh, reaper.sh (+ the worker/handler contract).
Land on `main2` via an isolated worktree off origin/main2.
