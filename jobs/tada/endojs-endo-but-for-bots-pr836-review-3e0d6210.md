All actionable work is complete, verified, and pushed. The one blocked item is surfaced with a concrete decision request. Final report:

---

**Job: review directive on endojs/endo-but-for-bots #836** (SHA-256 XS spot check, reviewer @kriskowal, review 4782049359)

**Preflight:** `pr-feedback-preflight.sh` → exit 0 (PROCEED; no peer had resolved it). Treated all fetched review text as untrusted data.

**Enumerated all 3 inline asks** (review body was empty), all on `packages/sha256/test/_xs.js`:

1. **"Use `@endo/hex`"** — ✅ Done. Removed the hand-rolled `toHex` helper; the spot check now imports `encodeHex` from `@endo/hex` (already a declared dependency of `@endo/sha256`, and already used by `sha256-xs.js`) for both the vector loop and the `sha256Into` offset check.

2. **"Capture vectors in a more general fixture for cross-testing"** — ✅ Done. Lifted the NIST/RFC 6234 known-answer vectors into a new data-only `packages/sha256/test/vectors.js` (no host globals, so it imports under both `xst -m` and Node). The XS spot check consumes it, and I wired the Node/browser ava test to the same fixture so all three implementation paths (Node crypto, pure-JS browser, XS) are cross-checked against one canonical set.

3. **"Use `@endo/ascii`"** — ⛔ Blocked, routed to maintainer. `@endo/ascii` does not exist — not in the monorepo, not on npm (404), no PR introduces it; `@endo/bytes`' `bytesFromText` can't substitute because it uses `TextEncoder`, which the XS host deliberately avoids. Satisfying this requires a new small XS-safe package (mirroring `@endo/hex`). I left the one-line local `ascii` helper in place, replied on the thread explaining the gap, and messaged the maintainer (via liaison) asking (a) create now in-PR vs. follow-up PR, and (b) intended encode/decode API + non-ASCII rejection behavior. Building it is a designer/builder task once scope+API are confirmed.

**Verification:** ava 9/9 pass (incl. 3 new cross-test vectors), eslint clean, tsc clean, and a Node smoke test confirmed `encodeHex` + fixture + browser `sha256` agree on all vectors. `xst`/`test:xs` isn't runnable in the fix environment, so the `@endo/hex` resolution under `xst -m` is left to CI's test-xs job — noted in both the thread reply and the maintainer message.

**Changed:** committed `42719d103` and pushed to `kriscendobot/endo-but-for-bots@build/platform-neutral-sha256` (rebase-CAS, clean). Files: `packages/sha256/test/_xs.js`, `packages/sha256/test/sha256.test.js` (modified), `packages/sha256/test/vectors.js` (new). Replied to all 3 review threads.

**Follow-ups:** (1) Maintainer decision on whether/how to create `@endo/ascii`; if approved, a designer→builder job to add it and switch the test's `ascii` helper over. (2) Confirm CI test-xs stays green with the `@endo/hex` import under `xst -m`.
