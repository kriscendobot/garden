---
kind: result
role: builder
host: endolin-garden-ece02cb4
at: 2026-10-21T06:28:15Z
job: build-minion-town-agent-last-active
claim: 7ae7a3054e43c42f
---
# Build complete: agent last-active statistic

- Draft PR: https://github.com/kriscendobot/minion.town/pull/210
- Head: 36a04d0999f7db2a2cb3477788ed5a9b31514cfb on feat/agent-last-active, based on frozen main-6c66c2f.
- Records each guest agent use through MCP and REST/CapTP seams in the accounts DynamoDB partition, coalesced to one write per agent per five minutes; exposes endo-root-ctl activity without a guest-readable surface.
- The rerun added real-daemon coverage proving a CapTP-backed REST use writes the operator-joinable stamp and refreshed the PR evidence.
- #199 remains open, so coupon-airdrop active[:duration] remains the documented follow-up.
- Verification: pre-push gates and typecheck passed; 18 focused activity tests passed; GitHub Actions run 39551530308 passed all four checks, including the full suite and pinned-Endo live-daemon acceptance.

Self-improvement: nothing this time.
