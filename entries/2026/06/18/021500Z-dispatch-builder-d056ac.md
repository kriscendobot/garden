---
ts: 2026-06-18T02:15:00Z
kind: dispatch
role: liaison
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo-but-for-bots
to: builder
dispatch_root: /home/kris/dispatches/builder--d056ac
model: opus
prs: []
refs:
  - https://github.com/endojs/endo/pull/3036
  - entries/2026/06/17/180000Z-result-researcher-79b689.md
  - entries/2026/06/18/014700Z-dispatch-researcher-a1e7b8.md
---

# dispatch: builder — exo-stream mirror of endo#3036 + llm app migration

User request: "Please create a mirror of
https://github.com/endojs/endo/pull/3036 based on the llm branch
and reconstruct the migration of iterators to streams since
there is considerably more usage of these patterns in the chat
application now."

Researcher `a1e7b8` returned a comprehensive scope survey
(`entries/2026/06/17/180000Z-result-researcher-79b689.md`). The
`## Library and project references` section below is inlined
verbatim from that result.

## State at dispatch time

- **Base**: `llm-5be4392` (newly-created frozen-base branch
  pointing at `5be43923957744064bb0321f6d23dae998c83adc`, the
  current `llm` tip). Builder branches FROM this; conductor
  unfreezes to live `llm` at merge.
- **Suggested branch**: `kriskowal-exo-stream-llm`.
- **Suggested PR title**: `feat(exo-stream): Introduce Exo
  streams (llm mirror of endojs/endo#3036 + chat/agent migration)`.

## Model selection

This is a large, multi-file migration with subtle CapTP protocol
semantics. Dispatch with **opus** per
`garden/skills/model-selection/SKILL.md` for the substantial
implementation work + cross-package migration coordination.

## Task

The exo-stream PACKAGE is already on llm at commit `3e240f9ff`
(sidetrack `kriskowal-exo-stream`). The work is the
DAEMON/CLI/APP MIGRATION away from the old reader-ref/ref-reader
API to the new exo-stream conversion functions.

See the `## Library and project references` section below for
exhaustive file:line citations. High-level execution:

1. **Verify exo-stream alignment with upstream #3036**: prettier
   diff is the only expected delta. If anything substantive
   differs, align to upstream.
2. **Daemon migration** (13 files): apply per the references.
   Pay special attention to the llm-only callsites the researcher
   identified (daemon.js extra `makeIteratorRef` calls, host.js
   extra calls at lines 1713-1725, etc.). Target
   `daemon-persistence-powers.js` for the content-store
   migration (the file was split from `daemon-node-powers.js` on
   llm via commit `39f4a5f0d`).
3. **CLI migration** (10 files): apply per the references.
4. **Chat migration** (~14 component files + retire
   `packages/chat/ref-iterator.js` + its tests).
5. **Other llm-only packages**: genie (3 files), fae (4 files),
   jaine (1 file), lal (2 files), sandbox (1 file structural),
   agent-tools (1 test file).
