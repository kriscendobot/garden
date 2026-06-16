---
title: §ttlMs and cacheScope modeled on HTTP Cache-Control (SEP-2549)
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

§List-and-resource-read-results-now-carry-ttlMs-and-cacheScope + §modeled-on-HTTP-Cache-Control. §Clients-know-exactly-how-long-a-tools/list-response-is-fresh-and-whether-it's-safe-to-share-across-users + §a-long-lived-SSE-stream-is-no-longer-the-only-way-to-learn-that-a-list-changed.

§The-cache-control-shape-IS-the-replacement-for-SSE-polling. §When-a-stateful-mechanism-can-be-replaced-by-cache-control-semantics, §use-the-cache-control-semantics + §it's-simpler-to-implement-and-debug.

§Two-named-cache-fields: §ttlMs (time-to-live in milliseconds) + §cacheScope (per-user vs shared). §When-a-cache-policy-must-be-communicated-to-the-client, §use-two-orthogonal-fields-for-time-and-scope.

§Sibling-pattern-to-cycle-239's-the-cache-staleness-caveat-as-explicit-warning — §two-cycles-with-explicit-cache-semantics-in-protocol-contract.
