---
ts: 2026-05-22T21:34:00Z
kind: dispatch
role: barrister
project: endo-but-for-bots
to: barrister
host: endolinbot
slot: 1
prs:
  - repo: endojs/endo-but-for-bots
    pr: 316
    role: target
refs:
  - entries/2026/05/22/212707Z-result-cleaner-919e16.md
  - entries/2026/05/22/213205Z-result-weaver-859cc9.md
---

# Dispatch: barrister 44a5c7 — first code panel on endo-but-for-bots#316 (Node 22.22.3 LTS pin, post-rebase)

Dispatch root: `dispatches/barrister--44a5c7/`. Project worktree on `endojs/endo-but-for-bots@chore/familiar-lts-node-pin` (head `930cf2f1c`, the weaver's post-rebase head).

**Chain context**: cleaner-919e16 found CONFLICT → weaver-859cc9 rebased past PR #354 (zizmor hardening) → barrister now runs first code panel. Cleaner-skipped per the shallow-chore variant of `garden/skills/pr-creation-flow/SKILL.md` (cleaner-919e16 surfaced the cleaner-skip explicitly in its result entry).

## PR shape

5-file declarative chore PR bumping bundled Node binary from v20.18.1 (Iron, EOL April 2026) to v22.22.3 (Jod Maintenance LTS) in lockstep across `download-node.mjs`, `download-node.sh`, `familiar-release.yml`, `package.json` engines field, and `.changeset/familiar-lts-node-pin.md`. Diff is small (+22/-3) and the surface is configuration only — no executable source change.

## Task

Standard barrister pass per `garden/roles/barrister/AGENT.md` and `garden/skills/panel-review/SKILL.md`:

- Consult `garden/skills/panel-hints/SKILL.md` to choose the relevant subset of the 26 seats for this diff shape. For a declarative chore-shape PR with no source code under test, the relevant seats are likely a smaller subset (typist, stylist, packager, archivist, changeset-auditor, releaser, locksmith, integrator at minimum; full panel optional).
- Dispatch the chosen seats concurrently per `skills/panel-review/SKILL.md` § Concurrent dispatch.
- `gh pr edit 316 -R endojs/endo-but-for-bots --add-reviewer @copilot` fire-and-forget.
- Aggregate verdicts per `skills/panel-review/SKILL.md` § Aggregation.
- Submit formal `gh pr review` with the aggregated body.
- If no `must-fix-loop` items, declare the loop done; the contractor's next cycle dispatches the appellate (or directly un-drafts per the chain). If `must-fix-loop` items surface, post the summary-fix job to the board per the skill.

## Per-action authorization

- `gh pr review 316` formal review submission with the panel's aggregated body.
- `gh pr edit 316 --add-reviewer @copilot`.
- Juror sub-dispatches via the panel skill.
- READ-ONLY everywhere else.
- **Don't un-draft** (the contractor un-drafts via `gh pr ready 316` after the appellate or — if no appellate — directly per the role-file path).

## Out of scope

- Don't broaden the PR scope.
- Don't move to ready-for-review.

## Report

≤ 300 words: panel-hints selection (seats dispatched); per-seat disposition summary; aggregated verdict ({fix, approve, summary-fix list}); commit URL of the formal review; one-line `Self-improvement: ...`.

Write to `journal/entries/2026/05/22/<HHMMSS>Z-result-barrister-44a5c7.md` and commit+push to origin journal before returning.
