Confirmed: 24 checks, zero failures, on head `951cde7f`. Only untracked artifact is my local `.corepack/` install cache (never committed). Job done.

## Completion report

**Job:** shepherd (auto: red CI) on endojs/endo-but-for-bots PR #700

**Root cause found (two independent reds):**
1. **`test` (all 4 matrix jobs) + `cover` (both):** `test/integration.test.js` in `@endo/ocapn-noise` crashed under the shims-only ava config with `ReferenceError: harden is not defined` at `packages/ocapn/src/client/sturdyref-uri.js:179`. The newly promoted `sturdyref-uri.js` (bridge cut 2) calls `harden()` at module top level (lines 179, 224) but never imported it, relying on a global `harden` that is undefined when `lockdown()` isn't called. Every sibling in `client/` imports `@endo/harden`. This is the documented 2026-06-18 SES-init class of failure.
2. **`lint`:** prettier flagged two test files (`packages/ocapn/test/codecs/passable.test.js`, `packages/ocapn/test/sturdyref-uri.test.js`).

**Fixes pushed** to head branch `build/sturdyref-bridge-2-ocapn-promotions` (two atomic commits):
- `bcc17416c` fix(ocapn): `import harden from '@endo/harden'` in `sturdyref-uri.js` — one root cause fixing all 4 `test` jobs and both `cover` jobs.
- `951cde7f1` chore(ocapn): `prettier --write` the two flagged test files.

Scanned all source files touched by the PR's feature commit; `sturdyref-uri.js` was the only one using the global `harden` without importing it.

**Result:** CI is **green** on head SHA `951cde7f13de5ae4503d3ebe51ca4f0d1d1ac301` — 24 checks, 0 failures (previously 8 red: lint ×2, test ×4, cover ×2). Verified by polling the live rollup to full settle.

**Notes:** No PR comment posted — auto-dispatched job with no per-action comment authorization in the body. PR remains a draft (bot-authored build-stack PR); driving CI green was the shepherd's remit. Local install verification was blocked by a sandbox restriction (`prebuild-install`/`node-gyp` permission denied for `better-sqlite3`, unrelated to this PR), so verification was done against live CI rather than a local run.

**Follow-ups:** none. `next: none` (failures were real and are now cleared by the pushed fixes; green run at https://github.com/endojs/endo-but-for-bots/actions confirms).
