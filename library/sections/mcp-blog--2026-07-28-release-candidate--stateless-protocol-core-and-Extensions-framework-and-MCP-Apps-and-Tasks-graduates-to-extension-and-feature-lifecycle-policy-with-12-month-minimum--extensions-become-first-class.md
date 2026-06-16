---
title: §Extensions become first-class with reverse-DNS IDs (SEP-2133)
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

§Extensions-existed-in-2025-11-25-but-had-no-formal-process. §SEP-2133-adds-that: §extensions-are-identified-by-reverse-DNS-IDs + §negotiated-through-an-extensions-map-on-client-and-server-capabilities + §live-in-their-own-ext-*-repositories-with-delegated-maintainers + §version-independently-of-the-specification.

§A-new-Extensions-Track-in-the-SEP-process-gives-them-a-path-from-experimental-to-official. §Two-tracks (Standards-Track for core spec + Extensions-Track for extensions); §each-track-has-its-own-graduation-path.

§Reverse-DNS-IDs as named-identifier-convention (e.g., `io.modelcontextprotocol/clientInfo` seen in the example payload). §When-a-protocol-needs-extension-identifiers-that-don't-collide, §use-reverse-DNS + §the-DNS-namespace-IS-the-uniqueness-guarantee.

§First-explicit-observation in library of §reverse-DNS-IDs-as-named-identifier-convention-for-extensions.

§Sibling-pattern-to-cycle-248's-custom-MIME-type (`application/x-endo-petname`) — §two-cycles-with-named-extension-identifier-conventions: §cycle-248 custom-MIME-type-with-x-prefix + §cycle-251 reverse-DNS-IDs.
