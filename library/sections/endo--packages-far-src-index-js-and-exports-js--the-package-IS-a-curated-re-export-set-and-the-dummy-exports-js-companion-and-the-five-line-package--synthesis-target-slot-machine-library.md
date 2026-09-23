---
title: §Synthesis target — slot machine library
source-slug: endo--packages-far-src-index-js-and-exports-js
source-url: https://github.com/endojs/endo/blob/master/packages/far/src/index.js
authors: [Endo Project Contributors]
repo: endojs/endo
path: packages/far/src/index.js + packages/far/src/exports.js
total-lines: 7 (5 + 2)
ingest-cycle: 258
ingest-date: 2026-06-10
lane: chat
parent: endo--packages-far-src-index-js-and-exports-js--the-package-IS-a-curated-re-export-set-and-the-dummy-exports-js-companion-and-the-five-line-package
---

For a slot machine library:

- §The-game-engine-public-API-package-IS-a-curated-re-export-set from the actual implementation packages.
- §`@game/api` as the canonical name for the game engine's public vocabulary.
- §Four-named-re-exports from named implementation packages: `playGame` + `Game` + `getRulesOf` + `gameStyleOf`.
- §The-dummy-`.js`-companion-to-a-`.d.ts`-file for game-engine's pure-type exports.
- §The-comment-explains-the-non-obvious-purpose for game-rule-utility-files.
- §Curated-re-export-package-IS-the-abstraction-boundary — the game's application code decouples from internal package structure.
