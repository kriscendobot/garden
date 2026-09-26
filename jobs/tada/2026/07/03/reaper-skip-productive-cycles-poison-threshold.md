Pushed to `main2` on the first attempt. The framework records this job's completion report as the journal `result` on doin→tada.

## Completion report

**Problem fixed:** The reaper poisoned a job after `GARDEN_REAP_POISON_THRESHOLD` (5) requeue cycles on the assumption the handler "fails every time." A long builder on the sanctioned resume treadmill (push green commits → exit *without* the completion signal before the ~2400s handler wall → resume next claim) tripped the same counter every cycle even though each cycle landed real work — the class that false-poisoned `xs2rust-endor-build-stage3-arrays` on 2026-07-03.

**Mechanism (verified in `reaper.sh` + `gardener.sh` + `common.sh`, then implemented as the cleanest fit for the existing gardener-stamps / reaper-reads split, exactly mirroring the deadline-overrun design):**

- **`common.sh`** — new `job_worktree_heads <base>` (snapshots `path:sha` for each isolated per-job worktree under `GARDEN_SCRATCH`: the `gardener-wt-<base>` garden checkout and any `project-wt-…` project checkouts) and `job_cycle_productive <before> <after>` (productive iff a worktree present in *both* snapshots advanced its HEAD — a worktree that only appears in `after` is setup, not progress, so resume cycles are what it reliably catches). Plus `PRODUCTIVE_MARKER`, `has_productive_cycle_hint`, and `stamp_productive_cycle_hint` (bounded-CAS body stamp, mirroring `stamp_reap_now_hint`).
- **`gardener.sh`** — captures `progress_before` right before the handler run; on *any* non-completion outcome computes `progress_after` and, if a persisted worktree HEAD advanced, stamps `<!-- garden-productive-cycle -->` on its still-in-doin claim before the branch-specific reap-now/deadline hints (which preserve it).
- **`reaper.sh`** — a claim flagged productive **resets** the `<!-- garden-reaped: N -->` counter to 0 instead of incrementing (so only no-progress cycles accumulate); `clean_body` strips the marker so each cycle must re-earn it. A genuinely-failing job never earns the marker and still poisons at the threshold.

**Tests (cited per `roles/COMMON.md` § Reporting):**
- New `scripts/jobs/test/productive-cycle-test.sh` — 8/8 pass: pure-helper detection (advance=productive, unchanged/setup=not), end-to-end gardener stamping on a resumed advancing exit-0 cycle (and no marker on a no-progress cycle), and the reaper reset-vs-poison contrast at threshold 1 (productive → requeued to todo with counter reset & marker stripped; non-productive → poisoned/parked in plan).
- Regressions all green: `reaper-poison-park` (5/5), `completion-signal` (17/17), `gardener-worktree` (30/30), `elapsed-constancy` (19/19), `timeout`/`signal-kill`/`empty-output` classifiers, and `run-test.sh` concurrency (exit 0, 0 failures).

**Landed:** commit `209a03d15` on `origin/main2` (garden-infra, no PR per convention). **Activates on the fleet after a deploy.**

**Follow-ups / notes:** The separate deadline-overrun escalation (rc=124 deterministic wall-hit, threshold 2) is intentionally left untouched — the treadmill exits *before* the wall, and a job that deterministically overruns its budget every cycle is a genuine "split the job" signal. First-cycle progress (worktree created *inside* the handler, so absent from `progress_before`) is conservatively not flagged productive; this only affects the very first cycle (count 0 vs 1, still bounded) and correctly avoids treating mere worktree creation as progress.