6. **Removed files** (per upstream #3036): retire
   `packages/daemon/{reader-ref.js, ref-reader.js,
   src/reader-ref.js, src/ref-reader.js, types.d.ts (4 lines),
   index.js (4 lines)}`.

## Test plan

- Run `corepack yarn workspace @endo/daemon test` after daemon
  migration; expect prior daemon iterator tests to pass against
  the new exo-stream API (the protocol change should be
  transparent at the callsite level once both sides migrate).
- Run `corepack yarn workspace @endo/chat test` after chat
  migration; ref-iterator.test.js should be retired in the same
  commit it's deleted.
- Run `corepack yarn workspace @endo/cli test` after CLI
  migration.
- Run package tests for genie/fae/jaine/lal/sandbox/agent-tools
  after their respective migrations.

## Commit shape

Prefer per-logical-unit commits (matching #3036's commit shape
where applicable, augmented with llm-only sections):

1. `chore(exo-stream): align with upstream endo#3036 (prettier)`
   (if any diff)
2. `feat(daemon): migrate to @endo/exo-stream (llm mirror of #3036 + persistence-powers + mount + worker + channel + tar-checkin)`
3. `feat(cli): migrate to @endo/exo-stream (llm mirror of #3036 + run + archive)`
4. `feat(chat): migrate makeRefIterator callsites to iterateReader; retire local ref-iterator.js`
5. `feat(genie,fae,jaine,lal): migrate makeRefIterator callsites to iterateReader`
6. `feat(sandbox): vend PassableBytesReader via bytesReaderFromIterator`
7. `chore(agent-tools): migrate test imports to @endo/exo-stream`
8. `chore: Update yarn.lock`

## Open PR

Open as DRAFT against `llm-5be4392`. PR body:
- Cite upstream #3036 (kriskowal's authored design).
- Describe the chat + agent migration scope expansion.
- Note the frozen-base discipline.
- Reference the upstream status comment
  `endojs/endo#3036 (comment 4737167650)` that the liaison
  already posted.

## Authorizations

- Create new branch and push commits to `kriskowal-exo-stream-llm`.
- Open new PR (DRAFT) against `llm-5be4392`.
- Top-level summary comment at-mentioning @kriskowal.
- Post a follow-up comment on upstream endo#3036 with the
  mirror PR number (per the liaison's earlier upstream status
  comment commitment).

## Out of scope

- Do NOT mark the PR ready (DRAFT only; gamut chain follows).
- Do NOT touch master directly.
- Do NOT touch #442, #449, #452, #460.
- Do NOT modify the design conversations on the upstream PR
  (leave the upstream review threads intact).

## Deliverable

A `result` entry under `journal/entries/2026/06/18/` naming:
- The branch name + head SHA.
- The new PR number + URL.
- Per-commit substance (with file:line cites for major
  migrations).
- Test results (per-suite).
- Pre-push-gates result.
- The upstream follow-up comment URL.
- A `Self-improvement: ...` line.
- **Recommended next stage**: `next: cleaner` (gamut stage 1).

End your turn with a concise summary back to the orchestrator.

---

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
- `types.js` / `types.d.ts` — TypeScript types
- `index.js` — empty twin for `index.d.ts` (all exports use sub-path imports)
- `package.json`, `CHANGELOG.md`, `DESIGN.md`, `MIGRATION.md`, `NEWS.md`, `README.md`, `SECURITY.md`, `LICENSE` — package scaffolding
- `test/` (9 files) — unit and CapTP round-trip tests
- `tsconfig.json`, `tsconfig.build.json`

**Key API change**: the old `streamBase64()` no-arg method on `EndoReadable` returned a `FarRef<Reader<string>>`. The new API changes `streamBase64(synPromise)` to take the head of a synchronize promise chain and returns the head of an acknowledge promise chain. Callers stop calling `E(readable).streamBase64()` and instead call `iterateBytesReader(readable)` directly.

**Daemon refactor touchpoints (files modified in #3036, status on llm — all still use OLD API)**:
- `packages/daemon/src/directory.js` — `makeIteratorRef` → `readerFromIterator` on `followLocatorNameChanges`/`followNameChanges`; llm-only extra callsites at lines 386, 480, 484
- `packages/daemon/src/guest.js` — three `makeIteratorRef` → `readerFromIterator`; llm-only extras at lines 384, 388, 392
- `packages/daemon/src/host.js` — three callsites + llm-only at lines 1713, 1717, 1721, 1725
- `packages/daemon/src/daemon.js` — `makeRefReader` → `iterateBytesReader` + `makeReaderPump`; `makeRefIterator` → `iterateReader`; llm imports `makeIteratorRef`/`makeReaderRef` at lines 26-28; llm-only callsites: `makeIteratorRef` at 1285, 2262, 2267, 2639, 2644; `makeReaderRef` at 1823 (`streamBase64: () => makeReaderRef([bytes])`); `makeRefIterator` at 1323 and 5289
- `packages/daemon/src/daemon-node-powers.js` — in #3036 removes `makeReaderRef`, changes `fetch()` shape; on llm, content-store fetch logic moved to `daemon-persistence-powers.js` (commit `39f4a5f0d` SQLite migration); migrate `daemon-persistence-powers.js:163` (`streamBase64: () => makeReaderRef(reader)`) to `streamBase64: makeReaderPump(mapReader(makeFileReader(), encodeBase64))`
- `packages/daemon/src/types.d.ts` — `EndoReadable.streamBase64()` signature change at line 1070; also lines 1099, 1131 for `storeBlob`/`formulateReadableBlob`

**Additional daemon files (llm-only migration work, not in upstream #3036 diff)**:
- `packages/daemon/src/daemon-persistence-powers.js:163` — `streamBase64()` returning `makeReaderRef(reader)`
- `packages/daemon/src/mount.js:20-21,717-718,930,950,979,1031-1034` — uses `makeReaderRef` (producer) + `makeRefReader`/`makeRefIterator` (consumer); `streamBase64()` at 930 returns `makeReaderRef(readConfined())`; caller at 717-718 calls `E(value).streamBase64()` + `makeRefReader(...)`
- `packages/daemon/src/worker.js:186-187` — `makeRefReader(E(readableP).streamBase64())` → `iterateBytesReader(readableP)`
- `packages/daemon/src/channel.js:354,665,1053,1184` — four `makeIteratorRef` for channel event subscription → `readerFromIterator`
- `packages/daemon/src/tar-checkin.js:110` — `makeRefReader(readerRef)` → `iterateBytesReader(readerRef)`
- `packages/daemon/src/interfaces.js:537,601` — `streamBase64: M.call().returns(M.remotable())` → `M.call(M.any()).returns(M.promise())`

**Removed (per upstream #3036, still present on llm)**:
- `packages/daemon/reader-ref.js`, `packages/daemon/ref-reader.js`
- `packages/daemon/src/reader-ref.js` (92 lines), `packages/daemon/src/ref-reader.js` (35 lines)
- `packages/daemon/types.d.ts` (re-exports), `packages/daemon/index.js` (4 re-export lines)

**CLI refactor touchpoints (still use OLD API on llm)**:
- `packages/cli/src/commands/store.js` — two `makeReaderRef(reader)` → `bytesReaderFromIterator(reader)`
- `packages/cli/src/commands/make.js` — `makeReaderRef([archiveBytes])` → `bytesReaderFromIterator`; llm extra at line 67
- `packages/cli/src/commands/install.js`, `bundle.js` — `makeReaderRef([bundleBytes])` → `bytesReaderFromIterator`
- `packages/cli/src/commands/cat.js` — `makeRefReader(E(readable).streamBase64())` → `iterateBytesReader(readable)`
- `packages/cli/src/commands/run.js` — same pattern as cat.js (llm-only command)
- `packages/cli/src/commands/follow.js` — `makeRefIterator(iterable)` → `iterateReader(iterable)`
- `packages/cli/src/commands/inbox.js` — `makeRefIterator(E(agent).followMessages())` → `iterateReader`
- `packages/cli/src/commands/list.js` — `makeRefIterator(topic)` → `iterateReader(topic)`
- `packages/cli/src/commands/archive.js` — `makeReaderRef([archiveBytes])` → `bytesReaderFromIterator` (llm-only)

### Chat application iterator surfaces (llm-only, needs reconstruction)

Chat uses a local `packages/chat/ref-iterator.js` (functionally
identical to old `makeRefIterator` from `daemon/src/ref-reader.js`).
After daemon migration, daemon returns `PassableReader` refs (new
protocol); the local `makeRefIterator` breaks. All callsites must
migrate to `iterateReader` from `@endo/exo-stream/iterate-reader.js`.

- `packages/chat/forum-component.js:529` — `makeRefIterator(messagesRef)` on `E(channel).followMessages()`
- `packages/chat/outliner-component.js:2915` — same pattern
- `packages/chat/outliner-component.js:236` — `makeRefIterator(ref)` in `for await`
- `packages/chat/outliner-component.js:1610` — `makeRefIterator` passed as prop
- `packages/chat/inventory-component.js:1252` — `makeRefIterator(E(powers).followNameChanges())`
- `packages/chat/inbox-component.js:76` — `makeRefIterator(E(powers).followMessages())`
- `packages/chat/spaces-gutter.js`, `channel-component.js`, `microblog-component.js`, `file-explorer.js` — import + use on daemon refs
- `packages/chat/chat-bar-component.js:216,616` — `makeRefIterator` as factory prop; receivers call on daemon refs
- `packages/chat/send-form.js:258` — `makeRefIterator(eventsRef)` in event loop
- `packages/chat/setup-llm-provider.js:31`, `setup-lal.js:31` — import from `@endo/daemon/ref-reader.js` → `iterateReader` from `@endo/exo-stream`
- `packages/chat/token-autocomplete.js:37,68` — prop + callsite both migrate
- `packages/chat/inline-command-form.js:55,450` — `makeRefIterator` as prop
- `packages/chat/browser-tree.js:75,238` — mock blobs with `streamBase64: () => {...}` style; signature change needed (or replace with `bytesReaderFromIterator`+`iterateBytesReader`)
- `packages/chat/test/unit/browser-tree.test.js:143,193,199,219,297,368` — test mocks of old `streamBase64()`

**Decision**: retire `packages/chat/ref-iterator.js` + tests after migration (cleaner than updating the proxy to new protocol).

### Other llm-only packages with iterator patterns

- `packages/genie/setup.js:31` — `makeRefIterator` import → `iterateReader`; used at line 112 on `E(hostAgent).followMessages()`
- `packages/genie/main.js:35` — same
- `packages/genie/src/tools/vfs-mount.js:117,273` — `methodNames.includes('streamBase64')` heuristic stays; call `iterateBytesReader(entry)` instead of `.streamBase64()` + `makeRefReader`
- `packages/fae/agent.js:8` — `makeRefIterator` import → `iterateReader`; used at 432 on `E(powers).followMessages()`
- `packages/fae/llm-provider-factory.js:7` — same; used at line 72
- `packages/fae/endo-skill.js:43-55` — LOCAL copy of `makeRefIterator`; used at 427, 450 on `E(channel).followMessages()`/`E(host).followMessages()` → replace with imported `iterateReader`
- `packages/fae/test/channel-mention.test.js:25` — `makeRefIterator` import → `iterateReader`; used at 156
- `packages/jaine/agent.js:10` — `makeRefIterator` import; used at 464 → `iterateReader`
- `packages/lal/setup.js:11` — `makeRefIterator` import; used at 85 → `iterateReader`
- `packages/lal/agent.js:8` — same import; used at 1471 and 1676 (two independent loops)
- `packages/sandbox/src/factory.js:18-239` — `makeReaderExoFromAsyncIterable` creates old-protocol AsyncIterator Exo; should vend `PassableBytesReader` via `bytesReaderFromIterator` (structural change)
- `packages/agent-tools/test/git-flow.test.js:20` — `makeReaderRef` import from `@endo/daemon/reader-ref.js` → `bytesReaderFromIterator` from `@endo/exo-stream`

### Llm-only daemon changes that intersect with #3036

- `84625ded7 fix(daemon): adapt to @endo/bytes` — touches `daemon-node-powers.js`, `daemon.js`, `directory.js`; **semantic conflict** (both touch same function bodies for `makeReadableBlob` and `fetch()`)
- `5798b56f5 feat(daemon): garbage-collect content store and scratch-mount dirs` — touches `daemon.js` GC pass; **trivial** (different function from blob migration)
- `39f4a5f0d feat(daemon): binary-safe readFile/maybeReadFile, shared persistence powers` — heavily refactors `daemon-node-powers.js`; **structural** — content-store fetch moved to `daemon-persistence-powers.js`; target `daemon-persistence-powers.js:163`, not `daemon-node-powers.js`
- `e1b865658 feat(daemon): @node, makeFromTree, makeUnconfinedFromTree (Phases 6-8)` — touches `host.js` and `daemon.js` for new formula types; **semantic** — new `makeIteratorRef` callsites at host.js lines 1713-1725 that #3036 doesn't know about
- `d0ce26b32 refactor(daemon): migrate to SQLite` — touches daemon.js, host.js, guest.js, directory.js (all in #3036's diff); **structural** — stream-API migration must apply to SQLite-era versions

### Mirror-vs-reconstruct distinction

**Mirror cleanly** (already on llm via sidetrack `kriskowal-exo-stream`):
- All `packages/exo-stream/` — diffs are cosmetic prettier only
- `packages/stream/types.d.ts` — check if `next()` override is already on llm

**Need adaptation** (llm-only changes require care):
- daemon.js, host.js, guest.js, directory.js, types.d.ts, interfaces.js

**Net-new migration work** (no equivalent in upstream #3036):
- daemon-persistence-powers.js, mount.js, worker.js, channel.js, tar-checkin.js
- chat (~14 files + retire ref-iterator.js)
- genie (3), fae (4), jaine (1), lal (2), sandbox (1 structural), agent-tools (1 test)

### Project context

- Branch: `kriskowal-exo-stream-llm` (consistent with prior mirror naming)
- Base: `llm-5be4392` (frozen-base discipline per `skills/frozen-base-branch/SKILL.md`)
- Title: `feat(exo-stream): Introduce Exo streams (llm mirror of endojs/endo#3036 + chat/agent migration)`
- exo-stream package already on llm at `3e240f9ff` (sidetrack `origin/kriskowal-exo-stream`); the builder should NOT re-add but verify alignment with upstream
- The `daemon-persistence-powers.js` split (commit `39f4a5f0d`) is the most structurally significant divergence
