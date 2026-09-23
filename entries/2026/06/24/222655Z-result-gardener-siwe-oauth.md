---
ts: 2026-06-24T22:26:55Z
kind: result
role: gardener
job: research-siwe-oauth-providers
host: endolinbot
---

# Research — OAuth/OIDC "Sign in with your Ethereum address" (the SIWE landscape)

Full source-cited survey backing the maintainer bulletin message. Method: a
6-angle deep-research fan-out (23 sources fetched, 109 claims extracted, top 25
adversarially verified 3-vote, 0 killed) over primary specs and provider docs,
plus a supplementary search pass to cover providers the fan-out left unverified
(Privy, Dynamic, thirdweb, Magic, Reown, NextAuth/Auth.js). Every load-bearing
claim is cited; unverifiable facts are flagged, not guessed.

## 1. The standard

**SIWE / ERC-4361** is the canonical, *Final* spec. A wallet (e.g. MetaMask)
signs an **ERC-191-prefixed** structured message (`\x19Ethereum Signed
Message:\n<len>`) carrying a `domain` (which **MUST** be an RFC-3986 authority —
this is the phishing/origin binding), `address`, `chain-id`, `uri`, `nonce` (≥8
alphanumeric chars, replay defense), and `issued-at`. The relying party (RP)
recovers the signer and **MUST bind the session to the immutable address, not to
mutable resolved resources** (ENS, balances) which it may optionally fetch
afterward. Source: <https://eips.ethereum.org/EIPS/eip-4361> (verified 3-0).

**The MetaMask credential path specifically.** The dApp requests
`personal_sign` (ERC-191) — or a typed `eth_signTypedData_v4` / EIP-712 variant
— over the SIWE message; MetaMask shows it and returns a 65-byte signature. The
RP verifies by: (1) **ecrecover** the signer and check it equals the claimed
address (EOA path); (2) check the **nonce** is one it issued and is unused
(replay); (3) check **domain/uri** match its own origin (anti-phishing); (4)
check `issued-at`/`expiration-time`. For **smart-contract wallets** (Safe,
Argent — no private key to ecrecover), the RP instead calls **EIP-1271**
`isValidSignature(bytes32 _hash, bytes _signature) returns (bytes4)` and accepts
iff it returns the magic value **`0x1626ba7e`**. Sources:
<https://eips.ethereum.org/EIPS/eip-4361>,
<https://eips.ethereum.org/EIPS/eip-1271> (both 3-0). (EIP-6492 extends this to
*counterfactual*/not-yet-deployed contract wallets — surfaced in fetch, not
separately verified.)

**CAIP-122 (Sign-In With X / SIWx)** generalizes EIP-4361 into a
chain-agnostic data model — verbatim "making EIP-4361 a specific implementation
of this specification" — and is explicitly framed as "an Alternative to
Centralized Identity… a self-custodied alternative to centralized identity
providers." Status is **Review** (not Final). **CACAO / CAIP-74** is the
container object: for `eip155` chains its payload reconstructs to an
EIP-4361-format message, with the signature-type field `t` selecting **`eip191`**
(EOA) or **`eip1271`** (contract wallet) verification. Sources:
<https://chainagnostic.org/CAIPs/caip-122>,
<https://chainagnostic.org/CAIPs/caip-74> (both 3-0).

## 2. The SIWE → OAuth/OIDC bridge

A raw SIWE signature is **not** OAuth/OIDC. Bridging it to a standard OIDC
session is exactly what **Spruce ID's `siwe-oidc`** does, and it is the only
verified *standards-native* bridge in this survey:

- **What it is:** an **OpenID Connect Identity Provider for SIWE**, ~80% Rust,
  exposing OIDC discovery at **`/.well-known/openid-configuration`**, mapping the
  Ethereum **address → `sub`** and the **ENS domain (fallback to address) →
  `preferred_username`**. Any service that already speaks OIDC adds it as a
  drop-in new IdP — no proprietary SDK. Spruce's stated rationale: most services
  wanting SIWE *already supported OIDC*, so a standard IdP lowered the adoption
  barrier versus a new SDK/workflow.
- **License / self-host:** dual **Apache-2.0 / MIT**. Ships **two deploy shapes
  from one codebase** — a standalone binary (Axum + **Redis**) and a Cloudflare
  Worker (WASM, serverless) — published at **`ghcr.io/spruceid/siwe_oidc`**
  (`:0.1.0`, `:latest`). Hosted instance at `oidc.signinwithethereum.org`.
- **Managed path:** Spruce **partnered with Auth0** (announced **April 2022**) to
  offer SIWE as a selectable IdP in the Auth0 marketplace, backed by the same
  open-source IdP (supports MetaMask/WalletConnect/Coinbase/Torus/Fortmatic).
