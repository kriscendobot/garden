Working tree clean, both commits pushed, draft PR #670 open. The job is complete.

---

## Completion report

**Job:** Build the subscription-OAuth path from the `endopi-provider-registry-and-oauth` design (M3) in `endojs/endo-but-for-bots` as a draft PR.

**Delivered:** Draft PR **[endojs/endo-but-for-bots#670](https://github.com/endojs/endo-but-for-bots/pull/670)** — `feat(lal): subscription OAuth flow and encrypted auth store (M3)`, base `llm-08f5acc` (frozen snapshot of the `llm` tip; `lal`/`genie` are `llm`-only, so base is `llm` per the base-inference rule), head `feat/lal-subscription-oauth`, **draft**.

**Affected package:** `@endo/lal` only (added workspace deps `@endo/base64`, `@endo/bytes`).

**What was built** (new dir `packages/lal/providers/oauth/`, scoped to the genuinely-missing OAuth slice):
- `pkce.js` — RFC 7636 S256 verifier/challenge; randomness + SHA-256 injected.
- `flow.js` — `buildAuthorizationUrl`, `exchangeAuthorizationCode`, `refreshAccessToken` (carries a refresh token forward when the provider omits one), `isExpired`; `fetch`/clock injected.
- `auth-store.js` — a `makeExo` per-provider credential store (`M.interface`-guarded) keyed by provider + account, sealing/unsealing through an injected cipher so at-rest state is ciphertext only.
- `node-crypto.js` — the sole `node:crypto` module (mirroring `daemon-node-powers.js`): SHA-256, randomness, AES-256-GCM authenticated cipher, scrypt passphrase KDF.
- `base64url.js`, `index.js` (public surface incl. `makeOAuthClient`), `oauth.types.d.ts`.
- A changeset (`@endo/lal: minor`) and a module README.

**Out of scope (as instructed):** the provider-registry refactor and the Lal-vs-Genie consolidation policy question — both deliberately left out and called out in the PR body as such.

**Verification (real-execution evidence):**
- `yarn workspace @endo/lal test` on `test/oauth-*.test.js` — **28 tests passed** (ran via `corepack yarn ava`, observed output). Covers the RFC 7636 Appendix B golden vector, token-exchange request-body assertions, refresh carry-forward, encrypted-at-rest (secret text absent from sealed bytes), AES-GCM fresh-IV / tamper-rejection / wrong-key-rejection, scrypt determinism, SHA-256 vector.
- **Regression evidence confirmed load-bearing** by breaking each core path and observing the matching test fail: dropping base64url padding → PKCE vector test failed; making the cipher a passthrough → encrypted-at-rest + round-trip tests failed. Both breaks reverted; tree re-verified green.
- `eslint` exit 0, `prettier --check` clean, `tsc` clean on the new files, and the `typedefs-belong-in-dts` probe passes. (Pre-existing repo-wide `undici-types`/MCP-sdk type-resolution errors live only in `node_modules` from an incomplete sandbox install — `better-sqlite3`'s native build fails here for lack of network — and are unrelated to this change; the OAuth tests import none of that.)

**Follow-ups** (noted in the PR body): persist sealed bytes into the daemon formula-graph store; extend daemon `CryptoPowers` with an encrypt-at-rest/KDF surface (the design cites an "existing daemon pattern" that does not yet exist in-tree); add verified provider presets for Claude/ChatGPT/Copilot; wire a subscription bearer token into the registry once the registry refactor lands.

**Handoff:** draft PR #670 is ready for the review gauntlet (panel → fixer loop → un-draft). A self-improvement note (two small library lessons: `git checkout --` cannot revert untracked files during regression breaks; the Endo `*.types.d.ts` gitignore-negation naming convention for hand-written declarations) was sent to the liaison inbox.

Self-improvement: sent the two lessons above to `liaison`.
