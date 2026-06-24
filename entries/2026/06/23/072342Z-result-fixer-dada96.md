---
ts: 2026-06-23T07:23:42Z
kind: result
role: fixer
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
refs:
  - entries/2026/06/23/071610Z-dispatch-fixer-dada96.md
---

# Result: summary-fix bundle for endo-but-for-bots#509 (dada96)

All 9 items from barrister review 4550516085 addressed in commit `5fbcfec04`
(force-pushed with lease anchor `367b9dcce` to `mirror-endo-3099`).

## 9-item resolution table

| # | Item | Resolution |
|---|------|------------|
| 1 | README.md sentence-per-line split | Fixed: split two-sentence line at 137 into one sentence per line |
| 2 | ENDO_BUNDLE_SOURCE_READ_CACHE_MAX_BYTES env var docs | Added 3-line bullet in README profiling section with default, zero-disable, and module-load-time notes |
| 3 | Changeset behavior-changes subsection | Added subsection naming .node removal, already-suffixed skip, and versionNeeded wire change |
| 4 | @endo/compartment-mapper bump to minor | Bumped from patch to minor in changeset frontmatter |
| 5 | makeBundleProfiler JSDoc | Extended with internal-only note and caller reference |
| 6 | makeShortestPathFromSource precondition | Added JSDoc paragraph documenting graph-immutability requirement |
| 7 | MAX_PARSE_ARCHIVE_MJS_CACHE_ENTRIES rationale | Added comment citing ~12k parses per agoric-sdk workspace; 20k cap = two workspaces |
| 8 | flush try/catch in zip-base64.js and script.js | Wrapped profiler.flush in try/catch; logs to stderr; preserves bundling error |
| 9 | parseArchiveMjsCache module-scope documentation | Added block comment documenting process-shared, FIFO-by-first-touch, (sourceUrl, source, sourceMapKey) key shape, tenant-isolation surface |

## Files touched

- `.changeset/bundle-source-profiling.md` (items 3, 4)
- `packages/bundle-source/README.md` (items 1, 2)
- `packages/bundle-source/src/profile.js` (item 5)
- `packages/bundle-source/src/script.js` (item 8)
- `packages/bundle-source/src/zip-base64.js` (item 8)
- `packages/compartment-mapper/src/generic-graph.js` (item 6)
- `packages/compartment-mapper/src/parse-archive-mjs.js` (items 7, 9)

## Test results

- `@endo/bundle-source`: 40 tests passed, 3 known failures (all pre-existing)
- `@endo/compartment-mapper`: 908 tests passed, 12 known failures (all pre-existing)
- Typecheck (`lint:types`): clean on both packages

## Gate status

- `yarn format`: no changes
- `yarn lint`: warnings only, all pre-existing
- `no-inline-import-jsdoc` failure at parse-archive-mjs.js:129: pre-existing, out of scope per job board
- `test-package-no-main` on chacha12-fast-check-test: pre-existing, out of scope per job board
- `sentence-per-line-md` failures at README.md:255-256: pre-existing in migration section, not introduced by this dispatch

## Push

New HEAD: `5fbcfec04`
Lease anchor: `367b9dcce`
Branch: `mirror-endo-3099`
PR: https://github.com/endojs/endo-but-for-bots/pull/509

## Summary comment

https://github.com/endojs/endo-but-for-bots/pull/509#issuecomment-4776744780

## Job board

Job `20260623T061558Z--225815--endo-but-for-bots-509-summary-fix` moved from
`jobs/open/` to `jobs/done/` in this journal commit.

Self-improvement: nothing this time.
