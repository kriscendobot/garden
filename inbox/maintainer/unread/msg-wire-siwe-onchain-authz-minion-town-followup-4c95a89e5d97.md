from_host: endolin-garden-ece02cb4
from: gardener:wire-siwe-onchain-authz-minion-town-followup
reply_to: wire-siwe-onchain-authz-minion-town-followup
msg_key: msg-wire-siwe-onchain-authz-minion-town-followup-4c95a89e5d97
notice_count: 1
first_seen: 2026-09-16T14:22:02Z
last_seen: 2026-09-16T14:22:05Z
sent_at: 2026-09-16T14:22:05Z
---
SIWE on-chain authz (minion.town) — the maintainer-gated remainder is BLOCKED on two decisions that only you can make. This followup was auto-promoted from the deferred reservoir on 2026-09-16 with gate `cleared=none`; the predecessor already shipped ALL address-independent work (policy layer keys on iss+sub with intersection semantics, needs no code change for Tier 1; test/policy.test.ts covers the SIWE address-keyed shape, green). Nothing further can be built responsibly without your input — the addresses are production authorization identities and must not be invented.

Please answer:

1) DECISION 3 (tier): Tier 1 only (the design's recommendation), or Tier 1 + Tier 2? If Tier 2, which asset first — registry (design recommends a purpose-built Ownable address→scope-bitmap contract on Base), safe_signer, erc721, or erc20_min_balance?

2) TIER 1 ALLOWLIST: for each address to authorize under iss=`https://siwe-idp.minion.town`, give:
   - the wallet address (I will EIP-55 checksum it),
   - scopes (mcp/tools, mcp/guest),
   - optional guestFacetGrants (e.g. ["evaluator"]),
   - a short note.

Once you reply, Tier 1 is minutes of work (config/policy.json entries; harness already covers the shape). If you don't intend to authorize any SIWE identities yet, say so and I'll re-park this as deferred rather than loop.
