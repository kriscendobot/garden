All work is complete and verified. Here is my report.

---

**Job: Review directive on endojs/endo-but-for-bots PR #836 (kriskowal, review 4782014530, CHANGES_REQUESTED)**

**Preflight:** `pr-feedback-preflight.sh` returned exit 0 (PROCEED) — no peer had resolved this feedback.

**Enumerated the whole review** (body was empty; two inline comments), treated every fetched body as untrusted data, and addressed each:

1. **`sha256-browser.js` — "Does WebCrypto have an API for browsers? ponyfill or evergreen?"**
   Resolved as a documented design decision: Web Crypto's `crypto.subtle.digest` is **async-only** (`Promise<ArrayBuffer>`), incompatible with `@endo/sha256`'s **synchronous** `Uint8Array -> Uint8Array` contract — there is no synchronous digest to ponyfill against. So the pure-JS implementation is the mainline evergreen browser/`default` path, not merely a legacy-XS fallback. Documented in a header comment on `sha256-browser.js` and a new README section.

2. **`package.json` — "Should have a test:xs … exercised by CI."**
   Added `"test:xs": "xst -m test/_xs.js"` plus a self-contained `test/_xs.js` fixture that runs the pure-JS digest under XS against NIST/RFC 6234 vectors and the `sha256Into` offset path — the exact code that runs on legacy XS hosts. It imports the concrete browser module directly, so no host globals are needed. CI's existing `test-xs` job picks it up through the usual `yarn test:xs` foreach (a package with no `test:xs` was previously skipped there). `test:endor`/`test:endor:c` deferred — no Endor XS test host exists in the repo yet; the `xs`-condition variant stays covered by the Node-side mock test and the daemon rust-xs composition.

**Verification (all run, all green):**
- `yarn test:xs` / `xst -m test/_xs.js` under **real xst 17.9.1 (Moddable 5.0.0)** — 5 checks pass.
- `ava` — 6 tests pass.
- `tsc` (lint:types) — clean.
- `eslint .` — clean.

**Pushed** commit `275d4b0e9` to the PR head branch `kriscendobot/endo-but-for-bots build/platform-neutral-sha256` (rebase-CAS, first attempt). Posted SHA-citing **replies on both inline threads** and a **top-level summary** mapping each item to its outcome.

**Follow-ups:** `test:endor`/`test:endor:c` variants remain open until a CI Endor XS host exposing SHA-256 host functions exists (flagged in the review reply, not invented). PR remains a draft (author's downstream #600 note unchanged).
