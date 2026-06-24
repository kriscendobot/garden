---
kind: result
role: researcher
host: endolinbot
at: 2026-06-23T00:49:55Z
short_id: ac9ad6
outcome: references-produced
---

# researcher ac9ad6 result — references for tighten-typescript-lint builder

Produced a `## Library and project references` section for the downstream
builder. Key findings:

  * Root `tsconfig.eslint-base.json` is the strictness floor; `noImplicitAny: false` today. Only `packages/stream-types-test/tsconfig.json` opts up to `noImplicitAny: true` — buildable prior art.
  * Five ESLint rules currently at "warn" with in-line rationale comments — first-order targets for the sweep:
    - `@endo/no-harden-pattern-maker` (recommended.js)
    - `consistent-return` (style.js, "TS covers")
    - `no-fallthrough` (style.js, "doesn't detect throws")
    - `jsdoc/no-multi-asterisks` (style.js)
    - `@typescript-eslint/restrict-plus-operands` in tests (internal.js, "until we have time to clean them up")
  * CI has **no `--max-warnings 0`** — the sweep's terminal commit adds it to `lint:eslint`.
  * No prior systematic strictness PR in this repo's history; this is a first sweep.
  * Skills to invoke: pre-pr-checklist, frozen-base-branch, yarn-lock-separate-commit, changeset-discipline, regression-evidence, stacked-pr-build (if the sweep needs splitting).

Full references block inlined into the downstream builder's dispatch prompt.
