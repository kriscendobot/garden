The work is complete. Inbox is empty, push landed, and all feedback threads are closed out.

## Completion report

**Job:** Fixer on `endojs/endo-but-for-bots` PR #288 (`feat/cbors-package` → `llm`) — address the closer-review feedback (comment 4886909660) and revisit prior maintainer feedback in its light, per kriskowal's directive (4932257960).

**Preflight:** `pr-feedback-preflight.sh` returned PROCEED (no peer resolution) — did the work.

**What I did** — implemented the Fable review's fixer-ready refactor spec, which also resolves the two unresolved 2026-07-04 maintainer inline notes on `decode.js`:

- **`packages/cbor-frame/src/decode.js`** — Deleted the local `concat` and `materialize()`; now imports `concatBytes` from `@endo/bytes/concat.js`. Cached the decoded head as carry state, fixing the quadratic re-materialization (was O(N·k) per N-byte frame in k chunks; now O(N) per frame): the head is probed only while unknown, and the carry materializes exactly once per completed frame. Error offsets and all other behavior unchanged. The head-decode rethrow now carries `{ cause }` to preserve the original stack (the review's minor note).
- **`packages/cbor-frame/package.json`** — Added `"@endo/bytes": "workspace:^"` to dependencies.
- **`packages/cbor-frame/src/encode.js`** — Simplified the buffered assembly to `concatBytes([TAG_24_PREFIX, head, ...messageChunks])`.
- **`packages/cbor-frame/test/cbor-frame.test.js`** — Replaced the local `concat` helper with the `concatBytes` import; added a test for a frame delivered one byte at a time whose successor's head straddles the residual suffix (locks the head-cache reset + multi-chunk probe path).
- The single-chunk zero-copy short-circuit deliberately **stays at the call sites** — moving it into `concatBytes` would break that function's always-fresh, never-aliasing contract (the answer to the `decode.js:60` maintainer note).

**Verification:** 33/33 tests pass under all three ses-ava configs (`noop-harden`, `base`, `lockdown`); `tsc`, `eslint`, and `prettier --check` (repo's prettier 3) clean. Regression evidence: removing the `head = undefined` reset breaks the new straddle test (dangling-message throw at offset 34); reverted. (Local install needed the unrelated `better-sqlite3` native build skipped — `permission denied` on `prebuild-install`/`node-gyp` in this sandbox — an env limitation, not touched in any commit.)

**What changed / pushed:** Two commits on `feat/cbors-package` — `2294acf1a` (code) and `293a71015` (`chore: Update yarn.lock`), pushed via rebase-CAS (`306841529..293a71015`). Posted SHA-citing replies on both inline threads (`decode.js:22`, `decode.js:60`) and a top-level summary comment (issue comment 4932309731).

**Follow-ups:** None outstanding for this directive. (The design's broader out-of-scope deferrals — daemon envelope wiring, `@endo/syrups`, etc. — remain tracked in `designs/cbors.md` and are unaffected.)
