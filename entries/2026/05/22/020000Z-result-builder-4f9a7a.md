---
ts: 2026-05-22T02:00:00Z
kind: result
role: builder
project: endo-but-for-bots
prs:
  - repo: endojs/endo-but-for-bots
    pr: 351
    role: mirror
  - repo: endojs/endo
    pr: 2422
    role: source
refs:
  - entries/2026/05/22/013728Z-dispatch-liaison-4f9a7a.md
---

# Result: builder mirrored endojs/endo#2422 as endojs/endo-but-for-bots#351

PR: https://github.com/endojs/endo-but-for-bots/pull/351 (DRAFT)
Head SHA: `a61ec6051da210fc4036598b47c4c8298992638b`
Branch: `mirror/2422-host-module-exits` on `endojs/endo-but-for-bots`

## Commit shape (6 commits, +281/-40 across 16 files)

1. `feat(ses): StrictModuleDescriptor type` (cherry-pick, NEWS.md edit dropped)
2. `test(compartment-mapper): Demonstration of host module ponyfill condition` (cherry-pick + test made async per modern API)
3. `feat(compartment-mapper): Allow arbitrary module descriptors to pass through importHook in absence of a policy` (cherry-pick + JSDoc adapted to modern `@import` style + `ExitModuleImportHook` return type broadened from `ThirdPartyStaticModuleInterface` to `ModuleDescriptor` + import-archive-lite call site updated to return the descriptor directly)
4. `feat(compartment-mapper): Implicitly exit for URL-scheme-prefixed module specifiers` (cherry-pick + `parseArchive(archive)` signature fix + test made async + `@ts-nocheck` on fixtures importing `h2g2:meaning`)
5. `test(import-hook): Round-trip bundleSource and importBundle with an exit and condition` (cherry-pick, clean)
6. `docs: changeset for host module exits` (replaces the 4 NEWS.md edits dropped from upstream commits)

## Conflicts and resolutions

- 4 NEWS.md modify/delete conflicts (ses, compartment-mapper twice, import-bundle): NEWS.md was consolidated into CHANGELOG.md on master (commit 9942e5234). Dropped the NEWS.md edits; added a single changeset.
- `packages/compartment-mapper/src/policy.js`: HEAD uses modern `@import` block; rewrote the incoming JSDoc inline `import('...').X` form to plain identifiers. Kept HEAD's `if (!policy) ... if (policyValue === true) ...` structure equivalent to incoming's combined predicate. Added narrowing type cast at the `attenuateModule` call site.
- `packages/compartment-mapper/src/link.js`: incoming re-added `extensionImpliesLanguage` / `makeExtensionParser` / `mapParsers` which have since moved to `src/map-parser.js`; kept HEAD's structure and added only the `urlish` const and the `archiveOnly` parameter that the new feature actually needs.
- `packages/import-bundle/package.json`: incoming `chore: Fix lint scripts for Yarn 4.` became obsolete; master is already in the canonical `eslint .` shape. Dropped that commit.
- `packages/compartment-mapper/src/import-archive-lite.js`: the upstream PR drops the `{record, specifier}` wrapper on `attenuateModuleHook`'s return; kept that change since `attenuateModuleHook` now returns a `ModuleDescriptor` (a wider type than `VirtualModuleSource`).
- New test files needed `async importHook(specifier) { ... }` for modern type compatibility.
- New fixtures importing `h2g2:meaning` got `@ts-nocheck` (the test specifiers are deliberately unresolvable).

## Per-command test status

- `yarn install` — pass (peer-dependency warnings only, pre-existing).
- `cd packages/compartment-mapper && yarn test` — 879 passed, 7 known failures (pre-existing), 0 new failures. Both new tests (`conditional-host-exports.test.js` and `exit.test.js`) pass; the `test.failing` reexport variant correctly remains failing.
- `cd packages/import-bundle && yarn test` — 16 passed. New `importBundle supports exiting to importHook` test passes.
- `cd packages/compartment-mapper && yarn lint` — pass.
- `cd packages/import-bundle && yarn lint` — pass.
- `cd packages/ses && yarn lint` — pass (1 pre-existing JSDoc warning).
- `yarn docs` — pass (warnings pre-existing).
- `pre-push-gates.sh` — auto-fixed Prettier paths re-staged; pre-existing probes findings (`no-inline-import-jsdoc` in unrelated `evasive-transform/src/index.js` and `compartment-mapper/src/import-hook.js`; divergent SECURITY.md across `bytes/hex/panic/immutable-arraybuffer` packages) not blocking this PR.

Per-action authorization: pushed mirror branch, opened DRAFT PR against master, READ-ONLY on endojs/endo. No comments outside the new PR's body. The contractor's PR-creation-flow scan will pick up the orphan DRAFT.

Self-improvement: cherry-picking a 2024 PR onto 2026 master frequently invalidates NEWS.md edits (master has migrated to changesets); the next builder mirroring an older PR should grep for `NEWS.md` modify/delete conflicts up front, drop them en bloc, and write a single replacement changeset rather than resolving each NEWS.md conflict in isolation.
