The build stage is complete. Draft PR #686 is open, clean, and verified.

## Completion report

**Job:** build the `@endo/init` inter-package plain-re-exports slice (design #548 / #543), as a separate PR per @erights's request on #660.

**Investigation of the flagged nuance (before acting):**
- Confirmed erights's directive: on #660 he answered the `@endo/init` question with "Please do this in a separate PR" — a clear go-ahead, so no re-asking was needed.
- Audited every in-repo importer of `@endo/init`: **every occurrence is a bare side-effect import** (`import '@endo/init'` / `import '@endo/init/debug.js'`). There is not a single named, default, namespace, or `export … from '@endo/init'` anywhere in `packages/**`. So the re-exported names are genuinely unused-as-names in-repo, and the package's value really is the lockdown side-effect. This makes the slice **deprecate-only** (nothing to repoint), exactly like #660's `@endo/patterns` sub-slice.

**What changed (`@endo/init` only, patch bump):**
- Added an `@deprecated` JSDoc tag (pointing at `@endo/lockdown`) above each inter-package plain re-export: `index.js`, `debug.js`, `debug-async-hooks.js`, `pre.js`. Each block states the deprecation is scoped to importing *names* through `@endo/init` and that the side-effect entry point (`import '@endo/init'`) is preserved and undeprecated — an `@deprecated` on `export *` marks re-exported symbols, not a bare side-effect import. This satisfies the design intent: deprecate the name re-export, preserve the side-effect entry point.
- Added changeset `.changeset/inter-package-init-deprecate.md` (`@endo/init: patch`).
- **Deliberately left untouched, with rationale in the PR body:** `pre-remoting.js`'s `export * from '@endo/eventual-send/shim.js'` (the shim exports no names, so nothing to deprecate/repoint; conversion belongs to the removal stage), and the intra-package `export * from './pre.js'` edges (governed by the separate intra-package design #544, not #548).

**Verification (real execution in an isolated project worktree, deps installed via corepack yarn 4.13.0):**
- `prettier --check` on all changed files: clean.
- `eslint` on the four init modules: exit 0.
- `tsc` (`yarn lint:types`) for `@endo/init`: exit 0.
- `yarn test` for `@endo/init`: **5/5 passed** — including "default init hardens" and "globals are present", confirming the lockdown side-effect entry point still works after the change.

**Delivered:** draft PR **#686** — https://github.com/endojs/endo-but-for-bots/pull/686
- base `llm-f7932ed` (frozen-base-branch convention), head `refactor/inter-package-reexports-init`, sibling to #590/#660.
- Affected package: **`@endo/init`**.

**Handoff / follow-ups:**
- PR is draft, ready for the panel/gauntlet stage (builder does not run the panel).
- Note: the two direct siblings (#590 merged, #660 open) used a plain `llm` base; I used a frozen `llm-f7932ed` base per the `frozen-base-branch` skill. The diff is identical either way and "unfreeze before merge" handles landing — just a base-name difference to expect within the cluster.
- Stage-2 (breaking) removal of these now-deprecated re-exports (and the cosmetic `export *`→`import` on the eventual-send shim) is deferred to the next major per the design.
