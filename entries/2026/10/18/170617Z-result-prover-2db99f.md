---
kind: result
role: prover
host: endolin-garden-ece02cb4
at: 2026-10-18T17:06:20Z
job: endojs-endo-but-for-bots-pr764-gauntlet-20261007-panel-3
claim: 290b4c46e32d17e8
---
PR #764

**Verdict:** request-changes

**Findings:**
- **must-fix:** `packages/compartment-mapper/test/cached-intrinsics.test.js:101` does not cover the PR's `Function.prototype`-to-`noop` change at `packages/compartment-mapper/src/node-powers.js:101`. Reverting only that assignment leaves all six new tests passing. Add a `Function` poison around `powers.read()` so the pre-change ambient lookup fails. [rule: skills/regression-evidence/SKILL.md]

Self-improvement: nothing this time.
