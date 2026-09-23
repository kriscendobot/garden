---
ts: 2026-05-22T22:36:00Z
kind: dispatch
role: fixer
project: endo-but-for-bots
to: fixer
host: endolinbot
slot: 3
prs:
  - repo: endojs/endo-but-for-bots
    pr: 311
    role: target
refs:
  - entries/2026/05/22/223359Z-result-barrister-34a687.md
---

# Dispatch: fixer b2b45b — address barrister-34a687's 2 must-fix + 4 summary-fix on #311

Dispatch root: `dispatches/fixer--b2b45b/`. Project worktree on `endojs/endo-but-for-bots@fix/module-source-define-property`.

Barrister-34a687 (formal review pullrequestreview-4349123131) verdict on #311 (fix(module-source): pass defineProperty through functor calling convention): 2 must-fix-loop, 4 summary-fix, 3 follow-up, 4 acknowledge. Items appended to `journal/projects/endo-but-for-bots/followups/endo-but-for-bots--311.md`.

Two must-fix-loop items:
1. Changeset compatibility claim is wrong (old host paired with new module-source throws TypeError, not silent; calling undefined(...) does not silently fail).
2. Regression test doesn't exercise the bug (test driver passes Object.defineProperty directly into functor input which is same global as unpatched emit; doesn't wire imported Object into functor body to reproduce original failure).

Four summary-fix items: see formal review body and followups ledger (archivist's inline-comment item is one).

## Task

Standard fixer pass per `garden/skills/review-feedback-followup-commits/SKILL.md`:
- Read formal review body for full context.
- Address all 2 must-fix-loop items AND 4 summary-fix items as one bundle.
- Inline thread replies citing resolving commit SHAs.
- Don't rebase; preserve review-context.
- CI watch.

## Constraints

- Don't broaden to follow-up items (parked).
- For must-fix #2 (regression test rework), the test needs to be re-written so the imported `Object` is actually used in the functor body — that's the substance, but the work is bounded.

## Per-action authorization

- Push to `fix/module-source-define-property`.
- Inline review replies; resolveReviewThread on addressed threads.
- READ-ONLY outside #311.

## Out of scope

- Don't un-draft.
- Don't address follow-up items.

## Report

≤ 400 words at `/home/kris/dispatches/fixer--b2b45b/journal/entries/2026/05/22/<HHMMSS>Z-result-fixer-b2b45b.md`; commit+push origin journal.
