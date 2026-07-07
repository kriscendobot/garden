# Verifying the flat/flatMap value-stack overflow with release `xst`

This harness answers mhofman's follow-up on kriskowal/garden#9 (comment
4907678857): reproduce the XS value-stack overflow with the **standalone `xst`
test tool** (not the agoric xsnap worker), using **release** builds from
**before and after `73aad47b`**, and — if the "pop at the end of the block"
placement is the more correct one — produce a **test case Moddable can run
against the latest release**.

It complements `../engine-flatmap-ab/` (which A/B'd the same fix via the agoric
`xsnap-worker` at `stackCount=4096`); here the engine under test is Moddable's
own `xst`.

## The commit and the releases that bracket it

`Moddable-OpenSource/moddable@73aad47b` ("XS: fix array flat/sort stack
overflows", committed **2026-01-20**) is three one-line `mxPop()`s. The one that
bears on #9 is in `fx_Array_prototype_flatAux` (`xs/sources/xsArray.c`): it adds
`mxPop()` **inside the leaf `else` branch**, after `mxDefineIndex(...)`, before
`start++`. (The other two are `fxSortArrayItems` and `_xsDelete`/`_xsDeleteAt` —
unrelated leak sites, not on the flat path.)

| release | published | contains 73aad47b? | XS version |
| --- | --- | --- | --- |
| **7.0.0** | 2026-01-16 | **no** (before) | 16.9.1 |
| **7.1.0** | 2026-02-11 | **yes** (after)  | 17.9.1 |
| **8.3.0** | 2026-07-03 | yes (latest, still leaf-only) | 17.9.1 |

Ancestry confirmed via `gh api .../compare`: `7.0.0..73aad47b` is ahead 5 / behind
0 (7.0.0 lacks it); `73aad47b..7.1.0` is ahead 28 / behind 0 (7.1.0 has it).
Source check: 7.0.0's leaf branch is `mxDefineIndex(start, 0, XS_GET_ONLY);
start++;` (no pop); 7.1.0 and 8.3.0 insert `mxPop();` between them — exactly
73aad47b's placement.

## The mechanism (why leaf-only is incomplete)

`fx_Array_prototype_flatAux` builds the flattened result on the heap but, in
stock XS, leaves each per-iteration item on the **value stack**, so peak
value-stack use is O(flattened output), not O(depth). Per present element it
leaks one slot:

- **LEAF branch** — the element `mxDefineIndex` just defined (`fxDefineAll` pops
  only the result-array reference, leaving the value below it). This is what
  73aad47b's leaf `mxPop()` reclaims. The `@agoric/internal` `hex.js`
  `new Map(RI.flatMap(=> [p,p,p,p]))` that tripped the chain is **leaf-dominated**
  (256 elements x 4 pairs), so 73aad47b fixes the real ymax0 import.
- **NESTED branch** — the sub-array reference that stays resident across the
  recursive `flatAux` call. 73aad47b does **not** pop this, so a nested-heavy
  `.flat()` still leaks ~1 slot per nested element and still overflows on the
  latest release.

kriscendobot/moddable#1 puts the `mxPop()` at the **end of the
`if (fxHasIndex)` block** (covering both branches) → O(depth). It is a superset
of 73aad47b on the flat/flatMap path.

## Build and run

```sh
BASE=~/.cache/garden-scratch/exp9-xst   # anywhere on an exec filesystem
sh build-xst.sh          # clones 7.0.0/7.1.0/8.3.0, builds xst-<tag>-{256k,4096}
STACK=4096 sh flat-ab.sh # the A/B (4096 = on-chain xsnap value-stack size; fast)
```

`xst`'s default value stack is `256 * 1024 = 262144` slots (`xs/tools/xst.c`),
64x the on-chain xsnap `stackCount=4096`. Both reproduce the overflow; the 4096
variant trips at small, fast N (the 256k stock binary needs ~262k elements, and
near capacity the run goes **quadratic** — GC rescans the piling value stack — so
prefer the 4096 variant for the A/B and use the stock binary only to confirm the
default release also overflows).

## Results (2026-07-07, release xst, meteringLimit off)

### Answer to "confirm before/after `73aad47b`" — LEAF-dominated (hex.js shape)

`new Map(RI.flatMap((e,t)=>[[e,t],[e+'a',t],[e+'b',t],[e+'c',t]]))`, RI length N,
at `stackCount=4096`:

| N | 7.0.0 before | 7.1.0 after | 8.3.0 latest |
| --- | --- | --- | --- |
| 500  | OK (size 1910) | OK | OK |
| 900  | **STACK_OVERFLOW** | OK (3435) | OK |
| 1200 | **STACK_OVERFLOW** | OK (4578) | OK |
| 2000 | **STACK_OVERFLOW** | OK (7628) | OK |

→ **73aad47b fixes the ymax0-class (leaf-dominated) overflow.** The stock 256k
release binaries show the same crossover at ~64x the N: 7.0.0-256k overflows the
leaf shape at N=60000 (240k pairs), 7.1.0-256k imports clean to N≥100000.

### Answer to "is end-of-block the more correct place?" — NESTED-heavy `flat(1)`

`Array.from({length:N}, () => [{}]).flat(1)` at `stackCount=4096`:

| N | 7.0.0 before | 7.1.0 after (73aad47b) | 8.3.0 latest | 8.3.0 + PR#1 (end-of-block) |
| --- | --- | --- | --- | --- |
| 1500 | OK | OK | OK | OK |
| 2000 | **OVERFLOW** | OK | OK | OK |
| 3000 | **OVERFLOW** | OK | OK | OK |
| 4000 | **OVERFLOW** | **OVERFLOW** | **OVERFLOW** | OK |
| 8000 | — | — | **OVERFLOW** | OK (len 8000) |
| 60000 | — | — | **OVERFLOW** | OK (len 60000) |

7.0.0 leaks in **both** branches (~2 slots/elem → overflows near N≈2000 on a
4096 stack). 73aad47b pops the leaf only (~1 slot/elem → threshold **doubles** to
N≈4000 but is **not eliminated**). **The latest release (8.3.0) still overflows
the nested-heavy `.flat()`** — the residual bug. kriscendobot/moddable#1's
end-of-block pop covers both branches (O(depth)) and clears every N tested, with
correct results (`[1,[2,[3,[4]]]].flat(3) === [1,2,3,4]`; `flatMap` unchanged).

**Conclusion:** for #9 (leaf-dominated `hex.js`), 73aad47b is sufficient and is
the better upstream cherry-pick (it also fixes the sort / `xsDelete` sites). For
the general `flat`/`flatMap` class, the **end-of-block placement is strictly more
complete** — it additionally bounds nested-array-heavy `.flat()`, which 73aad47b
leaves overflowing on the latest release.

## The test case Moddable needs against the latest release

`moddable-flat-overflow.js` — a self-contained nested-heavy `.flat()` that
overflows on a stock `xst` (73aad47b..HEAD) and passes once the pop moves to the
end of the block. It overflows once N exceeds the value stack (~4000 at the
on-chain `stackCount=4096`; ~262000 at the stock xst default). Reproduce:

```sh
$BASE/xst-8.3.0-4096 -e 'N=4000; '"$(cat moddable-flat-overflow.js)"   # Error: JavaScript stack overflow
$BASE/xst-8.3.0pr1-4096 -e 'N=60000; '"$(cat moddable-flat-overflow.js)" # OK len=60000
```
