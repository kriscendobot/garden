Work complete. All verification gates passed and the work is pushed, acknowledged inline, and the worktree torn down.

---

## Completion report — `pr-ebfb-96-rsvp`

**Request:** maintainer (kriskowal) commented on endojs/endo-but-for-bots#96 — "Please continue building the next phases." A single inline review comment asked that `mapNodeModules` construct a descriptor cache on demand so the `mapNodeModulesWithAuxiliary` entry function "should not be necessary."

**What I did**
- Acknowledged with a 👍 on the triggering comment, a PR status comment ([#issuecomment-4788093106](https://github.com/endojs/endo-but-for-bots/pull/96#issuecomment-4788093106)), and a direct reply on the inline review thread ([#discussion_r3466229009](https://github.com/endojs/endo-but-for-bots/pull/96#discussion_r3466229009)).
- Implemented and pushed commit `9d8b2ad33` to `design/compartment-mapper-auxiliary-package-json`.

**What changed (`@endo/compartment-mapper`)**
- **`node-modules.js`:** `mapNodeModules` now constructs a `PackageDescriptorCache` on demand when the caller supplies none — auxiliary-`package.json` handling is the **default** (design Phase 7 promotion). Removed the `mapNodeModulesWithAuxiliary` sibling; the `packageDescriptorCache` option survives only for cache-sharing across calls. Dropped the now-unused `search` import and the dual-path branch.
- **`package-descriptor-cache.js`:** added a `node_modules` boundary to the upward walk that fires **only after an auxiliary (unnamed) descriptor has been collected**. This was the load-bearing correctness fix: making the cache the default would otherwise have either broken the #70 diagnostic (unnamed package under `node_modules` wrongly adopting a workspace ancestor) or regressed the `custom-parser` fixture (a bare module with no `package.json` of its own, which must keep climbing past `node_modules` exactly as the old `search` did). The conditional boundary preserves old behavior for every non-auxiliary case.
- **`external.ts`, design doc, changeset:** updated to describe on-demand construction, Phase 6 (relatives inherit through `mapNodeModules`), and the boundary semantics; status → In Progress, date → 2026-06-24.
- **Tests:** replaced the obsolete "without cache still throws" test with one asserting the on-demand default resolves the auxiliary entry to its named compartment.

**Verification:** all **909** compartment-mapper tests pass (12 pre-existing known-failures unchanged) + node-condition config; `tsc` and `eslint` clean over the whole package.

**Phases covered:** 6 (relatives) and the Phase-7 promotion the maintainer's comment requested.

**Follow-up (deferred, the remaining functional phase):** honoring `languageForExtensionByPrefix` at parse time so a `{"type": "module"}` auxiliary actually flips `.js` parsing within its subtree. `collectLanguageOverrides` already returns the layered list, but `inferParsers` doesn't consult it; this reaches into the lazy import/link/parse pipeline (`link.js` → `map-parser.js`) rather than the static map, so I scoped it as its own phase and flagged it to the maintainer for a go-ahead. A future RSVP/build job can pick it up.

**Housekeeping:** build worktree created at `worktrees/endojs-endo-but-for-bots/cm-aux-96` was torn down. No PR re-review was requested by me; the PR remains open with CHANGES_REQUESTED pending the maintainer's next pass.
