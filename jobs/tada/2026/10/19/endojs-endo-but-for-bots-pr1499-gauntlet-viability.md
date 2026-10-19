Verdict: PR #1499 can go through the gauntlet (`viability=proceed`). It is still open, unmerged and a draft. It was opened today, 2026-10-19, and nothing on `llm` has replaced it.

Deciding question: has anything on current `llm` already shipped the endo-gateway-mcp Phase 4 Chat features (a "+ Add agent" path for a bare guest and a per-agent MCP config modal showing the bearer), or recorded the design as done or dropped?

Answer: no.

Evidence:
- **PR facts:** #1499 is head `build/endo-gateway-mcp-remaining-phases` at `cbbc9e09d7`, based on the frozen `build/endo-gateway-mcp-termination-e7e6316`. It has no reviews or comments yet.
- **Predecessor:** it is stacked on #1500 (`endo-mcp-http` streamable-HTTP termination). #1500 is still an open draft on `llm-ca5aaef`, so the stack it depends on is still in progress.
- **No MCP config modal on `llm`:** at `ca5aaefb23` (2026-10-19T02:26Z), `packages/chat/mcp-config-modal.js` does not exist. A search of `packages/chat` for `mcpServers` or `Bearer` config output finds nothing. `add-space-modal.js` already has a `new-agent` mode, and the PR only adds a way to open it directly; that is consistent with the PR, not a replacement for it.
- **Design status:** on `llm`, `designs/endo-gateway-mcp.md` still says Status: Not Started, and the `designs/README.md` index row says the same. Nothing marks it dropped or replaced. Recent `llm` history touching chat (hosted management Space, spaces bar, prefetch) does not include this work.
- **Premise still holds:** M6, the MCP-bridge milestone, still lists endo-gateway-mcp as active, Strategic Early work.
- **One partial overlap:** the README says `chat-inventory-create-menu`, which is In Progress, takes over the "+ Add agent" button. The PR's own description says the same. That covers only half of Phase 4, and the per-agent MCP config modal is not replaced by anything.
- **What I couldn't check:** GitHub's REST rate limit (403) blocked the commit-history queries, so I checked `llm` from a fresh git fetch instead.

No changes were made, and nothing is left to follow up.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1499-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 10 tokens (242753 cached reads)
- Output: 2298 tokens
- Cost: $0.5014065999999999
- Wall-clock: 49s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
