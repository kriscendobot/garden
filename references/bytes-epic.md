# Bytes epic — frozen Uint8Array / immutable ArrayBuffer (maintainer reference)

The cluster of `endojs/endo-but-for-bots` PRs implementing **passable byte arrays** as a
**plain frozen `Uint8Array` backed by an immutable `ArrayBuffer`** (and its emulation),
plus the related **`@endo/hex`** codec thread.

> **Data-model pivot (erights, 2026-06-30).** `byteArray` now maps a **plain frozen
> `Uint8Array` view** over a plain frozen immutable `ArrayBuffer`, **not a bare immutable
> `ArrayBuffer`**. A bare immutable buffer is no longer `byteArray` and is not passable.
> The design of record is **#572**; the fresh view-based implementation is **#475**. The
> three earlier "admit bare immutable ArrayBuffer through codecs" PRs (#57, #429, and
> upstream endojs/endo#3226) were **withdrawn** on 2026-06-30 to execute this pivot — the
> old "#57 stacked on #475" note is obsolete.

> **Upstream-bound.** The open feature PRs below are destined for upstream `endojs/endo`
> master and will need to be stacked/ferried; confirm the intended order before ferrying.

Maintained by the liaison for reference; update as PRs land. Last refreshed 2026-07-02.

## In-flight (open) — upstream-bound

| PR | Title | Base | Upstream |
|----|-------|------|----------|
| [#572](https://github.com/endojs/endo-but-for-bots/pull/572) | design: **byteArray maps a frozen Uint8Array view**, not a bare immutable ArrayBuffer — the design of record for the pivot; Ready for review. Whole-buffer span resolved **restrictive** (sub-view relaxation tracked at [#573](https://github.com/endojs/endo-but-for-bots/issues/573)) | `llm` | — |
| [#475](https://github.com/endojs/endo-but-for-bots/pull/475) | feat(pass-style): **narrow byteArray to plain frozen Uint8Array** — the **fresh view-based implementation PR** Design Decision 6 of #572 calls for (seeded from `feat/narrow-bytearray-to-uint8`); carries the narrowing, restrictive whole-buffer span, and codec admission. Ready for review, CI green. Stacked on merged #473 | `master` | — |
| [#503](https://github.com/endojs/endo-but-for-bots/pull/503) | feat(immutable-arraybuffer,pass-style): passable byte arrays (freezable TypedArray emulation + byteArray brand check) — upstream-ready reconstruction of merged #468+#473 for boatman ferry | `master-a7ff191` | — |
| [#472](https://github.com/endojs/endo-but-for-bots/pull/472) | chore: document `bytesToImmutable` freezable-TypedArray usage | `master-80e9b3e` | — |
| [#586](https://github.com/endojs/endo-but-for-bots/pull/586) | test(immutable-arraybuffer): exhaustive `byteOffset`+`length` constructor boundary tests (96 deterministic cases across the eleven flavors) — lands the boundary tests parked in #472, per erights' go-ahead | `master` | — |

## @endo/hex codec thread

- [#580](https://github.com/endojs/endo-but-for-bots/pull/580) chore(benchmarks): **hex-decode codec comparison across Node and XS** — standalone platform/size/speed/approach benchmark under `benchmarks/hex-decode-codec-comparison/` (native / char-code / buffer / map / lut). Validates `@endo/hex`'s shipped `native → char-code` dispatch and tests the agoric-sdk#7 premise (char-pair `Map` fastest on XS, `Buffer` fastest on Node). Does **not** modify the published `@endo/hex@1.1.1`; genuine platform wins would be proposed upstream via a later ferry. **Draft.** `master-0594e99`
- [kriscendobot/agoric-sdk#7](https://github.com/kriscendobot/agoric-sdk/pull/7) fix(internal): XS-safe hex decoding table (bounded loop) + Bufferish codec validation — related **downstream** item (refs kriskowal/garden#9); re-scoped to slim `@agoric/internal`'s `packages/internal/src/hex.js` to a thin re-export of the published `@endo/hex@1.1.1`. Fork-internal draft; base+head both on the `kriscendobot/agoric-sdk` fork (no upstream Agoric contact).

## Landed (merged) — substrate / context

- [#473](https://github.com/endojs/endo-but-for-bots/pull/473) feat(pass-style): validate plain frozen Uint8Array on immutable buffer as byteArray (base of #475)
- [#468](https://github.com/endojs/endo-but-for-bots/pull/468) feat(immutable-arraybuffer): freezable TypedArray emulation per #449 design
- [#449](https://github.com/endojs/endo-but-for-bots/pull/449) design(immutable-arraybuffer): freezable TypedArray emulation (followup to #435)
- [#435](https://github.com/endojs/endo-but-for-bots/pull/435) feat(immutable-arraybuffer,ses): drop the pseudo-prototype intrinsic
- [#451](https://github.com/endojs/endo-but-for-bots/pull/451) docs(immutable-arraybuffer): Moddable XS row in the support table
- [#140](https://github.com/endojs/endo-but-for-bots/pull/140) design(bytes): @endo/bytes package for Uint8Array helpers

## Closed / superseded

- [#57](https://github.com/endojs/endo-but-for-bots/pull/57) feat(marshal,pass-style): admit immutable ArrayBuffer through codecs — **withdrawn 2026-06-30** per the view-based pivot (mapped the bare buffer); superseded by #475/#572
- [#429](https://github.com/endojs/endo-but-for-bots/pull/429) feat(marshal,pass-style): admit immutable ArrayBuffer through codecs (llm-base mirror of #57) — **withdrawn 2026-06-30** per the pivot; its upstream original [endojs/endo#3226](https://github.com/endojs/endo/pull/3226) was closed the same day
- [#430](https://github.com/endojs/endo-but-for-bots/pull/430) feat(immutable-arraybuffer): no-spackle experiment from #417 — **closed 2026-06-30**
- [#417](https://github.com/endojs/endo-but-for-bots/pull/417) feat(immutable-arraybuffer): freezable virtual typedarrays (mirror of [endo#3164](https://github.com/endojs/endo/pull/3164)) — superseded by #430
- [#56](https://github.com/endojs/endo-but-for-bots/pull/56) feat(marshal): admit immutable ArrayBuffer through codecs — predecessor of #57
- [#27](https://github.com/endojs/endo-but-for-bots/pull/27) feat(base64): dispatch to native Uint8Array base64 intrinsics — tangential

## Stack order (current)

The bare-buffer codec stack (the old "#57 → on #475") is dissolved: #57/#429/endo#3226 are
withdrawn and the direction is now the view-based model. Current shape:

- **#473 (merged) → #475** — #475 is the fresh view-based implementation, stacked on the
  already-merged #473; it carries the consolidated narrowing + restrictive whole-buffer
  span + codec admission, and is the branch #572 names as the seed.
- **#572** is the design of record (on `llm`), Ready for review; sub-view relaxation is
  deferred to issue #573.
- **#503** is a separate upstream-ready reconstruction of the merged #468+#473 substrate
  (on `master-a7ff191`) for boatman ferry.
- **#472 → #586** — #586 lands the boundary tests #472 parked (both on `master`).

Upstream ferry order (substrate → byteArray view model → codecs → docs/tests) still needs
maintainer confirmation before ferrying; record it here once decided.
