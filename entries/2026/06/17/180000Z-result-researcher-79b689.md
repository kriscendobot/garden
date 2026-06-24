---
ts: 2026-06-17T18:00:00Z
kind: result
role: researcher
project: endo-but-for-bots
repo: endojs/endo-but-for-bots
refs:
  - entries/2026/06/17/180000Z-dispatch-researcher-a1e7b8.md (approx; dispatch entry written by orchestrator)
---

This researcher dispatch investigated upstream `endojs/endo#3036`
(`feat(exo-stream): Introduce Exo streams`, head `ce7293d677956d3937f8ed9c8afd62cb7ec2639d`)
and surveyed the `llm` branch of `endojs/endo-but-for-bots` for the
iterator/stream patterns that the mirror PR must reconstruct.
Key finding: `@endo/exo-stream` is already present on `llm` (commit
`3e240f9ff`, sidetrack `kriskowal-exo-stream`), almost identical to
upstream, but the daemon / CLI / chat / genie / fae / jaine / lal
callers are **not yet migrated** — they still use the old
`reader-ref.js` / `ref-reader.js` API. The PR must port the daemon and
CLI callers exactly as #3036 does on master, then additionally migrate
the llm-only callsites in the chat, genie, fae, jaine, and lal packages.

```markdown
## Library and project references

### Upstream PR #3036 substance

**New files (packages/exo-stream/) — already on llm at commit 3e240f9ff, nearly identical**:
- `async-iterate.js` — `asyncIterate(iterable)` helper that normalises sync/async iterables to iterators; replaces the copy in `daemon/src/reader-ref.js`
- `bytes-reader-from-iterator.js` — `bytesReaderFromIterator(iter, opts?)`: wraps a local `AsyncIterable<Uint8Array>` as a `PassableBytesReader` Exo (responder/producer side, base64-encodes for CapTP transport); replaces `makeReaderRef`
- `bytes-writer-from-iterator.js` — `bytesWriterFromIterator(iter, opts?)`: wraps a local sink iterator as a `PassableBytesWriter` Exo (responder/consumer side, base64-decodes from CapTP); new — no prior equivalent in daemon
- `iterate-bytes-reader.js` — `iterateBytesReader(ref, opts?)`: converts a remote `PassableBytesReader` ref to a local `AsyncIterableIterator<Uint8Array>` (initiator/consumer side, base64-decodes); replaces `makeRefReader(E(readable).streamBase64())`
- `iterate-bytes-writer.js` — `iterateBytesWriter(ref, opts?)`: converts a remote `PassableBytesWriter` ref to a local `AsyncIterableIterator<Uint8Array>` (initiator/producer side, base64-encodes); new
- `iterate-reader.js` — `iterateReader(ref, opts?)`: converts a remote `PassableReader` ref to a local `AsyncIterableIterator` (initiator/consumer side); replaces `makeRefIterator`
- `iterate-writer.js` — `iterateWriter(ref, opts?)`: converts a remote `PassableWriter` ref to a local write-side iterator (initiator/producer side); new
- `reader-from-iterator.js` — `readerFromIterator(iter, opts?)`: wraps a local async iterable as a `PassableReader` Exo (responder/producer side); replaces `makeIteratorRef`
- `reader-pump.js` — `makeReaderPump(iter, opts?)`: low-level responder pump for building custom reader Exos; used in `daemon.js` for `streamBase64` on `EndoReadable`
- `writer-from-iterator.js` — `writerFromIterator(iter, opts?)`: wraps a local iterator as a `PassableWriter` Exo (responder/consumer side); new
- `writer-pump.js` — `makeWriterPump(iter, opts?)`: low-level writer pump for custom Exo construction
- `type-guards.js` — `PassableReaderInterface`, `PassableWriterInterface`, `PassableBytesReaderInterface`, `PassableBytesWriterInterface`: Exo interface guards
- `types.js` / `types.d.ts` — `PassableReader`, `PassableWriter`, `PassableBytesReader`, `PassableBytesWriter`, `StreamNode`, `StreamYieldNode`, `StreamReturnNode` TypeScript types
- `index.js` — empty twin for `index.d.ts` (all exports use sub-path imports)
- `package.json`, `CHANGELOG.md`, `DESIGN.md`, `MIGRATION.md`, `NEWS.md`, `README.md`, `SECURITY.md`, `LICENSE` — package scaffolding
- `test/` (9 files) — unit and CapTP round-trip tests for all 8 conversion functions plus async-iterate and pump utilities
- `tsconfig.json`, `tsconfig.build.json` — TypeScript configuration

**Key API change (upstream #3036 vs. old reader-ref/ref-reader)**:

The old `streamBase64()` no-arg method on `EndoReadable` returned a
`FarRef<Reader<string>>` (an AsyncIterator ref). The new API changes
`streamBase64(synPromise)` to take the head of a synchronize promise chain and
returns the head of an acknowledge promise chain — the bidirectional chain
protocol. Callers stop calling `E(readable).streamBase64()` and instead call
`iterateBytesReader(readable)` directly (the `readable` object itself is the
`PassableBytesReader`).

**Daemon refactor touchpoints (files modified in #3036, status on llm)**:

All of these files still use the OLD API on llm — they are the migration targets:

- `packages/daemon/src/directory.js` — `makeIteratorRef` (from `reader-ref.js`) → `readerFromIterator` (from `@endo/exo-stream/reader-from-iterator.js`) on `followLocatorNameChanges` and `followNameChanges` return values; on llm this file also has additional llm-only `makeIteratorRef` callsites (lines 386, 480, 484 plus the `readerRef` construction at line 386) added by llm-only commits
- `packages/daemon/src/guest.js` — three `makeIteratorRef` calls → `readerFromIterator`; llm has additional `makeIteratorRef` calls (lines 384, 388, 392) not present in upstream master
- `packages/daemon/src/host.js` — three `makeIteratorRef` calls → `readerFromIterator` (followLocatorNameChanges, followMessages, followNameChanges); llm has four additional `makeIteratorRef` calls at lines 1713, 1717, 1721, 1725 in an extended method dispatch table not present in upstream master
- `packages/daemon/src/daemon.js` — `makeRefReader` import → `iterateBytesReader` + `makeReaderPump`; `makeRefIterator` → `iterateReader`; on llm this file ALSO still imports `makeIteratorRef`/`makeReaderRef` from `reader-ref.js` (lines 26-28) and has additional llm-only callsites: `makeIteratorRef` at lines 1285, 2262, 2267, 2639, 2644; `makeReaderRef` at line 1823 (`streamBase64: () => makeReaderRef([bytes])`); `makeRefIterator` at lines 1323 and 5289
- `packages/daemon/src/daemon-node-powers.js` — in #3036: removes `makeReaderRef`, changes `fetch()` return from `EndoReadable`-shaped object with `streamBase64()` to `{ sha512, makeFileReader, text, json }`; on llm this file has been heavily refactored by llm-only commits (SQLite migration) and now imports from `./daemon-persistence-powers.js`; the content-store fetch logic now lives in `packages/daemon/src/daemon-persistence-powers.js` (line 163: `const streamBase64 = () => { ... makeReaderRef(reader) }`) — this is the corresponding migration target on llm
- `packages/daemon/src/types.d.ts` — `EndoReadable.streamBase64()` signature changes from `FarRef<Reader<string>>` to `(synPromise: ERef<StreamNode<Passable,Passable>>) => Promise<StreamNode<string,undefined>>`; `EndoHost.storeBlob` param changes from `ERef<AsyncIterableIterator<string>>` to `ERef<PassableBytesReader>`; `DaemonCore.formulateReadableBlob` param same change; on llm this file has many additional types not present in upstream (SQLite, channels, capability-bus, etc.) — the streamBase64 signature line is at 1070 and needs updating

**Additional daemon files that use old API on llm (not in upstream #3036 diff — llm-only migration work)**:

- `packages/daemon/src/daemon-persistence-powers.js:163` — `streamBase64()` that returns `makeReaderRef(reader)` → should become `streamBase64: makeReaderPump(mapReader(makeFileReader(), encodeBase64))` per #3036's pattern for `daemon.js`
- `packages/daemon/src/mount.js:20-21,717-718,930,950,979,1031-1034` — uses both `makeReaderRef` (producer) and `makeRefReader`/`makeRefIterator` (consumer) for mount file streaming; the `streamBase64()` method at line 930 returns `makeReaderRef(readConfined())`; the caller at line 717-718 calls `E(value).streamBase64()` then `makeRefReader(...)` — both sides must migrate
- `packages/daemon/src/worker.js:186-187` — `makeRefReader(E(readableP).streamBase64())` pattern → `iterateBytesReader(readableP)`
- `packages/daemon/src/channel.js:354,665,1053,1184` — four `makeIteratorRef` callsites for channel event subscription iterators → `readerFromIterator`
- `packages/daemon/src/tar-checkin.js:110` — `makeRefReader(readerRef)` → `iterateBytesReader(readerRef)` (for tar entry parsing from a remote bytes reader)
- `packages/daemon/src/interfaces.js:537,601` — `streamBase64: M.call().returns(M.remotable())` guards for `BlobInterface` and related → must change to `M.call(M.any()).returns(M.promise())` (the new signature takes synPromise)

**Removed (no longer needed after exo-stream, per upstream #3036)**:
- `packages/daemon/reader-ref.js` — re-export shim of `src/reader-ref.js` (still present on llm)
- `packages/daemon/ref-reader.js` — re-export shim of `src/ref-reader.js` (still present on llm)
- `packages/daemon/src/reader-ref.js` — `asyncIterate`, `makeIteratorRef`, `makeReaderRef` (still present on llm at 92 lines)
- `packages/daemon/src/ref-reader.js` — `makeRefIterator`, `makeRefReader` (still present on llm at 35 lines)
- `packages/daemon/types.d.ts` — re-exports of `makeRefReader`, `makeRefIterator`, `makeReaderRef`, `makeIteratorRef` (still present on llm)
- `packages/daemon/index.js` (partial) — the four re-export lines for reader-ref/ref-reader (still present on llm)

**CLI refactor touchpoints (files modified in #3036, status on llm)**:

All CLI files below still use the OLD API on llm:

- `packages/cli/src/commands/store.js` — two `makeReaderRef(reader)` calls → `bytesReaderFromIterator(reader)` (stdin and file paths)
- `packages/cli/src/commands/make.js` — `makeReaderRef([archiveBytes])` → `bytesReaderFromIterator([archiveBytes])`; note llm has an additional `makeReaderRef([archiveBytes])` call on llm (archive command in the same file at line 67)
- `packages/cli/src/commands/install.js` — `makeReaderRef([bundleBytes])` → `bytesReaderFromIterator([bundleBytes])`
- `packages/cli/src/commands/bundle.js` — `makeReaderRef([bundleBytes])` → `bytesReaderFromIterator([bundleBytes])`
- `packages/cli/src/commands/cat.js` — `makeRefReader(E(readable).streamBase64())` pattern → `iterateBytesReader(readable)`
- `packages/cli/src/commands/run.js` — `makeRefReader(E(readableP).streamBase64())` pattern → `iterateBytesReader(readableP)`; not in upstream #3036's diff (llm-only command)
- `packages/cli/src/commands/follow.js` — `makeRefIterator(iterable)` → `iterateReader(iterable)`
- `packages/cli/src/commands/inbox.js` — `makeRefIterator(E(agent).followMessages())` → `iterateReader(E(agent).followMessages())`
- `packages/cli/src/commands/list.js` — `makeRefIterator(topic)` → `iterateReader(topic)`
- `packages/cli/src/commands/archive.js` — `makeReaderRef([archiveBytes])` → `bytesReaderFromIterator([archiveBytes])` (llm-only command, not in upstream diff)

### Chat application iterator surfaces (llm-only, needs reconstruction)

These files use a local `makeRefIterator` from `packages/chat/ref-iterator.js`.
That local implementation is functionally identical to the old `makeRefIterator`
from `daemon/src/ref-reader.js` but does NOT use the new CapTP stream protocol.
After the daemon migration, the daemon's `followMessages()`, `followNameChanges()`,
etc. will return `PassableReader` refs (new protocol), so `makeRefIterator`
(which calls `E(ref).next()` directly) will break. All chat callsites that call
`makeRefIterator` on a daemon-returned value must migrate to `iterateReader`.

The chat package has its own `ref-iterator.js` module and tests for it.
The migration shape is: replace `makeRefIterator(ref)` with `iterateReader(ref)`
everywhere the ref comes from a daemon call; the `ref-iterator.js` module itself
can be retired or kept for non-daemon use.

- `packages/chat/forum-component.js:529` — `makeRefIterator(messagesRef)` where `messagesRef` = result of `E(channel).followMessages()` → `iterateReader(messagesRef)`; daemon provides the ref
- `packages/chat/forum-component.js:543` — `for await (const message of messageIterator)` — no change needed once above is fixed
- `packages/chat/outliner-component.js:2915` — `makeRefIterator(messagesRef)` from channel followMessages → `iterateReader(messagesRef)`
- `packages/chat/outliner-component.js:236` — `makeRefIterator(ref)` inside `for await` on name-change subscription → `iterateReader(ref)`
- `packages/chat/outliner-component.js:1610` — `makeRefIterator` passed as a prop → the receiver must use `iterateReader` instead
- `packages/chat/inventory-component.js:1252` — `makeRefIterator(E(powers).followNameChanges())` → `iterateReader(E(powers).followNameChanges())`
- `packages/chat/inbox-component.js:76` — `makeRefIterator(E(powers).followMessages())` → `iterateReader(E(powers).followMessages())`
- `packages/chat/spaces-gutter.js` — imports `makeRefIterator` from `./ref-iterator.js`; usage is on daemon-provided refs → `iterateReader`
- `packages/chat/channel-component.js` — imports `makeRefIterator`; usage on daemon-provided subscription refs → `iterateReader`
- `packages/chat/chat-bar-component.js:216,616` — `makeRefIterator` passed as factory prop; receivers call it on daemon refs → the prop type should change to `iterateReader`-equivalent
- `packages/chat/send-form.js:258` — `makeRefIterator(eventsRef)` inside event loop → `iterateReader(eventsRef)`; `eventsRef` comes from daemon
- `packages/chat/microblog-component.js` — imports `makeRefIterator`; usage on daemon subscription refs → `iterateReader`
- `packages/chat/file-explorer.js` — imports `makeRefIterator`; usage on daemon refs → `iterateReader`
- `packages/chat/setup-llm-provider.js:31` — `makeRefIterator` imported from `@endo/daemon/ref-reader.js` → import `iterateReader` from `@endo/exo-stream/iterate-reader.js`
- `packages/chat/setup-lal.js:31` — same import and pattern as setup-llm-provider.js → same migration
- `packages/chat/token-autocomplete.js:37,68` — `makeRefIterator` passed as prop and called on name-changes ref → prop type + callsite both migrate to `iterateReader`
- `packages/chat/inline-command-form.js:55,450` — `makeRefIterator` passed as prop → `iterateReader`
- `packages/chat/browser-tree.js:75,238` — `streamBase64()` (no-arg) called on blob entries → the blob's `streamBase64` method signature changes with the daemon migration; `browser-tree.js` constructs mock blobs with `streamBase64: () => {...}` style in tests and in the real `BrowserFileBlob` — both must be updated to the new `(synPromise) => Promise<StreamNode>` signature or replaced with `bytesReaderFromIterator` wrapping a local byte source and `iterateBytesReader` on the consumer side
- `packages/chat/test/unit/browser-tree.test.js:143,193,199,219,297,368` — tests mock `streamBase64()` (no-arg, returns iterator ref) → must update mocks to new `streamBase64(synPromise)` signature or remove in favour of `iterateBytesReader` on the consumer side

**Chat local ref-iterator.js migration decision**: `packages/chat/ref-iterator.js`
implements the old `.next()` / `.return()` / `.throw()` proxy pattern. After daemon
migration this will be incompatible with `PassableReader` refs. The module should
either be retired (all callers migrate to `iterateReader` from `@endo/exo-stream`)
or updated to proxy the new `stream(synPromise)` protocol — the former is cleaner.
The tests in `packages/chat/test/unit/ref-iterator.test.js` can be retired with it.

### Other llm-only packages with iterator patterns

**`packages/genie/`**:

- `packages/genie/setup.js:31` — `makeRefIterator` imported from `@endo/daemon/ref-reader.js` → `iterateReader` from `@endo/exo-stream/iterate-reader.js`; used at line 112 on `E(hostAgent).followMessages()` return value
- `packages/genie/main.js:35` — same import and usage pattern as `setup.js` → same migration
- `packages/genie/src/tools/vfs-mount.js:117,273` — checks `methodNames.includes('streamBase64')` to classify entries as blobs vs trees; this detection heuristic remains valid (the method name stays the same, only its signature changes); the actual read at no specific line calls `iterateBytesReader(entry)` on detected blobs → needs updated to use `iterateBytesReader(entry)` rather than calling `.streamBase64()` + `makeRefReader`

**`packages/fae/`**:

- `packages/fae/agent.js:8` — `makeRefIterator` imported from `@endo/daemon/ref-reader.js`; used at line 432 on `E(powers).followMessages()` → `iterateReader`
- `packages/fae/llm-provider-factory.js:7` — same import; used at line 72 on `E(powers).followMessages()` → `iterateReader`
- `packages/fae/endo-skill.js:43-55` — local copy of `makeRefIterator` definition (not imported from daemon); used at lines 427 and 450 on `E(channel).followMessages()` and `E(host).followMessages()` → replace with `iterateReader` from `@endo/exo-stream/iterate-reader.js`
- `packages/fae/test/channel-mention.test.js:25` — `makeRefIterator` imported from `@endo/daemon/ref-reader.js`; used at line 156 on a mock `messagesRef` → `iterateReader`

**`packages/jaine/`**:

- `packages/jaine/agent.js:10` — `makeRefIterator` imported from `@endo/daemon/ref-reader.js`; used at line 464 on `E(powers).followMessages()` → `iterateReader`

**`packages/lal/`**:

- `packages/lal/setup.js:11` — `makeRefIterator` imported from `@endo/daemon/ref-reader.js`; used at line 85 on `E(agent).followMessages()` → `iterateReader`
- `packages/lal/agent.js:8` — same import; used at lines 1471 and 1676 on `E(powers).followMessages()` → `iterateReader` (two independent message-loop entry points)

**`packages/sandbox/`**:

- `packages/sandbox/src/factory.js:18-239` — `makeReaderExoFromAsyncIterable` creates an Exo implementing the old `AsyncIterator` protocol (`next`/`return`/`throw`) to wrap Node.js `AsyncIterable<Uint8Array>` for daemon integration. After daemon migration the daemon no longer consumes old-style iterator refs in this shape for stdio; the sandbox factory's exo should be updated to wrap using `bytesReaderFromIterator` so it vends a `PassableBytesReader` instead of a raw iterator ref. This is a structural change in how sandbox integrates with daemon's file-transfer API.

**`packages/agent-tools/`**:

- `packages/agent-tools/test/git-flow.test.js:20` — `makeReaderRef` imported from `@endo/daemon/reader-ref.js` → `bytesReaderFromIterator` from `@endo/exo-stream`

### Llm-only daemon changes that intersect with #3036

The following llm-only commits touch files that #3036 also modifies:

- `84625ded7 fix(daemon): adapt to @endo/bytes` — touches `daemon-node-powers.js`, `daemon.js`, `directory.js`; #3036 also modifies all three. The bytes-adapt commit migrates from `Buffer` to `Uint8Array` and imports from `@endo/bytes`; #3036's changes in the same files are the reader-ref → exo-stream migration. The intersection is `daemon.js` (import section and the `makeReadableBlob` function) and `daemon-node-powers.js`/`daemon-persistence-powers.js` (the `fetch()` function body). Conflict shape: **semantic** — the bytes commit and the stream-API commit both touch the same function bodies; careful manual reconciliation required.
- `5798b56f5 feat(daemon): garbage-collect content store and scratch-mount dirs` — touches `daemon.js` (the GC pass in `collectIfDirty`); #3036 touches `daemon.js` for `makeReadableBlob` and `formulateReadableBlob`. Conflict shape: **trivial** if the GC changes are in a separate function not touched by the blob migration.
- `39f4a5f0d feat(daemon): binary-safe readFile/maybeReadFile, shared persistence powers` — heavily refactors `daemon-node-powers.js` (248-line delta); #3036's corresponding change is also in `daemon-node-powers.js` (the `fetch()` method). However, on llm the content-store fetch logic moved to `daemon-persistence-powers.js` via this commit, so the builder should target `daemon-persistence-powers.js:163` (not `daemon-node-powers.js`) for the `makeReaderRef` → `makeReaderPump` migration. Conflict shape: **structural** — the file that #3036 modifies was split on llm; the builder must apply the migration to the correct file.
- `e1b865658 feat(daemon): @node, makeFromTree, makeUnconfinedFromTree (Phases 6-8)` — touches `host.js` and `daemon.js` for new formula types; #3036 touches both for the iterator migration. Conflict shape: **semantic** — the new formula-type additions in host.js include new `makeIteratorRef` callsites (lines 1713-1725) that #3036 does not know about; the builder must apply `readerFromIterator` to those callsites in addition to the three that #3036 covers.
- `d0ce26b32 refactor(daemon): migrate to SQLite` — touches `daemon.js`, `host.js`, `guest.js`, `directory.js`; all four are in #3036's diff. Conflict shape: **structural** — the SQLite migration is a large-scale refactor; the stream-API migration must be applied to the SQLite-era versions of these files, not the upstream master versions.

### Mirror-vs-reconstruct distinction

**Files that mirror cleanly** (package exists on llm, already at the upstream PR's version or very close):

- All files under `packages/exo-stream/` — the package was added via the `kriskowal-exo-stream` sidetrack commit `3e240f9ff`. Diffs between llm and upstream #3036 head are cosmetic (prettier formatting only: `// @ts-expect-error` → `/** @type {any} */` cast style). These files do NOT need re-adding; at most a prettier-alignment pass.
- `packages/stream/types.d.ts` — the upstream PR adds `next()` override; check if this is already on llm via the exo-stream sidetrack.

