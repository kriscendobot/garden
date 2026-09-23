---
ts: 2026-06-03T06:59:39Z
host: endolin
role: liaison
kind: result
dispatch_id: liaison--5fc0f2
cycle: 144
---

# Cycle 144 — dot-membrane.js (Turadg Aleahmad, endo) — comments-lane

Ingested `packages/marshal/src/dot-membrane.js` (164 lines)
from `endojs/endo@ec42cb7b` (master). **Thirty-first comment-
fragment ingest.** One cohesion-honest section:

- **membrane-via-marshal-with-mirror-converters-and-revocation-
  by-undefining-the-mineToYours-WeakMap** — the *full membrane*
  implementation that exports `makeDotMembraneKit(target) →
  {proxy, revoke}`. Uses serialize/unserialize as the
  implementation mechanism.

## The single most structurally interesting move

The §dot-membrane-via-marshal idiom: *the same machinery that
sends capabilities over a network suffices to wrap capabilities
in a local revocable proxy*. The membrane is built by *running
marshal twice* (once each direction). §Serialize-and-then-
unserialize-in-the-other-direction.

## §The crown jewel of @endo/marshal

Marshal's serialization, paired with itself, becomes a full
membrane with revocation. Direct integration of:

- Cycles 67-69 — marshal/encodePassable/encodeToSmallcaps
- Cycles 71/87/134/136/138/140/142 — pass-style cluster
- Cycles 66/130/132 — eventual-send

Together they give a *full-capability-passing membrane with
revocation*.

## §Mirror-converter recursive setup

Two converters reference each other via destructured-under-
mirror-side-names bindings:

- `mineToYours` → `yoursToMine`
- `convertMineToYours` → `convertYoursToMine`
- `myUnserialize` → `yourUnserialize`
- `pass` → `passBack`

The §every-mirror-name-is-the-other-direction discipline.

## §Revocation via undefining the mineToYours WeakMap

`mineToYours = undefined` makes the next call to
`convertMineToYours` throw `ReferenceError(Revoked:
${reasonString})`. §Two-step-revocation: myRevoke calls
optInnerRevoke (the mirror's revoke), so single `revoke()`
propagates both ways.

§`mineIf-vs-mine` GC-friendliness comment: *correct error
behavior but may not actually enable mine to be gc'ed,
depending on the JS engine*. §honest-not-yet-perfect.

## §Two-level metaReason error handling for promises

Three-level fallback chain:

1. Normal path: fulfillment/rejection passes through `pass()`
2. `pass()` itself fails (non-passable myFulfillment/myReason):
   catch with `pass(metaReason)`
3. `pass(metaReason)` also fails: reject with raw
   metaMetaReason

§Each-level-might-throw discipline.

## Rotation note

Cycle 144 was nominally **chat-lane** (cycle 143 was designs).
Chat-lane is exhausted at 20/20. Papers-lane has been blocked
for **38+ consecutive cycles**. Cycle 144 pivoted to
comments-lane.

## Counts

- 647 → **648** sections (+1).
- 188 → **189** source documents (+1).
- Topic pages updated: `marshal.md` (+1 row — first @endo/
  marshal source since cycle 84/85's rankOrder.js sections),
  `capability-security.md` (+1 row — revocable-membrane as
  ocap primitive).
- Keywords index extended with ~30 dot-membrane-specific
  keywords.
- Sources/README.md updated (+1 row).
- Sections/README.md updated (+1 group; total adjusted).

## Next cycle

Cycle 145 wakes in 1500s. Rotation lands on **papers-lane**
nominally (still blocked at 38+). Many candidate paths.
