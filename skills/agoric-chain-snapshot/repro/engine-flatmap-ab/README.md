# Engine-level flat/flatMap value-stack A/B — verifying the Moddable fix

This harness verifies the **engine-side** fix for the ymax0 v320 XS value-stack
overflow (kriskowal/garden#9), complementing the **contract-side** `hex.js`
`flatMap`→loop fix verified by the drivers one directory up. It answers two
questions mhofman raised (#9 comment 4898246955):

1. Would a cherry-pick of Moddable-OpenSource `73aad47b` have fixed the issue?
2. Why does kriscendobot/moddable#1's `fx_Array_prototype_flatAux` fix "pop at a
   different place"?

## The three engine variants

`fx_Array_prototype_flatAux` (`xs/sources/xsArray.c`) builds the flattened result
on the heap but, in stock XS, leaves each per-iteration slot resident on the
**value stack**, so peak value-stack use is O(flattened output), not O(depth).
Per present element it leaks exactly one slot: in the LEAF branch the element that
`mxDefineIndex` defined into the result (`fxDefineAll` pops only the result-array
reference, leaving the value); in the NESTED branch the sub-array reference that
stays resident across the recursion. `fxHasIndex` balances the `mxPushSlot(source)`
at the top of the loop (`fxHasAll` does `the->stack = stack; mxPop()`), so the
source push is not the leak.

The two proposed fixes differ only in **where** the `mxPop()` goes:

| variant | placement | pops |
| --- | --- | --- |
| `stock`  | agoric-labs `f6c5951`, no pop | nothing (leaks ~2 slots/element: leaf + sub-array) |
| `cherry` | `73aad47b`: `mxPop()` INSIDE the leaf `else` branch, before `start++` | leaf refs only (nested sub-array refs stay resident) |
| `pr1`    | kriscendobot/moddable#1: `mxPop()` at the END of the `if (fxHasIndex)` block | BOTH leaf and nested sub-array refs → O(depth) |

## Build the three workers (stackCount=4096)

```sh
XSNAP=~/.cache/garden-scratch/exp6-ymax0/node_modules/@agoric/xsnap   # any agoric xsnap pkg
curl -sL https://raw.githubusercontent.com/agoric-labs/moddable/f6c5951fc055e4ca592b9166b9ae3cbb9cca6bf0/xs/sources/xsArray.c -o /tmp/stock_xsArray.c
for v in stock cherry pr1; do
  MODDABLE=$XSNAP/moddable PRISTINE=/tmp/stock_xsArray.c DEST=$XSNAP \
    python3 build-variant.py $v
done
```

`stackCount=4096` is the on-chain default, hardcoded at
`xsnap-native/xsnap/sources/xsnap-worker.c:365`. Workers must live on an `exec`
filesystem (not a `noexec` `/tmp`).

## Run the A/B (put `xsdrive.mjs` beside the workers or symlink it)

```sh
# hex.js-shaped (leaf-dominated): reproduces the ymax0 overflow class
for v in stock cherry pr1; do
  XSNAP_WORKER=$XSNAP/worker-4096-$v LABEL=$v node synth-flatmap-ab.mjs 700 900 1100
done
# nested-heavy: separates the two pop placements
for v in stock cherry pr1; do
  XSNAP_WORKER=$XSNAP/worker-4096-$v LABEL=$v node nested-flatmap-ab.mjs 2000 3800 4200
done
```

## Verified results (2026-07-07, agoric-labs moddable f6c5951, meteringLimit=0)

Synthetic hex.js-shaped `new Map(RI.flatMap(...))`, RI length N, 4 pairs each:

| N | pairs | stock | cherry (73aad47b) | pr1 |
| --- | --- | --- | --- | --- |
| 256 | 1024 | OK (size 512) | OK | OK |
| 700 | 2800 | OK (size 1400) | OK | OK |
| 900 | 3600 | **STACK_OVERFLOW** | OK | OK |
| 1100 | 4400 | **STACK_OVERFLOW** | OK | OK |
| 1300 | 5200 | **STACK_OVERFLOW** | OK | OK |

The stock overflow trace (this tree's instrumented worker) is the same signature
as the real ymax0 import: value stack 4092/4096, one wide frame holding 3883
slots of which **3878 are REFERENCE** — the flatMap pairs piling on the stack —
only ~5 frames deep (width, not depth).

Nested-heavy `Array.from({length:N},()=>[{}]).flat(1)`:

| N | stock | cherry (73aad47b) | pr1 |
| --- | --- | --- | --- |
| 2000 | **STACK_OVERFLOW** | OK | OK |
| 3800 | **STACK_OVERFLOW** | OK | OK |
| 4200 | **STACK_OVERFLOW** | **STACK_OVERFLOW** | OK |

**Conclusions.** A cherry-pick of `73aad47b`'s flatAux hunk clears the ymax0-class
(leaf-dominated) overflow at the stock 4096 stack — so yes, it would have fixed
the issue. PR#1 "pops at a different place" — end of the per-element block rather
than inside the leaf branch — which is strictly more complete: it also reclaims
the nested sub-array reference, so it stays O(depth) even for nested-array-heavy
`flat`, where `73aad47b`'s leaf-only pop still leaves ~N sub-array refs resident
and overflows at ~2× the stock width (N≈4100 vs N≈2000). Both suffice for hex.js;
PR#1 covers a class `73aad47b`'s placement leaves partially resident.

`73aad47b` also carries two unrelated hunks — a `mxPop()` in `fxSortArrayItems`
(Array sort) and two in `xsmc.c` `_xsDelete`/`_xsDeleteAt` — for separate
value-stack leak sites not on the hex.js import path; they don't bear on #9.

Scope: read-only analysis + on-host builds/runs of the open-source XS engine, on
bot forks only. No upstream `agoric/agoric-sdk` or `Moddable-OpenSource/moddable`
interaction.
