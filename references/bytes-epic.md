# Bytes epic — frozen Uint8Array / immutable ArrayBuffer (maintainer reference)

The cluster of `endojs/endo-but-for-bots` PRs implementing **passable byte arrays** as a
**plain frozen `Uint8Array` backed by an immutable `ArrayBuffer`** (and its emulation),
plus the related **`@endo/hex`** codec thread.

> **Data-model pivot (erights, 2026-06-30).** `byteArray` now maps a **plain frozen
> `Uint8Array` view** over a plain frozen immutable `ArrayBuffer`, **not a bare immutable
> `ArrayBuffer`**. A bare immutable buffer is no longer `byteArray` and is not passable.
> The design of record is **#572**; the integrated implementation is **#475**. The
> three earlier "admit bare immutable ArrayBuffer through codecs" PRs (#57, #429, and
> upstream endojs/endo#3226) were **withdrawn** on 2026-06-30 to execute this pivot — the
> old "#57 stacked on #475" note is obsolete.

> **Upstream-bound.** The open feature PRs below are destined for upstream `endojs/endo`
> master and will need to be stacked/ferried; confirm the intended order before ferrying.

Maintained by the liaison for reference; update as PRs land. Last refreshed 2026-08-24.

## In-flight (open) — upstream-bound

| PR | Title | Base | Upstream |
|----|-------|------|----------|
| [#572](https://github.com/endojs/endo-but-for-bots/pull/572) | design: **byteArray maps a frozen Uint8Array view**, not a bare immutable ArrayBuffer — the design of record for the pivot. Non-draft and 5/5 green, but currently **CONFLICTING/DIRTY**; whole-buffer span remains restrictive (sub-view relaxation tracked at [#573](https://github.com/endojs/endo-but-for-bots/issues/573)) | `llm` | — |
| [#475](https://github.com/endojs/endo-but-for-bots/pull/475) | feat(pass-style): **narrow byteArray to plain frozen Uint8Array** — now the **broad integrated landing line**: consolidates `frozenBytes`/`thawedBytes` and carries the model through bytes, marshal, OCapN, thixotrope, pass-style, docs, types, and changesets; completes DataView emulation and adds hardened262/test262/XS/SES coverage, including the TextEncoder/TextDecoder intersection matrix. Non-draft, **MERGEABLE/CLEAN**, 27/27 green at `df0606e1bd`; latest review decision is Changes requested | `llm-e22e67a` | — |
| [#472](https://github.com/endojs/endo-but-for-bots/pull/472) | chore: document `bytesToImmutable` freezable-TypedArray usage. Non-draft, **MERGEABLE/CLEAN**, 15/15 green | `master-80e9b3e` | — |
| [#586](https://github.com/endojs/endo-but-for-bots/pull/586) | test(immutable-arraybuffer): exhaustive `byteOffset`+`length` constructor boundary tests (96 deterministic cases across the eleven flavors), carrying the boundary-test follow-up parked in #472. Non-draft, **MERGEABLE/CLEAN** | `master-46d4edf` | — |
| [#602](https://github.com/endojs/endo-but-for-bots/pull/602) | feat(immutable-arraybuffer): **Proxy-based freezable-TypedArray comparison** requested from #472 — an empirical alternative, not the landing implementation. **Draft**, MERGEABLE/CLEAN, 15/15 green | `master-80e9b3e` | — |

## @endo/hex codec thread

- [#664](https://github.com/endojs/endo-but-for-bots/pull/664) docs(designs): **platform-conditional `@endo/hex` dispatch** — the design follow-up requested when #580 landed: native first; shipped char-code fallback by default; legacy-XS `Map` decoder behind the `xs` export condition. **Draft**, 5/5 green but **CONFLICTING/DIRTY** on `llm`.
- The benchmark that motivated this design, #580, has landed; the downstream agoric-sdk experiment #7 closed without merging after its original fixes landed upstream independently. See the dispositions below.

## Landed (merged) — substrate / context

- [#580](https://github.com/endojs/endo-but-for-bots/pull/580) chore(benchmarks): hex-decode codec comparison across Node and XS — merged 2026-07-10; establishes the performance evidence behind #664
- [#1040](https://github.com/endojs/endo-but-for-bots/pull/1040) feat(hardened262): mirror the Hardened JavaScript test262 harness — merged 2026-08-20; the harness now carries #475's immutable-buffer/view and text-codec coverage
- [#473](https://github.com/endojs/endo-but-for-bots/pull/473) feat(pass-style): validate plain frozen Uint8Array on immutable buffer as byteArray (base substrate incorporated into #475)
- [#468](https://github.com/endojs/endo-but-for-bots/pull/468) feat(immutable-arraybuffer): freezable TypedArray emulation per #449 design
- [#449](https://github.com/endojs/endo-but-for-bots/pull/449) design(immutable-arraybuffer): freezable TypedArray emulation (followup to #435)
- [#435](https://github.com/endojs/endo-but-for-bots/pull/435) feat(immutable-arraybuffer,ses): drop the pseudo-prototype intrinsic
- [#451](https://github.com/endojs/endo-but-for-bots/pull/451) docs(immutable-arraybuffer): Moddable XS row in the support table
- [#140](https://github.com/endojs/endo-but-for-bots/pull/140) design(bytes): @endo/bytes package for Uint8Array helpers

## Closed / superseded

- [#503](https://github.com/endojs/endo-but-for-bots/pull/503) feat(immutable-arraybuffer,pass-style): passable byte arrays reconstruction — **closed unmerged 2026-08-22**, superseded by the broader, pivot-conforming #475 line
- [kriscendobot/agoric-sdk#7](https://github.com/kriscendobot/agoric-sdk/pull/7) fix(internal): XS-safe hex decoding table + Bufferish codec validation — **closed unmerged 2026-07-10** after the two original fixes landed independently on upstream `agoric-sdk`; its later consume-`@endo/hex` experiment did not land, and the Endo follow-up is now #664
- [#57](https://github.com/endojs/endo-but-for-bots/pull/57) feat(marshal,pass-style): admit immutable ArrayBuffer through codecs — **withdrawn 2026-06-30** per the view-based pivot (mapped the bare buffer); superseded by #475/#572
- [#429](https://github.com/endojs/endo-but-for-bots/pull/429) feat(marshal,pass-style): admit immutable ArrayBuffer through codecs (llm-base mirror of #57) — **withdrawn 2026-06-30** per the pivot; its upstream original [endojs/endo#3226](https://github.com/endojs/endo/pull/3226) was closed the same day
- [#430](https://github.com/endojs/endo-but-for-bots/pull/430) feat(immutable-arraybuffer): no-spackle experiment from #417 — **closed 2026-06-30**
- [#417](https://github.com/endojs/endo-but-for-bots/pull/417) feat(immutable-arraybuffer): freezable virtual typedarrays (mirror of [endojs/endo#3164](https://github.com/endojs/endo/pull/3164)) — superseded by #430
- [#56](https://github.com/endojs/endo-but-for-bots/pull/56) feat(marshal): admit immutable ArrayBuffer through codecs — predecessor of #57
- [#27](https://github.com/endojs/endo-but-for-bots/pull/27) feat(base64): dispatch to native Uint8Array base64 intrinsics — tangential

## Stack order (current)

The bare-buffer codec stack (the old "#57 → on #475") is dissolved: #57/#429/endo#3226 are
withdrawn and the direction is now the view-based model. Current shape:

- **#475** is the broad, integrated landing line on frozen base `llm-e22e67a`; it absorbs
  the earlier #468/#473 substrate and now carries the view model, codecs, DataView
  emulation, cross-package consumers, and the full test campaign together.
- **#572** remains the design of record, but its `llm` base is now conflicting. Resolve it
  alongside the #475 landing decision rather than sending it through an independent loop.
- **#602** is a separate, clean draft comparison of the Proxy alternative on
  `master-80e9b3e`; it is evidence for the landing decision, not a successor stack layer.
- **#503** is no longer a competing landing line; it closed as superseded by #475.
- **#472** is the documentation follow-up; **#586** is the associated boundary-test
  follow-up, now separately based on `master-46d4edf` rather than stacked directly on #472.
- **#580 (merged) → #664** is the current `@endo/hex` benchmark-to-design thread. The
  downstream agoric-sdk#7 experiment is closed and is not a stack layer.

Upstream ferry order (substrate → byteArray view model → codecs → docs/tests) still needs
maintainer confirmation before ferrying; record it here once decided.
