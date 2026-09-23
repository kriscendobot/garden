---
title: §The job inbox's seven named job kinds
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

Lines 217-218 enumerate §seven-named-job-kinds:
1. `pr-creation`
2. `observed-error`
3. `issue-response`
4. `build-request`
5. `design-request`
6. `retcon-rebase`
7. `ci-recovery`

§First-explicit-observation in library: **§seven-named-job-kinds-in-a-generic-job-inbox — §each-kind-IS-a-named-workflow + §the-`kind`-field-IS-the-dispatch-key + §the-driver-loads-`skills/driver-${kind}-state-machine/SKILL.md`-per-kind**.

§Sibling-pattern to many event-driven systems where the kind field selects the handler; §the-generic-inbox-with-typed-jobs-IS-the-canonical-event-driven-shape.
