---
gate: ready
priority: normal
posted_by: gardener
roadmap: lint-ratchet-endo-master
---

# ratchet `jsdoc/check-tag-names` warning → error on endo master (+ fix the 1 defect)

Map: **fixer** → a small PR on `endojs/endo-but-for-bots` (base `master`).

Maintainer directive (2026-06-28, via the `classify-lint-endo-master` thread):
*"classify the warnings and post jobs to ratchet each of these warnings up to
error and fix resulting defects."* This is the go-ahead. One job per warning rule
class; this is the `jsdoc/check-tag-names` class.

## Where the rule lives

`jsdoc/check-tag-names` is inherited at **warn** from
`plugin:jsdoc/recommended-typescript-flavor` and is **not** currently overridden in
**`packages/eslint-plugin/lib/configs/style.js`**. `style.js` runs in `typescript`
jsdoc mode (`settings.jsdoc.mode = 'typescript'`).

**Ratchet:** add `'jsdoc/check-tag-names': 'error'` to the main `rules:` block of
`style.js`.

## The 1 defect this surfaces

As of master `364d69ba1` (unchanged since the 2026-06-27 classification),
`eslint .` reports `jsdoc/check-tag-names` ×1, **not autofixable**
(`fixableWarningCount: 0`):

- `packages/compartment-mapper/src/types/policy-schema.ts:64` — invalid JSDoc tag
  `@remarks` (a TSDoc tag the plugin's tag set does not recognize in this mode).

## Fix approach — needs judgment, two options

This is a house-style call. Pick one and apply it:

- **(a) Allow the tag** — if the project wants TSDoc tags like `@remarks` in `.ts`
  type files, add `remarks` to the jsdoc plugin's `definedTags` (settings) /
  allowed tag-names in `style.js`. This keeps the prose and legitimizes the tag
  repo-wide.
- **(b) Rewrite the block** — replace `@remarks` with a plain description or a
  recognized JSDoc tag at `policy-schema.ts:64`, leaving the rule's tag set
  unchanged.

If unsure which the maintainer prefers, post a one-line question to the maintainer
(via the PR or the bus) before landing — but the ratchet-to-error itself is
authorized regardless of which fix path is chosen.

## Definition of done

- `style.js` sets `jsdoc/check-tag-names: 'error'` (plus `remarks` in `definedTags`
  if option (a) is chosen).
- The compartment-mapper `@remarks` defect resolved per the chosen option.
- `yarn lint` green repo-wide (root `eslint .` exits 0 with **0**
  `check-tag-names` warnings/errors). Confirm no OTHER file repo-wide now errors on
  `check-tag-names` (classification said this was the only instance — verify).
- Small fixer PR opened on `endojs/endo-but-for-bots` against `master`, run through
  the normal gauntlet.

Supersedes the `jsdoc/check-tag-names` half of the now-retired consolidated plan
`fix-lint-jsdoc-warnings-endo-master`.
