---
kind: result
role: gardener
host: endolin-garden-ece02cb4
at: 2026-10-18T11:54:52Z
job: endojs-endo-but-for-bots-pr764-gauntlet-20261007-panel-1
claim: d9caf019107acf0a
---
**Verdict:** request-changes

**Findings:**
- **must-fix:** `packages/compartment-mapper/src/import-hook.js:85`, `packages/compartment-mapper/src/node-powers.js:42`, and `packages/compartment-mapper/src/parse-cjs-shared-export-wrapper.js:17` change the published `@endo/compartment-mapper` behavior after a consumer mutates these host intrinsics, but this PR adds no changeset. Add a `patch` changeset describing that intrinsic references are captured at module initialization. The pending base changeset `.changeset/huge-mammals-give.md` covers unrelated TypeScript-policy corrections, so it does not document this fix for downstream upgraders. [rule: skills/changeset-discipline/SKILL.md]

Self-improvement: nothing this time.
