---
tier: mentat
dispatch: manual
---
role: orchestrator

Read `designs/cybernetics-audit.md` (landed 2026-09-01, commit `ebbc6915a9`/`3fd0adce6a` on `main2`) in full, especially § 7 Ranked recommendations (10 items) and the "Not recommended, deliberately" paragraph immediately after it: https://github.com/kriscendobot/garden/blob/main2/designs/cybernetics-audit.md#7-ranked-recommendations

Wear `roles/orchestrator/AGENT.md` and `skills/orchestration/SKILL.md`: decompose the applicable recommendations into child jobs, park them (`post-plan.sh --orchestrated --orchestrated-by <orch-base> ...`), and record one orchestration (`post-orchestration.sh`) that sequences them. You are the producer half of the orchestrator role for this job — you organize the children; you do not implement the recommendations yourself here.

Ground rules:

1. **Never create a child for anything in the audit's "Not recommended, deliberately" list** (end of § 7): loosening the cap-consistency guard, raising `max_iterations`, any new autonomous promoter for doomed work, or building the telemetry layer as a prerequisite. These are explicit non-recommendations, not omissions the audit forgot to rank.

2. **Recommendations 1–3 all touch `budget-level.sh`/`usage-meter.sh`** (spend-sensor blindness, setpoint provenance, controller restraint) and are tightly coupled — group them into one child, or sequence them explicitly, rather than firing independent editors at the same files; scattered concurrent bare pushes to `main2` on one file just fight each other. Every other recommendation touches a distinct file/subsystem and may run in parallel.

3. **Recommendations that point at an already-existing Proposed design implement THAT design, not a fresh redesign.** Rec 2 (setpoint provenance + calibration) → `designs/recurring-budget-calibration.md` and `designs/live-budget-admission.md` open question 1. Rec 4 (fuzz backpressure) → `designs/ironhorse-fuzz-triage-and-batch.md`, which also specifies the journal CAS op that migrates the 77 quarantined `plan/` jobs — treat rec 4 as the bigger, riskier lift and give it its own careful child rather than folding it into anything else; confirm `ironhorse-fuzz.sh` stays paused until the triage stage actually lands.

4. **Recommendation 6 is deliberately narrow per its own text**: only split a `panel.sh` sensor error from the decline branch so it retries under `max_stage_retries` instead of halting the whole gauntlet. Do NOT touch `max_iterations` or the disposition rule — that convergence question is open on the maintainer's desk (`designs/gauntlet-panel-fix-nonconvergence.md`, `designs/evaluation-epochs-panel-calibration.md`), and the seat-error root cause itself belongs to the job `diagnose-panel-seat-error-rate`. Check whether that job has landed or is still live (`jobs/tada/`, `jobs/doin/` on the journal) and park this child `--blocked --blocked-on <that job>` if it's still in flight, rather than duplicating its investigation.

5. **Recommendations 5, 7, 8, 9, 10 are each self-contained garden-repo changes.** Treat each as an ordinary garden self-improvement job (`skills/self-improvement/SKILL.md`): edit the named script(s), verify with local-verify + pre-push-gates, land bare on `main2` per CLAUDE.md § Conventions (no PR workflow for the garden's own repo) unless the change surfaces a genuine open maintainer question — in which case use the design-with-open-questions PR carve-out instead of landing bare.

6. Each child job body must cite its recommendation number(s) and the exact evidence section(s)/file:line citations already in the audit, so the claiming gardener doesn't have to re-derive them from scratch.

7. Choose serial vs. parallel per the coupling in (2), not uniformly one or the other. `--on-child-failure halt` (the default) is fine — none of this is time-critical enough to want `continue`.

Report back, in your completion report: the orchestration base name, the full child list with a one-line description of what each does, and which recommendation(s) (if any) you deliberately excluded and why.

<!-- garden-transient-elapsed: kind=signature through=0 values=3 -->

<!-- garden-reaped: 1 -->
