---
role: builder
tier: mentor
---
<!-- garden-promoted-from-plan: gate=go-ahead priority=normal at=2026-08-22T05:49:24Z cleared=none -->

---
role: builder
---

# Wire the chosen SIWE on-chain authorization tier into minion.town's policy layer

**Repo (PRIVATE):** github.com/kriscendobot/minion.town — direct push to `main`, no PR. Work in an isolated per-job checkout (`scripts/jobs/ensure-project-worktree.sh <this-base> kriscendobot/minion.town main`).

Design: `designs/siwe-onchain-authz.md` § 3 (the tier model and the placement decision: evaluation lives in the MCP POLICY LAYER at request time behind a TTL cache — not in the thunk, not in the pre-token-gen Lambda) and § 6 decision 3 (which asset/tier the maintainer chose — the answer should be in this job's body or inbox at promotion time; the design's recommendation is Tier 1 now, then a purpose-built registry contract for Tier 2).

Scope by tier:
- Tier 1 (always): add the SIWE issuer's identities to `config/policy.json` (`iss` = the deployed thunk issuer, `sub` = checksummed address) per the maintainer's allowlist; extend `test/policy.test.ts` coverage for an address-keyed identity.
- Tier 2 (if chosen): the `onchain` rule schema from design § 3 in `config/policy.json`; a cached viem reader in `src/auth/policy.ts` (per-(address,rule) TTL cache, default 60s, serve-stale on RPC error with a fail-closed staleness ceiling ~15min); rule types per the chosen asset (erc20_min_balance / erc721 / erc1155 / safe_signer / registry). Union on-chain-derived scopes with static entries, then intersect with token scopes (the existing invariant). Tests against a mocked viem transport (see `deploy/thunks/siwe/dev/wallet.js` for the custom()-transport pattern).
- Registry contract (if Tier 2 chose `registry`): the ~40-line Ownable address→scope-bitmap contract + deploy script; chain per the maintainer's § 6.1 answer (design recommends Base for the registry).

Keep the policy module provider-portable (plain viem, no AWS SDK). Note design § 8 Q4: this code may later migrate to the endo/MCP side; keep it in `src/auth/` with no minion.town-specific coupling beyond the policy document path.

PRECONDITION: maintainer answers to design § 6 decisions 1 and 3, and (for anything past Tier 1) the deployed thunk issuer URL from job deploy-siwe-thunk-minion-town.

<!-- garden-reaped: 0 -->

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 2
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-08-22T07:43:10Z
