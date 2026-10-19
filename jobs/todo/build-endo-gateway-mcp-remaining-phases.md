---
arc: minion-town-mcp-ocapn
role: builder
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Build step for endojs/endo-but-for-bots on `llm`: finish the remaining phases of the design `designs/endo-gateway-mcp.md` (Endo Gateway MCP termination, milestone M6). Predecessor job `build-endo-gateway-mcp-termination` landed Phase 3 as `endo-mcp-http` in `@endo/agent-mcp-stdio` (head branch `build/endo-gateway-mcp-termination`, base `llm-ca5aaef`; find its draft PR by the `<!-- garden-job: build-endo-gateway-mcp-termination -->` marker). That PR's Phase and evidence ledger is `orchestrated-slice` with this job as `Successor:`.

Remaining work, from the design's Status section:
1. Phase 4, the Chat-side UI: a "+ Add agent" affordance on the spaces gutter, and an "MCP" tab on each agent's space-home view. The tab shows the `mcpServers` JSON block (`url: https://<gateway-host>/mcp`, `Authorization: Bearer <formula id>` via `E(powers).identify(petName)`), a Copy button, and the "treat it like an SSH key" warning. Add a Playwright smoke test.
2. Streaming: SSE responses with `notifications/progress`, and `notifications/cancelled` forwarding in `packages/agent-mcp-stdio/src/http.js`. If this stays deferred, record why in the design.
3. Optional, and only if it can be done without a daemon -> agent-mcp-stdio package cycle: mount `makeMcpHttpHandler` on the daemon gateway's own port.

Then update the predecessor PR's ledger (or this PR's) to `deliverable`, citing the evidence. Open a DRAFT PR for the new work via ensure-pr.sh, stacked on the predecessor head if it has not merged.
