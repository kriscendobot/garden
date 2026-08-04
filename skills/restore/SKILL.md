# Skill: restore

Recover the fleet after a fleet-wide interruption — an API/quota outage, a long
network partition, or any window in which `claude -p` calls failed en masse — once
service is back (typically a fresh login or a quota bump). Use this when the
maintainer says **"restore"** (or "recover the fleet", "we're back, clean up the
wreckage", "reactivate the hung agents").

## Purpose

The garden already self-heals: the `garden-reaper` requeues stale claims, the
`garden-deadmail` service forwards dead letters into jobs, and the `garden-proxy`
clears watchdog noise — each on its own cadence, on the **leader** host. But a
fleet-wide outage leaves wreckage those cadenced singletons recover only slowly,
and the outage may have stalled the singletons themselves:

- **Orphaned in-flight claims.** A gardener that was mid-job when the API started
  erroring dies; systemd restarts a *fresh* gardener that idle-polls, but the dead
  session's claim is stranded in `jobs/doin/` with no live worker. It is recovered
  only when a reaper tick notices the claim is older than `GARDEN_CLAIM_TTL`
  (default 14400s = 4h, widened to fit build-heavy `handler-timeout:` budgets) —
  and never if the reaper is not running on this host. A gardener that died a
  *transient* signal-kill first stamps a reap-now hint so the reaper requeues it on
  the next tick rather than idling the full TTL, so this full-TTL stall applies only
  to a claim whose worker vanished *silently* (host crash, hard SIGKILL).
- **Dead letters.** A reply sent to a doer whose inbox tore down as the message was
  in flight lands in `inbox/dead/`; it becomes work only on a deadmail tick.
- **Doomed jobs.** A job that failed every requeue cycle (often *because* every
  attempt hit the outage) is surfaced to the maintainer inbox as a DOOM message
  and dropped from the board — now recoverable, since the cause was transient.

**Restore is the immediate, in-session, human-triggered form of that recovery.**
Rather than wait out the cadences, the liaison runs the recovery services once now,
reactivates the worker pool, and clears the doom the outage produced. It is a
fleet operation the liaison performs directly (like *stand up* / *stand down* /
*drain*), not work posted to the board.

## Inputs / state

No arguments. Reads and writes existing fleet state:

- `jobs/doin/` — stale/orphaned claims (requeued by the reaper to `jobs/todo/`).
- `inbox/dead/` — dead letters (forwarded to jobs by deadmail).
- `inbox/maintainer/unread/` — DOOM messages to ack + redispatch.
- the `garden-gardener@*` units — the worker pool to reactivate.

Env knobs honored by the underlying tools: `GARDEN_CLAIM_TTL` (claim staleness
threshold), `GARDEN_REAP_DOOM_THRESHOLD` (requeue cycles before doom).

## Procedure

Run from the garden root as the liaison. Each step is idempotent — a restore that
finds nothing to do is a clean no-op, so it is safe to run whenever an outage is
suspected.

1. **Reactivate the worker pool.** A quota outage leaves gardeners in a
   restart-loop or a failed state; clear the failures so systemd stops
   back-off-throttling them and they resume polling:
   ```sh
   systemctl --user reset-failed 'garden-*' 2>/dev/null || true
   ```
   The `garden-gardener-scaler` reconciles the pool to this host's target count
   (`journal/hosts/<GARDEN>`); if it is not running, force the count with
   `scripts/jobs/set-gardeners.sh <N> <GARDEN>` then
   `scripts/jobs/install-units.sh scale <N>`. Confirm
   `systemctl --user list-units 'garden-gardener@*.service'` shows the pool
   `running` and polling ("no jobs in todo" is healthy idle), not crash-looping on a
   FATAL. A gardener that still errors on every tick after login points at a real
   fault (e.g. a broken journal worktree) — diagnose that first; restore assumes the
   fleet's plumbing is sound.

2. **Requeue orphaned in-flight claims (reaper one-shot).** Reactivates the hung
   agents: each stale `doin/` claim goes back to `todo/`, its `work/<base>` record
   and any orphaned worktree are cleared, and — crucially — the **same basename** is
   preserved, so the fresh gardener that re-claims derives the same deterministic
   Claude session id and `--resume`s the interrupted transcript in the same
   worktree (see `handlers/gardener-claude.sh` § session continuity). A gardener
   that exited cleanly at the wall may have left a `reap-now` hint so its claim is
   requeued before the TTL elapses.
   ```sh
   bash scripts/jobs/reaper.sh          # logs "reaped N stale claim(s); doomed M"
   ```
   The reaper batches the tick into one push and retries within the tick, so a
   requeue lands even under board contention. Confirm the requeued bases reappear
   in `jobs/todo/` and are re-claimed into `jobs/doin/` by a live gardener within a
   minute.

3. **Forward dead letters (deadmail one-shot).** Each `inbox/dead/` entry becomes a
   job carrying the original message and its intended recipient, then the entry is
   retired. Idempotent by basename, so a re-run never double-promotes.
   ```sh
   bash scripts/jobs/deadmail.sh
   ```

4. **Ack and redispatch doom.** Read the maintainer inbox; for each DOOM
   message (a `from: reaper` / `watchdog:*` report naming a job that exhausted its
   requeue cycles and was dropped):
   - **Redispatch** the job now that the transient cause is gone — re-post it under
     its original basename with the body the doom message quoted:
     ```sh
     scripts/jobs/post-job.sh <original-base> <body-file>   # idempotent by basename
     ```
     A doom whose repeated failure was NOT the outage (a genuinely stuck job)
     should not be blindly re-posted — surface it to the maintainer instead.
   - **Ack** (archive) the doom message once redispatched or triaged:
     ```sh
     scripts/jobs/maintainer-archive.sh <msgid>
     ```
   Watchdog/anomaly reports (`from: watchdog:*`) that are informational, not action
   requests, are acked without redispatch — the `garden-proxy` auto-clears these on
   its own, so an empty inbox after restore is the expected steady state.

5. **Report** the recovery tally (§ Output).

Prefer running the recovery **services one-shot** (steps 2–3) over hand-editing the
board: the scripts carry the hardened requeue/forward logic (claim-stamp stripping,
push-race retry, idempotency) that a manual `git mv` would miss.

## Output shape

A short recovery tally to the maintainer, e.g.:

> **Restore complete.** Pool: 20 gardeners running. Reaper: requeued 1 orphaned
> claim (`xs2rust-endor-build-stage3b-binary`, re-claimed by gardener 5, session
> resumed); doomed 0. Deadmail: 0 dead letters. Inbox: 0 doom to redispatch.

## Notes

- **Leader-only singletons.** The reaper/deadmail/proxy run automatically only on
  the leader host (their `ExecCondition=is-main-host.sh`). On a host where those
  singletons are not enabled — a follower, or a leader whose units were never
  brought up — restore is how their recovery happens at all until they run. Running
  the scripts one-shot by hand is safe on any host: they act on the shared board via
  the same push-CAS, so they never double-recover a claim another host already took.
- **Restore vs stand up.** *Stand up* brings the units up from nothing; *restore*
  recovers a running-but-wrecked fleet after an outage. After a long stop you often
  *stand up* then *restore*. After a quota bump on an already-standing fleet you
  just *restore*.
- **Idempotent and cheap.** Every step no-ops when there is nothing to recover, so
  restore doubles as a diagnostic sweep: run it whenever an API outage is suspected;
  a clean tally confirms the fleet self-healed.
- Related: [job-board](../job-board/SKILL.md) (claim/complete/post primitives),
  [message-bus](../message-bus/SKILL.md) (the maintainer inbox), and the
  `roles/liaison/AGENT.md` § Stand up / stand down fleet operations.
