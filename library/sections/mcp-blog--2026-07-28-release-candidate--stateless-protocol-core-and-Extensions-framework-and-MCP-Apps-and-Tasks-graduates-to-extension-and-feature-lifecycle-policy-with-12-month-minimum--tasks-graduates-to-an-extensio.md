---
title: §Tasks graduates to an extension — named demotion from core
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

§Tasks-shipped-as-an-experimental-core-feature-in-2025-11-25. §Production-use-surfaced-enough-redesign-that-the-right-home-for-it-is-an-extension-rather-than-the-specification.

§The-named-rationale: §the-protocol-substrate-changed-shape (stateless) + §the-feature's-lifecycle-no-longer-fits-the-core. §Anyone-who-shipped-against-the-2025-11-25-experimental-Tasks-API-will-need-to-migrate-to-the-new-lifecycle.

§Task-creation-is-server-directed: §the-client-advertises-the-extension-and-the-server-decides-when-a-call-should-run-as-a-task. §tasks/list-is-removed-because-it-can't-be-scoped-safely-without-sessions.

§First-explicit-observation in library of §feature-graduates-to-an-extension-as-named-demotion-from-core. §The-direction-is-not-promotion-but-demotion + §the-redesign-IS-the-evidence-the-feature-belongs-elsewhere.

§Sibling-pattern-to-cycle-242's-stops-at-the-filesystem-boundary — §two-different-shapes-of-named-scope-boundary: §cycle-242 explicit-boundary-of-this-design + §cycle-251 explicit-demotion-of-feature-from-core-to-extension.

§Sibling-to-cycle-244's-no-cron-semantics — §three-cycles-with-explicit-refusal-of-conventional-feature-or-graduation (240 no-encoding + 242 no-help + 244 no-cron + 251 tasks-demoted).
