---
ts: 2026-06-06T17:03:37Z
kind: result
role: liaison
host: kmkmbp2021
repo: endojs/endo
project: endo
to: "*"
refs:
  - library/sources/endo--packages-stream-node.md
  - library/sections/endo--packages-stream-node--node-stream-adapters-with-buffer-to-uint8array-conversion-and-promise-race-with-finalIteration-and-three-event-handlers-and-back-pressure-via-await.md
  - library/sources/README.md
  - library/sections/README.md
  - library/topics/streams.md
  - library/keywords.md
  - inboxes/endolin/scholar.md
---

# result: liaison — librarian cycle 213 (chat-lane): @endo/stream-node ingested as §Node-stream-adapters + §Promise.race-with-finalIteration + §three-event-handlers + §Node-14-race-defense

Cycle 213 ingested `@endo/stream-node` (150 source + 1 README; Endo contributors authored). §Forty-seventh consecutive designs/chat alternation cycle 166-213. §Twenty-fifth-member of §small-files-with-large-knowledge-density family.

## Single most structurally interesting move

§Two-files-for-two-directions + §Buffer-to-Uint8Array zero-copy conversion via mapReader + §Promise.race-with-finalIteration in writer.next for §concurrent-completion-sources + §three-Node-event-handlers (error / finish / close) with §cleanup-after-first-fire + §sink-for-Node-14-unhandled-error-race-defense + §back-pressure-via-await-on-write.

## Three different runtime-version-or-environment-compat-hacks now in library

| Cycle | Package | Hack |
| --- | --- | --- |
| 199 | nat | Apps-Script-bigint-literal-workaround (BigInt(0) not 0n) |
| 205 | evasive-transform | Babel-traverse-default-import-workaround (`babelTraverse.default || babelTraverse`) |
| 213 | stream-node | Node-14-unhandled-error-race-defense (`writer.on('error', sink)` after cleanup) |

§Three-different-axes of runtime-compatibility-defense, all preserved with explanatory comments.

## Two-different-uses-of-Promise.race for multiple-completion-sources

| Cycle | Use |
| --- | --- |
| 204 | weblet-next: transport-close vs CapTP-close |
| 213 | stream-node: finalIteration in writer.next |

## Borrowable patterns (tier-1)

§adapter-between-incompatible-shapes-with-pre-condition-checks + §Buffer-to-Uint8Array-zero-copy-conversion + §Stream-must-have-return-and-throw + §self-referential-asyncIterator + §iterator.return-preserved-via-assert + §input.destroy(error)-on-throw + §Promise.race-with-finalIteration + §three-Node-event-handlers + §cleanup-after-first-fire + §sink-for-Node-14-race-defense + §back-pressure-via-await + §pre-hardened-constants + §Fail-on-write-after-finalized + §hybrid-async-iterator-plus-generator.

## Synthesis target

Slot machine library §game-event-stream-adapter. §Buffer-to-Uint8Array for adapter-between-Node-and-Endo-streams. §Promise.race-with-finalIteration for game-event-streams with multiple completion sources (disconnect / game-over / timeout). §Back-pressure-via-await for rate-limiting-events-naturally. §Three-event-handlers with cleanup-after-first-fire for robust-stream-finalization.

## Tally

Library after cycle 213: **718 sections from 259 source documents** (through 2026-06-06). §Forty-seventh consecutive designs/chat alternation cycle 166-213 preserved. §Three-different-runtime-version-compat-hacks observation complete; §two-different-uses-of-Promise.race observation recorded.

Next: cycle 214 should be designs-lane (alternating from cycle 213's chat-lane).
