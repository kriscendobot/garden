---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
handler-timeout: 10800
---
Implement ReadableBlob range attenuation on endojs/endo-but-for-bots, per the
MERGED design `designs/readableblob-range-attenuation.md` (design PR
endojs/endo-but-for-bots#826, now on `llm`). MAINTAINER GO-AHEAD (kriskowal,
2026-09-16).

PROVENANCE: this replaces the empty husk `build-readableblob-range-attenuation`,
whose body was lost to a poison/requeue cycle and which has sat parked since
2026-08-01 with 0 bytes of spec. Do not look for prior state there; this is the
spec.

## What to build

Replace the byte-window READ with a capability ATTENUATION. Today
`ReadableBlob.fetch(offset, length)` returns a one-use `PassableBytesReader`, so
a caller cannot pass the selected part of a blob on as the same read capability.
The replacement returns a new, ephemeral `ReadableBlob` with exactly the
authority to read the selected portion:

```ts
range(start: bigint, end: bigint): Promise<ReadableBlob>
textRange(startLine: number, endLine: number): Promise<ReadableBlob>
```

Ranges therefore COMPOSE and can be handed to anything that already accepts a
readable blob. Runtime guards must require the returned `ReadableBlob`, NOT
`M.any()`, so the same-interface guarantee is enforced at the CapTP boundary.

THIS IS A SEMANTIC RENAME, NOT A MECHANICAL `fetch` SEARCH-AND-REPLACE. The old
method's result is a `PassableBytesReader`; the new one is a same-interface
capability. `fetch` CANNOT be an alias of `range`. The design is explicit that
the inventory must be taken before editing, and that range-specific `fetch`
definitions must be separated from the unrelated HTTP, Git-transport, and
content-store methods that are also named `fetch`.

## Semantics (from the design; do not re-derive)

- `range(start, end)` selects the half-open byte interval `[start, end)` relative
  to the RECEIVER. Non-negative bigints in the backing safe-offset domain.
  `start > end`, negative, or non-safe rejects `EINVAL`; `start === end` returns
  an empty blob. Selection CLAMPS at the receiver's end, so `range(100n, 200n)`
  on a 12-byte blob is a valid empty attenuation and `range(6n, 100n)` is the
  suffix.
- Constructing a range neither reads nor persists bytes. The returned cap retains
  only its source cap plus the composed interval, so a range of a range
  INTERSECTS the intervals and can never regain authority outside its parent.
  This is the security property of the whole change — test it directly.
- Every ordinary read applies to the attenuated bytes: `text()`/`json()` decode
  only those bytes, `streamBase64()` streams only those, `getInfo()` reports the
  SELECTED content's `{algorithm, hash, size}`. Empty range = size `0n` + SHA-256
  of empty bytes. For an immutable source this is a stable content address; for
  the live mount-file face it preserves current live semantics (each operation
  observes the source at that operation, subject to the fixed interval).
- `textRange(startLine, endLine)` selects lines `[startLine, endLine)` relative to
  the receiver's current bytes and returns the byte slice as a `ReadableBlob`.
  Zero-based, end-exclusive, plain `number` indices. Negative/fractional/non-safe
  or inverted rejects `EINVAL`; equal, or start at/beyond end, returns empty; end
  past the last line clamps.
- Line boundaries are LF (0x0a). A CR before LF stays content — CRLF is PRESERVED,
  not normalized. A final LF creates the same terminal empty line `rangeReadText`
  uses, and selecting through it preserves the final LF. `textRange(a,b).text()`
  must agree with `rangeReadText` on exactly which bytes a line range selects.
- `textRange` is defined on the RECEIVER, not the original blob: a text range of a
  byte range indexes the lines visible in that byte range, and vice versa. That is
  the intended attenuation law even when a byte range starts or ends mid-line.

## Resolved decisions — settled, do not reopen

1. `textRange` keeps the zero-based, end-exclusive, LF-with-terminal-empty-line
   model, consistent with `rangeReadText`.
2. NO compatibility window and NO versioned legacy-adapter package. Migration is
   not a concern: replace the old methods outright, with no deprecated aliases.
3. Every current rich blob adopts the new surface in ONE clean release — `BlobRef`,
   `LocalBlob`, daemon stored and transient blobs, mount views, and Git blobs. No
   daemon-only-first phase, no temporary interface split.

Also: do NOT add `range`/`textRange` to `Directory`, `ReadableTree`,
`EndoDirectory`, `EndoGuest`, or `EndoHost`. Path selection stays `lookup`; range
selection happens on the blob.

## The three-step plan the design prescribes

1. Add a shared attenuation maker plus tests (byte composition, empty and
   EOF-clamped selections, revocation/liveness, `getInfo` on selected content,
   text-line selections). Adopt it in every rich blob implementation. Keep the
   source's identity and lifetime PRIVATE: derived ranges get no formula, no name,
   no persistence entry.
2. Replace `fetch`, `rangeRead`, and `rangeReadText` with `range`/`textRange` on
   every producer in one clean break. Update internal consumers (`cas.js`,
   `cached-fs.js`, daemon consumers) to the new cap shape, decoding/streaming
   through the normal blob surface where they previously consumed a bytes reader.
3. Rename the shared guard to the single `ReadableBlob` surface, drop the
   `ReadableBlobRange*` names, update generated declarations and help text, and
   make method-set conformance tests assert every derived cap exposes the same
   methods as its parent.

## Test matrix (required)

Nested byte ranges; byte-after-text and text-after-byte ranges; terminal-LF
behavior; CRLF preservation; invalid arguments; `start === end`; EOF clamping;
immutable snapshot stability; live mount changes; revocation.

## Inventory to update

The design's table is authoritative — read it on `llm` rather than working from
this summary. It spans: the shared lite contract (`packages/platform/src/fs/
interfaces.js`, `types.d.ts`, `index.js`, `packages/exo-git/src/types.ts`);
implementations (`fs-node/local-blob.js`, `fs/extended/shared/blobref.js`,
`daemon/src/manager.js` `makeReadableBlob`/`makeBytesBlob`, `daemon/src/mount.js`
`makeMountFileExo`/`makeReadableBlobView`, `git/src/native-git-backend.js`);
the extended guard and consumers (`type-guards.js`, `cas.js`, `cached-fs.js`);
daemon guard/declarations/help (`daemon/src/interfaces.js`, `types.d.ts`,
`help-text-data.js`, `help.md`); existing range tests across
`packages/platform/test/` and `packages/daemon/test/` plus the mount conformance
tests; and the design/API prose listed there.

## Scope and splitting

This is a large clean-break change across many packages. If it does not fit one
handler even at 10800s, SPLIT it along the design's own three steps and say so in
your report rather than overrunning — steps 1, 2, and 3 are natural claim-sized
stages. Follow skills/local-verify and the pre-push gates; open the PR per the
normal build flow.
