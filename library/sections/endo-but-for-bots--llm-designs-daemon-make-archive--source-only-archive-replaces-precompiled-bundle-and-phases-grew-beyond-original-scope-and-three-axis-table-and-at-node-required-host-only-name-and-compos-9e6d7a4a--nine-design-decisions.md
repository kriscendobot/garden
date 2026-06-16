---
title: §Nine-Design-Decisions
source-slug: endo-but-for-bots--llm-designs-daemon-make-archive
section-id: source-only-archive-replaces-precompiled-bundle-and-phases-grew-beyond-original-scope-and-three-axis-table-and-at-node-required-host-only-name-and-composable-stageTree-plus-convenience-wrapper
url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/daemon-make-archive.md
authors: [Kris Kowal (prompted)]
repo: endojs/endo-but-for-bots
path: designs/daemon-make-archive.md
total-lines: 813
status: In Progress (2026-04-23 → 2026-04-24; Phases 1-5 complete; Phases 6-7-8 added)
ingest-cycle: 236
ingest-date: 2026-06-08
lane: designs
parent: endo-but-for-bots--llm-designs-daemon-make-archive--source-only-archive-replaces-precompiled-bundle-and-phases-grew-beyond-original-scope-and-three-axis-table-and-at-node-required-host-only-name-and-composable-stageTree-plus-convenience-wrapper
---

The design has §a-numbered-Design-Decisions-section with §nine-named-decisions each with §a-paragraph-of-rationale. §Borrowable-pattern: §when-the-design-has-many-trade-off-decisions, §collect-them-in-a-Design-Decisions-section-with-numbered-bullets + §each-bullet-has-its-own-rationale-paragraph.

§Sibling to cycle 230 endor-npm-registry-proxy's §Five-Design-decisions-with-named-rationale-per-decision. §Two-cycles-with-numbered-Design-Decisions; §cycle-230-has-five + §cycle-236-has-nine — §the-bigger-design-has-more-decisions-explicitly-numbered.

The decisions span:
1. §Same-readable-blob-storage (reuse not introduce).
2. §Compartment-mapper's-parseArchive-on-Node (reuse canonical loader).
3. §Source-only-contract-on-both-workers.
4. §Remove-rather-than-deprecate (user authorized purge).
5. §XS-workers-do-not-implement-makeUnconfined (explicit-not-papered-over).
6. §`@node`-is-a-host-only-special-name.
7. §`makeFromTree`-unifies-the-archive-and-tree-paths.
8. §The-legacy-Node.js-bridge-stays-open-indefinitely.
9. §`@node`-is-a-required-host-dependency-not-optional.
