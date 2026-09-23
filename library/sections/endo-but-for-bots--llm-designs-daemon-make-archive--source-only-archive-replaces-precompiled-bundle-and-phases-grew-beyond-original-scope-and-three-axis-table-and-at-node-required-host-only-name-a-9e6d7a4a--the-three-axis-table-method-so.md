---
title: §The-three-axis-table (Method × Source × Confinement)
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

§The-novel-architectural-table introduced in the 2026-04-24 revision:

| Method | Source | Confinement |
|---|---|---|
| `makeArchive` | ZIP blob pet name | Compartmentalised (any worker) |
| `makeFromTree` | Readable tree or mount pet name | Compartmentalised (any worker) |
| `makeUnconfined` | Filesystem path string | Unconfined (Node only) |
| `makeUnconfinedFromTree` | Readable tree or mount pet name → scratch | Unconfined (Node only) |

§Four-shapes-of-make-distinguished-by-source-and-confinement. §The-table-IS-the-design-language. §Two-axes-(source × confinement) generate §a-2x2-naming-scheme with §source-as-the-naming-suffix (Archive / FromTree / Unconfined / UnconfinedFromTree).

§Borrowable-pattern: §when-a-design-has-multiple-related-methods, §name-them-by-the-axes-that-distinguish-them + §a-two-by-two-table-IS-the-naming-rationale. §Cycle 236 explicitly says §every-`make*`-already-returns-a-caplet-so-the-naming-axis-IS-the-distinguishing-axis-not-the-product-name.

§Sibling to cycle 222 endoclaw-skill-registry's §three-recursive-EndoDirectory-levels-with-uniform-shape + cycle 226 endoclaw-cluster's §two-facet-control-pair canonical-shape — but cycle 236 is §a-2x2-method-naming-table not §a-uniform-pattern-applied-recursively.
