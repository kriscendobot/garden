# Stock-`xst` A/B — flat/flatMap value-stack overflow before/after `73aad47b`

This harness answers mhofman's follow-up on kriskowal/garden#9
([comment 4907678857](https://github.com/kriskowal/garden/issues/9#issuecomment-4907678857)):

> Can you verify the stack overflow using `xst` instead of our worker? You should
> be able to use release `xst`, from before and after `73aad47b` to confirm. If
> the pop at the end of the block is indeed the more correct place, Moddable needs
> a test case to reproduce the issue against the latest release.

Everything here runs on the **stock upstream `xst`** (the standalone XS shell) built
straight from tagged **Moddable-OpenSource/moddable releases** — no agoric fork, no
xsnap worker, no patches. It complements `../engine-flatmap-ab/` (which A/B's the
three `mxPop()` placements on the agoric xsnap worker at the on-chain
`stackCount=4096`); this one confirms the same behavior on the canonical engine
release binaries, at `xst`'s own default 256K-slot value stack.

## The release window

[`Moddable-OpenSource/moddable@73aad47b`](https://github.com/Moddable-OpenSource/moddable/commit/73aad47b3eb5f5f13baf401bd28d1609c14f23ab)
("XS: fix array flat/sort stack overflows") landed **2026-01-20**.

| release | date | contains `73aad47b`? | `flatAux` leaf branch |
| --- | --- | --- | --- |
| **7.0.0** | 2026-01-16 | **no** (BEFORE) | `mxDefineIndex; start++` — no pop |
| **7.1.0** | 2026-02-11 | yes (first AFTER) | `mxDefineIndex; mxPop(); start++` |
| **8.3.0** | 2026-07-03 | yes (LATEST) | `mxDefineIndex; mxPop(); start++` |

Confirmed with `gh api .../compare/73aad47b...<tag>`: 7.0.0 is *behind* the commit
(does not contain it), 7.1.0 and 8.3.0 are *ahead* (contain it).

## The two branches of `fx_Array_prototype_flatAux`

`fx_Array_prototype_flatAux` (`xs/sources/xsArray.c`) builds the flattened result on
the heap but, in stock XS, leaves per-iteration slots resident on the **value
stack**, so peak use is O(flattened output), not O(depth). Two leak sites:

- **LEAF branch** — `item` defined into the result via `mxDefineIndex`; `fxDefineAll`
  pops only the result-array reference, leaving the value below it. `73aad47b` adds
  `mxPop()` here. This is the ymax0 `hex.js` class (`new Map(RI.flatMap(...))`,
  leaf-dominated).
- **NESTED branch** — `item = the->stack` (the sub-array), pushed before descending;
  after the recursion returns it is **never popped**. `73aad47b` does **not** touch
  this branch, so it still leaks one slot per nested element on the latest release.
  kriscendobot/moddable#1 moves the pop to the **end of the `if (fxHasIndex)` block**,
  covering both branches.

## Build the three release `xst`s

```sh
for tag in 7.0.0 7.1.0 8.3.0; do ./build-xst.sh $tag; done
# each prints  .../src/moddable-<tag>/build/bin/lin/release/xst
```

## Run the A/B

```sh
XST() { echo ~/.cache/garden-scratch/xst-ab/src/moddable-$1/build/bin/lin/release/xst; }
# LEAF (ymax0 hex.js class) — fast:
for tag in 7.0.0 7.1.0 8.3.0; do ./run-ab.sh leaf   300000 "$(XST $tag)"; done
# NESTED (the branch 73aad47b leaves resident) — SLOW at 256K stack (see note):
for tag in 7.0.0 7.1.0 8.3.0; do ./run-ab.sh nested 300000 "$(XST $tag)" 600; done
```

## Verified results (2026-07-07, x86-64 linux, GOAL=release)

Stock `xst` runs a script file with a **256K-slot** value stack
(`xs/tools/xst.c` `_creation.stackCount = 256*1024`), so thresholds are ~256K
elements — far above the on-chain xsnap 4096, but the **same leak**. A value-stack
exhaustion surfaces as `Error: JavaScript stack overflow` (exit 1).

### LEAF — `[inner].flat()`, inner = K scalars (the ymax0 `flatMap` class)

| K | 7.0.0 (before) | 7.1.0 (after) | 8.3.0 (latest) |
| --- | --- | --- | --- |
| 300000 | **STACK OVERFLOW** | OK | OK |

Fast (< 1 s): the leaf loop allocates almost nothing, so it fills the stack in one
near-linear pass. **`73aad47b` fixes the ymax0-class (leaf) overflow on release
`xst`, before → overflow, after → clean.** This is the decisive "verify with `xst`,
before and after" result.

### NESTED — `a = [inner,inner,…] (N×); a.flat(1)`, every element an array

| N | 7.0.0 (before) | 7.1.0 (after) | 8.3.0 (latest) |
| --- | --- | --- | --- |
| 130000 | OK (42 s) | — | — |
| 160000 | **STACK OVERFLOW** (76 s) | — | — |
| 300000 | **STACK OVERFLOW** | **STACK OVERFLOW** (229 s) | **STACK OVERFLOW** (218 s) |

Before the fix the nested case leaks **two** slots per element (leaf + sub-array), so
it overflows at N ≈ 150K. After `73aad47b` the leaf slot is popped but the sub-array
slot is **not**, so the leak halves (one slot/element) and the overflow simply moves
out to N ≈ 256K — **it does not go away on the latest release.** That is the case
`73aad47b` leaves open and kriscendobot/moddable#1's end-of-block pop closes.

> **Timing note.** At the 256K stock stack the nested overflow is O(N²) to reach —
> XS's GC rescans the growing value stack on every collection — so each nested run
> is minutes, not seconds. This is a property of the large default stack, not the
> bug: at the on-chain `stackCount=4096` the identical nested overflow trips at
> N ≈ 4200 in well under a second (`../engine-flatmap-ab/README.md`).

## Test cases for Moddable

- [`testcase-flat-leaf-overflow.js`](./testcase-flat-leaf-overflow.js) — reproduces
  the overflow `73aad47b` fixed; a regression guard for the leaf pop (overflows
  ≤ 7.0.0, passes ≥ 7.1.0).
- [`testcase-flat-nested-overflow.js`](./testcase-flat-nested-overflow.js) — **the
  one mhofman asked for**: still overflows on the **latest** release `xst` (8.3.0),
  because 73aad47b's leaf-only pop leaves the nested branch resident. Passes only
  with kriscendobot/moddable#1's end-of-block pop. Runs in minutes at the 256K stock
  stack; Moddable's harness can create the machine with a small `stackCount` (e.g.
  4096) to trip it in well under a second.

## Conclusion

1. **Verified on release `xst`, before and after `73aad47b`:** 7.0.0 overflows on the
   ymax0 (leaf) class, 7.1.0 and 8.3.0 clear it. The cherry-pick is confirmed on the
   canonical engine, not just the agoric worker.
2. **The end-of-block pop is the more correct place, confirmed on release `xst`:** the
   nested branch still leaks on the latest release (8.3.0) — its overflow only moves
   out from N ≈ 150K to N ≈ 256K, it does not disappear. `testcase-flat-nested-overflow.js`
   is the reproduction against the latest release Moddable can adopt.

Scope: read-only analysis + on-host builds/runs of the open-source XS engine from
public Moddable release tarballs. No upstream `Moddable-OpenSource/moddable` or
`agoric/agoric-sdk` interaction.

## Follow-up (2026-07-28) — the fix as a PR on the fork, and a fast reproducer

mhofman asked for the fix as a PR against **upstream HEAD** on the bot fork
([kriskowal/garden#9 comment 5098251895](https://github.com/kriscendobot/garden/issues/9#issuecomment-5098251895)):
[**kriscendobot/moddable#2**](https://github.com/kriscendobot/moddable/pull/2) —
base `upstream-public` (a branch of the fork pinned at
`Moddable-OpenSource/moddable@23b4d6b0`, "version bump 8.3.1"), head
`xs-flat-value-stack`. It *moves* the `73aad47b` leaf `mxPop()` to the end of the
`if (fxHasIndex)` block (upstream HEAD already carries the leaf pop, so this is a
move, not an addition) and adds two tests in Moddable's own suite:
`tests/xs/built-ins/Array/prototype/{flat,flatMap}/value-stack.js`.

**The reproducer is now instant, not minutes.** The O(N²) runtime reported above is
**not** the leak — it is how the *source array* is built. Under XS,
`new Array(N)` followed by index assignment (or `.fill(ref)`) is quadratic; the
same array built with `push` is linear:

| build of a 300000-element array | time |
| --- | --- |
| `new Array(N)` + `a[i] = inner` | 3 m 56 s |
| `new Array(N).fill(inner)` | ~16 s at N=100000 |
| `a = []; a.push(inner)` | **0.15 s** |

With `push`, the nested-branch overflow on stock release `xst` (256K slot value
stack) trips in **0.15 s** at N = 300000 — so the Moddable test needs no small
`stackCount` build and no minutes-long run. That is what the PR's test cases do.

**Verification of the PR (x86-64 linux, `make -f xst.mk GOAL=release`, XS 17.9.1):**

| suite | before (`23b4d6b0`) | after (PR#2) |
| --- | --- | --- |
| the two new tests (via test262 runner, strict + sloppy) | both `JavaScript stack overflow` | 4 cases, no failures |
| `test262` `built-ins/Array` (6112 cases) | 6 failures | same 6 failures |
| `$MODDABLE/tests/xs/built-ins` | 6 failures (4 pre-existing + the 2 new) | 4 pre-existing |
| `$MODDABLE/tests/xs/language` | 0 failures | 0 failures |

Recipe: copy `$MODDABLE/tests` to `<test262>/test/moddable` (or symlink), then from
`<test262>/test` run `xst moddable/xs/built-ins/Array/prototype/flat`. `xst` enters
test262 mode whenever `../harness` resolves from the cwd.

(`$MODDABLE/tests/xs/issues` aborts stock `xst` at case ~#287 with a glibc
`free(): double free detected in tcache 2` — **pre-existing**, byte-identical
before and after the patch, unrelated to `flatAux`.)
