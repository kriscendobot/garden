# Fold in the .js-extension migration: migrate 3 packages to .js-suffixed export keys + enforce on @endo/* subpaths
Repo: endojs/endo-but-for-bots (bot; base `llm`, frozen-base discipline). **Maintainer decision
(kriskowal, 2026-07-01):** on the "enforce .js by lint" ask (#442 review), **FOLD IN the exports-map
migration** — do NOT leave it as a follow-up.
Context: the lint rule (`@endo/jsdoc-import-extensions`, relative-only) landed as **PR #581** (the
surviving PR; sibling #582 was closed as a duplicate). Both PRs deliberately scoped to relative
specifiers because enforcing `.js` on `@endo/*` **subpaths** is not yet correct — three packages use
**extensionless export keys**: `@endo/platform` (`./fs/lite/types`, `./fs/node`, …), `@endo/agentry`
(`./harness`, …), `@endo/preact-container` (`./renderer`, …).
**Task (the folded-in migration):**
1. **Migrate** `@endo/platform`, `@endo/agentry`, `@endo/preact-container` `package.json` **exports
   maps to `.js`-suffixed keys** (the convention `@endo/daemon`/`@endo/exo`/`@endo/marshal` already
   follow), keeping resolution working.
2. **Update every consumer** of those subpaths across the tree to the `.js`-suffixed specifiers
   (incl. the `@endo/platform/fs/lite/types` from the #442 review).
3. **Extend the lint** (from #581) to ALSO enforce `.js` on `@endo/*` subpath imports, now correct.
   Prefer **extending #581** (one coherent change, per "fold in"); if #581 is already
   landing/awkward to extend, open a **stacked PR on #581** clearly linked. Add a changeset.
4. **Verify:** `eslint .` green, `import/no-unresolved` clean (all migrated subpaths resolve), builds
   + tests pass. This is an API-surface change — run local-verify and be honest about any consumer
   you couldn't migrate.
Bot fork; no upstream contact. Report the PR and the migrated packages/consumers.

---
claim:
  host: endolinbot2
  gardener: 3
  claimed_at: 2026-07-01T02:54:13Z
