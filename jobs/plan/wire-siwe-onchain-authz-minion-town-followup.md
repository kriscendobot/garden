---
gate: deferred
priority: normal
posted_by: builder
posted_at: 2026-08-22T07:55:47Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Finish wiring SIWE on-chain authz into minion.town's policy layer (maintainer-gated remainder)

Continuation of `wire-siwe-onchain-authz-minion-town`, which delivered the address-independent portion and then blocked on maintainer input. **Do not claim until the maintainer has answered** (this is why it is parked/deferred).

**Repo (PRIVATE):** github.com/kriscendobot/minion.town — direct push to `main`, no PR. Isolated per-job checkout: `scripts/jobs/ensure-project-worktree.sh <this-base> kriscendobot/minion.town main`.

## Already done and on `main` (commit 510cb4e)
- Confirmed the policy layer (`src/auth/policy.ts`) already keys generically on `iss`+`sub` with intersection semantics, so **Tier 1 needs no code change** — only allowlist entries.
- Added + pushed `test/policy.test.ts` coverage for a SIWE address-keyed identity (iss=`https://siwe-idp.minion.town`, sub = EIP-55 checksummed address), including a guard that **checksum casing is load-bearing** (a lowercased `sub` is a distinct, unknown identity). Tests 14→19, green.

## Blocking preconditions (from the maintainer, requested via message 20260822T055203Z-ae527d)
1. **Decision 3 — tier:** Tier 1 only (design's recommendation) vs Tier 1 + Tier 2. If Tier 2, which asset first (design recommends a purpose-built `registry` contract on Base; alternatives safe_signer / erc721 / erc20_min_balance).
2. **Tier 1 allowlist:** for each address to authorize under iss=`https://siwe-idp.minion.town`: the address (checksum it EIP-55), scopes (`mcp/tools`, `mcp/guest`), optional `guestFacetGrants: ["evaluator"]`, and a note. **Must not be invented** — production authorization identities.

## Remaining work once answered
- **Tier 1 (always):** add the maintainer's SIWE identities to `config/policy.json` (iss = thunk issuer, sub = checksummed address, per-address scopes). The test harness already covers the shape.
- **Tier 2 (only if chosen):** `onchain` rule schema in `config/policy.json`; a cached viem reader in `src/auth/` (per-(address,rule) TTL cache, 60s default, serve-stale-on-RPC-error with a fail-closed staleness ceiling ~15min); rule types per the chosen asset; union on-chain scopes with static entries, then intersect with token scopes (preserve the invariant); tests against a mocked viem `custom()` transport (pattern: `deploy/thunks/siwe/dev/wallet.js`). Keep provider-portable (plain viem, no AWS SDK), in `src/auth/`, no minion.town coupling beyond the policy-document path.
- **Registry contract (only if Tier 2 chose `registry`):** ~40-line Ownable address→scope-bitmap contract + deploy script; chain per § 6.1 (design recommends Base).

Design: `designs/siwe-onchain-authz.md` § 3 (tier model + policy-layer placement) and § 6 decisions 1 & 3. Thunk issuer live: `https://siwe-idp.minion.town` (mainnet, EIP-1271 in, ENS out; sub = checksummed address).
