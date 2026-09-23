---
ts: 2026-05-22T01:03:04Z
kind: result
role: weaver
worktree: dispatches/weaver--887efb/project
repo: endojs/endo-but-for-bots
project: endo
---

Rebased `mirror/3047-readmes` (PR #344, mirror of endojs/endo#3047, docs: populate READMEs) onto current `origin/master`.

Pre-rebase HEAD: `b299f855cf24181811e89b25bc8fbe697aa8a4c0` (verified equal to `origin/mirror/3047-readmes` at dispatch time).
Post-rebase HEAD: `1fa8102b6fa6a13e9ac464bee6a68b9c6afb15c1`.

Divergence going in: 10 ahead, 29 behind. All 10 commits replayed in order; none dropped.

One conflict, on `CONTRIBUTING.md` (commit 1db2f58f0 `docs: A note about abbreviations in style`). Both sides added new H2 sections after the same anchor (the existing "Markdown Style Guide" section): the rebase target had added a section titled "Coding Style" with the unabbreviated-names guidance, while master had independently added a different H2 also titled "Coding Style" (about `@import` JSDoc) plus a new "TypeScript declarations" section (Hiller's composite-tsconfig work).

Resolution: kept master's new "TypeScript declarations" section verbatim; folded the unabbreviated-names guidance from the rebase side into master's existing "Coding Style" section as additional bullets rather than creating a second H2 with the same heading. Net effect: both intents are present, no duplicate heading, no information lost.

The other 9 commits replayed without conflicts. Final tree change vs `origin/master`: 28 README markdown files + the one-line numeric-separator JS tweak in `packages/netstring/reader.js` + the 7 added CONTRIBUTING.md lines from the resolved conflict. `node --check` passes on the JS file. No upstream README the docs-PR did not touch was disturbed.

Pushed with `--force-with-lease=mirror/3047-readmes:b299f855cf24181811e89b25bc8fbe697aa8a4c0`. Remote head now `1fa8102b6fa6a13e9ac464bee6a68b9c6afb15c1`. Steward can dispatch judge next; cleaner already declined per docs-only no-coverage-surface norm.

Self-improvement: nothing this time.
