All three review directives on endojs/endo-but-for-bots PR #592 are resolved, verified, pushed, and answered on their threads.

## Completion report

**Preflight:** `pr-feedback-preflight.sh` exited 0 (no peer resolution) → proceeded. The review body itself was empty; the whole unit of work was the three inline comments (all treated as untrusted data).

**Comment 1 — `daemon-node-powers.js:463` ("we prefer `@import`"):** Replaced the inline `import('@endo/platform/fs/node/watch-directory').WatchDirectory` type reference with an `@import { WatchDirectory }` tag near the file's other `@import`s; line 463 now reads `@type {WatchDirectory}`.

**Comment 2 — `fs-node/index.js:10` (barrel module):** Deleted the `@endo/platform/fs/node` barrel (`src/fs-node/index.js`) and removed the `./fs` and `./fs/node` package exports. Added dedicated per-adapter subpaths (`./fs/node/local-tree`, `.../local-blob`, `.../tree-writer`; `.../watch-directory` already existed) and updated the three importers (`cli/checkout.js`, `cli/checkin.js`, `lal/agent.js`) plus the XS-bundle exclusion list to the individual subpaths.

**Comment 3 — `watch-directory.js:49` (accept a `cancelled` promise):** `makeWatchDirectory` now returns `(dirPath, cancelled) => AsyncIterable<DirectoryWatchEvent>` — settling `cancelled` closes the OS watcher rather than a returned `cancel()` function. The async iterator keeps its own `return()` as the documented exception to the idiom (both surfaces resolve to the same idempotent `close()`), with a reviewer-facing note in the typedef JSDoc. Rippled through `FilePowers.watchDirectory` (types.d.ts), the XS-on-Rust stub, and the `EndoMount.followNameChanges` consumer (threads a promise-kit `cancelled`; kept the `finally` for early-throw cleanup). Rewrote the platform unit tests around a small cancellation helper. Updated the changeset prose.

**Verification (local):**
- Platform `watch-directory.test.js`: 11/11 pass
- Daemon `mount.test.js`: 73/73 pass (incl. the `followNameChanges` integration through real node `FilePowers`)
- `mount-platform-fs-conformance.test.js`: 19/19 pass (node/XS `FilePowers` parity)
- `tsc`: clean for platform, daemon, cli
- `eslint` on changed files: clean

**Committed & pushed:** `3eea2327c` → `factor-watchdirectory-to-endo-platform` (bot identity `endolinbot`). Posted a resolution reply on each of the three inline threads citing the commit.

**Follow-ups / notes (non-blocking):**
- The full daemon runtime suite (`endo.test.js`) needs `better-sqlite3`, whose native build failed in this sandbox; those weren't run locally, but the affected `followNameChanges`/watcher paths are covered by `mount.test.js` (real node powers). CI will run the rest.
- `lal` `tsc` reports pre-existing third-party type-resolution noise (`undici-types`, `@modelcontextprotocol/sdk`) from the partial install — unrelated to the one-line import change (which resolves cleanly).
- A pre-existing `no-underscore-dangle` lint error on `bundle-bus-daemon-rust-xs.mjs:22` (`__dirname`) is identical on `origin/llm` and untouched by this change.
