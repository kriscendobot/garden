---
ts: 2026-05-15T03:21:00Z
kind: dispatch
role: general-contractor
to: fixer
project: endo-but-for-bots
worktree: dispatches/fixer--ea1194/project
refs:
  - entries/2026/05/15/031826Z-result-cleaner-06e7fc.md
  - entries/2026/05/15/025300Z-dispatch-general-contractor-06e7fc.md
---

# Dispatch fixer: address Chromium browser-tests red on PR #259 (slot 3)

Slot 3's cleaner `06e7fc` returned at 03:18Z. Coverage and dead-code pass complete. SES suite green. But one **real** CI failure surfaced:

- **Job**: `browser-tests` (Chromium Playwright canary).
- **Error**: `TypeError: Cannot delete property 'arguments' of function TextEncoder() { [native code] }`.
- **Origin**: `packages/ses/src/cauterize-property.js`'s `delete obj[prop]`.
- **Reproduces on builder's prior commit** `fc2aa8d3c`, so this is **the PR introducing the bug**, not pre-existing infra red.

Dispatch root: `dispatches/fixer--ea1194` (project worktree at `endojs/endo-but-for-bots@feat/hardened-text-codecs-shim`, head ~`6e5b50d98`).

## Task

Extend `cauterizeProperty`'s tolerate-undeletable escape hatch to handle Chromium's native function `arguments` own property. Chromium exposes `arguments` on native functions as a non-configurable own property; `delete obj.arguments` throws in strict mode (or silently fails in sloppy mode). Either:

- Detect via `Object.getOwnPropertyDescriptor` and skip the `delete` when `configurable: false`, **or**
- Wrap the `delete` in a try/catch that tolerates the throw (less surgical, may mask other issues).

Read `packages/ses/src/cauterize-property.js` to find the existing escape-hatch pattern and extend it consistently.

After the fix lands:
1. Push to `feat/hardened-text-codecs-shim`.
2. Watch CI converge — `browser-tests` should pass, all other jobs should remain green.
3. Report.

## Per-action authorization (forwarded by general-contractor)

- Commits and pushes to `feat/hardened-text-codecs-shim` implicit.
- No PR comments authorized this dispatch (cleaner-introduced fix; no reviewer feedback to reply to).

## Stale-prep note

Run `git fetch origin feat/hardened-text-codecs-shim && git checkout FETCH_HEAD` to align with the cleaner's pushed head.

## Definition of done

- `cauterizeProperty` correctly handles the undeletable-`arguments` case.
- CI converges to all-green on the new head.
- Result entry naming the fix, the new head SHA, and CI status.

The contractor's next cycle re-evaluates: with all CI green and a fixer push after the cleaner, next-stage-owed is **judge** (the cleaner's place in the chain is already done; this fixer is the CI-correction layer).

Self-improvement per `garden/skills/self-improvement/SKILL.md`.
