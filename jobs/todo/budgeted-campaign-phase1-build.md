---
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---
repo: the garden itself (this repo, `main2` branch)
role: builder

Garden-infra build: implement straight onto `main2` from an isolated per-job
worktree off `origin/main2` — no branch, no PR.

## Task

Implement Phase 1 of `designs/budgeted-campaign-dispatch.md` (landed
`main2` commit `67e6b0d88246`): the `--budget-tokens` flag on
`post-orchestration.sh`, fresh CostRecord aggregation over a campaign's
children before each serial promotion, the budget-exhausted and
meter-incomplete terminal outcomes, the parked/visible-unspent-remainder
behavior, and separately-budgeted resume — exactly as the design specifies.
Read the design in full; it is this job's spec.

## Then, as this job's final deliverable

Launch the actual, real dispatch this was all built for: call

    scripts/jobs/post-orchestration.sh --serial --on-child-failure halt \
      --budget-tokens 2080000 ironhorse-test262-implementation-completion-resume \
      <the full original 29 child basenames, in original order>

The 29 basenames are listed in full in
`jobs/tada/ironhorse-test262-completion-recover-children.md`'s completion
report (children 1-6 already have `tada/` reports under these exact
basenames and will be recognized as done by the resume logic; children 7-29
were re-staged under `orchestrated_by:
ironhorse-test262-implementation-completion-resume` by that same job and are
waiting, inert, for exactly this call). Use the design's landed
`--budget-tokens` flag with value `2080000` (the calibrated combined weekly
allocation from `budgeted-campaign-dispatch-design`'s report) — do not
recompute or second-guess that number; it is deliberate and maintainer-
approved.

## Report

Confirm the flag/mechanism is built and tested per the design's own
acceptance criteria, and confirm the orchestration launch call succeeded
(name the resulting `jobs/orch/ironhorse-test262-implementation-completion-resume.md`
state).
