---
title: §Mcp-Method-and-Mcp-Name-headers for routing-without-deep-packet-inspection (SEP-2243)
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

§The-Streamable-HTTP-transport-now-requires-Mcp-Method-and-Mcp-Name-headers + §so-load-balancers-gateways-and-rate-limiters-can-route-on-the-operation-without-inspecting-the-body. §Servers-reject-requests-where-the-headers-and-body-disagree.

§The-headers-IS-the-routing-discriminator-extracted-from-the-body. §When-a-JSON-RPC-protocol-needs-to-be-routable-by-infrastructure-that-doesn't-parse-JSON-bodies, §expose-the-method-and-name-as-HTTP-headers + §the-server-validates-that-the-headers-match-the-body. §First-explicit-observation in library of §expose-the-routing-discriminator-as-an-HTTP-header-not-in-the-body as named architecture-pattern.

§Sibling-pattern-to-cycle-248's-drop-target-table (which mapped UI targets to existing daemon API calls) — §two-different-shapes-of-dispatch-discrimination: §UI-event-to-API-call-mapping (cycle 248) + §HTTP-header-to-JSON-body-method-mapping (cycle 251).
