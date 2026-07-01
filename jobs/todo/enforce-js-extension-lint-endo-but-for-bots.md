# Builder: enforce `.js` extension on imports via lint (endojs/endo-but-for-bots)

Source: maintainer directive from kriskowal's CHANGES_REQUESTED review on
endojs/endo-but-for-bots PR #442
(review https://github.com/endojs/endo-but-for-bots/pull/442#pullrequestreview-4604884092),
inline comment on `packages/daemon-cas/src/content-store.js:6`:
"Lack of .js extension is not expected. Post a job for a builder to ensure this is
enforced by lint."

## Ask

The daemon-cas extraction landed a JSDoc `@import` with an extensionless module
specifier (`@endo/platform/fs/lite/types`). The one-off occurrence is fixed on the
#442 branch by a fixer. This job is the maintainer's SECOND, standing ask: ensure
missing `.js` extensions are caught by **lint** going forward, so the class of
mistake cannot recur silently.

## Scope

- Investigate the repo's ESLint config (root + per-package). Endo uses
  `import/extensions` and typically `import/no-unresolved`; confirm whether an
  existing rule already should have flagged this and why it did not (JSDoc
  `@import` type-only specifiers may be outside the import plugin's coverage —
  the interesting gap may be TS/JSDoc `@import` specifiers, not runtime imports).
- Land lint enforcement that requires the `.js` extension on relative and
  `@endo/*` subpath imports, INCLUDING the JSDoc `@import` form if the current
  tooling misses it (consider `eslint-plugin-jsdoc` / a TS-aware check, or the
  repo's established mechanism). Match the repo's existing lint conventions;
  do not introduce a new plugin if an existing rule can be tightened.
- Add/adjust a targeted test or fixture if the repo's lint config is itself
  tested, else rely on running lint over the tree to prove the rule bites.

## Definition of done

A DRAFT PR against `endojs/endo-but-for-bots` (base `llm`, or whatever the
maintainer's daemon-cas line targets) that makes an extensionless import specifier
(runtime or JSDoc `@import`) a lint ERROR, with lint green on the existing tree
after the one-off #442 fix. Run the full gamut chain.

<!-- garden-reaped: 1 -->
