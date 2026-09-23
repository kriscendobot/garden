---
title: §MCP Apps as server-rendered UI in sandboxed iframe (SEP-1865)
source-slug: mcp-blog--2026-07-28-release-candidate
source-url: https://blog.modelcontextprotocol.io/posts/2026-07-28-release-candidate/
authors: [David Soria Parra (Lead Maintainer), Den Delimarsky (Lead Maintainer)]
publication-date: 2026-05-21
spec-versions: [2025-11-25, 2026-07-28]
ingest-cycle: 251
ingest-date: 2026-06-09
lane: papers
parent: mcp-blog--2026-07-28-release-candidate--stateless-protocol-core-and-Extensions-framework-and-MCP-Apps-and-Tasks-graduates-to-extension-and-feature-lifecycle-policy-with-12-month-minimum
---

§MCP-Apps-lets-servers-ship-interactive-HTML-interfaces-that-hosts-render-in-a-sandboxed-iframe. §Tools-declare-their-UI-templates-ahead-of-time-so-hosts-can-prefetch-cache-and-security-review-them-before-anything-runs. §The-rendered-UI-talks-back-to-the-host-over-the-same-JSON-RPC-base-protocol-used-everywhere-else-in-MCP + §every-UI-initiated-action-goes-through-the-same-audit-and-consent-path-as-a-direct-tool-call.

§Three-named-defenses: §sandboxed-iframe (browser isolation) + §declared-ahead-of-time (cacheable + reviewable) + §UI-talks-back-via-same-JSON-RPC (same audit/consent path).

§When-a-server-can-render-interactive-UI-in-a-host, §the-isolation-IS-the-sandbox + §the-pre-declaration-IS-the-cacheability-and-review + §the-back-channel-IS-the-same-as-the-direct-tool-call-channel.

§First-explicit-observation in library of §server-rendered-UI-with-three-named-defenses (sandbox + pre-declaration + uniform-back-channel). §Sibling-pattern-to-cycle-238's-three-named-SSRF-vectors-and-three-named-defenses — §two-cycles-with-three-named-defenses-against-a-substrate-risk.
