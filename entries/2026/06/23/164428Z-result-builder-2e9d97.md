---
ts: 2026-06-23T16:44:28Z
kind: result
role: builder
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
refs: []
---

Opened DRAFT PR #514: "chore(lint+ts): tighten ESLint and TypeScript strictness; add --max-warnings 0"
https://github.com/endojs/endo-but-for-bots/pull/514

**12 commits on `feat/lint-strict-no-warn` based on `master-7c25992`.**

### ESLint warn → error promotions (5 commits)

All had zero violations. Promoted:
- `@endo/no-harden-pattern-maker` (recommended.js)
- `consistent-return` (style.js)
- `no-fallthrough` (style.js)
- `jsdoc/no-multi-asterisks` (style.js)
- `@typescript-eslint/restrict-plus-operands` test override (internal.js)

### ESLint warning fix (1 commit)

- `jsdoc/check-tag-names`: removed TSDoc `@remarks` tag in policy-schema.ts. Before: 1 warning. After: 0 warnings.

### TypeScript strictness commits (4 commits + 1 Prettier format)

- `noFallthroughCasesInSwitch` (2 sites fixed: chacha12 Duff's device rewritten as if-chain; cjs-module-analyzer default-case refactored)
- `noImplicitReturns` (1 site: compartment-mapper maybeReadDescriptorDefault)
- `strictNullChecks` (0 violations)
- `noUnusedParameters` (52 params prefixed with `_` across 27 files)

### Terminal commit (1 commit)

- Root `package.json` `lint:eslint` now passes `--max-warnings 0`.

### Before / after

ESLint: 1 warning → 0 warnings.
TypeScript (tsconfig.json): 0 errors → 0 errors (new strictness options enabled with code fixes).

### Skipped constraints

- `noUnusedLocals`: widespread false positives in a JSDoc-heavy codebase — types used only in `@type`/`@returns` JSDoc annotations are reported as unused by TypeScript. Not viable without a major JSDoc-to-TypeScript migration.
- `noImplicitAny`: 3386 errors at baseline — separate large undertaking.

Self-improvement: nothing this time.
