---
title: §Full JSON Schema 2020-12 for tool schemas (SEP-2106) with named security constraints
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

§Tool-inputSchema-and-outputSchema-are-lifted-to-full-JSON-Schema-2020-12. §Input-schemas-keep-the-type-object-root-constraint-but-now-allow-composition (oneOf + anyOf + allOf) + conditionals + references ($ref + $defs). §Output-schemas-are-unrestricted + §structuredContent-can-now-be-any-JSON-value-rather-than-only-an-object.

§Two-named-security-constraints: §implementations-must-not-auto-dereference-external-$ref-URIs + §implementations-should-bound-schema-depth-and-validation-time. §When-a-protocol-adopts-a-more-expressive-schema-language, §name-the-security-constraints-explicitly + §the-power-comes-with-named-bounds.

§First-explicit-observation in library of §named-security-constraints-when-adopting-more-expressive-schema-language. §Sibling-pattern-to-cycle-238's-three-named-SSRF-vectors-and-three-named-defenses — §two-different-shapes-of-named-security-bounds: §cycle-238 named-SSRF-defenses + §cycle-251 named-schema-validation-bounds.
