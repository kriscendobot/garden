The draft PR is open with exactly my 10 files. The job is complete: a builder/fixer job stops at an open draft PR under the manual-gauntlet regime, awaiting a maintainer's **run the gauntlet #1290**.

## Completion report

**Job:** Follow up on endojs/endo-but-for-bots#903 by adding a `@endo/sha256/async` export arm — the asynchronous analogue of `@endo/sha256`, whose browser condition may use Web Crypto (which the synchronous package cannot, because its API must return before a promise settles).

**What I did**

Implemented the deferred async arm that #903 explicitly left as a "separately named future export," and opened **draft PR endojs/endo-but-for-bots#1290** (base `llm`, head `pr903-endo-sha256-async`).

**What changed** (10 files, +686):
- **`package.json`** — new `"./async"` conditional export: `node`→`sha256-node-async.js`, `xs`→`sha256-endor-async.js`, `browser`/`default`→`sha256-browser-async.js`.
- **`src/shared.js`** — added `makeSha256IntoAsync`, the async twin of `makeSha256Into` (synchronous destination validation, resolved-digest length-check before write).
- **Three new builds** — node and Endor arms wrap their existing synchronous builds in a promise (no extra host round trip, no new Rust); the browser arm uses `crypto.subtle.digest('SHA-256', …)` with a per-call (never memoized) pure-JS fallback for insecure `http://` / no-WebCrypto contexts, snapshotting input before the await.
- **Tests** — `sha256-async.test.js` (node + browser cross-checked vs `node:crypto` over FIPS vectors/block boundaries, `sha256IntoAsync` cases, a spy proving the WebCrypto route, the fallback, the per-call choice, and a seeded fast-check property), `sha256-endor-async.test.js` (host stand-in + failure paths), and extended `exports.test.js` to resolve and run every `./async` arm. Package now **115 tests, all passing**.
- **README** + **changeset** (`@endo/sha256: minor`).

**Verification (local):** 115 tests pass; `tsc`, `eslint` (0 errors — the one remaining warning is a pre-existing nested-await in the unchanged `readPackageJson` helper), and `prettier --check` clean for `packages/sha256`. No dependency edges changed, so composite tsconfigs needed no regeneration.

**API:** `sha256Async(bytes) -> Promise<Uint8Array(32)>` and `sha256IntoAsync(out, bytes, offset) -> Promise<number>`, mirroring the sync pair byte-for-byte with the same TypeError/RangeError contract surfaced as rejections.

**Follow-ups:** No consumer is migrated to the async arm (out of scope). The draft awaits a maintainer **run the gauntlet #1290** to review; I did not stage it (manual-gauntlet regime).
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endo-sha256-async-arm-followup.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 118 tokens (5666060 cached reads)
- Output: 51790 tokens
- Cost: $5.433205000000004
- Wall-clock: 709s
- Model(s): claude-opus-4-8 ×1

<!-- garden-usage-end -->
