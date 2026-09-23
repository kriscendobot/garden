---
ts: 2026-06-02T21:08:34Z
host: endolin
role: liaison
kind: result
dispatch_id: liaison--880dd0
cycle: 125
---

# Cycle 125 — merge-bag-operators.js (Kris Kowal, endo) — comments-lane

Ingested `packages/patterns/src/keys/merge-bag-operators.js` (291
lines) from `endojs/endo@e56bf00f` (master). **Twenty-second
comment-fragment ingest.** One cohesion-honest section:

- **five-bag-operations-with-multiplicity-arithmetic-and-three-
  code-sharing-callouts** — the *bag-algebra layer* sister to
  cycle 123's merge-set-operators.js. Three explicit *code-sharing
  callouts* mark the abstraction debt: file-level (*Based on
  merge-set-operators.js, but altered for the bag representation.
  TODO share more code with that file and
  keycollection-operators.js*); above `bagIterIsSuperbag` (*We
  should be able to use this for iterIsSuperset as well. The
  generalization is free*); above `bagIterIsDisjoint` (*We should
  be able to use this for iterIsDisjoint as well. The code is
  identical*). Three structural layers: `bagWindowResort`
  (entry-variant `[T, bigint][]` + `assertNoDuplicateKeys`); `merge`
  (six-let-buffer variant for real multiplicities); five
  bagIterOps + two adapter pyramids producing 5 exports.

## The §single most structurally interesting move

*The same merge-iterator + adapter pyramids support two different
algebras*. Sets form a Boolean lattice (presence-only); bags form a
multiplicity lattice — bag union *sums counts* (`xc + yc`);
intersection takes *min* (`min(xc, yc)`); superset compares *counts*
(`xc >= yc`). The set algebra is *bag-algebra-with-counts-clipped-
to-{0n, 1n}*. The §generalization-is-free claim is structural:
*bag machinery subsumes set machinery; consolidation should be
straightforward*.

## *5 exports vs cycle 123's 6*

- No `bagDisjointUnion` — bag union already sums counts; equivalent
  keys merge by addition automatically. Sets need disjoint-union
  to assert no shared elements; bags get *element-sharing-is-just-
  counted* for free.
- No `bagIterCompare` — bag-compare lives in cycle 104's
  `compareKeys.js` dispatch table via cycle 120's
  `makeCompareCollection`, *not* in this file's set of iterOps.

## The Keys substrate now spans seven cycle-ingested files

- cycle 102 — `checkKey.js` (kind validation)
- cycle 104 — `compareKeys.js` (partial-order dispatch table)
- cycle 110 — `copySet.js` (CopySet shape)
- cycle 115 — `copyBag.js` (CopyBag shape)
- cycle 120 — `keycollection-operators.js` (Pareto-partial-order
  pair-merging machinery)
- cycle 123 — `merge-set-operators.js` (set-algebra layer)
- **cycle 125 (this cycle)** — `merge-bag-operators.js`
  (bag-algebra layer)

The seven cover the substrate's complete operational surface in
*both the set and bag dimensions*.

## Rotation note

Cycle 125 was nominally **comments-lane** (cycle 124 was a
designs-lane pivot). Comments-lane is active. Papers-lane has been
blocked for **19+ consecutive cycles** (97/100/102/104/106/108/110
/112/113/114/116/117/118/119/120/121/122/123/124) due to lack of
PDF-fetching infrastructure.

## Counts

- 628 → **629** sections (+1).
- 169 → **170** source documents (+1).
- Topic pages updated: `patterns.md` (+1 row — seventh @endo/
  patterns row), `marshal.md` (+1 row — third @endo/patterns
  consumer of `makeFullOrderComparatorKit().antiComparator`).
- Keywords index extended with ~31 bag-algebra-specific keywords.
- Sources/README.md updated (+1 row).
- Sections/README.md updated (+1 group; total adjusted).

## Next cycle

Cycle 126 wakes in 1500s. Rotation lands on **papers-lane**
nominally (still blocked). Expect another pivot.
