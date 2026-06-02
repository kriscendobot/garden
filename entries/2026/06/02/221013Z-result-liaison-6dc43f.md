---
ts: 2026-06-02T22:10:13Z
host: endolin
role: liaison
kind: result
dispatch_id: liaison--6dc43f
cycle: 127
---

# Cycle 127 — getGuardPayloads.js (Turadg Aleahmad, endo) — comments-lane

Ingested `packages/patterns/src/patterns/getGuardPayloads.js` (300
lines) from `endojs/endo@ef97f83e` (master). **Twenty-third
comment-fragment ingest.** One cohesion-honest section:

- **legacy-guard-tolerance-and-payload-extraction-at-three-
  granularities-with-method-key-introspection** — the
  *legacy-guard-tolerance adapter layer* that cycle 118's
  exo-tools.js defendPrototype imports `getInterfaceGuardPayload`
  from. Solves *one problem at three granularities*
  (`getAwaitArgGuardPayload` → `getMethodGuardPayload` →
  `getInterfaceGuardPayload`): extract the typed payload from a
  guard that might be in the pre-1712 `klass:`-discriminator
  record shape OR the post-1712 `payload:` envelope shape.

## The single most structurally interesting subtlety

The §exploitable-bug warning vs §why-this-isn't-exploitable
distinction: the AwaitArgGuard adapter acknowledges an
*exploitable bug* (a record matching the legacy shape is also a
valid parameter pattern); the method-guard and interface-guard
adapters are *not* exploitable because *there is not currently
any context where either a methodGuard or a copyRecord would both
be meaningful*. The *shape-collision-only-matters-where-overlap-
exists* discipline.

## *No LegacyRawGuardShape* — raw guards postdate the transition

The §file-level comment explains: *raw guards were introduced at
PR #1831, which was merged well after PR #1712. Thus, there was
never a `klass:` form of the raw guard*. Cycle 118 sees post-1712
raw guards directly, without legacy translation — the three
sentinels (RawMethodGuard / REDACTED_RAW_ARG / PassableMethodGuard)
from cycle 118 section 1 confirm this.

## How this file serves cycle 118

Cycle 118's defendPrototype (section 2) calls
`getInterfaceGuardPayload(interfaceGuard)` to extract:
- `interfaceName`
- `methodGuards` (string-keyed)
- `symbolMethodGuards` (CopyMap, symbol-keyed)
- `defaultGuards` (`undefined` / `'passable'` / `'raw'`)
- `sloppy` (deprecated boolean alias for `defaultGuards: 'passable'`)

Cycle 118's symmetric listDifference validation iterates over
keys from *both* `methodGuards` and `symbolMethodGuards`. Cycle
118's `GET_INTERFACE_GUARD` auto-installation stores the
interface guard for later introspection via this file's
`getInterfaceMethodKeys`. Together cycles 118 + 127 form the
*exo defendPrototype + guard-payload-adapter* pair.

## Rotation note

Cycle 127 was nominally **chat-lane** (cycle 126 was designs).
Chat-lane is exhausted (20/20 upstream designs ingested).
Papers-lane has been blocked for **21+ consecutive cycles**
(97/100/102/104/106/108/110/112/113/114/116/117/118/119/120/121/
122/123/124/125/126) due to lack of PDF-fetching infrastructure.
Cycle 127 pivoted to comments-lane.

## Counts

- 630 → **631** sections (+1).
- 171 → **172** source documents (+1).
- Topic pages updated: `patterns.md` (+1 row — eighth
  @endo/patterns row), `exo.md` (+1 row — first @endo/patterns
  row in exo topic, completing the defendPrototype + adapter pair).
- Keywords index extended with ~35 legacy-guard-tolerance-
  specific keywords.
- Sources/README.md updated (+1 row).
- Sections/README.md updated (+1 group; total adjusted).

## Next cycle

Cycle 128 wakes in 1500s. Rotation lands on **papers-lane**
nominally (still blocked). Expect another pivot to designs-lane
(three endopi-* spinouts remain) or comments-lane.
