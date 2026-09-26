The job is complete. A prior run of this same stable worktree implemented and pushed the fix before dying without emitting the completion signal, so the job was requeued and I re-claimed it. I verified the implementation is correct and complete, and all tests pass.

## Completion report

**What the job asked for:** Stop the reaper from false-poisoning children on the sanctioned exit-0-unsatisfying budget-resume path that land real commits every cycle (the `xs2rust-endor-build-stage3-arrays` false positive that had to be hand-reversed on endolinbot2).

**State on claim:** The fix was already committed and pushed to `origin/main2` as `209a03d15` ("reaper: don't count PRODUCTIVE requeue cycles toward the poison threshold") by a prior run of this same base's persistent worktree, which died before signaling completion. `HEAD == origin/main2`, working tree clean.

**What the change does (verified):**
- `gardener.sh` snapshots each per-job worktree HEAD (`job_worktree_heads`) *before* the handler runs (`progress_before`) and, on **any non-completion outcome** (`hrc != 0` — which covers the rc!=0 deadline-overrun path — **or** `! -e completion_sentinel` — the exit-0-unsatisfying path), compares against the after-snapshot via `job_cycle_productive` and stamps `<!-- garden-productive-cycle -->` on its still-in-doin claim. This single detection point sits above the branch-specific reap-now/deadline hints, so it covers both decision points the job named.
- `reaper.sh` reads the marker (`has_productive_cycle_hint`): on a productive cycle it **resets** the `<!-- garden-reaped: N -->` counter to 0 instead of incrementing, and `clean_body`'s existing body-rewrite awk **strips** the marker (via `PRODUCTIVE_MARKER_RE`, alongside the reap-now marker) so productivity is re-earned each cycle. The reaper stays session-agnostic — it only reads a marker.
- `common.sh` adds `job_worktree_heads` / `job_cycle_productive` (a worktree appearing only in the after-snapshot is setup, not progress) plus the `stamp_`/`has_productive_cycle_hint` helpers.

**Correctness preserved:** a job that truly fails every cycle (no HEAD movement) never earns the marker and still poisons at the threshold; deterministic deadline-overruns still poison at the lower overrun threshold.

**Tests:** `productive-cycle-test.sh` (8/8), `reaper-poison-park-test.sh` (5/5), `completion-signal-test.sh` (17/17) all pass; `bash -n` clean on all three scripts.

**Follow-ups:** none. Nothing left to push (already on origin/main2).
