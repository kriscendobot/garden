---
kind: result
role: assessor
host: endolin-garden-ece02cb4
at: 2026-10-31T22:42:51Z
job: endojs-endo-but-for-bots-pr1596-gauntlet-panel-5
claim: 125962ab7c7efa75
---
**Verdict:** request-changes

**Findings:**
- **must-fix** — `packages/exo-npm/src/mvs-resolver.js:246` treats a pre-release as eligible when *any* disjunct in an OR range names a pre-release for its release tuple. Eligibility is per comparator set: `satisfiesRange('1.0.0-rc.1', '<2.0.0 || 1.0.0-alpha.1')` returns true, though neither eligible set matches. Split OR alternatives before applying the pre-release rule. [proposed-rule: A pre-release must be admitted only by the individual comparator set that names a pre-release of its exact major.minor.patch tuple.]
- **must-fix** — `packages/exo-npm/src/mvs-resolver.js:107` compares arbitrary-size numeric pre-release identifiers through `Number`, which becomes Infinity and makes equal valid identifiers fail ordered comparisons (for example, a 400-digit identifier against an equal >= floor). Compare numeric identifiers by digit length and lexicographically, or another exact representation. [rule: AGENTS.md § Numeric domain]

**Notes (out of scope but worth flagging):**
- Focused verification passed: `yarn workspace @endo/exo-npm test test/mvs-resolver.test.js` (35 tests).

Self-improvement: nothing this time.
