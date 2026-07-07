Both follow-on jobs are parked (`--go-ahead`), inbox is empty, and everything is pushed. Final verification pass of the state is done. Writing the completion report:

Job `design-siwe-onchain-authz-minion-town` complete.

## What I did

**Pushed to `kriscendobot/minion.town` `main` (50ec61b → 20767ff, 18 files, +1816):**

1. **`designs/siwe-onchain-authz.md`** — the design. The SIWE thunk against the five-endpoint contract with the twist made explicit (no upstream IdP; the wallet signature is the authentication, verified at the authorize step rather than `/token`, with rationale). The **three-tier on-chain authorization model**: Tier 1 address allowlist (works today — the policy layer already keys `iss`+`sub`; `sub` = checksummed address), Tier 2 capability-from-holdings (rule schema for `config/policy.json`, asset types cheapest-first, caching/staleness with a fail-closed ceiling, and a **placement decision**: evaluation belongs in the MCP policy layer at request time, not the thunk or the pre-token-gen Lambda — trade-off table included), Tier 3 agent/ocap identity (the headless challenge/verify wire protocol is the machine `/authorize` — already proven by the toy's consumer; the Tier-2 registry contract doubles as the capability registry; the honest ocap caveat that scopes are roles, with the finer delegation story named as the endo-side seam). Plus the state deviation from the contract's "stateless" invariant (single-use nonce/code stores; DynamoDB recommended, signed-nonce rejected with reason), new dependencies, threat model (replay, domain-binding/phishing, sybil per tier, key loss, **RPC-as-trusted-oracle**, XSS, DoS), and the provider-portability boundary.
2. **`deploy/thunks/siwe/`** — the runnable toy: portable five-endpoint OIDC core (plain-object handlers), viem 2.54.6 + jose only, node adapter as the sole host-aware file, wallet page for injected wallets, dev EOA + **mock EIP-1271 contract wallet** (a viem `custom()` transport answering the exact `isValidSignature` `eth_call` production makes), and a mock Cognito consumer doing discovery → code → `client_secret_basic` → JWKS-verified id_token → userinfo.
3. **`deploy/thunks/CONTRACT.md`** — SIWE row updated from "deferred" to the implementation pointer.

**Verified by real execution:** `npm test` **19/19 pass** (replay, phishing/domain-binding, wrong signer/chain/address-swap, expiry, code single-use, client auth, issuer byte-exactness, JWKS/`kid` consistency, EIP-1271 accept/reject/no-RPC); `npm run demo` end-to-end for **both** wallet types (EOA offline, EIP-1271 via mock chain); `npm run dev` smoke-tested (discovery + wallet page served, curled). **Not verified:** the wallet page against a real injected wallet in a browser (no MetaMask in the container) — the page's wire protocol is fully covered headlessly, but the browser/UI path awaits the deploy job.

**Maintainer decisions surfaced (design § 6, each with a recommendation):** (1) chain — Ethereum mainnet for identity, Base for a future registry; **flag:** if Agoric-native identity is the real goal, the analog is a Cosmos ADR-036 thunk (would reuse everything but `siwe.js`); recommend SIWE first. (2) principals — both humans and machines (machine path already works). (3) authz key — ship Tier 1 now; first Tier-2 asset should be a purpose-built registry contract, not an ERC-20/NFT threshold. (4) v1 scope — EIP-1271 in, ENS out of the mint path.

**Follow-on jobs parked `--go-ahead`:** `deploy-siwe-thunk-minion-town` (Lambda/API-Gateway/Caddy/Cognito binding, DynamoDB store, secrets, email-less-identity resolution) and `wire-siwe-onchain-authz-minion-town` (policy-layer tiers, cached viem reader, optional registry contract). Both name the § 6 decisions they block on.

Self-improvement: nothing this time.
