## Completion report: `finish-ebfb-pr96`

**Outcome:** Finished the designed-but-unimplemented work on endojs/endo-but-for-bots #96. Pushed to branch `design/compartment-mapper-auxiliary-package-json`, head **`729e07f115317f0bcf3b8210b2f7b5d7ddd77543`**.

**The gap the maintainer flagged ("a comment but not the corresponding code"):** This is the auxiliary-`package.json` design PR. Phases 1–6 (the descriptor cache, on-demand construction, entry-resolution reclassification) had landed, but **Phase 7 — honoring the overrides at parse time — was described in PR comments and prose yet never wired up.** `collectLanguageOverrides` returned the layered descriptor list, but nothing consumed it: a `{"type": "module"}` auxiliary was collected and silently ignored by the parser, so `.js` files in its subtree were never reparsed as ESM.

**What I implemented (Phase 7, as designed):**
- New optional compartment-descriptor field `languageForExtensionByPrefix` — an ordered `{ prefix, languageForExtension }` list, shortest-prefix-first, built by layering `inferParsers` over the entry's auxiliary descriptors (deeper auxiliaries win for conflicting extensions). Added to the schema types, `Node` type, internal `ParserGeneratorConfig`/`MapParsersFn`, and the `compartment-map.js` validator.
- `mapNodeModules` attaches the list to the entry compartment from the auxiliaries `findEnclosingCompartmentRoot` already collected on the entry path.
- `link.js` threads it to `map-parser.js`; `resolveLanguage` now selects the **deepest matching prefix** for each module's path, falling back to the flat `parsers` map when no prefix matches or the list is absent (so auxiliary-free compartments are byte-for-byte unchanged).

**Tests:** new `test/auxiliary-package-json-parsers.test.js` + a nested-auxiliary fixture, covering the design's test plan — including an end-to-end `loadLocation` import proving a `.js` entry under a `type:module` auxiliary now imports as ESM (it parsed as CJS and failed before), the nested `type:commonjs`-inside-`type:module` deepest-first layering, and a no-auxiliary regression case. **913 compartment-mapper tests pass** (909 prior + 4 new; 12 known failures unchanged); `tsc` and `eslint` clean.

**One scoped decision the design left open (surfaced, not guessed):** the static graph builder doesn't traverse package subtrees, so only auxiliaries on the **entry module's path** are known at map time — which covers the entire test plan (every case makes the auxiliary-bearing package the entry). The fully general case (auxiliaries deep inside *dependency* subtrees, off the entry path) needs the per-file walk carried into the lazy import-time lookup (`import-hook.js`); I scoped that as remaining work rather than guess at that cross-cutting mechanism. `importArchive` and fully-described-map relatives are unaffected (language already pinned per module). Design §7, the changeset, and the PR reply all state this explicitly.

**Chain continued:** posted a summary reply on the PR ([#issuecomment-4801179238](https://github.com/endojs/endo-but-for-bots/pull/96#issuecomment-4801179238)) and posted `shepherd-ebfb-pr96` to drive the full monorepo CI to green (the change is non-trivial; only the compartment-mapper suite was run locally). Worktree torn down.

**Follow-ups:** (1) shepherd CI; (2) optional future generalization to lazy dependency-subtree auxiliaries — offered to the maintainer on their go-ahead.
