---
created: 2026-07-03
updated: 2026-07-03
author: gardener
---

# Skill: xs-debugging

The garden's reusable methodology for debugging **XS** (the Moddable JavaScript
engine that Agoric's `xsnap` worker and endojs's XS surfaces run on): diagnosing
value-stack overflows, symbolicating a native crash into JS frames, and choosing
between the targeted and the coarse remedy. This is the **broad XS envelope**. It
is engine-level knowledge that is not specific to one repo, so it applies wherever
an XS worker runs, which today is two projects:

- **agoric-sdk**: the swingset `xsnap` worker (`packages/xsnap`,
  `packages/swingset-*`), where a contract-bundle import or a vat upgrade runs
  user code under XS. Reproduction against real chain state is the
  [agoric-chain-snapshot](../agoric-chain-snapshot/SKILL.md) lever.
- **endojs**: endo's XS builds and the **`xs2rust-endor`** port
  (endojs/endo-but-for-bots#600), where XS semantics are the thing being ported,
  so any divergence is an XS-behavior debugging question.

This skill is the *envelope*. The project-specific reproduction and tooling live
in the sub-role briefs that point here: the fixer's
[agoric-sdk](../../roles/fixer/subroles/agoric-sdk.md) and
[endojs](../../roles/fixer/subroles/endojs.md) debugging sub-roles.

## The signals: what an XS overflow looks like

An XS value-stack exhaustion surfaces under several renderings depending on how
far up the stack you are reading. Learn to recognize them as **one** fault:

| Layer | Signal you see |
| --- | --- |
| XS engine | exit code **12** (`E_STACK_OVERFLOW`), `exited: stack overflow` |
| Metered worker | `Stack meter exceeded` (a metered `xsnap` renders the overflow this way) |
| swingset delivery | `Vat Creation Error: Stack meter exceeded`, `vat-upgrade failure` |
| slog / flight recorder | a delivery record with `{"#error":"Stack meter exceeded","errorId":"error:liveSlots…"}` |

Reading the slog for these is [slog-debugging](../slog-debugging/SKILL.md).

## Root-cause pattern: width, not depth

The load-bearing insight from kriskowal/garden#9 (the ymax0 v320 70->71 upgrade
overflow): **an XS value-stack overflow is often value-stack *width*, not
call-depth recursion.** XS gives each machine a fixed value stack (the ymax0 case:
**4,096 slots**). Ordinary deep recursion is one failure mode. The subtler one is a
single expression that materializes a very wide set of live reference slots *at
once*.

The canonical offender is a **wide `.flatMap(...)` (or `.map(...)`) that builds a
large collection during module evaluation**. In the ymax0 case,
`@agoric/internal/src/hex.js` built its `decodings` table with
`new Map(encodings.flatMap(...))`, spreading **~1,024 live slots** onto the value
stack simultaneously. That is enough to tip a 4,096-slot machine over **during the
bundle import**, before any message is delivered. Native XS `flatMap` spreads its
intermediate arrays onto the value stack, so the width is real, not an
abstraction.

Diagnostic tells that point at width-not-depth:

- The crash happens **at import / module-evaluation time**, not on a later
  delivery.
- The trace is **shallow** (not thousands of self-recursive frames) but sits
  inside an array builtin (`flatMap`, `map`, spread).
- The same code ran fine until an input grew (a larger bundle, a wider table): the
  code did not change, it **crossed a fixed-width threshold**. In ymax0, `hex.js`
  was byte-identical beta2->beta3; the beta3 bundle simply crossed 4,096.

## Instrumentation: symbolicating a native crash into JS frames

