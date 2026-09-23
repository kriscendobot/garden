---
ts: 2026-06-23T06:01:17Z
kind: result
role: cleaner
repo: endojs/endo-but-for-bots
project: endo
refs:
  - entries/2026/06/22/054455Z-dispatch-liaison-4c5f8d.md
---

## Pre-push-gate findings

Ran `corepack yarn install` and deterministic pre-push-gate sweep on PR #509 at commit 367b9dcce (builder's initial HEAD).

### Auto-fixable findings

- `yarn format`: pass (no changes)
- `yarn lint`: pass (no auto-fix flag; ran clean)

No auto-fixable findings. No cleaner-side commits added.

### Non-auto-fixable findings (3 issues)

1. **no-inline-import-jsdoc** (8 locations):
   - `packages/bundle-source/src/endo.js:132`
   - `packages/compartment-mapper/src/import-hook.js:77`
   - `packages/compartment-mapper/src/parse-archive-mjs.js:117`
   - `packages/compartment-mapper/src/parse-mjs.js:42`
   - `packages/evasive-transform/src/index.js:69,72`
   - `packages/evasive-transform/src/transform-comment.js:36,79`
   - `packages/zip/src/format-writer.js:195,196,211`
   - `packages/zip/src/writer.js:94,98,102`

   The probe flags inline `import()` forms in JSDoc type annotations (e.g. `@param {string | import('source-map').RawSourceMap | undefined}`). The garden rule requires `@import` form instead per AGENTS.md conventions.

2. **sentence-per-line-md** (multi-sentence lines in markdown):
   - `packages/bundle-source/README.md:137`: "Each bundle call writes one `*.trace.json` file. Open these in Chrome tracing"
   - `packages/bundle-source/README.md:252-253`: Multi-sentence block quote in changelog

3. **test-package-no-main** (incorrect exports in test package):
   - `packages/chacha12-fast-check-test/package.json`: Package has `"exports": {"./package.json": "./package.json"}` but test packages should not declare exports.

### Test status

All touched packages pass their test suites:
- `packages/bundle-source`: 40 tests passed, 3 known failures
- `packages/compartment-mapper`: 908 tests passed, 12 known failures
- `packages/evasive-transform`: 56 tests passed
- `packages/zip`: 2 tests passed (per config)
- `packages/module-source`: 57 tests passed

No regressions.

## Summary

No commits added (no auto-fixable findings). PR is **not judge-ready** due to three non-auto-fixable gate findings (8 inline-import-jsdoc issues, 2 sentence-per-line-md issues, 1 test-package-no-main issue). Builder must address these before the judge can proceed.

HEAD: 367b9dcce (unchanged)
Lease anchor: 367b9dcce

Self-improvement: nothing this time.
