---
title: §Lane-numbered systemd template with `@<N>.service` syntax
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

Lines 78, 105 carry §the-systemd-templated-unit-shape:

- `scripts/systemd/garden-driver@.service`
- `scripts/systemd/garden-watcher@.service`

§First-explicit-observation in library: **§lane-numbered-systemd-template-with-`@<N>.service`-syntax — §systemd's-templated-units-IS-the-canonical-pattern-for-N-instance-services + §the-`@`-IS-the-named-parameter-marker + §the-instance-name-becomes-the-lane-number-or-feed-slug**.

§Sibling-pattern to many systemd conventions; §the-cluster-uses-systemd-natively-rather-than-supervising-its-own-processes.