- **Maturity caveats (important):** pre-1.0 (**v0.1.0**), **no formal security
  audit** (per its own README), partial OIDC conformance (25/29 basic-profile
  tests at the time documented), and the most recent container tags / the
  `docs.login.xyz/servers/oidc-provider/` page appear **~2 years stale / 404** —
  possible reduced maintenance that must be confirmed before production adoption.
  The Auth0 integration's *current 2026* status could not be reconfirmed (page
  would not load; no deprecation notice found; note Auth0 is now Okta-owned).

Sources: <https://github.com/spruceid/siwe-oidc>,
<https://blog.spruceid.com/sign-in-with-ethereum-decentralizing-an-identity-provider-server/>,
<https://blog.spruceid.com/sign-in-with-ethereum-on-auth0/>,
<https://auth0.com/blog/sign-in-with-ethereum-siwe-now-available-on-auth0/>,
<https://github.com/spruceid> (all verified 3-0).

There is also a **library-level** (not IdP) path: **`siwe`** (Spruce's TS lib,
dual Apache-2.0/MIT, ~1.1k★, the client primitive that produces the credential)
combined with a backend session framework. The most common framework recipe is
**NextAuth/Auth.js `CredentialsProvider`**: `authorize()` validates the SIWE
message + signature + domain + nonce and returns the address; sessions **must use
JWT** (the Credentials provider cannot persist DB users). Fully self-hosted, no
SaaS. Sources: <https://github.com/spruceid/siwe-next-auth-example>,
<https://blog.spruceid.com/sign-in-with-ethereum-on-next-js-applications/>,
<https://next-auth.js.org/providers/credentials>.

## 3. Provider survey

Two distinct shapes appear, and the distinction is the whole decision:

**(A) SIWE-native auth — the address *is* the identity, wallet signature is the
credential.** `siwe-oidc` (standard OIDC), `siwe` + NextAuth/Auth.js (library),
thirdweb Auth, Reown AppKit SIWE/SIWX. Non-custodial by construction (the user's
existing wallet signs).

**(B) Embedded-wallet / social-auth platforms — social/email login is primary,
a wallet is *minted* for the user via MPC/TSS.** Web3Auth→MetaMask Embedded
Wallets, Privy, Dynamic, Magic. These are *not* "sign in with your existing
Ethereum address" in the SIWE sense; they **consume** OIDC (bring-your-own-IdP)
rather than **issue** an address-keyed OIDC token. Mostly proprietary SaaS SDKs.

| Provider | What it is | Custody | OIDC posture | Host model | OSS / License | Maturity / notes |
|---|---|---|---|---|---|---|
| **Spruce `siwe-oidc`** | SIWE→OIDC IdP | Non-custodial (user wallet) | **Issues standard OIDC** (`sub`=address) | **Self-host** (binary+Redis / CF Worker) or hosted | **OSS, Apache-2.0/MIT** | Pre-1.0 v0.1.0, unaudited, looks ~2yr stale — verify upkeep |
| **`siwe` + NextAuth/Auth.js** | Library + session framework | Non-custodial | No OIDC endpoint; JWT session in your app | **Self-host** | **OSS** (siwe Apache/MIT; Auth.js ISC/MIT) | Mature, widely used; you own verification + nonce store |
| **thirdweb Auth** | SIWE login SDK + wallet infra | Non-custodial / self-custodial wallets | Proprietary SDK (SIWE spec-compliant); not an OIDC IdP | SaaS + OSS SDKs | SDKs **Apache-2.0** (e.g. Go/Android) | Active; broad wallet support |
| **Reown AppKit** (ex-WalletConnect Web3Modal) | Wallet-connect modal + SIWE/SIWX one-click auth | Non-custodial | SDK; SIWE/SIWX, not an OIDC IdP | SaaS infra + OSS SDK | **OSS** SDK (free) | Active, multi-chain (EVM/Solana/Bitcoin) |
| **Web3Auth → MetaMask Embedded Wallets** | Social-login embedded wallet (MPC/TSS) | Non-custodial MPC (semi-custodial until user adds MFA/backup share) | **Consumes** OIDC (social IdP-derived key share) | SaaS | Proprietary | **Acquired by Consensys, announced 2025-06-02**; now first-party MetaMask; docs 301→docs.metamask.io/embedded-wallets |
| **Privy** | Embedded wallet + auth SDK | Non-custodial (2-of-3 Shamir + TEE) | **Consumes** any OIDC/JWT IdP (BYO auth) | SaaS (no self-host found) | Proprietary | **Acquired by Stripe, June 2025** (Bridge integration) — lock-in consideration |
| **Dynamic** | Embedded + external wallet SDK | Non-custodial (TSS-MPC, user+server share in TEE) | SDK; consumes external auth | SaaS | Proprietary | Active; unified embedded+external+multichain |
| **Magic** | Delegated-key-management embedded wallet | Non-custodial DKMS (HSM-delegated) | **Consumes** OIDC (BYO IdP) + offers OIDC extension | SaaS | Proprietary | Active, enterprise-focused (G-DKMS) |
| **Auth0 + SIWE** | Managed IdP with SIWE marketplace integration | Non-custodial (wallet) | **Standard OIDC** (backed by Spruce IdP) | SaaS (Okta-owned) | Integration backed by OSS IdP | Announced Apr 2022; **2026 status unconfirmed** |

