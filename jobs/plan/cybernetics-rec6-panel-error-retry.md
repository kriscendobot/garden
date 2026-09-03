---
gate: blocked
blocked_on: diagnose-panel-seat-error-rate
priority: normal
posted_by: orchestrator
posted_at: 2026-09-03T00:01:29Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Implement recommendation 6 of `designs/cybernetics-audit.md` § 7 [wrong
sensor], DELIBERATELY NARROW per the recommendation's own text: route panel
seat-error into the gauntlet's retry budget, not the decline branch.

The defect (audit § 2.5): a `panel.sh` non-zero exit caused by seat/decider
error is a SENSOR failure, not a review verdict. Today the run dies at the
first non-ok seat in the join (`panel.sh:545-554`) before any aggregation;
the gauntlet's stage brief instructs the supervising gardener to complete
with `orchestration-failed: true` on a non-zero panel exit
(`gauntlet.sh:315-316`); and a tada carrying that marker takes the explicit
decline branch, which never retries (`gauntlet.sh:569-570`). Net: a
transient provider blip inside a panel halts the whole gauntlet on first
occurrence, while a panel job that dies outright gets two retries. Measured
noise floor: 88 of 465 panel runs (18.9%) ended `disposition: error`
(journal `panel-runs/`, re-measured 2026-09-01).

Change: have the panel stage report a seat/decider error DISTINCTLY — a
`panel-error` stage result rather than `orchestration-failed: true` — so the
gauntlet's existing `max_stage_retries` (2) covers it, exactly as
`d28a2d5f76` made it cover a doomed transient stage. Fail closed as before
on everything unparseable.

Hard boundaries (all three are explicit in the audit):
- Do NOT touch `max_iterations` or the disposition rule — the convergence
  question is open on the maintainer's desk
  (`designs/gauntlet-panel-fix-nonconvergence.md`,
  `designs/evaluation-epochs-panel-calibration.md`). Raising gain into a
  noisy sensor is on the audit's "Not recommended, deliberately" list.
- Do NOT investigate the seat-error root cause — that belongs to
  `diagnose-panel-seat-error-rate`, this job's blocker. It has landed by the
  time you read this (this plan is blocked on it): READ ITS TADA REPORT
  FIRST (`journal jobs/tada/diagnose-panel-seat-error-rate.md`) and honor
  any conclusions that overlap or supersede this change.
- A genuine review decline (the panel ran, seats returned, disposition says
  no) keeps its current never-retry semantics untouched.

Verify with `skills/local-verify/SKILL.md` + `skills/pre-push-gates/SKILL.md`
(panel/gauntlet tests must pass); land bare on `main2` per CLAUDE.md
§ Conventions.
