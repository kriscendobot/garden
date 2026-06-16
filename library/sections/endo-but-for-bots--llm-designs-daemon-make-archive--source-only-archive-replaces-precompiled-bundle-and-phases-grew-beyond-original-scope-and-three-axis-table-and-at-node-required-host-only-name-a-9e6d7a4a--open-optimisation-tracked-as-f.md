---
title: §Open-optimisation-tracked-as-follow-up
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

> *Open optimisation:* the worker currently streams the archive through CapTP; for archives already in the CAS we could skip the stream and have the Rust worker fetch the SHA-256 directly from `cas_archive::load_archive_from_cas`. Tracked as a follow-up; not required for correctness.

§Borrowable-pattern: §when-the-design-has-an-optimization-not-required-for-correctness, §name-it-explicitly + §mark-it-as-follow-up + §mark-it-as-not-required-for-correctness. §The-design-document-IS-the-tracking-system for known optimizations.

§Sibling to cycle 220 familiar-localhttp-protocol's §Research-needed-section. §Different-shape — cycle 220 names verification gaps; cycle 236 names optimization opportunities.
