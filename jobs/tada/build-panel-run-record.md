The commit is on `origin/main2` and my inbox is clear. The job is complete.

## Completion report

**What I built.** The scripted review panel (`scripts/jobs/gardening/panel.sh`) — the garden's primary evaluator — left no durable evidence: every per-seat verdict and round aggregate went to a scratch rundir torn down with the job's worktree, so `journal2` recorded nothing about which seats reviewed which PR, how many fix-loop rounds it took, or the must-fix items. This change adds the missing substrate.

- **New deterministic writer** `scripts/jobs/panel-run-record.sh` — plain code, no `claude -p`, in the single-writer CAS discipline of `reputation.sh`/`review-miss-record.sh`. On `emit <rundir>` it reads the rundir and pushes one compact record to `panel-runs/<owner>-<repo>-<pr>/<run-id>.md`.
- **`panel.sh` wiring** — on termination (pass, the max-rounds bound, or any fail, via an EXIT trap that preserves the real exit code) it assembles a `record-meta` file and invokes the writer best-effort. It records the head sha per round, and tags the terminal disposition (`passed` / `max-rounds-exceeded` / `seat-error` / `decider-error`).

**Record contract (compact by design).** Frontmatter: `repo`, `pr`, `panel_kind`, `base_ref`, `rounds`, `disposition`, `must_fix_total`, `appellate_ran`/`appellate_proposals`, a **reserved empty `epoch:`** field for `designs/evaluation-epochs-panel-calibration.md`, and `run_id`. Body per round: head sha, per-seat **verdict class only** (never the seat's prose), and must-fix titles **truncated to ≤120 chars, ≤20/round** as DATA (never re-interpolated as instruction). A 2-seat/2-round run is ~650 bytes. Best-effort: a failed push WARNs and never fails the panel or blocks an un-draft.

**Verification.** `scripts/jobs/test/panel-run-record-test.sh` (+3 committed stub hooks) drives the real `panel.sh` with seat/decide/fixer/un-draft hooks stubbed against a throwaway journal — **27 asserts**: record lands for a pass (rounds=1), a must-fix→pass loop (rounds=2), and a failure (max-rounds-exceeded); seat prose does not leak; re-emit is idempotent (one file); and a simulated push failure WARNs without failing the panel. `panel-seat-retry-test.sh` updated to skip the writer — **11 asserts**, still green.

**One notable snag, handled.** My tool calls initially edited the *deployed garden root* (`/home/kris/garden`) rather than my per-job worktree — and that root was **behind** `origin/main2` (its `panel.sh` lacked the newer concurrent seat fan-out). I re-applied all changes correctly against the worktree's real (concurrent) `panel.sh`, then fully reversed every stray edit and removed the 5 files I had created in the deployed root (file ops only — no git in the root), verifying it is clean of my markers so no untested change stays live for the fleet.

**Follow-ups.** None blocking. The audit of the evaluator itself (consuming these records) is a separate job, as the spec notes. When `designs/evaluation-epochs-panel-calibration.md` lands, it can stamp the reserved `epoch:` field without a schema change.

Pushed to `main2` as `9e757524f5`.