Sources for the (A)/(B) provider rows beyond the Spruce/Auth0 set above:
<https://docs.privy.io/authentication/user-authentication/jwt-based-auth/overview>,
<https://www.dynamic.xyz/features/embedded-wallets>,
<https://thirdweb.com/wallets>, <https://portal.thirdweb.com/auth>,
<https://docs.reown.com/appkit/next/core/siwe>, <https://docs.reown.com/appkit/overview>,
<https://magic.link/docs/authentication/login/idp>,
<https://magic.link/docs/wallets/enterprise-features/generalized-dkms>,
<https://consensys.io/blog/consensys-acquires-web3auth-to-enhance-metamasks-user-experience-user-safety>,
<https://docs.metamask.io/embedded-wallets/features/mpc/>.

**First-party MetaMask.** There is **no verified first-party MetaMask "OIDC IdP
keyed on your address" product.** MetaMask's auth-adjacent offerings are: the
**MetaMask SDK** (wallet connect; you implement SIWE yourself on top), the
**Delegation Toolkit** (ERC-7710/7715 permissions, not login), and the acquired
**Embedded Wallets** (social-auth/MPC, shape (B)). So the canonical "MetaMask
signs, you verify the address" path is **SIWE-on-your-backend**, not a MetaMask
product.

## 4. Tradeoffs & recommendation

- **Want true OAuth/OIDC plumbing, address-as-identity, self-hostable, zero
  lock-in?** → **`siwe-oidc`** is the only standards-native fit — *if* you accept
  pre-1.0/unaudited/maybe-stale and are willing to run/fork it (it's small Rust +
  Redis). Confirm maintenance first; budget to vendor the code.
- **Want SIWE without standing up an IdP?** → **`siwe` library + NextAuth/Auth.js
  CredentialsProvider**. Mature, fully self-hosted, you own nonce store + JWT
  sessions. No OIDC discovery endpoint, but if your stack just needs an
  authenticated session (not federation to third parties) you don't need one.
- **Want a managed OIDC drop-in and OK with SaaS?** → **Auth0 + SIWE** (verify
  2026 availability first).
- **Want mainstream onboarding (social/email, no wallet required) and a wallet
  minted for users?** → **(B) embedded-wallet platforms** (MetaMask Embedded
  Wallets, Privy, Dynamic, Magic). These optimize convenience over
  decentralization and are **proprietary SaaS with SDK lock-in**; note recent
  consolidation (**Privy→Stripe**, **Web3Auth→Consensys/MetaMask**). They consume
  OIDC; they don't give you "sign in with an arbitrary Ethereum address."

**Recommendation for a decentralization-minded project that wants OAuth-style
"sign in with your Ethereum address":** prefer the **`siwe` library +
NextAuth/Auth.js** path for a self-contained app (lowest dependency, fully
self-hosted, mature), and reach for **`siwe-oidc`** only if you genuinely need a
*standard OIDC IdP* to federate the Ethereum identity to other relying parties —
vendoring/forking it given its staleness. Avoid the (B) embedded-wallet SaaS
unless mainstream non-crypto onboarding is a hard product requirement; they
solve a different problem (custody UX) and reintroduce the SaaS lock-in SIWE was
designed to remove.

## Caveats & open questions

- CAIP-122 is **Review** status, not Final. `siwe-oidc` is **v0.1.0, unaudited**,
  with staleness signals — **confirm 2026 maintenance before adopting**.
- Auth0+SIWE 2026 availability **unconfirmed** (page would not load; no
  deprecation notice; Auth0 now Okta-owned).
- Embedded-wallet rows (Privy/Dynamic/Magic/thirdweb/Reown) are from current
  vendor docs + the supplementary search pass, not the 3-vote adversarial gate,
  so treat their license/custody specifics as **vendor-stated**, not
  independently verified to the same bar as §1–§2.
- Open: does any embedded-wallet provider *issue* an address-keyed OIDC token
  (vs. only consuming BYO-IdP)? Not found. MetaMask first-party OIDC IdP: none
  found.
