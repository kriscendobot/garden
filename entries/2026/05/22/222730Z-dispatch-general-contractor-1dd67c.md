---
ts: 2026-05-22T22:27:30Z
kind: dispatch
role: fixer
project: endo-but-for-bots
to: fixer
host: endolinbot
slot: 2
prs:
  - repo: endojs/endo-but-for-bots
    pr: 242
    role: target
refs:
  - entries/2026/05/22/222335Z-result-barrister-5620d6.md
---

# Dispatch: fixer 1dd67c — address barrister-5620d6's 6 must-fix-loop + 6 summary-fix on #242

Dispatch root: `dispatches/fixer--1dd67c/`. Project worktree on `endojs/endo-but-for-bots@feat/syrups-ocapn-framing`.

Barrister-5620d6 (formal review pullrequestreview-4349099374) verdict on #242 (feat(ocapn): consume syrups-framed ocapn-test-suite): 6 must-fix-loop, 6 summary-fix, 6 follow-up, 5 acknowledge. Six items appended to `journal/projects/endo-but-for-bots/followups/endo-but-for-bots--242.md`.

Six must-fix-loop items:
1. Dead `designs/ocapn-tcp-syrups-framing.md` link in README/reader.js/writer.js.
2. Un-disclosed silent-discard at EOF in reader.js.
3. Unsignalled API-surface decision (legacy aliases vs netstring family).
4. Missing peer-fix test (concurrent chunked writes).
5. `patch`-on-brand-new-package bump-kind inconsistency.
6. `.catch(() => {})` swallow in `makeSyrupsWritingSocketOperations`.

Six summary-fix items: see formal review and followups ledger.

## Task

Standard fixer pass per `garden/skills/review-feedback-followup-commits/SKILL.md`:
- Read the formal review body for full context on each item.
- Address **all 6 must-fix-loop items** with commits to `feat/syrups-ocapn-framing`. Address the **6 summary-fix items as well** (since the contractor is bundling per the barrister's recommendation).
- For each item, post inline thread replies citing the resolving commit SHA.
- Don't rebase; preserve review-context.
- CI watch after pushes.

## Constraints

- Don't broaden PR's scope to follow-up items (defer per the followups ledger).
- If any must-fix proposes architecture material that exceeds the PR's purpose, surface as out-of-scope to designer/liaison.

## Per-action authorization

- Push to `feat/syrups-ocapn-framing`.
- Inline review replies on PR #242; `resolveReviewThread` on addressed threads.
- READ-ONLY outside PR #242.

## Out of scope

- Don't un-draft (justice's call after re-panel).
- Don't address follow-up items (parked).

## Report

≤ 400 words at `/home/kris/dispatches/fixer--1dd67c/journal/entries/2026/05/22/<HHMMSS>Z-result-fixer-1dd67c.md`; commit+push origin journal. Cover per-must-fix item resolution; per-summary-fix item resolution; commit shas pushed; CI status; one-line `Self-improvement: ...`.
