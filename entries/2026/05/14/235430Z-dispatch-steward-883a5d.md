---
ts: 2026-05-14T23:54:30Z
kind: dispatch
role: steward
project: endo-but-for-bots
to: "*"
prs:
  - repo: endojs/endo-but-for-bots
    pr: 255
    role: target
refs:
  - entries/2026/05/14/225300Z-dispatch-steward-f0aba2.md
  - entries/2026/05/14/225829Z-result-builder-f0aba2.md
  - entries/2026/05/14/225200Z-message-steward-7e3a91.md
---

# Dispatch: judge runs panel + un-drafts PR #255 (OCapN Guile Interop resilience iter II)

Dispatch root: `dispatches/judge--883a5d/`. Project worktree on `endojs/endo-but-for-bots@ci/ocapn-guile-interop-resilience-ii`.

## Why direct-to-judge (skip cleaner)

PR #255 is a tiny-PR by the `pr-creation-flow` heuristic: workflow YAML only, no source / test surface, no doc surface. Diff is in `.github/workflows/ocapn-guile-interop.yml` exclusively. The cleaner's coverage / dead-code surface does not apply; per the skill, tiny-PRs route directly to the judge.

## CI state at dispatch time

All 24 checks SUCCESS as of ~23:51Z (after one re-run of `test-xs (20.x, 5.0.0, ubuntu-latest)` which had flaked on `esvu` install error in the first run). `test-ocapn-guile-interop` itself passed cleanly — substitute server happened to be healthy during this CI window, so the PR's effect cannot be observed empirically on its own run; the resilience pattern is judged on its diff alone (reorder + widen windows, both incremental hardening of merged PR #82's design).

## Operational urgency

The companion broadcast `225200Z-message-steward-7e3a91.md` set a standing instruction for shepherd dispatches: treat `test-ocapn-guile-interop` failures as pass-equivalent until this PR (or successor) lands. Getting #255 merged is the natural retire-condition for that broadcast. Un-drafting it to maintainer-review state is the next-owed step.

## Per-action authorization

- `gh pr ready 255` on jury panel completion (or direct un-draft if the panel-kind discriminator routes this as config-only that no panel reviews).
- No comment on PR #82, #109, or other affected PRs.
- No edit to source files; diff stays in `.github/workflows/ocapn-guile-interop.yml`.

## Panel kind

The PR has no source / test / doc surface. Per `roles/judge/AGENT.md` § Panel-kind discrimination (per the panel composition note in `skills/pr-creation-flow/SKILL.md` § Jury composition), neither the code panel (`assessor`, `typist`, …) nor the design panel (`critic`, `skeptic`, …) is a natural fit for a CI-config-only PR. Judge picks: either route to the code panel for a sanity pass on the YAML's syntactic correctness and the action-pin discipline, or skip the panel entirely and un-draft directly if the YAML diff is self-evidently sound.

## Out of scope

- No master-base mirror in this dispatch.
- No re-run of currently-passing checks.
- No edit to PR title or body unless the judge identifies an in-scope improvement.

## Commits

None expected (un-draft is API-only). If the judge identifies any inline edits to the YAML, those are a separate commit on the same branch with conventional-commit message shape.

## Report

≤ 400 words: panel-kind decision (which panel or skip), jury result if panel ran, the un-draft action, the PR's final state, and one-line `Self-improvement: ...`.
