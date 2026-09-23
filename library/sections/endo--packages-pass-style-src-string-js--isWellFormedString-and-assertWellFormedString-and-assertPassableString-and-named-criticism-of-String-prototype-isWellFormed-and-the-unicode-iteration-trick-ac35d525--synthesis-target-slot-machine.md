---
title: §Synthesis target — slot machine library
source-slug: endo--packages-pass-style-src-string-js
section-slug: isWellFormedString-and-assertWellFormedString-and-assertPassableString-and-named-criticism-of-String-prototype-isWellFormed-and-the-unicode-iteration-trick-as-polyfill-and-three-stage-migration-plan
source-url: https://github.com/endojs/endo/blob/master/packages/pass-style/src/string.js
source-repo: endojs/endo
source-path: packages/pass-style/src/string.js
source-author: Endo project (collective)
total-lines: 83
ingest-cycle: 272
ingest-date: 2026-06-10
lane: chat
parent: endo--packages-pass-style-src-string-js--isWellFormedString-and-assertWellFormedString-and-assertPassableString-and-named-criticism-of-String-prototype-isWellFormed-and-the-unicode-iteration-trick-as-polyfill-and-three-stage-migration-plan
---

§The-passable-string-utility-pattern applies to the §game-engine-cluster:

- §**`isWellFormedGameValue` + `assertWellFormedGameValue` + `assertPassableGameValue`** — three named exports as predicate + asserter + extended-asserter.
- §**§named-criticism-of-a-standard-game-API-as-design-justification** when an existing standard does the wrong thing for the protocol.
- §**§feature-detection-at-module-load** for stage-3 game-platform features.
- §**§the-runtime-toggle-pattern** with `getGameOption(name, default, allowed-list)`.
- §**§the-three-stage-migration-plan-named-explicitly** for switching defaults: (1) disabled-by-default + (2) change-default-to-enabled + (3) remove-switch-and-simplify.
- §**§the-performance-uncertainty-acknowledgment** as the conservative-default's rationale.
