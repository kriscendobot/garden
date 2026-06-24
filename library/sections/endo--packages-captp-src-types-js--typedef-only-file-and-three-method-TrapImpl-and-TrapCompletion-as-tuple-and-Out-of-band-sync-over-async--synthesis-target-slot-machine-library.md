---
title: §Synthesis target — slot machine library
source-slug: endo--packages-captp-src-types-js
source-url: https://github.com/endojs/endo/blob/master/packages/captp/src/types.js
authors: [Endo Project Contributors]
repo: endojs/endo
path: packages/captp/src/types.js
total-lines: 49
ingest-cycle: 249
ingest-date: 2026-06-08
lane: chat
parent: endo--packages-captp-src-types-js--typedef-only-file-and-three-method-TrapImpl-and-TrapCompletion-as-tuple-and-Out-of-band-sync-over-async
---

For a slot machine library:

- §`export {};`-typedef-only-file-pattern for §game-protocol-contract-without-runtime-exports.
- §Three-method-game-action-protocol (action × send-mode is async; sync game actions have three methods).
- §atomic-applyAction-not-get-then-apply for §game-rule-cannot-detach-actions-from-their-target.
- §game-action-completion-tuple `[isRejected, gameData]` for §game-result-encoded-as-discriminator-payload.
- §the-non-thenable-constraint for §sync-game-action-fulfillment.
- §`keyof InterfaceName`-as-defense-by-construction for §game-action-name-must-be-key-of-game-action-impl.
- §out-of-band-communications for §sync-over-async-game-action-bridge.
- §AsyncIterator-as-async-side-of-sync-over-async-bridge for §game-engine-streaming-results-back-to-sync-callsite.
- §branded-string-typedef for §game-id-vs-player-id-vs-action-id-distinguished-by-name.
