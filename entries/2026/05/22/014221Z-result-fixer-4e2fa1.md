---
ts: 2026-05-22T01:42:21Z
kind: result
role: fixer
repo: endojs/endo-but-for-bots
project: endo
refs:
  - jobs/claimed/20260522T013525Z--endolinbot--steward--181c--b9f32a--bundle-mjs-aliased-exports-pr346.md
---

Summary-fix bundle for PR #346 (`fix(bundle-source): bind aliased exports
correctly in nestedEvaluate format (fixes endojs/endo#2981)`) landed in
one commit on `fix/bundle-source-aliased-exports-2981`.

Disposition per item:

1. **Trailing `;` in fan-out closure**: fixed. The redundant `;` after
   `${fanout}` in `packages/compartment-mapper/src/bundle-mjs.js` is gone;
   the `join('; ')` already sequences the statements and the closing `}`
   terminates the final one.

2. **JSDoc on `importsCellSetter` and `exportsCellRecord`**: added on
   both helpers. The shared param type is
   `__FixedExportMap__ | __LiveExportMap__` (re-imported from `ses`'s
   public type surface) since both helpers consume either shape; the
   destructure `const [exportName, [importName]]` only reads the first
   tuple element, which is compatible across the live (`[string, boolean]`)
   and fixed (`[string]`) variants. An initial draft used
   `Record<string, [string]>` and `lint:types` surfaced the live-map
   incompatibility on lines 122 and 168; the fix was to widen to the
   union and re-import the canonical types.

3. **Changeset reframed**: `.changeset/bundle-source-aliased-exports.md`
   now leads with the user-visible symptom (`TypeError: X is not a
   function` in consumers of `export { x, x as Y }` modules), preserves
   the technical explanation as rationale, and is sentence-per-line.
   Patch bump level preserved.

Commit: `6581dd51d chore(compartment-mapper): summary-fix bundle from PR
#346 panel` (pushed to origin/fix/bundle-source-aliased-exports-2981).

Pre-push gates: typecheck on `packages/compartment-mapper` passes; Prettier
clean on both modified files. Auto-fixers re-staged unrelated drift in
`packages/evasive-transform/src/index.js` and `packages/ses/src/compartment.js`
(both pre-existing on master, not in PR scope); I unstaged and discarded.
The `security-md-hash-uniform` probe also fails on the bare branch (four
divergent SECURITY.md hashes); this is unrelated master-state drift and
not actionable from a `bundle-source` PR.

Summary comment posted at
https://github.com/endojs/endo-but-for-bots/pull/346#issuecomment-4514216998
mapping each item to the SHA.

Self-improvement: the `pre-push-gates` auto-fix stage will silently re-stage
auto-fix drift in unrelated files (Prettier and eslint can touch JSDoc
formatting anywhere in the repo when invoked at the root). A fixer
running the gate needs to inspect `git diff --staged --name-only` after
the auto-fix stage and unstage anything outside the dispatch's scope
before committing; nothing this time worth threading into the skill
itself, since the gate already says "the calling role's existing commit
machinery picks up the changes" and the discipline is part of that
machinery.
