---
title: §Synthesis target — slot machine library
source-slug: endo--packages-import-bundle-src-source-map-node-pair
section-slug: platform-bound-bootstrap-plus-powers-injected-factory-pair-and-sha512-sharded-cache-with-two-character-prefix-and-minimal-platform-typedef
source-url: https://github.com/endojs/endo/blob/master/packages/import-bundle/src/source-map-node.js
source-repo: endojs/endo
source-path: packages/import-bundle/src/source-map-node.js + source-map-node-powers.js
source-author: Endo project (collective)
total-lines: 45 (10 + 35)
ingest-cycle: 276
ingest-date: 2026-06-10
lane: chat
parent: endo--packages-import-bundle-src-source-map-node-pair--platform-bound-bootstrap-plus-powers-injected-factory-pair-and-sha512-sharded-cache-with-two-character-prefix-and-minimal-platform-typedef
---

§The-platform-bound-bootstrap-plus-powers-injected-factory-pair applies to the §game-engine-cluster:

- §**`game-engine-node-bootstrap.js`** — thin Node-platform-bound bootstrap that imports Node-specific modules (e.g., `node:os` for game-cache-location) and delegates to a powers-injected factory.
- §**`game-engine-node-powers.js`** — the powers-injected factory that takes `{os, process}` as parameters; platform-agnostic implementation.
- §**§minimal-game-platform-typedef** — only the fields the game-engine-cluster needs (`platform` + `env`) rather than the full Node Process type.
- §**§nested powers injection** — the game-engine factory passes its powers onward to cluster helpers.
- §**§the make-X-locator pattern** — `makeGameStateLocator(powers)` returns a `whereGameState(details)` closure.
- §**§sha-sharded game-state cache** with two-character-prefix shard + remaining-tail filename.
