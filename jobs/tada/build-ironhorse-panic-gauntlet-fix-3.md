All round-3 panel must-fix items were applied by the prior (reaped) attempt's commit `e8e4f452a`, which is the current PR head, and CI is fully green. Job complete.

---

**Completion report — build-ironhorse-panic-gauntlet-fix-3 (endojs/endo-but-for-bots PR #1150)**

This was a cross-host reaper requeue with no carried session. I re-derived state: a prior attempt had already committed and pushed the round-3 fix as `e8e4f452a` ("fix(ironhorse,xsnap): round-3 panel — honest panic-catch docs, panic=unwind guard"), which is the current PR head (`origin/build/ironhorse-panic`). I verified rather than redid the work.

The round-3 panel (disposition must-fix, 29 seats) items, all addressed by the pushed commit:
- **archivist [must-fix]** — `XsnapError::Panicked` doc + `Display` no longer falsely assert "FFI-guarded" for the non-FFI `inproc.rs` machine-thread run-entry catch; doc names both construction sites, `Display` qualifier dropped.
- **warden [must-fix]** (+ purist/wire-watcher/engine-realist) — the shared process-wide power handle tables (`FILE_MAP`/`DIR_MAP`/`DB_MAP`/`STMT_MAP`/`HASHER_MAP`) torn-state/leak hazard now honestly scoped: isolation claim narrowed and the gap + per-worker-scoping/sweep follow-on documented at `guard_ffi`, each map declaration, and `designs/ironhorse-panic.md` § Scope.
- **benchmarker [must-fix-loop]** — PR body § Scaling Considerations rewritten to name the widened crate-wide surface (incl. `metering_callback`) with an explicit "no benchmark being pursued, deliberately" rationale (1-in-10,000 metering sample). Confirmed live on the PR body.
- **corner-prober [must-fix-loop/summary-fix]** — five crank-loop poison checkpoints enumerated with their bracketing invariant; String-payload downcast and `mem_read` `checked_add` overflow tests added (per-site Machine-level injection harness noted as follow-on).
- **breaker / integrator / spec-keeper [should-fix]** — `compile_error!` asserting `panic = "unwind"`; `designs/README.md` roadmap corrected to `ExecutionOutcome`.

CI: bounded wait returned **rc 0 — CI GREEN** (27 checks, 0 failed). No changes were needed from me. Per the fix-stage protocol I did not re-run the panel; the driver re-posts panel-4.

Follow-ups (already noted in-diff, not blocking): per-site checkpoint tests need a Machine-level panic-injection harness; the shared-handle-table per-worker scoping/sweep is a documented follow-on, not delivered here.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-ironhorse-panic-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 2 host(s)
- Input: 158 tokens (8601672 cached reads)
- Output: 61490 tokens
- Cost: $8.126202
- Wall-clock: 1652s
- Model(s): claude-opus-4-8 ×3

<!-- garden-usage-end -->
