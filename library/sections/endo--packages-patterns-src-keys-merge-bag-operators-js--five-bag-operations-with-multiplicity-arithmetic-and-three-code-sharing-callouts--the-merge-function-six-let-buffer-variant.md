---
section: five-bag-operations-with-multiplicity-arithmetic-and-three-code-sharing-callouts
source: endo--packages-patterns-src-keys-merge-bag-operators-js
topics: [patterns, marshal]
status: current
title: The §merge function — six-let-buffer variant
parent: endo--packages-patterns-src-keys-merge-bag-operators-js--five-bag-operations-with-multiplicity-arithmetic-and-three-code-sharing-callouts
---

The §`merge(xbagEntries, ybagEntries)` function produces
`Iterable<[T, xCount, yCount]>` — *same output shape* as cycle
123's `merge`. But the buffer-let pattern grows from *four* to
*six* variables:

- Cycle 123: `let x; let xDone; let y; let yDone;` (element + done
  flag)
- This cycle: `let x; let xc; let xDone; let y; let yc; let yDone;`
  (element + count + done flag)

The extra `xc`/`yc` buffers carry the *actual multiplicities from
the bag entries* (not hardcoded `1n`/`0n` as in cycle 123). Each
emitted triple `[m, xc, yc]` carries the *real* counts:

- `xDone` only y left → `[y, 0n, yc]` (yc is the actual y count)
- `yDone` only x left → `[x, xc, 0n]` (xc is the actual x count)
- comp === 0 (equivalent) → `[x, xc, yc]` (both real counts)
- comp < 0 → `[x, xc, 0n]`
- comp > 0 → `[y, 0n, yc]`

Cycle 123's `merge` could be obtained by hardcoding `xc=1n` when
present (and `yc=1n` similarly). The *generalization-is-free*
claim is structural: bag-merge subsumes set-merge.

The §history-dependent comparator scoping is repeated verbatim
from cycles 120 + 123:

```js
const fullCompare = makeFullOrderComparatorKit().antiComparator;
```

Fresh per call. *Does not survive this one merge call.*
