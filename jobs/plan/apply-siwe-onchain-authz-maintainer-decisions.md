---
gate: blocked
blocked_on: siwe-onchain-authz-maintainer-decision
priority: normal
posted_by: gardener
posted_at: 2026-09-16T14:35:49Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Apply the maintainer's SIWE on-chain authz decisions to minion.town (blocked on a maintainer decision)

Successor to `wire-siwe-onchain-authz-minion-town-followup`. **Do not promote until the maintainer has answered the two blocking decisions below** (blocker: `siwe-onchain-authz-maintainer-decision`). The liaison/maintainer promotes this manually once the answer arrives; it is intentionally `--blocked`, NOT `--deferred`, because a deferred maintainer-gated job is foreman-auto-promotable and was pulled into a budget-burning no-op loop twice (predecessor 2026-08-22, this job 2026-09-16 at 14:19:14Z — foreman `guard=promoted` with no maintainer answer, gate `cleared=none`).

**Repo (PRIVATE):** github.com/kriscendobot/minion.town — direct push to `main`, no PR. Isolated per-job checkout: `scripts/jobs/ensure-project-worktree.sh <this-base> kriscendobot/minion.town main`.

## Already done and on `main` (commit 510cb4e)
- Policy layer (`src/auth/policy.ts`) already keys generically on `iss`+`sub` with intersection semantics, so **Tier 1 needs no code change** — only allowlist entries in `config/policy.json`.
- `test/policy.test.ts` covers a SIWE address-keyed identity (iss=`https://siwe-idp.minion.town`, sub = EIP-55 checksummed address), including a guard that **checksum casing is load-bearing** (a lowercased `sub` is a distinct, unknown identity). Tests green.

## Blocking decisions (only the maintainer can answer)
1. **Decision 3 — tier:** Tier 1 only (design's recommendation) vs Tier 1 + Tier 2. If Tier 2, which asset first (design recommends a purpose-built `registry` contract on Base; alternatives safe_signer / erc721 / erc20_min_balance).
2. **Tier 1 allowlist:** for each address to authorize under iss=`https://siwe-idp.minion.town`: the address (checksum it EIP-55), scopes (`mcp/tools`, `mcp/guest`), optional `guestFacetGrants: ["evaluator"]`, and a note. **Must not be invented** — production authorization identities.

## Remaining work once answered
- **Tier 1 (always):** add the maintainer's SIWE identities to `config/policy.json` (iss = thunk issuer `https://siwe-idp.minion.town`, sub = checksummed address, per-address scopes). Harness already covers the shape.
- **Tier 2 (only if chosen):** `onchain` rule schema in `config/policy.json`; a cached viem reader in `src/auth/` (per-(address,rule) TTL cache, 60s default, serve-stale-on-RPC-error with a fail-closed staleness ceiling ~15min); rule types per the chosen asset; union on-chain scopes with static entries, then intersect with token scopes (preserve the invariant); tests against a mocked viem `custom()` transport (pattern: `deploy/thunks/siwe/dev/wallet.js`). Provider-portable (plain viem, no AWS SDK), in `src/auth/`.
- **Registry contract (only if Tier 2 chose `registry`):** ~40-line Ownable address→scope-bitmap contract + deploy script; chain per design § 6.1 (recommends Base).

Design (in the minion.town repo): `designs/siwe-onchain-authz.md` § 3 (tier model + policy-layer placement) and § 6 decisions 1 & 3. Thunk issuer live: `https://siwe-idp.minion.town` (mainnet, EIP-1271 in, ENS out; sub = checksummed address).
