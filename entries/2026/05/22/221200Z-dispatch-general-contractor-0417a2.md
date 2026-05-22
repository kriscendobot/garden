---
ts: 2026-05-22T22:12:00Z
kind: dispatch
role: barrister
project: endo-but-for-bots
to: barrister
host: endolinbot
slot: 3
prs:
  - repo: endojs/endo-but-for-bots
    pr: 318
    role: target
refs:
  - entries/2026/05/22/221035Z-result-cleaner-7e6a11.md
---

# Dispatch: barrister 0417a2 — first code panel on endo-but-for-bots#318 (familiar CI build pipeline)

Dispatch root: `dispatches/barrister--0417a2/`. Project worktree on `endojs/endo-but-for-bots@feat/familiar-ci-build-pipeline` (head `1467909d0`).

Cleaner-7e6a11 skipped (workflow-only PR; no coverage surface) per the *Skip the cleaner pass* clause. CI `UNSTABLE`: 28 SUCCESS + 3 FAILURE (the 3 new `Make (darwin-arm64)`, `Make (darwin-x64)`, `Make (linux-x64)` jobs fail because the workflow calls `step:make` without a prior `step:package` after `prepare-package.sh`). Cleaner-7e6a11 noted: "This is the exact surface G1 was created to expose; the judge has disposition authority on whether to un-draft as-is (the gap is one of the design's owed followups) or dispatch a fixer to insert `step:package`."

## PR shape

PR #318 = G1 of `designs/familiar-release.md` / #229: triggers per-platform familiar build on PR + branch push (`.github/workflows/familiar-release.yml`, +58/-3). The PR body enumerates remaining MVR followups (G16, G14, G5, G7, G10/G13, G9, G4) explicitly; the design's intent is that G1's first CI trigger surfaces remaining gaps.

## Task

Standard barrister pass per `garden/roles/barrister/AGENT.md` and `garden/skills/panel-review/SKILL.md`:

- Consult `garden/skills/panel-hints/SKILL.md` for seat selection on a CI-workflow-only diff (likely a smaller subset: gateway, archivist, scribe, releaser, packager, locksmith, integrator).
- Dispatch concurrently per `skills/panel-review/SKILL.md`.
- `gh pr edit 318 --add-reviewer @copilot`.
- Aggregate verdicts.
- **Special disposition on the Make-jobs failure**: this is a known design-intentional gap (G1's purpose is to expose remaining steps). The panel may classify it as `acknowledge` (gap surfaced as designed, follow-up tracked in PR body) OR `must-fix-loop` (CI red is unmergeable). Either reading is defensible; let the panel decide. If `must-fix-loop`, the contractor's next cycle dispatches a fixer.

## Per-action authorization

- `gh pr review 318 --comment` formal submission.
- `gh pr edit 318 --add-reviewer @copilot`.
- Juror sub-dispatches via the panel skill.
- READ-ONLY everywhere else.
- **Don't un-draft** (contractor un-drafts after appellate / directly per chain).

## Out of scope

- Don't broaden PR scope.
- Don't move to ready-for-review.

## Report

≤ 300 words: panel-hints selection (seats); per-seat dispositions; aggregated verdict including Make-jobs disposition; formal review URL; one-line `Self-improvement: ...`.

Write to `journal/entries/2026/05/22/<HHMMSS>Z-result-barrister-0417a2.md` and commit+push origin journal.
