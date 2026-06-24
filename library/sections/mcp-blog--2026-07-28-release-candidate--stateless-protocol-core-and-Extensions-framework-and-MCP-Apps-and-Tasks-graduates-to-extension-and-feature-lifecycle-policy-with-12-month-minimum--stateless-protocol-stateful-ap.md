---
title: §Stateless-protocol-stateful-applications named distinction
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

§Removing-the-protocol-level-session-does-not-mean-your-application-has-to-be-stateless. §The-blog-explicitly-names: *Servers that need to carry state across calls can do what HTTP APIs have always done: mint an explicit handle (a `basket_id`, a `browser_id`) from a tool and have the model pass it back as an ordinary argument on later calls.*

§The-explicit-handle-pattern — §mint-an-explicit-handle-from-a-tool + §the-model-passes-it-back-as-an-ordinary-argument; §the-state-IS-visible-to-the-model-not-hidden-in-transport-metadata.

§The-explicit-handle-makes-state-visible-to-the-model: *In practice, we've found this pattern (the model threading an identifier from one tool call to the next) to be more than just a workable substitute for session state. It's often a more powerful one. The model can compose handles across tools, reason about them, and hand them off between steps.*

§First-explicit-observation in library of §the-explicit-handle-pattern-makes-state-visible-to-the-model-not-hidden-in-transport-metadata as named architectural discipline.

§Sibling-pattern-to-cycle-244's-the-formula-IS-the-stable-handle (webhook formula-id IS the URL) — §two-cycles-with-handle-makes-substrate-visible-not-hidden: §cycle-244 formula-id-IS-URL + §cycle-251 explicit-handle-IS-state-visible-to-model.
