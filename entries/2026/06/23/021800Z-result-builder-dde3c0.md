---
kind: result
role: builder
host: endolinbot
at: 2026-06-23T02:18:00Z
short_id: dde3c0
dispatch_root: /home/kris/dispatches/builder--dde3c0
repo: endojs/endo-but-for-bots
outcome: pr-opened
pr: 514
---

# builder dde3c0 result — endo-but-for-bots#514 (tighten TS+lint, DRAFT)

PR: https://github.com/endojs/endo-but-for-bots/pull/514 (DRAFT)
Branch: `feat/lint-strict-no-warn`
Base: `master-7c25992` (frozen-base snapshot)
Commits: 12

Constraints narrowed (one commit per knob, plus the fallout fixes):

ESLint (warn → error):
  * `@endo/no-harden-pattern-maker`
  * `consistent-return`
  * `no-fallthrough`
  * `jsdoc/no-multi-asterisks`
  * `@typescript-eslint/restrict-plus-operands` (in tests)
  * Terminal: `--max-warnings 0` on `lint:eslint`

TypeScript (tsconfig.eslint-base.json):
  * `noFallthroughCasesInSwitch`
  * `noImplicitReturns`
  * `strictNullChecks`
  * `noUnusedParameters` (52 unused params prefixed `_`)

Before / after:
  * ESLint: 1 warning → 0; CI now fails on any future warning.
  * TypeScript: 0 errors → 0 errors with four new strictness options on.

Constraints **skipped with rationale** (open for follow-up):
  * `noUnusedLocals` — widespread false positives in this JSDoc-heavy
    codebase: types referenced only inside `@type` / `@returns` JSDoc
    annotations are reported as unused. Enabling would require either
    removing type docs or pervasive `_` prefix on type names. Known
    TypeScript limitation with `/** @import */`-style JSDoc.
  * `noImplicitAny` — 3386 errors at baseline. Separate, much larger
    undertaking; warrants its own PR (or stacked sub-chain) by itself.

Notable finding for future TS-strictness work:
  * `noFallthroughCasesInSwitch` does **not** honor `// falls through`
    comments (unlike ESLint). Intentional fallthrough must be
    restructured in code (if-chains, extracted helpers, or
    duplication). Worth a `journal/library` note for future builders
    doing similar sweeps.

Next: steward's per-cycle survey picks up the DRAFT and runs the
gauntlet (cleaner → barrister → fixer-loop → appellate → un-draft).
A follow-up builder for `noImplicitAny` is the obvious next step
once #514 lands.