When the bare signal (exit 12) is not enough, the methodology is to interleave the
**C stack** with **symbolicated JS frame names** (file/line), so a native overflow
reads as the JavaScript that caused it. This is the overflow-trace instrumentation
carried on `kriscendobot/agoric-sdk` (`debug/xs-stack-overflow-methodology`,
kriscendobot/agoric-sdk#6). The steps:

1. Build/patch XS to walk its own frame stack at the overflow point and emit each
   JS frame's function name, file, and line alongside the C frames.
2. Run the failing import under that instrumented worker.
3. Read the interleaved trace: the deepest JS frames name the offending call site
   (in ymax0, the `hex.js` `flatMap` inside the `decodings` table build).
4. Cross-check the slot accounting: count the live slots the offending expression
   materializes and compare against the machine's `stackCount`.

Keep the instrumentation and the methodology write-up on the fork's methodology
branch. The garden skill is the distilled procedure, not the patch.

## Remedies, targeted to coarse

Two levers fix an XS value-stack overflow. Prefer the targeted one, and understand
the coarse one's cost.

1. **Targeted, narrow the offending expression (the `flatMap`->loop rewrite).**
   Replace the wide `new Map(coll.flatMap(...))` with a `new Map` plus a bounded
   `for` loop plus `.set()`. The loop materializes one entry at a time instead of
   spreading the whole intermediate array onto the value stack, dropping the
   ~1,024-slot spike. This is **one call site** and flips the outcome from overflow
   to clean import on the stock stack. Verify the net behavior is identical (the
   Map is built with the same entries) with a
   [regression-evidence](../regression-evidence/SKILL.md)-style equivalence
   assertion.
   - **Residual caveat:** the loop rewrite removes the ~1,024-slot spike but leaves
     the baseline flat-functor closure count (~2,000 in ymax0). A future
     module-scope widening can re-trip the stock stack. The durable structural
     remedy is the `bundle-source`/esbuild **sub-module-functor** lever (split the
     module so its functors are not all live at once), not the one-line patch.

2. **Coarse, raise the compile-time value-stack `stackCount`.** Recompiling XS with
   a taller value stack also resolves the import. Its cost is **not** snapshot
   incompatibility: the XS snapshot read path (`fxReadSnapshot` in
   `moddable/xs/sources/xsSnapshot.c`) gates only on `XS_MAJOR_VERSION`,
   `XS_MINOR_VERSION`, the architecture byte (`sizeof(txSlot)`), and the signature
   string (`"xsnap 1"`), and `stackCount` is none of these. A restored machine is
   allocated from the *snapshot's* creation atom, so old on-chain snapshots stay
   loadable; only **fresh** machine creations (a vat upgrade abandons its heap and
   starts fresh, so an upgrade import *does* pick up the taller stack) get the
   larger stack. The real cost is **determinism**: a taller binary writes different
   snapshot bytes (hashes), so in a replicated system (a chain) **all validators
   must cut over in lockstep at an agreed height**. That is why the targeted patch
   is preferred for a single call site and the taller stack is the lever for a
   systemic width problem.

## Procedure (debugging an XS overflow end to end)

1. **Classify the signal.** Map whatever you see (exit 12 / `Stack meter
   exceeded` / `vat-upgrade failure` / a slog `#error`) to "XS value-stack
   exhaustion". Confirm it is import/eval-time (width) versus delivery-time
   recursion (depth) from *when* it fires.
2. **Localize.** If the trace is opaque, run under the instrumented worker to get
   symbolicated JS frames (above). Otherwise read the shallow trace for the array
   builtin at the tip.
3. **Account for the slots.** Estimate the live-slot width the offending
   expression materializes and compare to the machine `stackCount`. A width near or
   over the budget confirms width-not-depth.
4. **Reproduce.** For agoric-sdk, reproduce against real chain state with
   [agoric-chain-snapshot](../agoric-chain-snapshot/SKILL.md) (the `createVat`
   import A/B is the decisive cross-check; the contract-control `upgrade(bundleId)`
   vector is the faithful one). For endojs, reproduce with the project's own XS
   test harness.
5. **Remedy.** Apply the targeted `flatMap`->loop rewrite at the call site and
   verify the collection is built identically. Only reach for the taller
   `stackCount` when the problem is systemic, and then flag the lockstep-cutover
   determinism constraint.
6. **Prove the flip.** A/B the control (overflows) against the patched (imports
   clean) on the same worker and cite the exact delta (in ymax0: one `.flatMap(`
   removed, 10->9). A "verified" claim needs the real run, per `roles/COMMON.md`
   § Reporting.

## Related

- [agoric-chain-snapshot](../agoric-chain-snapshot/SKILL.md): the on-chain
  reproduction lever (capture a mainnet swing-store, feed inquisitor, A/B the fix).
- [slog-debugging](../slog-debugging/SKILL.md): read the slog / flight recorder for
  the overflow's delivery-level record.
- [regression-evidence](../regression-evidence/SKILL.md): prove a `flatMap`->loop
  rewrite is behavior-preserving.
- Fixer debugging sub-roles that route here:
  [agoric-sdk](../../roles/fixer/subroles/agoric-sdk.md),
  [endojs](../../roles/fixer/subroles/endojs.md).

## Scope

Read-only analysis plus on-host runs of the open-source XS worker and public
bundles, on bot forks only. No upstream `agoric/agoric-sdk` or `endojs/endo`
interaction (`roles/COMMON.md` § External-repo etiquette).
