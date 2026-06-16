---
title: "garden/designs/driver.md — the garden's own script-orchestrated PR-creation flow design + claude-on-top vs claude-under-script as named orchestration shape + multi-author attribution + Update section at top + the garden's design-doc format distinct from endo-but-for-bots + seven named job kinds + scripts/ top-level directory convention"
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
kind: index
section_count: 21
---

Sections:

- [`garden/designs/driver.md` — the garden's own architectural design](garden--designs-driver-md--the-garden's-own-script-orchestrated-PR-creation-flow-design-and-claude-on-top-vs-claude-under-script-as-named-orchestration-shape-and-multi-author-attribution-and-Updat-482b40e2--garden-designs-driver-md-the-g.md)
- [§The garden's design-doc format distinct from endo-but-for-bots](garden--designs-driver-md--the-garden's-own-script-orchestrated-PR-creation-flow-design-and-claude-on-top-vs-claude-under-script-as-named-orchestration-shape-and-multi-author-attribution-and-Updat-482b40e2--the-garden-s-design-doc-format.md)
- [§The Update section at top — named time-stamped amendment](garden--designs-driver-md--the-garden's-own-script-orchestrated-PR-creation-flow-design-and-claude-on-top-vs-claude-under-script-as-named-orchestration-shape-and-multi-author-attribution-and-Updat-482b40e2--the-update-section-at-top-name.md)
- [§The "claude-on-top vs claude-under-script" framing](garden--designs-driver-md--the-garden's-own-script-orchestrated-PR-creation-flow-design-and-claude-on-top-vs-claude-under-script-as-named-orchestration-shape-and-multi-author-attribution-and-Updat-482b40e2--the-claude-on-top-vs-claude-un.md)
- [§Three named observable costs from a single day](garden--designs-driver-md--the-garden's-own-script-orchestrated-PR-creation-flow-design-and-claude-on-top-vs-claude-under-script-as-named-orchestration-shape-and-multi-author-attribution-and-Updat-482b40e2--three-named-observable-costs-f.md)
- [§"The driver is a script, not a role" — named categorical distinction](garden--designs-driver-md--the-garden's-own-script-orchestrated-PR-creation-flow-design-and-claude-on-top-vs-claude-under-script-as-named-orchestration-shape-and-multi-author-attribution-and-Updat-482b40e2--the-driver-is-a-script-not-a-r.md)
- [§The scripts/ top-level directory with named convention](garden--designs-driver-md--the-garden's-own-script-orchestrated-PR-creation-flow-design-and-claude-on-top-vs-claude-under-script-as-named-orchestration-shape-and-multi-author-attribution-and-Updat-482b40e2--the-scripts-top-level-director.md)
- [§Two daemon shapes — persistent driver pool + per-feed watcher daemons](garden--designs-driver-md--the-garden's-own-script-orchestrated-PR-creation-flow-design-and-claude-on-top-vs-claude-under-script-as-named-orchestration-shape-and-multi-author-attribution-and-Updat-482b40e2--two-daemon-shapes-persistent-d.md)
- [§The driver outer loop — six numbered steps](garden--designs-driver-md--the-garden's-own-script-orchestrated-PR-creation-flow-design-and-claude-on-top-vs-claude-under-script-as-named-orchestration-shape-and-multi-author-attribution-and-Updat-482b40e2--the-driver-outer-loop-six-numb.md)
- [§The job inbox's seven named job kinds](garden--designs-driver-md--the-garden's-own-script-orchestrated-PR-creation-flow-design-and-claude-on-top-vs-claude-under-script-as-named-orchestration-shape-and-multi-author-attribution-and-Updat-482b40e2--the-job-inbox-s-seven-named-jo.md)
- [§Lane-numbered systemd template with `@<N>.service` syntax](garden--designs-driver-md--the-garden's-own-script-orchestrated-PR-creation-flow-design-and-claude-on-top-vs-claude-under-script-as-named-orchestration-shape-and-multi-author-attribution-and-Updat-482b40e2--lane-numbered-systemd-template.md)
- [§The role-prefixed lanes — extending the lane convention](garden--designs-driver-md--the-garden's-own-script-orchestrated-PR-creation-flow-design-and-claude-on-top-vs-claude-under-script-as-named-orchestration-shape-and-multi-author-attribution-and-Updat-482b40e2--the-role-prefixed-lanes-extend.md)
- [§The prompt-on-failure capture pattern — `git hash-object -w --stdin`](garden--designs-driver-md--the-garden's-own-script-orchestrated-PR-creation-flow-design-and-claude-on-top-vs-claude-under-script-as-named-orchestration-shape-and-multi-author-attribution-and-Update-482b40e2--the-prompt-on-failure-capture.md)
- [§"What changes in the existing library" — the named refactor record](garden--designs-driver-md--the-garden's-own-script-orchestrated-PR-creation-flow-design-and-claude-on-top-vs-claude-under-script-as-named-orchestration-shape-and-multi-author-attribution-and-Updat-482b40e2--what-changes-in-the-existing-l.md)
- [§Cycle 281 first-explicit-observations roundup (twelve)](garden--designs-driver-md--the-garden's-own-script-orchestrated-PR-creation-flow-design-and-claude-on-top-vs-claude-under-script-as-named-orchestration-shape-and-multi-author-attribution-and-Updat-482b40e2--cycle-281-first-explicit-obser.md)
- [§Recurring meta-pattern counters bumped at cycle 281](garden--designs-driver-md--the-garden's-own-script-orchestrated-PR-creation-flow-design-and-claude-on-top-vs-claude-under-script-as-named-orchestration-shape-and-multi-author-attribution-and-Updat-482b40e2--recurring-meta-pattern-counter.md)
- [§Synthesis target — slot machine library](garden--designs-driver-md--the-garden's-own-script-orchestrated-PR-creation-flow-design-and-claude-on-top-vs-claude-under-script-as-named-orchestration-shape-and-multi-author-attribution-and-Update-482b40e2--synthesis-target-slot-machine.md)
- [§Tier-1 borrowing](garden--designs-driver-md--the-garden's-own-script-orchestrated-PR-creation-flow-design-and-claude-on-top-vs-claude-under-script-as-named-orchestration-shape-and-multi-author-attribution-and-Update-section-at-top--tier-1-borrowing.md)
- [§Tier-2 borrowing](garden--designs-driver-md--the-garden's-own-script-orchestrated-PR-creation-flow-design-and-claude-on-top-vs-claude-under-script-as-named-orchestration-shape-and-multi-author-attribution-and-Update-section-at-top--tier-2-borrowing.md)
- [§Tier-3 borrowing](garden--designs-driver-md--the-garden's-own-script-orchestrated-PR-creation-flow-design-and-claude-on-top-vs-claude-under-script-as-named-orchestration-shape-and-multi-author-attribution-and-Update-section-at-top--tier-3-borrowing.md)
- [Pattern summary (tag-prefixed)](garden--designs-driver-md--the-garden's-own-script-orchestrated-PR-creation-flow-design-and-claude-on-top-vs-claude-under-script-as-named-orchestration-shape-and-multi-author-attribution-and-Update-482b40e2--pattern-summary-tag-prefixed.md)
