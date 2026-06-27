---
gate: deferred
priority: low
posted_by: gardener
posted_at: 2026-06-27T12:01:39Z
---

# fix-lint: jsdoc warnings on endo master (the only lint findings)

Map: **fixer** → a small PR on endojs/endo-but-for-bots.

## Context — endo master is lint-clean

Classification job `classify-lint-endo-master` (2026-06-27) ran the full lint
surface on endo master (endojs/endo-but-for-bots `master` @ `364d69ba1`, which is
ahead of upstream `endojs/endo@master` by 64 legitimately-merged bot-fork PRs and
behind by 8; not force-synced — the ahead commits are real merged work). Result:

| Gate (CI `yarn lint` = these first three) | Result |
| ----------------------------------------- | ------ |
| `lint:prettier` (`prettier --check .github packages`) | **clean** |
| `lint:eslint` (root `eslint .`)           | **0 errors, 5 warnings** |
| `lint:sh` (`scripts/shellcheck.sh`)       | **clean** |
| per-package `lint:eslint` (`eslint .` × 49 pkgs) | same 5 warnings, 0 errors |
| per-package `lint:types` (`tsc`), spot-checked ses/pass-style/daemon/compartment-mapper | **clean** |

There are **no lint *error* classes** on master — CI's lint gate is green. The
only findings are **5 warnings** in **two jsdoc sub-classes**, which do not fail
CI (root `eslint .` exits 0). This single plan covers both.

## Sub-class A — `jsdoc/require-param` (4×, autofixable)

Missing `@param` declarations on documented functions, all in **packages/daemon**:

- `packages/daemon/src/directory.js:129` — missing `@param "locator"`
- `packages/daemon/src/directory.js:174` — missing `@param "petNamePath"`
- `packages/daemon/src/pet-sitter.js:71` — missing `@param "id"`
- `packages/daemon/src/pet-store.js:159` — missing `@param "id"`

ESLint reports all 4 as **fixable** (`fixableWarningCount: 4`). `eslint --fix`
inserts the `@param` stub, but the inserted description is empty — a human (or
fixer) should fill a one-line description per param rather than landing a bare
stub. Fix approach: **autofix-then-fill** — mechanically safe insert, then a
short description pass; scope is one package (daemon).

## Sub-class B — `jsdoc/check-tag-names` (1×, needs judgment)

- `packages/compartment-mapper/src/types/policy-schema.ts:64` — invalid JSDoc tag
  `@remarks`.

**Not autofixable** (`fixableWarningCount: 0`). `@remarks` is a TSDoc tag that the
repo's jsdoc plugin config does not recognize. Fix approach **needs judgment**,
two options: (a) add `remarks` to the jsdoc plugin's `definedTags`/allowed-tags
config (if the project wants TSDoc tags in `.ts` type files), or (b) rewrite the
`@remarks` block as a plain description / a recognized tag. Decision belongs to
the maintainer's house-style preference for TSDoc-in-Endo.

## Definition of done

A small fixer PR on endojs/endo-but-for-bots that clears all 5 jsdoc warnings:
`jsdoc/require-param` autofixed + descriptions filled (daemon), and
`jsdoc/check-tag-names` resolved per the chosen option (compartment-mapper).
After it lands, `eslint .` reports 0 warnings. Low priority — these are warnings,
not CI-failing errors.
