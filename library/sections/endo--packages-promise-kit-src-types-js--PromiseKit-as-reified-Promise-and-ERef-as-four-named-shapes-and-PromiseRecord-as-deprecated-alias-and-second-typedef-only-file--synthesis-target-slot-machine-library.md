---
title: §Synthesis target — slot machine library
source-slug: endo--packages-promise-kit-src-types-js
source-url: https://github.com/endojs/endo/blob/master/packages/promise-kit/src/types.js
authors: [Endo Project Contributors]
repo: endojs/endo
path: packages/promise-kit/src/types.js
total-lines: 25
ingest-cycle: 256
ingest-date: 2026-06-10
lane: chat
parent: endo--packages-promise-kit-src-types-js--PromiseKit-as-reified-Promise-and-ERef-as-four-named-shapes-and-PromiseRecord-as-deprecated-alias-and-second-typedef-only-file
---

For a slot machine library:

- §`export {};` typedef-only file for §game-state-type-vocabulary.
- §reified-game-state — three properties (commit + abort + future) make the game state's implicit transition explicit.
- §game-action-target-takes-ERef-not-T — the game-action's resolver accepts any game-token shape.
- §four-named-shapes-of-game-token-reference (local + remote-presence + promise + thenable) with prose distinction.
- §deprecated-game-rule-alias-with-named-replacement-in-JSDoc.
- §stack-of-three-typedefs-in-one-file for §game-rule-input-canonical-and-deprecated.
- §thenable-defined-explicitly for §game-token-promise-like-but-not-a-real-game-token.
