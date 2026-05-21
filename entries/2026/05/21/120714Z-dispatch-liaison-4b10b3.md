---
ts: 2026-05-21T12:07:14Z
kind: dispatch
role: cleaner
project: endo-but-for-bots
to: cleaner
---

# Dispatch: cleaner 4b10b3 — gauntlet on endo-but-for-bots#337 (Endo Gateway slice 1)

Dispatch root: `dispatches/cleaner--4b10b3/`. Project worktree on `endojs/endo-but-for-bots@feat/endo-gateway` (head `3e3468638`).

Continuing the autonomous-loop gauntlet on [PR #337](https://github.com/endojs/endo-but-for-bots/pull/337). Builder c3c0dc landed a scaffolding-only slice 1 (host-scope path functions in `@endo/where`); 11 slices total enumerated for the Endo Gateway design, this PR carries only the leaf-package foundation.

## PR shape

Single commit `feat(where): Endo Gateway host-scope path functions` in `@endo/where`. 16 new tests added across 4 test files. Lint and test both green per builder's verification. Zero daemon-side risk — `@endo/where` is a leaf path-string package; the gateway-relevant function additions are pure platform-branching path constructors.

## Task

Standard cleaner pass on `@endo/where`:

- **Coverage sweep**: confirm every platform branch in the new functions is exercised. Builder noted regression evidence (each branch perturbed locally, confirmed test fails, reverted). Verify.
- **Adversarial coverage**: if the new functions have failure modes not exercised (e.g. `process.env.HOME` unset on non-Windows, `process.env.LOCALAPPDATA` unset on Windows), surface them. Be conservative — don't broaden scope.
- **Dead-code audit**: scaffolding-only, no expected drift.
- **CI watch**: push any coverage commits to the same branch, watch CI converge.

If you push nothing, say so explicitly — the cleaner-skip docs/leaf-package norm may apply.

## Per-action authorization

- Push to `feat/endo-gateway` on `endojs/endo-but-for-bots`.
- READ-ONLY everywhere else. No comments. Don't un-draft.

## Out of scope

- Don't broaden into other Gateway slices.
- Don't move to ready-for-review — judge's call.

## Report

≤ 300 words:
1. Coverage assessment for the new path functions.
2. Commits landed (subjects + head SHA). Or "no commits".
3. CI status at end of dispatch.
4. One-line `Self-improvement: ...`.

Write into `journal/entries/2026/05/21/<HHMMSS>Z-result-cleaner-4b10b3.md` and commit+push to origin journal before returning.
