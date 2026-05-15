---
ts: 2026-05-15T04:23:06Z
kind: result
role: designer
project: endo
repo: endojs/endo-but-for-bots
worktree: dispatches/designer--a39803
refs:
  - entries/2026/05/15/041700Z-dispatch-steward-a39803.md
  - entries/2026/05/15/035900Z-message-liaison-f1bfe3.md
  - https://github.com/endojs/endo-but-for-bots/pull/264
  - https://github.com/endojs/endo-but-for-bots/pull/248
---

# Result: compartment-mapper-side import-attributes design

Drafted `designs/compartment-mapper-import-attributes.md` on
`design/compartment-mapper-import-attributes` (off `llm`) and opened
draft PR #264 against `llm`.
Sibling to PR #248 (`design/ses-import-attributes`).
The two designs are meant to be reviewed as a pair: #248 is the SES
surface boundary, #264 is the propagation contract for the
compartment-mapper.

## PR

- **#264** `design(compartment-mapper): import-attributes propagation proposal`, draft, base `llm`, head `design/compartment-mapper-import-attributes`. https://github.com/endojs/endo-but-for-bots/pull/264

## Surface coverage

The design walks the four propagation hops the SES sibling defers:

1. Per-import attribute record in the compartment-map descriptor
   (`Record<importSpecifier, string | { specifier, attributes }>`,
   bare-string for the legacy-collapse case to keep archives
   byte-identical).
2. `infer-exports.js` companion-field handling for a speculative
   `withAttributes` adjacent to a `package.json` exports / imports
   condition.
3. `link.js` routing: partition `compartmentDescriptor.modules` into
   legacy-collapse (`moduleMap`) and extended
   (`modulesWithAttributes`) seats; widen the `makeImportHook`
   factory's returned hook to two arguments so the SES arity rule
   honors it.
4. Archive read / write paths
   (`archive-lite.js`, `import-archive-lite.js`,
   `import-hook.js`'s synthetic hook), including a
   `'import-attributes-v1'` tag sentinel for fail-fast on a
   reader that cannot honor the schema.

JSON schema diff is sketched on `FileModuleConfiguration` in
`packages/compartment-mapper/src/types/compartment-map-schema.ts`.
Nine-item test catalogue.
Four alternatives considered, each with the reason for rejection.

## Open questions

Five entries, each tagged with the resolution mode the maintainer is
expected to pick:

1. **`withAttributes` companion-field name on `package.json`.**
   Alternatives: `with`, `attributes`. Maintainer picks.
2. **Schema-version sentinel scope.**
   A `tags` entry (`'import-attributes-v1'`) vs. a numeric
   `compartmentMapVersion` field.
   Lightweight tag is the design's default.
3. **Attribute-aware bundler.**
   `bundle.js` / `bundle-lite.js` are out of v1 scope; v1 rejects
   attribute-bearing graphs at bundle time with a clear error.
4. **CommonJS interop.**
   `with` is ESM-only; CJS `require` of an attribute-bearing module
   is a domain error.  Maintainer may want a more explicit story.
5. **Policy: per-attribute allow / deny.**
   Out of v1 scope; policy keys on specifier alone.

## Out-of-scope statement

Explicit negative scope in the design's `## Scope and non-goals` and
in the PR body: the SES surface (#248), implementation
(separate master-base builder dispatch per the maintainer's
2026-05-14 framing), new condition keys, per-type
`ModuleSource` variants, bundler propagation, per-attribute policy.

## Process

- Read both the dispatch entry and the upstream liaison's
  forwarded directive.
- Read the sibling design from `origin/design/ses-import-attributes`
  for the surface boundary it lands.
- Read `packages/compartment-mapper/src/link.js`,
  `import-archive-lite.js`, `infer-exports.js`,
  `node-modules.js`, and the
  `types/compartment-map-schema.ts` JSON-schema definitions.
- Drafted `designs/compartment-mapper-import-attributes.md` against
  the project's `designs/CLAUDE.md` metadata-table and section-shape
  conventions.
- Updated `designs/README.md` (Summary table row + Totals) per the
  project's README-sync rule.
- Pushed `design/compartment-mapper-import-attributes`, opened draft
  PR #264 against `llm` using the project's PR template (all
  template sections populated; no checklists, no file callouts in
  prose, no methodology leak).

Self-improvement: nothing this time.
