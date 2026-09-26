Inbox empty. Work complete.

## Completion report

**Job:** Harden `reap_stale_worker_cgroup` (`scripts/jobs/common.sh`) against detached Node descendants surviving worker restarts, with regression coverage for the restart/race path.

**Root cause identified.** The function already TERMs then KILLs live stale descendants and correctly refuses to signal zombies. The residual defect driving the repeated cleric/monk "left-over process" warnings was timing: a descendant we *successfully* SIGKILL is dead but stays in `cgroup.procs` as a zombie until its owning parent (or PID 1 after reparenting) calls `wait(2)`. The only post-KILL wait was the short fork-race window (`GARDEN_WORKER_STARTUP_REAP_KILL_WAIT`, 2s), which routinely ended before that reap — so a terminated process was recorded as "persistent residue" and re-escalated on every restart, even though cleanup had worked. That lingering zombie is exactly what systemd reports as a left-over process at the next unit start.

**What changed (`scripts/jobs/common.sh`):**
- New tunable `GARDEN_WORKER_STARTUP_REAP_ZOMBIE_WAIT` (default 5s): a dedicated zombie-drain loop that polls for the owning parent/systemd to reap dead members — but runs *only once no live survivor remains* (a live process needs attention now; a zombie only needs patience), and early-exits the instant the cgroup drains, so it adds startup latency only in the rare restart-into-residue case.
- Split the final escalation: a **live** survivor we could not kill (the genuine, actionable failure) keeps its existing alert; **purely dead** residue that outlives the drain now gets a distinct log line + alert ("ONLY dead (zombie) … terminated, not live residue … implies a wedged parent"), no longer conflated with a kill failure.
- Updated the function header comment to document the drain and the severity split.

**Regression coverage (`scripts/jobs/test/worker-startup-cgroup-reap-test.sh`), the restart/race path:**
- A live descendant that ignores TERM, is KILLed into a zombie, then reaped *within* the drain → resolves cleanly (one TERM + one KILL, no alert, no cooldown state).
- A zombie that outlives the drain → never signalled, escalated with the distinct dead-residue message, holds cooldown state.

Existing 13 assertions unchanged (the shared fixtures default `ZOMBIE_WAIT=0`, making the drain a no-op there). Suite now 17/17 pass. `bash -n` clean.

**Note:** My first edit pass accidentally targeted the deployed garden root paths instead of the worktree; I reverted those precisely (verified byte-identical to pristine — the root's working tree is clean) before re-applying and committing in the job worktree. No git was run in the root.

**Delivered:** commit `c4bc969405`, pushed to `origin/main2` via rebase-CAS.

**Follow-ups:** none required. Possible future tuning: if 5s proves too long for startup latency on busy hosts, `GARDEN_WORKER_STARTUP_REAP_ZOMBIE_WAIT` is now the single knob to adjust.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/improve-worker-cgroup-residue-reaping.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 90 tokens (3603597 cached reads)
- Output: 44695 tokens
- Cost: $3.8816635
- Wall-clock: 604s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
