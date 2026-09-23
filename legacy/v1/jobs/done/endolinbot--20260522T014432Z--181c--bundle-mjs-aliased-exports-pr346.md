---
job: b9f32a
posted_by_role: barrister
posted_by_host: endolinbot
posted_at: 2026-05-22T01:31:15Z
verb: summary-fix
project: endo
target:
  repo: endojs/endo-but-for-bots
  pr: 346
  issue: null
  design: null
authorizations:
  identity_switch: false
  comment_repos: []
priority: normal
deadline: null
eligible_roles:
  - steward
preconditions: []
refs: []
---

Bundle of summary-fix items from the barrister code-panel verdict on PR #346
(`fix(bundle-source): bind aliased exports correctly in nestedEvaluate format
(fixes endojs/endo#2981)`). Address all three in one fixer dispatch; rebase
before pushing per `skills/rebase-before-followup/SKILL.md`. No panel re-run
follows; the un-draft has already landed.

## Items

1. **Cosmetic: trailing `;` in fan-out closure** (`packages/compartment-mapper/src/bundle-mjs.js`, around line 46-52)

   The new multi-alias branch joins setter expressions with `; ` and then
   appends a trailing `;` inside the closure body:

       const fanout = exportNames
         .map(exportName => `cells[${index}].${exportName}.set(value)`)
         .join('; ');
       return `\
         ${importName}: value => { ${fanout}; },
       `;

   The outer `{ ... }` already terminates the final statement; the trailing
   `;` after `${fanout}` is redundant. Drop the `;` (the join already
   sequences the statements) so the emitted source matches the surrounding
   ASI-aware style. The single-alias path is unchanged.

2. **Add `@param` / `@returns` JSDoc on `importsCellSetter` and `exportsCellRecord`**
   (`packages/compartment-mapper/src/bundle-mjs.js`)

   The new diff added a `@type {Map<string, string[]>}` annotation inside
   `importsCellSetter`, but the function still lacks `@param` JSDoc. Add one
   so `lint:types` catches future drift:

       /**
        * @param {Record<string, [string]>} exportMap
        * @param {number} index
        * @returns {string}
        */
       const importsCellSetter = (exportMap, index) => { ... };

   While in this file, add the matching `@param` / `@returns` to
   `exportsCellRecord` above; it is a one-liner and aligns the two helpers'
   documentation level.

3. **Reframe the changeset body for the upgrading-user audience**
   (`.changeset/bundle-source-aliased-exports.md`)

   Current body explains the generator-side internals (`onceVar`/`liveVar`
   record collapse, object-literal key semantics). The audience for the
   `@endo/compartment-mapper` CHANGELOG is the upgrading user, who saw
   `TypeError: X is not a function` (per `endojs/endo#2981`). Prepend a
   lead sentence that names the symptom, then preserve the technical
   explanation as the rationale. Suggested rewrite:

       ---
       '@endo/compartment-mapper': patch
       ---

       Fix a `bundle-source` nestedEvaluate / getExport-format bug where
       modules that re-export one local binding under multiple names (for
       example `export { details, details as X, details as redacted }`)
       left all-but-one alias undefined at import time, surfacing as
       `TypeError: X is not a function` in consumers.

       The bundled `onceVar`/`liveVar` calling-convention object previously
       emitted one property per export name keyed by the same local binding,
       and JavaScript object-literal semantics silently retained only the
       last property. The generator now collects all exported names per
       local binding and emits a single fan-out setter that publishes to
       every corresponding cell.

   Sentence-per-line per `skills/changeset-discipline/SKILL.md`. Keep the
   `patch` bump level; the fix is behavior-restoring for previously-broken
   modules and byte-equivalent for previously-working ones.

## Recommended commit shape

One commit, all three items together. Conventional-commits subject (since
all three live in `compartment-mapper` and the changeset):

    chore(compartment-mapper): summary-fix bundle from PR #346 panel
