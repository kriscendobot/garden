---
role: builder
tier: mentor
fallback-tier: minion
handler-timeout: 14400
dispatch: automatic
---

# Retire `streamBase64()` from `@endo/exo-stream` and collapse the bytes surface

Repo: `endojs/endo-but-for-bots`. Base: `llm`. Branch from current `llm` and
open a draft PR against `llm` (the gauntlet auto-runs).

## Why now

`@endo/exo-stream` carries a base64 transitional surface that exists only
because CapTP could not pass binary. `packages/exo-stream/DESIGN.md` § "Migration
Path for Bytes Streams" states the plan explicitly:

> 1. **Current**: `streamBase64()` yields base64 strings
> 2. **Future**: When CapTP supports binary, implement `stream()` yielding `Uint8Array`
> 3. **Migration**: ... Eventually `streamBase64()` can be deprecated

That precondition is now met.
[`#475`](https://github.com/endojs/endo-but-for-bots/pull/475), "feat(pass-style)!:
narrow byteArray to a frozen Uint8Array", **merged to `llm` on 2026-08-30**
(merge commit `9675ba8212`). `byteArray` is a first-class pass-style, so bytes
can ride `stream()` directly and the base64 hop — an encode on the sender and a
decode on the receiver for every chunk, plus ~33% wire inflation — is pure
overhead.

## What to do

Remove the experimental base64 stream methods and clean up the resulting API
surface, on `llm`.

- Make bytes ride the generic protocol: responders yield `byteArray` values from
  `stream()`; delete `streamBase64()` and its `@endo/base64` encode/decode hops
  from `bytes-reader-from-iterator.js`, `bytes-writer-from-iterator.js`,
  `iterate-bytes-reader.js`, and `iterate-bytes-writer.js`.
- Collapse the API surface, not just the method. Once `stream()` carries bytes,
  decide and justify whether the four bytes-specific modules and their exports
  (`bytesReaderFromIterator`, `bytesWriterFromIterator`, `iterateBytesReader`,
  `iterateBytesWriter`) still earn their existence as distinct entry points or
  become thin aliases / disappear in favour of `readerFromIterator`,
  `writerFromIterator`, `iterateReader`, `iterateWriter`. The DESIGN's own
  migration text anticipates initiators moving from `iterateBytesReader()` to
  `iterateReader()`. Whichever you choose, the end state must be ONE obvious way
  to stream bytes.
- Update the type guards, interface guards, and `types.ts` / `types.types.d.ts`
  so no `streamBase64` method survives in any interface declaration.
- Update every consumer. This is the bulk of the work and it is NOT confined to
  `exo-stream`: `streamBase64` appears in **53 non-design code files across 10
  packages** (`agent-tools`, `daemon`, `exo-git`, `exo-stream`, `exo-unzip`,
  `exo-zip`, `git`, `platform`, `space-file-explorer`, `spaces-util`), and the
  bytes reader/writer helpers are imported by **17 packages**. Notable
  interface-bearing sites: `packages/daemon/src/{interfaces,mount,manager,host}.js`
  and `types.d.ts`, `packages/platform/src/fs/{interfaces,snapshot-blob}.js` and
  `blob.js`, `packages/exo-zip/src/zip.js`,
  `packages/git/src/native-git-backend.js`. Regenerate — do not hand-edit —
  anything under `packages/agent-tools/generated/`, and update the daemon help
  text (`help.md` + `help-text-data.js`) through whatever generator owns it.
- Update the docs that describe the retired surface: `packages/exo-stream/
  {README,DESIGN,MIGRATION,NEWS}.md`. DESIGN's "Migration Path for Bytes Streams"
  section should be rewritten as history/completed, not left describing a future.
- Add changesets per [changeset-discipline](skills/changeset-discipline/SKILL.md).
  This is a **breaking** wire and API change for `@endo/exo-stream` and every
  package whose Exo interface loses the method — mark majors accordingly and say
  so plainly in the changeset prose.

## The question you must resolve and report, not silently decide

`#475` narrowed `byteArray` to a **frozen / immutable-ArrayBuffer-backed**
`Uint8Array` (`packages/pass-style/src/byteArray.js`). Chunks arriving from the
filesystem, sockets, and zip inflation are **mutable** `Uint8Array`s, so every
producer now needs an immutability step on the send path, and that step may cost
a copy — precisely the copy base64 was already paying, or an extra one.

Determine what the actual cost is (is there a transfer-based path that avoids
the copy?), pick the approach, and **state the answer explicitly in the PR
description with measurements, not assertions**. If it turns out the immutability
requirement makes direct-bytes streaming *worse* than base64 for some path,
report that as a finding and scope the removal to where it is a genuine win
rather than forcing a uniform removal — that outcome is a legitimate result of
this job, not a failure of it.

Also check whether XS / the daemon's target engines have the immutable
ArrayBuffer support this depends on, or whether `@endo/immutable-arraybuffer`'s
emulated path is what will actually run, and note the consequence.

## Definition of done

- No `streamBase64` remains in any `packages/**` source, type declaration,
  generated file, or test — only in `designs/` history where it is describing
  past state.
- Full local verify green per [local-verify](skills/local-verify/SKILL.md);
  the daemon, platform-fs, exo-zip/unzip, git, and agent-tools test suites in
  particular must pass, since they exercise the wire path end to end.
- Draft PR against `llm` with the immutability finding written up, then the
  auto-gauntlet.

## Notes

- Split into a stacked series if the single diff becomes unreviewable — a
  bottom PR that lands `stream()`-carries-bytes in `exo-stream` with both
  methods live, then per-package consumer migrations, then a final PR deleting
  `streamBase64`. Prefer that shape if the one-shot diff exceeds what a
  reviewer can hold. See [stacked-pr-build](skills/stacked-pr-build/SKILL.md).
- Do not touch `designs/` documents other than to note completion where a design
  explicitly tracked this migration.
