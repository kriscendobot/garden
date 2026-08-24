---
title: At-most-once approved MCP calls
source: packages/mcp-shared/README.md
source_repo: cloudflare/cloudflare-os
source_commit: bd0aa2dcde02008bb6170341fe2c574fd3ace275
source_date: 2026-08-18
source_authors: [Dan Carter, Maximo Guk, Nathan Disidore, Phillip Jones]
ingested: 2026-08-24
ingested_by: scholar
topics: [capability-mediated-integrations, capability-security]
status: current
---

Approved MCP writes provide at-most-once rather than exactly-once execution, preferring a lost result over repeating a side effect when the protocol cannot supply an idempotency key or inverse operation.

Storage claims an approval before sending the call, preventing concurrent `applyAction` attempts. After return, the action is settled before attaching or normalizing the server-controlled result, so payload failure cannot erase the fact that dispatch happened. Only 401 and 403 prove refusal before execution and permit a retry classification. HTTP or JSON-RPC errors, dropped connections, malformed or oversized replies, and timeouts leave the outcome unknown and close the action as failed without retry. A claim surviving a dead activation expires the same way.

The operational cost is deliberate restaging after uncertainty. One human approval is never spent twice without another explicit decision.

Source: [packages/mcp-shared/README.md](https://github.com/cloudflare/cloudflare-os/blob/bd0aa2dcde02008bb6170341fe2c574fd3ace275/packages/mcp-shared/README.md) at commit `bd0aa2dc`.
