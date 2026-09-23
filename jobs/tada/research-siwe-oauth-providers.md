Inbox empty. Job complete.

---

# Completion report — `research-siwe-oauth-providers`

**What I did.** Researched the landscape of OAuth/OIDC "sign in with your Ethereum address" (SIWE) solutions via a deep-research fan-out (6 angles, 23 sources fetched, 109 claims extracted, top 25 adversarially 3-vote-verified — 0 killed) over primary specs and provider docs, then ran a supplementary web-search pass to cover providers the fan-out left unverified (Privy, Dynamic, thirdweb, Magic, Reown/WalletConnect, NextAuth/Auth.js). Every load-bearing claim is cited; unverifiable facts are flagged, not guessed.

**Key findings.**
- **Standard:** SIWE/ERC-4361 (wallet signs ERC-191 message bound to domain + nonce; RP recovers signer to the immutable address; EIP-1271 `0x1626ba7e` for smart-contract wallets), generalized by CAIP-122/SIWx + CACAO (CAIP-74). Documented the exact MetaMask `personal_sign`/EIP-712 credential path and what the RP verifies.
- **Bridge to OIDC:** Spruce ID's `siwe-oidc` (Apache-2.0/MIT Rust OIDC IdP, address→`sub`, self-hostable as binary+Redis or Cloudflare Worker) is the only standards-native bridge — but v0.1.0, unaudited, with ~2-year staleness signals. Same bridge offered as an Auth0 marketplace integration (2026 status unconfirmed).
- **Provider split:** SIWE-native/address-as-identity (siwe-oidc, siwe+NextAuth, thirdweb, Reown) vs. social-login embedded-wallet SaaS that *consume* OIDC (Privy, Dynamic, Magic, Web3Auth→MetaMask Embedded Wallets). Noted recent consolidation: Privy→Stripe and Web3Auth→Consensys/MetaMask (both 2025). No first-party MetaMask address-keyed OIDC IdP exists.
- **Recommendation:** default to `siwe` lib + NextAuth/Auth.js (self-hosted, mature) for a self-contained app; reach for `siwe-oidc` (vendored/forked) only if federating to other relying parties; avoid embedded-wallet SaaS unless mainstream onboarding is a hard requirement.

**What changed / artifacts.**
- Full source-cited report committed to the journal: `entries/2026/06/24/222655Z-result-gardener-siwe-oauth.md` (commit `96011938` on `journal2`), pushed via an isolated worktree off `origin/journal2` (the shared `/home/kris/journal` tree had another process's untracked `library/` files blocking a rebase — isolated-worktree push is the reliable pattern and avoided touching that dirty tree).
- Maintainer bulletin message sent with executive summary + comparison table + recommendation, referencing the full report (delivered to `inbox/maintainer`, id `20260624T222907Z-d848e0`).

**Follow-ups / open items (flagged in the report, not blockers):**
- Confirm `siwe-oidc` is still maintained in 2026 before any adoption (stale Docker tags, 404'd docs page).
- Confirm the Auth0 + SIWE marketplace integration is still live in 2026 (Auth0 now Okta-owned).
- Embedded-wallet rows (Privy/Dynamic/Magic/thirdweb/Reown) are vendor-stated, not held to the 3-vote adversarial bar — re-verify license/custody specifics if one is shortlisted.
