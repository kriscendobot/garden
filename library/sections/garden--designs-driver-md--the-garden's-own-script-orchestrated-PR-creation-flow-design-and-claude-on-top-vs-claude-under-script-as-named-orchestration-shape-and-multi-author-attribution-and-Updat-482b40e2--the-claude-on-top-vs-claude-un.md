---
title: §The "claude-on-top vs claude-under-script" framing
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

Lines 161-187 carry the §two-named-orchestration-shapes:

- **claude-on-top** — the steward and contractor wake on cron, run an LLM tick to scan state, and dispatch subagents via `Agent`. Every quiet cycle burns LLM tokens.
- **claude-under-script** — a bash script drives a state machine and delegates judgment-bearing substeps to claude via `claude -p`. Deterministic steps are no-LLM.

§First-explicit-observation in library: **§the-claude-on-top-vs-claude-under-script-as-named-orchestration-shape-distinction — §two-named-orchestration-shapes-with-an-explicit-pivot-between-them + §the-design-NAMES-the-shapes-not-just-the-mechanisms + §the-shape-vocabulary-IS-the-design's-rhetorical-anchor**.

§Sibling-pattern to many systems-architecture distinctions (e.g., interpreter-on-top vs. compiler-under; declarative vs. imperative); §the-discipline-IS-name-the-shape-not-just-the-pattern.

§The-pivot-IS-not-just-implementation-it-IS-a-named-shape-change — §the-design-claims-an-architectural-inversion-not-a-refactor.
