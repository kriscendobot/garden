---
role: designer
---

# Design: Sign-In with Ethereum (SIWE) for minion.town — the thunk + the on-chain authorization model

**Repo (PRIVATE):** github.com/kriscendobot/minion.town — direct push to `main`, no PR. Work in an isolated per-job checkout (`scripts/jobs/ensure-project-worktree.sh <this-base> kriscendobot/minion.town main`). AWS CLI `~/.local/bin/aws` (install via `bash scripts/aws/install-aws-cli.sh` from the garden repo if absent; creds hard-linked in `$HOME/.aws`), region us-west-1. **Secrets only in Secrets Manager.**

## Mandate

Design — **spec + a runnable local toy** (mirror how `designs/mcp-oauth.md` shipped a tested toy) — how minion.town adds **Sign-In with Ethereum (EIP-4361)** as a federated identity. This is NOT a live deployment: produce the design, the toy, follow-on job proposals, and the maintainer decisions. A separate build/orchestration deploys it later.

**Two halves — the SECOND is the real work:**
1. **The SIWE OIDC thunk** — plumbing against the existing contract (comparatively mechanical).
2. **The on-chain authorization model** — what verifiable on-chain facts map to what minion.town capabilities. This is the substance.

## Architecture context (exists already — reuse, don't reinvent)

- Cognito broker (pool `us-west-1_mDaTgjr1m`) federates upstream IdPs via **OIDC "thunks"**: a 5-endpoint OIDC face (`/.well-known/openid-configuration`, `/authorize`, `/token`, `/userinfo`, `/.well-known/jwks.json`) that Cognito's generic-OIDC IdP consumes. Contract: `deploy/thunks/CONTRACT.md`.
- **Reference implementation:** the LIVE GitHub thunk — `deploy/aws/lambda/github-oidc-thunk/` (zero-dep ARM64 Node Lambda behind an **API Gateway HTTP API** — this account BLOCKS public Lambda Function URLs — fronted by Caddy at `github-idp.minion.town`). SIWE mirrors its deployment shape.
- **First-party authorization** is owned by minion.town (identity → permissions policy, keyed on `iss`+`sub`), enforced in the MCP server + web gate; the Phase-4 pre-token-generation V2 Lambda can enrich the token with derived claims.
- **Provider-portability directive (maintainer):** minion.town is a deployment/config layer — keep the thunk provider-agnostic so it can later run on CloudFlare Workers / Netlify functions, not just AWS; the AWS binding stays under `deploy/aws/`.

## The twist — SIWE is an authenticator, not a wrapper

Unlike the GitHub/Google thunks (which bounce to an upstream OAuth), the SIWE thunk has no upstream — it IS the authenticator:
- `/authorize` serves a **wallet-connect page** (WalletConnect v2 + `viem`/`siwe`), issues a nonce-bearing EIP-4361 message bound to the `minion.town` domain, collects the signature.
- `/token` **verifies** the signature: ECDSA `ecrecover` for EOAs **plus EIP-1271 `isValidSignature`** for smart-contract wallets (Safe / ERC-4337 — now common), which needs an **on-chain call**; then mints the `id_token` (`sub` = checksummed address; optionally ENS name/avatar).
- New dependencies vs other thunks: **single-use nonce state** (small DynamoDB table or a stateless signed nonce), an **Ethereum RPC** (EIP-1271 + ENS; Infura/Alchemy key or public RPC → Secrets Manager), and a **bit of frontend**.

Ground the spec in current standards/libraries (researcher precedence — verify against actual library surfaces, not memory): EIP-4361, EIP-1271, the `siwe` + `viem` libraries, WalletConnect v2, ENS resolution.

## The on-chain authorization model (the substance) — design it in tiers

- **Tier 1 — address identity:** `sub` = address; bare allowlist. Simple, sybil-weak. Keep the Cognito break-glass admin as the non-crypto fallback (key loss = identity loss, no recovery).
- **Tier 2 — capability from holdings (the real unlock):** derive scopes/roles from **on-chain assets** — ERC-20 balance thresholds, ERC-721/1155 ownership, POAP, DAO/multisig (Safe signer / governance weight), or a purpose-built on-chain allowlist contract. Specify WHERE it's computed (thunk at token-mint vs. the Phase-4 identity Lambda vs. the MCP server's policy layer at request time — trade-offs), caching/staleness, and how the policy file expresses "asset X → capability Y." Sybil-resistant because the gate is the scarce asset.
- **Tier 3 — agent/ocap identity (frontier — call it out given the Endo/Agoric context):** a keypair is an unforgeable bearer of authority, so a **minion/agent** can sign in as a principal, its authority expressed on an on-chain capability registry, granted/revoked by transaction. For a machine principal, `/authorize` may be a headless signing endpoint rather than a wallet popup. Sketch how this composes with the existing scope→tool model and the "endo-but-for-bots" direction.

## Maintainer decisions to resolve or surface clearly (with a recommendation)

1. **Chain(s):** Ethereum mainnet vs an L2 (Base/Optimism/Arbitrum) for gating assets + RPC. **And flag:** if the identity actually wanted is **Agoric-native**, SIWE is Ethereum-specific — note the Cosmos/Agoric **ADR-036 arbitrary-signature** analog as an alternative/parallel thunk, and recommend which to build first.
2. **Principals:** humans, agents/machines, or both (shapes `/authorize`).
3. **What authz keys on:** bare address allowlist (Tier 1) vs on-chain assets (Tier 2) — and which asset(s).
4. **v1 scope:** EIP-1271 + ENS in or out of the first cut.

## Deliverables

- **`designs/siwe-onchain-authz.md`** — the thunk against the contract; the three-tier on-chain-authz model; the twist's new dependencies; a threat model (replay/nonce/domain-binding, sybil, key loss, phishing); the provider-portability boundary; and the maintainer decisions with a recommendation.
- **A runnable local toy** proving SIWE → OIDC → token end-to-end (wallet sign against a local dev key, signature verification incl. an EIP-1271 path, the 5-endpoint OIDC face, a mock Cognito-side consumer) with a test suite — mirroring the mcp-oauth toy's `npm run dev` + `npm test`. **No AWS deploy in this job.**
- **Follow-on job proposals**, parked `--go-ahead`: deploy the SIWE thunk (mirroring the GitHub thunk's AWS path) and wire the chosen authz tier into the policy layer.

Keep coupling loose; secrets only in Secrets Manager; respect the deployment/config-layer boundary (the authz *model* may ultimately belong with the MCP/endo code, not minion.town — note where each piece lives).

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 5
  claimed_at: 2026-07-07T22:41:01Z
