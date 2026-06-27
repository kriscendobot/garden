Done. Draft PR #7 is open against `kriskowal/garden` base `main2`, the inbox is empty, and the worktree is torn down. Completion report follows.

---

## Completion report: `investigate-systemd-run-vs-gardener-loops`

**Deliverable:** Draft design PR **kriskowal/garden#7** — `design(fleet-model-systemd-run)` — base `main2`, head `kriscendobot:design/fleet-model-systemd-run`, bot identity (endolinbot), verified `isDraft: true`. Doc at `designs/fleet-model-systemd-run.md`. Josh Corbin credited as the suggester.

**Recommendation: a hybrid (Option C), adopted incrementally and behind measurement — not transient-per-job and not a fleet rebuild.** A *small* resident dispatcher pool polls and wins claims via today's CAS, then `systemd-run`s the `claude -p` worker as a transient per-job unit that exits on completion.

**What the investigation found (measured on a live systemd 255 user manager — this host has systemd, contrary to the build-env note in `job-board.md`):**
- **The suggestion's premise doesn't hold.** Memory is not the constraint: 100 idle bash loops ≈ 340 MB on a 128 GB host. And a transient unit blocked for hours on a maintainer reply costs the same as a blocked bash loop — `systemd-run` doesn't make a blocked process cheaper, so the "save the cost of 100 idle workers" win is largely illusory.
- **The real cost of the resident pool is the POLL, not memory.** I confirmed from the call path (`gardener.sh` → `claim-job.sh:34` → `common.sh:487` `sync_clone`) that an idle gardener is *not* cheaply idle-blocked — it runs a `git fetch` against `origin/journal2` every `GARDEN_IDLE_SLEEP` (5 s). 100 gardeners = ~20 fetch/s of self-inflicted journal contention (the same the clone-lock/stuck-fetch hardening fights). This corrects the "concurrency-not-CPU / cheaply idle-blocked" framing in `CLAUDE.md`/`job-board.md`.
- **Measured numbers cited in the doc:** `systemd-run --user --wait` spawn = ~5–7 ms warm / ~24 ms cold (<0.05% of a minutes-long job); idle-loop RSS ~3.5 MB; transient `--user` unit confirmed to outlive its spawner (load-bearing for the dispatcher/worker split); per-unit `MemoryCurrent`/`CPUUsageNSec` accounting works; `user@.service TasksMax`=23006 (ample headroom).
- **Why hybrid wins:** dispatcher frees itself the instant it spawns a worker, so D dispatchers (D ≪ 100) sustain far more than D concurrent jobs — dropping poll-fetch load from ~100 to a handful, the one real cost. Plus per-job cgroup caps/accounting, per-job status/logs, and a free deploy story (each job's unit runs current scripts → the `deploy-sync` busy-marker re-exec dance disappears).

The doc includes a measured-cost table, analysis rejecting transient-per-job (A) and dynamic-pool (B), full migration analysis (scaler gains a second knob, reaper can cross-check `is-active`, two-level killswitch, observability win, message-bus blocking unchanged, tests unaffected), and 6 open questions. Step 1 of the recommendation is the cheaper non-systemd fix first: idle-poll back-pressure / bus-wakeup, re-measure, *then* pilot.

**Method/hygiene:** built in an isolated worktree off `origin/main2` (per garden-infra-job discipline), bot identity pinned, worktree torn down. No change to the live fleet model. Inbox drained (empty).

**Follow-ups (for the maintainer, captured as the PR's open questions):** whether poll-fetch contention is a felt problem today or already tamed by existing hardening; whether to land idle-poll back-pressure independently first; concurrency-cap mechanism (slice `TasksMax` vs. dispatcher count); the dispatcher count D (the one number a pilot should measure); and worker-unit naming to avoid stale `garden-job@<base>` collisions after a reaper requeue.
