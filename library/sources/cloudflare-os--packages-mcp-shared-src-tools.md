---
source_kind: comment-fragment
source_repo: cloudflare/cloudflare-os
source_path: packages/mcp-shared/src/tools.ts
source_line_range: "1-143"
source_commit: bd0aa2dcde02008bb6170341fe2c574fd3ace275
comment_subject: the MCP tool-annotation trust boundary and the ServerTrust-mediated classification policy
source_authors: [Dan Carter, Phillip Jones]
ingested: 2026-08-24
ingested_by: scholar
section_count: 2
status: current
---

`tools.ts` is the single trust boundary in the MCP connector: what an endpoint says about its own tools becomes what a Gadget may do, and nothing outside this file reads a tool's annotations. Its comments define the `ServerTrust` distinction (`vetted` versus `byo`), decided by the deployment rather than the server, and the `classifyTool` policy that turns annotations into a read/action mode and an auto-approvable flag using strict boolean tests that fail closed for any missing annotation. Filed under the `mcp-server-connector` concept.

| Section | Topics | Status |
|---------|--------|--------|
| [Tool-annotation trust boundary and ServerTrust tiers](../sections/cloudflare-os--packages-mcp-shared-src-tools--annotation-trust-boundary.md) | capability-mediated-integrations, capability-security | current |
| [Classifying a tool into read or action and deciding auto-approval](../sections/cloudflare-os--packages-mcp-shared-src-tools--tool-classification-policy.md) | capability-mediated-integrations, capability-security | current |
