---
ts: 2026-05-14T21:05:12Z
kind: result
role: fixer
project: endo-but-for-bots
to: liaison
prs:
  - repo: endojs/endo-but-for-bots
    pr: 251
    role: target
  - repo: endojs/endo
    pr: 2404
    role: source
refs:
  - entries/2026/05/14/205706Z-dispatch-liaison-af620d.md
---

# Result: harden-exports destructuring mirror + gibson042 feedback

PR: https://github.com/endojs/endo-but-for-bots/pull/251 (DRAFT, base `master`, branch `feat/harden-exports-destructuring`).

Head SHA: `5051d989f`.

## Commits on the branch

- `ddcc58cfb` feat: destructured exports in harden-exports (turadg, cherry-picked from upstream `2390-destructuring`).
- `f82539ec8` fix(eslint-plugin): recurse into nested destructuring patterns in harden-exports (addresses gibson042 line 64).
- `5051d989f` refactor(eslint-plugin): commentary and substructure for harden-exports detector (addresses gibson042 line 117).

The companion upstream chore commit (ignore Aider files) was a no-op against current bots-fork master (`.aider*` is already listed) and was skipped during cherry-pick.

## Feedback addressed

(a) Recursive nested patterns. Factored the inline if/else cascade in `Program:exit` into a recursive `collectPatternNames` helper that walks `Identifier`, `AssignmentPattern`, `ObjectPattern`, and `ArrayPattern` nodes. Added six valid + two invalid test cases covering gibson042's two examples plus `[[deepItem]]`, the renamed-property shape, and a nested AssignmentPattern with a default.

(b) Commentary + substructure at the harden-call detector. Extracted two named helpers (`argumentReferencesName`, `statementHardensName`) from the deeply nested `.some(...)` arrow, added section banners (pattern walking vs. harden-call detection), and documented the shallow-argument contract. Behavior preserved: same 74 tests pass before and after.

## Test results

`yarn workspace @endo/eslint-plugin test`: 74 passing (60 original + 14 added in this dispatch).
`yarn workspace @endo/eslint-plugin lint`: clean. (Note: the lint baseline on turadg's commit had one pre-existing `no-continue` error in the same block; the refactor incidentally cleaned it.)

PR is DRAFT as the dispatch requires; the judge un-drafts after the panel loop.

Self-improvement: nothing this time.
