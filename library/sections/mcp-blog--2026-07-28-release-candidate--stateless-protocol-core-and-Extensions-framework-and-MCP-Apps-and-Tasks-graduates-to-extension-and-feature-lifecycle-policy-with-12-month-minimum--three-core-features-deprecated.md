---
title: §Three core features deprecated under new lifecycle policy (SEP-2577)
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

§Three-core-features-deprecated-under-the-new-feature-lifecycle-policy:

| Feature | Replacement |
|---------|-------------|
| Roots | Tool parameters, resource URIs, or server configuration |
| Sampling | Direct integration with LLM provider APIs |
| Logging | `stderr` for stdio transports; OpenTelemetry for structured observability |

§The-deprecations-are-annotation-only — §the-methods-types-and-capability-flags-continue-to-work-in-this-release-and-in-every-specification-version-published-within-a-year-of-it + §removing-any-of-them-will-require-a-separate-SEP-under-the-lifecycle-policy.

§Each-deprecated-feature-has-a-named-replacement-mechanism — §not-all-replaced-by-the-same-thing + §each-replacement-IS-appropriate-for-the-feature-it-replaces. §When-a-protocol-deprecates-multiple-features, §name-the-replacement-for-each-feature-individually + §don't-use-a-single-blanket-replacement.

§First-explicit-observation in library of §per-deprecated-feature-named-replacement as named deprecation-discipline.

§Sibling-pattern-to-cycle-238's-reserved-future-siblings + cycle-244's-no-cron-semantics — §three-different-shapes-of-feature-management: §reserved-future-siblings + §explicit-refusal + §deprecated-with-named-replacement.
