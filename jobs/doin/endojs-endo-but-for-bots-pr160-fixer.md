# fixer (shepherd→fixer auto-chain) on endojs/endo-but-for-bots PR #160

Posted by the pr160 **shepherd** after driving CI from a fully-red matrix down
to a single root cause it classified `next: fixer` (contextual impasse: the fix
needs the `@endo/exo-stream` reader-pump convention and a judgment call on a
documented contract). Head branch endojs/endo-but-for-bots @ `feat/exo-zip-package`
(bot-pushable). Re-fetch live state before acting.

## What the shepherd already landed (all green now)
- `chore: Update yarn.lock` fixup — exo-unzip's new `@endo/bytes`/`@endo/errors`
  deps were missing from the lockfile; `yarn install --immutable` failed, which
  reddened the ENTIRE matrix at install.
- `throw Fail`...`` trailing-comma SyntaxError → semicolons.
- Local `makeIteratorRef` helper in exo-unzip (workspace has no `@endo/daemon`).
- `help` + `listTree` added to the UnzipTree/UnzipBlob exos (required by
  `ReadableTreeInterface`/`ReadableBlobInterface`; mirrored platform `LocalTree`).
- Regenerated composite tsconfigs (`yarn build:types:gen`) — `build:types:check`
  drift from the two new packages.

## The remaining failure (9 tests: 3 exo-unzip + 6 exo-zip)
All trace to ONE root cause. `packages/exo-unzip/src/unzip.js` implements
`streamBase64` as a 0-arg method returning a Far async-iterator (`.next()`), and
the shepherd's interim `makeIteratorRef` doubles down on that. But the current
shared `@endo/platform/fs/lite` `ReadableBlobInterface` guard is
`streamBase64: M.call(M.any()).returns(M.promise())` — the platform evolved to
the **syn/ack reader-pump protocol**: `streamBase64(synHead) -> StreamNode`,
consumed via `iterateBytesReader` (which base64-DECODES each ack chunk to
`Uint8Array`). The 0-arg call the tests/consumer make is rejected by the guard
("Expected at least 1 arguments").

## Recommended fix (Option A — conform to the platform protocol; matches `local-blob`)
1. `packages/exo-unzip/src/unzip.js`
   - Remove the local `makeIteratorRef` helper and the `@endo/far` `Far` import.
   - `import { makeReaderPump } from '@endo/exo-stream/reader-pump.js';`
   - Blob method, mirroring `packages/platform/src/fs-node/local-blob.js`
     (fresh pump per call → re-streamable, lazy):
     ```js
     streamBase64: synHead => {
       const pump = makeReaderPump(base64Chunks(zipReader.get(fullPath)));
       return pump(synHead);
     },
     ```
     (`base64Chunks` already yields base64 strings, so no `mapReader`/encode
     wrapper is needed — its yields ARE the ack values.)
2. `packages/exo-zip/src/zip.js`
   - `import { iterateBytesReader } from '@endo/exo-stream/iterate-bytes-reader.js';`
   - Replace `const readerRef = await E(node).streamBase64(); const bytes =
     await drainBase64(readerRef);` and the string-concat `drainBase64` with a
     byte drain: `for await (const chunk of iterateBytesReader(node)) {...}` then
     concatenate the `Uint8Array` chunks. (`node` IS the reader; its
     `streamBase64` is the stream method.)
3. Tests — `packages/exo-unzip/test/unzip.test.js` and any exo-zip test drain:
   - Rewrite the `drainBase64` helper + the `streamBase64 decodes to original
     bytes` test to consume via `iterateBytesReader(blob)` (yields bytes).
   - The `streamBase64 chunks at 3-byte raw boundaries (no mid-stream padding)`
     test inspects base64-STRING chunk lengths via `.next()`. Under the byte
     reader those chunks are decoded `Uint8Array`s, so the base64-padding
     concern is subsumed (per-chunk decode, not concat). Preserve its verifiable
     intent — multi-chunk streaming + byte-exact reconstruction — and drop the
     now-unobservable base64-string-length sub-assertion. This is NOT weakening
     to hide a failure; it migrates the test to the evolved contract.
4. Add `@endo/exo-stream` as a dependency to BOTH `packages/exo-{zip,unzip}/package.json`
   (`"workspace:^"`), then `yarn install --mode=update-lockfile` and commit the
   lockfile in its own `chore: Update yarn.lock` fixup (retcon discipline). Also
   re-run `yarn build:types:gen` in case the new dep shifts composite refs.

## Maintainer heads-up (already surfaced by the shepherd, non-blocking)
The author documented the base64-string-concat "no mid-stream padding" contract
deliberately. Option A retires it in favor of the platform byte-reader protocol
(the reason `ReadableBlobInterface` exists). If the maintainer wants to KEEP the
base64-concat contract instead, the alternative (Option B) is to give exo-unzip
its own interface rather than the platform's — but that likely defeats the PR's
goal of handing trees to `E(agent).storeTree(...)` over CapTP. Prefer Option A
unless the maintainer directs otherwise.

Verify locally: `yarn workspace @endo/exo-unzip test` and
`yarn workspace @endo/exo-zip test` both green, then confirm the CI matrix.

<!-- garden-reaped: 4 -->

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 12
  worker_kind: gardener
  claimed_at: 2026-07-20T08:03:21Z
