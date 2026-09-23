---
kind: result
role: liaison
host: endolin
dispatch_root: /home/kris/garden/dispatches/liaison--deb9a6
ts: 2026-06-03T21:56:42Z
ref_id: deb9a6
---

# Cycle 171: endo packages/stream/index.js (canonical async-stream substrate)

Cycle 171 — chat-lane after cycle 170's designs-lane.
§Endo-source-comment-fragment genre.

The §canonical-async-stream-substrate. Referenced by cycle
137 daemon-message-streaming, cycle 163 ocap-kernel
glossary (as the shared substrate), and CapTP's wire
transport. Foundational; many other files depend on it.

## Source

`endojs/endo packages/stream/index.js`. Author Kris Kowal
(prompted). 247 lines. **§Fourteenth file in the e56bf00f
coordinated-update cluster** (cycles 108/110/115/118/123/
125/132/134/138/140/144/167/169/171).

## Sections written (1)

`endo--packages-stream-index-js--symmetric-async-iterator-
streams-with-makeQueue-makePipe-pump-and-prime-utilities.md`
(420 lines; commit `6d20ce62`).

**§Cohesion-honest section count**: One. §The-seven-
utilities-form-a-coherent-substrate around §symmetric-
stream-interface.

## Single most structurally interesting move

**§Symmetric-stream-interface** where Reader and Writer
differ only by *convention*, not by structure. The same
object shape serves both ends.

§makePipe = §two-queues-cross-wired. The §symmetry-of-
makeStream (taking acks and data) makes this three-line
implementation possible.

## Structural moves captured

- **§Functional-async-queue** (promise-chain cons-cells):
  §producer-makes-cons-cell + §consumer-walks-chain;
  §promise-as-pointer.
- **§Back-pressure-via-acks**: writer.next() doesn't
  resolve until reader acks.
- **§pump-with-tick-tock-mutual-recursion**: §behold-mutual-
  recursion (literal code comment). §E.when-not-await lets
  streams work on §remote-eventual-send-values.
- **§prime captures first-returned-promise**: handles
  §async-generator-priming-asymmetry.
- **§mapReader / mapWriter** have §two-different-shapes-
  for-same-pattern: §async-generator for reader (data
  flows out); §method-wrapping for writer (data flows in).
- **§Harden-everything-individually** (7 export-level
  harden calls): §defensive-harden-discipline.

## §Gap-revealing-comparison with garden cycles

| Cycle | Connection |
|-------|------------|
| 137 (daemon-message-streaming) | §Uses-this-substrate for progressive-text-delivery |
| 163 (ocap-kernel glossary) | §Vocabulary-drift-where-substrate-is-shared |
| 158 (loopback.js) | §Two-CapTP-instances-cross-wired using these streams |
| 154 (trap.js) | §Async-generator-as-resumable-state-machine sibling |
| 152 (memo-race.js) | §Promise-kit-substrate sibling (racing vs sequencing) |
| 169 (atomics.js) | §SharedArrayBuffer-synchronous-transport; this is the async-substrate counterpart |

## §Vocabulary-drift observation

§Three-different-vocabularies-for-shared-substrate:
- ocap-kernel: channel (bidirectional) + stream
  (unidirectional)
- @endo/stream: symmetric Stream (Reader or Writer by
  convention)
- @endo/captp: connection (bidirectional CapTP wire)

§Synthesis-target: clarifying these terms in OCapN
documentation could reduce confusion across ecosystems.

## §Tier-1 vocabulary borrowing candidates

§Symmetric-stream-interface, §makePipe-from-two-cross-
wired-queues, §functional-async-queue, §back-pressure-via-
acks, §prime-captures-first-returned-promise, §E.when-
not-await, §harden-everything-individually.

## §Synthesis-target

§Slot machine library will need stream-like primitives for
game-state-stream and player-action-stream. §Reuse-this-
substrate. The §symmetric-stream-interface pattern is
borrowable beyond Endo.

## Files written / edited

- `library/sections/endo--packages-stream-index-js--
  symmetric-async-iterator-streams-with-makeQueue-makePipe-
  pump-and-prime-utilities.md` (420 lines; commit
  `6d20ce62`)
- `library/sources/endo--packages-stream-index-js.md`
  (new source page)
- `library/sources/README.md` (cycle-171 row added in the
  @endo source-fragment section above atomics.js)
- `library/sections/README.md` (cycle-171 entry; totals
  bumped 675/216 → 676/217)
- `library/topics/streams.md` (cycle-171 row — finally
  the streams topic gets a substantive source-level
  section)
- `library/topics/patterns.md` (cycle-171 row)
- `library/topics/captp.md` (cycle-171 row)
- `library/keywords.md` (52 new keyword rows)
- `inboxes/endolin/scholar.md` (timestamp + commit hash
  bumped manually)

## Library totals

675 / 216 → **676 sections from 217 source documents**.

## Lane rotation note

Cycle 171 was nominally **chat-lane** (after cycle 170's
designs-lane). Papers-lane blocked **65+ consecutive
cycles**.

§Designs/chat-alternation maintained since cycle 166 —
six cycles of alternation (166 designs / 167 chat / 168
designs / 169 chat / 170 designs / 171 chat).

## §Small-file-but-foundational observation cluster

Recent cycles confirm: §the-substrate-files-are-often-
the-shortest. Three foundational @endo files ingested
recently:
- Cycle 165: ocap-kernel platform-specific.md (92 lines)
- Cycle 167: @endo/where/index.js (115 lines)
- Cycle 169: @endo/captp/atomics.js (170 lines)
- Cycle 171: @endo/stream/index.js (247 lines)

§Average-load-bearing-knowledge-density is high for these
small files. §Reading-the-shortest-files-tells-you-the-
substrate.

## Cycle 171 — done. Schedule cycle 172.
