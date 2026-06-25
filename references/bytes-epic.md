# Bytes epic — frozen Uint8Array / immutable ArrayBuffer (maintainer reference)

The cluster of `endojs/endo-but-for-bots` PRs implementing **passable byte arrays** as a
**plain frozen `Uint8Array` backed by an immutable `ArrayBuffer`** (and its emulation).

> **These changes are all bound for upstream `endojs/endo` master and will need to be
> stacked.** The open PRs below interdepend; confirm the intended stack order before
> ferrying. Known hard dependency: **#57 is stacked on #475**.

Maintained by the liaison for reference; update as PRs land.

## In-flight (open) — upstream-bound, to be stacked

| PR | Title | Base | Upstream |
|----|-------|------|----------|
| [#475](https://github.com/endojs/endo-but-for-bots/pull/475) | feat(pass-style): **narrow byteArray to plain frozen Uint8Array** — the model decision | `master` | — |
| [#57](https://github.com/endojs/endo-but-for-bots/pull/57) | feat(marshal,pass-style): admit immutable ArrayBuffer through codecs — **stacked on #475** | `feat/narrow-bytearray-to-uint8` | [endo#2871](https://github.com/endojs/endo/pull/2871) |
| [#503](https://github.com/endojs/endo-but-for-bots/pull/503) | feat(immutable-arraybuffer,pass-style): passable byte arrays (freezable emulation + byteArray brand check) | `master-a7ff191` | — |
| [#430](https://github.com/endojs/endo-but-for-bots/pull/430) | feat(immutable-arraybuffer): no-spackle experiment from #417 | `master-4a04d07` | — |
| [#429](https://github.com/endojs/endo-but-for-bots/pull/429) | feat(marshal,pass-style): admit immutable ArrayBuffer through codecs (**llm-base mirror of #57**) | `llm-2bd9e0c` | [endo#3226](https://github.com/endojs/endo/pull/3226) |
| [#472](https://github.com/endojs/endo-but-for-bots/pull/472) | chore: document `bytesToImmutable` freezable-TypedArray usage | `master-80e9b3e` | — |

## Landed (merged) — substrate / context

- [#473](https://github.com/endojs/endo-but-for-bots/pull/473) feat(pass-style): validate plain frozen Uint8Array on immutable buffer as byteArray
- [#468](https://github.com/endojs/endo-but-for-bots/pull/468) feat(immutable-arraybuffer): freezable TypedArray emulation per #449 design
- [#449](https://github.com/endojs/endo-but-for-bots/pull/449) design(immutable-arraybuffer): freezable TypedArray emulation (followup to #435)
- [#435](https://github.com/endojs/endo-but-for-bots/pull/435) feat(immutable-arraybuffer,ses): drop the pseudo-prototype intrinsic
- [#451](https://github.com/endojs/endo-but-for-bots/pull/451) docs(immutable-arraybuffer): Moddable XS row in the support table
- [#140](https://github.com/endojs/endo-but-for-bots/pull/140) design(bytes): @endo/bytes package for Uint8Array helpers

## Closed / superseded

- [#417](https://github.com/endojs/endo-but-for-bots/pull/417) feat(immutable-arraybuffer): freezable virtual typedarrays (mirror of [endo#3164](https://github.com/endojs/endo/pull/3164)) — superseded by #430
- [#56](https://github.com/endojs/endo-but-for-bots/pull/56) feat(marshal): admit immutable ArrayBuffer through codecs — predecessor of #57
- [#27](https://github.com/endojs/endo-but-for-bots/pull/27) feat(base64): dispatch to native Uint8Array base64 intrinsics — tangential

## Stack order (to confirm)

The open PRs are upstream-bound and need stacking. Known: #57 → on #475. The full intended
upstream stack order (substrate → byteArray model → codecs → docs) needs maintainer
confirmation; record it here once decided.