**Files that need adaptation** (path exists on llm but llm-only changes require care):

- `packages/daemon/src/daemon.js` — large; apply #3036's import changes + blob/stream migration, but also handle llm-only callsites (`makeIteratorRef` at lines 1285, 2262, 2267, 2639, 2644; `makeRefIterator` at lines 1323, 5289; `makeReaderRef` at line 1823)
- `packages/daemon/src/host.js` — apply #3036's three-callsite migration plus the four llm-only `makeIteratorRef` calls at lines 1713-1725
- `packages/daemon/src/guest.js` — apply #3036's three-callsite migration plus llm-only callsites at lines 384, 388, 392
- `packages/daemon/src/directory.js` — apply #3036's two-callsite migration plus llm-only callsite at line 386
- `packages/daemon/src/types.d.ts` — apply #3036's `EndoReadable.streamBase64` signature change, but the llm types file has grown significantly; surgical edit on the specific lines (1070, 1099, 1131)
- `packages/daemon/src/interfaces.js` — update `BlobInterface.streamBase64` guard from `M.call().returns(M.remotable())` to `M.call(M.any()).returns(M.promise())`

**Net-new migration work** (llm-only callsites that have no equivalent in upstream #3036):

- `packages/daemon/src/daemon-persistence-powers.js` — migrate `streamBase64: () => makeReaderRef(reader)` to `streamBase64: makeReaderPump(mapReader(makeFileReader(), encodeBase64))`; the content-store was split out of `daemon-node-powers.js` on llm
- `packages/daemon/src/mount.js` — migrate all six old-API callsites (producer and consumer sides for mount file streaming); this file is entirely llm-only relative to upstream master
- `packages/daemon/src/worker.js` — migrate `makeRefReader(E(readableP).streamBase64())` to `iterateBytesReader(readableP)`
- `packages/daemon/src/channel.js` — migrate four `makeIteratorRef` callsites for subscription iterators; this file is entirely llm-only
- `packages/daemon/src/tar-checkin.js` — migrate `makeRefReader(readerRef)` to `iterateBytesReader(readerRef)`
- `packages/chat/` — migrate all `makeRefIterator` callsites (see chat section above); retire `packages/chat/ref-iterator.js` and its tests after migration
- `packages/genie/setup.js`, `main.js`, `src/tools/vfs-mount.js` — three files
- `packages/fae/agent.js`, `llm-provider-factory.js`, `endo-skill.js`, `test/channel-mention.test.js` — four files
- `packages/jaine/agent.js` — one file
- `packages/lal/setup.js`, `agent.js` — two files
- `packages/sandbox/src/factory.js` — structural: `makeReaderExoFromAsyncIterable` should produce a `PassableBytesReader` via `bytesReaderFromIterator`
- `packages/agent-tools/test/git-flow.test.js` — one test file

### Suggested branch and PR shape

- Branch name: `kriskowal-exo-stream-llm` (consistent with the pattern used for prior mirror PRs such as `kriskowal-marshal-binary-llm`)
- Base: `llm` (the PR touches llm-only packages such as `packages/chat`, `packages/fae`, `packages/jaine`, `packages/lal`; per `journal/projects/endo-but-for-bots/README.md` § Base-branch inference from package availability, any PR touching llm-only packages bases on `llm`)
- PR title: `feat(exo-stream): Introduce Exo streams (llm mirror of endojs/endo#3036 + chat/agent migration)`
- The PR should use a frozen `llm-<sha>` base per `skills/frozen-base-branch/SKILL.md`; conductor unfreezes to live `llm` at merge time

### Project context

- Project README relevant sections: `journal/projects/endo-but-for-bots/README.md` § Base-branch inference from package availability (llm-only package check before opening PR), § Rules of engagement (merge commits on `llm` PRs), § Identity and credentials (kriscendobot for routine work)
- Prior mirror PRs follow the `kriskowal-<feature>-llm` branch naming convention per journal history
- The exo-stream package itself is already on llm at commit `3e240f9ff` (sidetrack `origin/kriskowal-exo-stream`); the builder should NOT re-add it but should verify alignment with upstream and proceed to the daemon/CLI/app migration
- The `daemon-persistence-powers.js` split from `daemon-node-powers.js` (llm commit `39f4a5f0d`) is the most structurally significant divergence from upstream master; the builder must target the correct file for the content-store fetch migration
```

Library writeback: drafted new concept page `exo-stream` at
`journal/library/concepts/exo-stream.md`; added 22 keyword shortcuts to
`keywords.md` covering `@endo/exo-stream`, all 8 public API function names,
all 4 TypeScript interface names, `StreamNode`, and the 4 old API names
being replaced (`makeIteratorRef`, `makeReaderRef`, `makeRefIterator`,
`makeRefReader`, `reader-ref.js`, `ref-reader.js`). The prior keyword
`exo-stream PR 330 | daemon` pointed to a non-existent concept page `daemon`;
replaced with a pointer to the new `exo-stream` concept page.

Open questions: the `daemon` concept page referenced by the old keyword never
existed; the librarian/gardener should check whether there are other keywords
pointing to a `daemon` concept page and consolidate.

Self-improvement: the researcher should recommend in a message that the
`journal/projects/endo-but-for-bots/README.md` § Base-branch inference rule
include an example specifically for mirror PRs that touch both master-era and
llm-only packages, since this PR type is common and the mixed-touch impasse
case is not yet illustrated.
