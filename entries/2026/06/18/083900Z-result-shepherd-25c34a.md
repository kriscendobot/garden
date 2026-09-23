---
ts: 2026-06-18T08:39:00Z
kind: result
role: shepherd
host: endolinbot
repo: endojs/endo-but-for-bots
project: endo
prs:
  - repo: endojs/endo-but-for-bots
    pr: 461
    role: target
refs:
  - https://github.com/endojs/endo-but-for-bots/pull/461
  - entries/2026/06/18/072700Z-dispatch-shepherd-70a4b9.md
  - entries/2026/06/18/072000Z-result-shepherd-bf3623.md
---

## PR #461 — exo-stream second shepherd pass

**Pre-head SHA**: d74d38265 (first shepherd left here)
**Post-head SHA**: a510585f5fdbbb1d295d469985984ef7925f8277 (two new commits)

### Failure classification (run 27743930294, head d74d38265)

| Class | Job | Signature | Disposition |
| --- | --- | --- | --- |
| C | lint | import/order: @endo/exo-stream imports after local ./ imports (chat/file-explorer.js, spaces-gutter.js, send-form.test.js, mock-powers.test.js); no-unused-vars: bytesReaderFromIterator in daemon.js, iterateReader in mount.js, ReadableBlobInterface+M in conformance/mount tests; no-shadow: dynamic import of iterate-bytes-reader.js shadowing top-level in git.test.js; no-empty-function: empty async generator in factory.js; no-await-in-loop: await in for(;;) in factory.js | fixed |
| C | test (all 4 matrix variants) | ReferenceError: harden is not defined (SES not locked down); TypeError: target has no method "stream" (bare Far iterators returned from followMessages/followNameChanges in 8 chat component test files) | fixed |
| C | cover (22.x, 24.x) | same test failures cascading to cover | fixed: same root causes |

### Fix substance

**Commit a2b70c49f** — fix(lint): fix import/order, no-unused-vars, no-shadow, no-empty-function, no-await-in-loop

- `packages/chat/file-explorer.js`, `spaces-gutter.js`,
  `test/component/send-form.test.js`,
  `test/helpers/mock-powers.test.js`: moved `@endo/exo-stream/iterate-reader.js`
  import above local `./` imports (import/order rule).
- `packages/daemon/src/daemon.js`: removed unused `bytesReaderFromIterator` import.
- `packages/daemon/src/mount.js`: removed unused `iterateReader` import.
- `packages/daemon/test/git.test.js`: removed dynamic `await import(...)` at
  line 2506 that shadowed the top-level static import; static import already
  present (no-shadow).
- `packages/daemon/test/mount-platform-fs-conformance.test.js`: removed unused
  `ReadableBlobInterface` and `M` from import.
- `packages/daemon/test/mount.test.js`: removed unused `ReadableBlobInterface`.
- `packages/sandbox/src/factory.js`: renamed empty generator to `emptyBytesGen`
  + added descriptive body comment with eslint-disable-next-line comment
  (no-empty-function); wrapped `for(;;) await` block with
  `eslint-disable/enable no-await-in-loop` (legitimate pattern for stream
  generator).

**Commit a510585f5** — fix(tests): init SES via @endo/init/debug.js and wrap mock iterators as PassableReader

- Eight component test files (`channel-thread.test.js`, `form-request-inbox.test.js`,
  `inventory-component.test.js`, `microblog.test.js`, `outliner-enter-key.test.js`,
  `spaces-gutter-home.test.js`, `token-autocomplete.test.js`, and
  `mock-powers.js` helper): replaced `import 'ses'; import
  '@endo/eventual-send/shim.js'` with `import '@endo/init/debug.js'`.
  The two-line form only defines `globalThis.lockdown` without calling it,
  so `harden` is undefined at runtime. `@endo/init/debug.js` calls
  `lockdown()` and sets up HandledPromise shim.
- `test/helpers/mock-powers.js`: `followNameChanges()` returned a bare Far
  iterator (next/return/throw only). Wrapped with `readerFromIterator()`.
- `channel-thread.test.js`, `form-request-inbox.test.js`, `microblog.test.js`,
  `outliner-enter-key.test.js`: `followMessages()` returned bare Far
  iterators. Wrapped with `readerFromIterator()`.
- `outliner-enter-key.test.js`: `followHeatEvents()` returned bare Far
  iterator. Wrapped with `readerFromIterator()`.
- `spaces-gutter-home.test.js`: `spacesDir.followNameChanges()` returned bare
  Far iterator. Wrapped with `readerFromIterator()`.

### CI new run

All jobs queued at push time (run `27747445828` on head `a510585f5`).

### PR comment

https://github.com/endojs/endo-but-for-bots/pull/461#issuecomment-4739764575

### Recommended next stage

next: conductor — pending CI green on run 27747445828.

Self-improvement: The SES init pattern (`import 'ses'; import '@endo/eventual-send/shim.js'`) was inherited from pre-exo-stream tests that never called any function using `harden` as a bare global. The exo-stream migration introduced `iterateReader()` which calls `harden()` at runtime; this is a cross-cutting change that silently breaks any test file still using the two-line pattern. Pattern to encode: when a migration adds a new consumer-side adapter from `@endo/exo-stream`, scan all test files for the two-line SES init pattern and replace with `@endo/init/debug.js`.
