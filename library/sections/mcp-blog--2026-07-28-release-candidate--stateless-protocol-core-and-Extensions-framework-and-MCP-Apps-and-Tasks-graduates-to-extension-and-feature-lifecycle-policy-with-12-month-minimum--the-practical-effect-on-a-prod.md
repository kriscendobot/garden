---
title: §The practical effect on a production deployment IS the value statement
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

§The-blog-explicitly-names: *A remote MCP server that previously needed sticky sessions, a shared session store, and deep packet inspection at the gateway can now run behind a plain round-robin load balancer, route traffic on an `Mcp-Method` header, and let clients cache `tools/list` responses for as long as the server's `ttlMs` permits.*

§The-practical-effect-IS-the-value-statement + §the-named-infrastructure-changes (sticky sessions removed + shared session store removed + deep packet inspection removed) + §the-replacement-shape (plain round-robin + Mcp-Method routing + ttlMs caching) make the value concrete.

§Three-named-things-removed + §three-named-replacements. §When-a-protocol-change-affects-operations-not-just-API, §name-the-infrastructure-changes-explicitly + §the-replacement-shape-IS-the-evidence-the-change-improves-operations. §First-explicit-observation in library of §the-practical-effect-on-production-IS-the-value-statement.
