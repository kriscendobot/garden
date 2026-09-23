---
title: §Two daemon shapes — persistent driver pool + per-feed watcher daemons
source-slug: garden--designs-driver-md
section-slug: the-garden's-own-script-orchestrated-PR-creation-flow-design-and-claude-on-top-vs-claude-under-script-as-named-orchestration-shape-and-multi-author-attribution-and-Update-section-at-top
source-url: https://github.com/kriskowal/garden/blob/main/designs/driver.md
source-repo: kriskowal/garden
source-path: designs/driver.md
source-author: gardener + fixer + designer
total-lines: 691
ingest-cycle: 281
ingest-date: 2026-06-10
lane: designs
scope: structural-pattern-observations
parent: garden--designs-driver-md--the-garden's-own-script-orchestrated-PR-creation-flow-design-and-claude-on-top-vs-claude-under-script-as-named-orchestration-shape-and-multi-author-attribution-and-Update-section-at-top
---

Lines 26-32 carry §two-named-daemon-shapes:

1. **Persistent driver pool** — `garden-driver@1.service`, `garden-driver@2.service`, ... — each lane's lifetime spans many jobs and many PRs.
2. **One daemon per upstream activity feed** — one watcher per repo / feed; translates upstream events into message dispatches + posts `:eyes:` reactji.

§First-explicit-observation in library: **§two-named-daemon-shapes-with-distinct-cardinality (N-driver-pool + one-watcher-per-feed) — §the-cardinality-shapes-the-discipline + §drivers-IS-many-watchers-IS-one-per-feed + §the-asymmetry-IS-because-drivers-are-fungible + §watchers-are-feed-bound**.

§Sibling-pattern to many systems where worker-pools differ in cardinality from producer-loops.
