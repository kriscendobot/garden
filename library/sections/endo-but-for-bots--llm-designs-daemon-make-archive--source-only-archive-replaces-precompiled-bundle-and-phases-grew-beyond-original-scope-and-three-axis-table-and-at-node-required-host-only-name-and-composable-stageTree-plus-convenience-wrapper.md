---
title: "daemon-make-archive — §source-only-archive-replaces-precompiled-bundle + §Phases-1-5-complete-then-6-7-8-added-with-status-back-to-In-Progress + §three-axis-table-Method-by-Source-by-Confinement + §@node-required-host-only-special-name + §makeFromTree-and-makeUnconfinedFromTree + §composable-stageTree-plus-convenience-wrapper + §naming-by-source-shape-not-by-product + §nine-Design-Decisions + §fourth-Prompt-section-instance-with-Follow-on-prompt"
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
kind: index
section_count: 24
---

Sections:

- [daemon-make-archive — Source-only archives replace precompiled bundles; phases grew beyond original scope](endo-but-for-bots--llm-designs-daemon-make-archive--source-only-archive-replaces-precompiled-bundle-and-phases-grew-beyond-original-scope-and-three-axis-table-and-at-node-required-host-only-name-a-9e6d7a4a--daemon-make-archive-source-onl.md)
- [§Twenty-eighth-honest-design-evolution-record family member with a new shape: §Phases-grew-beyond-original-scope-and-Status-flipped-back-to-In-Progress](endo-but-for-bots--llm-designs-daemon-make-archive--source-only-archive-replaces-precompiled-bundle-and-phases-grew-beyond-original-scope-and-three-axis-table-and-at-node-required-host-only-name-a-9e6d7a4a--twenty-eighth-honest-design-ev.md)
- [§The-load-bearing-substitution: source-only-archive replaces precompiled-bundle](endo-but-for-bots--llm-designs-daemon-make-archive--source-only-archive-replaces-precompiled-bundle-and-phases-grew-beyond-original-scope-and-three-axis-table-and-at-node-required-host-only-name-an-9e6d7a4a--the-load-bearing-substitution.md)
- [§The-three-axis-table (Method × Source × Confinement)](endo-but-for-bots--llm-designs-daemon-make-archive--source-only-archive-replaces-precompiled-bundle-and-phases-grew-beyond-original-scope-and-three-axis-table-and-at-node-required-host-only-name-a-9e6d7a4a--the-three-axis-table-method-so.md)
- [§`@node` as §required-host-only-special-name](endo-but-for-bots--llm-designs-daemon-make-archive--source-only-archive-replaces-precompiled-bundle-and-phases-grew-beyond-original-scope-and-three-axis-table-and-at-node-required-host-only-name-a-9e6d7a4a--node-as-required-host-only-spe.md)
- [§Naming-by-source-shape-not-by-product](endo-but-for-bots--llm-designs-daemon-make-archive--source-only-archive-replaces-precompiled-bundle-and-phases-grew-beyond-original-scope-and-three-axis-table-and-at-node-required-host-only-name-an-9e6d7a4a--naming-by-source-shape-not-by.md)
- [§Composable-alternative: §stageTree-as-public-primitive + §makeUnconfinedFromTree-as-convenience-wrapper](endo-but-for-bots--llm-designs-daemon-make-archive--source-only-archive-replaces-precompiled-bundle-and-phases-grew-beyond-original-scope-and-three-axis-table-and-at-node-required-host-only-name-a-9e6d7a4a--composable-alternative-stagetr.md)
- [§thisDiesIfThatDies — §lifetime-linkage discipline](endo-but-for-bots--llm-designs-daemon-make-archive--source-only-archive-replaces-precompiled-bundle-and-phases-grew-beyond-original-scope-and-three-axis-table-and-at-node-required-host-only-name-a-9e6d7a4a--thisdiesifthatdies-lifetime-li.md)
- [§Source-only-contract-preserved-via-parser-map-omits-precompiled-parsers](endo-but-for-bots--llm-designs-daemon-make-archive--source-only-archive-replaces-precompiled-bundle-and-phases-grew-beyond-original-scope-and-three-axis-table-and-at-node-required-host-only-name-a-9e6d7a4a--source-only-contract-preserved.md)
- [§The-legacy-Node.js-bridge stays open indefinitely](endo-but-for-bots--llm-designs-daemon-make-archive--source-only-archive-replaces-precompiled-bundle-and-phases-grew-beyond-original-scope-and-three-axis-table-and-at-node-required-host-only-name-a-9e6d7a4a--the-legacy-node-js-bridge-stay.md)
- [§Nine-Design-Decisions](endo-but-for-bots--llm-designs-daemon-make-archive--source-only-archive-replaces-precompiled-bundle-and-phases-grew-beyond-original-scope-and-three-axis-table-and-at-node-required-host-only-name-and-compos-9e6d7a4a--nine-design-decisions.md)
- [§Dependencies-table-with-Relationship-column](endo-but-for-bots--llm-designs-daemon-make-archive--source-only-archive-replaces-precompiled-bundle-and-phases-grew-beyond-original-scope-and-three-axis-table-and-at-node-required-host-only-name-a-9e6d7a4a--dependencies-table-with-relati.md)
- [§Known-Gaps-and-TODOs section](endo-but-for-bots--llm-designs-daemon-make-archive--source-only-archive-replaces-precompiled-bundle-and-phases-grew-beyond-original-scope-and-three-axis-table-and-at-node-required-host-only-name-and-9e6d7a4a--known-gaps-and-todos-section.md)
- [§Fourth-Prompt-section-instance with §Follow-on-prompt](endo-but-for-bots--llm-designs-daemon-make-archive--source-only-archive-replaces-precompiled-bundle-and-phases-grew-beyond-original-scope-and-three-axis-table-and-at-node-required-host-only-name-a-9e6d7a4a--fourth-prompt-section-instance.md)
- [§Open-optimisation-tracked-as-follow-up](endo-but-for-bots--llm-designs-daemon-make-archive--source-only-archive-replaces-precompiled-bundle-and-phases-grew-beyond-original-scope-and-three-axis-table-and-at-node-required-host-only-name-a-9e6d7a4a--open-optimisation-tracked-as-f.md)
- [§The-four-buckets section](endo-but-for-bots--llm-designs-daemon-make-archive--source-only-archive-replaces-precompiled-bundle-and-phases-grew-beyond-original-scope-and-three-axis-table-and-at-node-required-host-only-name-and-com-9e6d7a4a--the-four-buckets-section.md)
- [§The-no-on-the-wire-format-change-needed observation](endo-but-for-bots--llm-designs-daemon-make-archive--source-only-archive-replaces-precompiled-bundle-and-phases-grew-beyond-original-scope-and-three-axis-table-and-at-node-required-host-only-name-a-9e6d7a4a--the-no-on-the-wire-format-chan.md)
- [Related material in the library](endo-but-for-bots--llm-designs-daemon-make-archive--source-only-archive-replaces-precompiled-bundle-and-phases-grew-beyond-original-scope-and-three-axis-table-and-at-node-required-host-only-name-a-9e6d7a4a--related-material-in-the-librar.md)
- [§Twelve-different-shapes-of-design-evolution-record in 2026-06 cluster](endo-but-for-bots--llm-designs-daemon-make-archive--source-only-archive-replaces-precompiled-bundle-and-phases-grew-beyond-original-scope-and-three-axis-table-and-at-node-required-host-only-name-a-9e6d7a4a--twelve-different-shapes-of-des.md)
- [§Four-cycles-with-Prompt-section-captured + §first-Follow-on-prompt](endo-but-for-bots--llm-designs-daemon-make-archive--source-only-archive-replaces-precompiled-bundle-and-phases-grew-beyond-original-scope-and-three-axis-table-and-at-node-required-host-only-name-a-9e6d7a4a--four-cycles-with-prompt-sectio.md)
- [§Three-cycles-with-Dependencies-table-with-Relationship-column](endo-but-for-bots--llm-designs-daemon-make-archive--source-only-archive-replaces-precompiled-bundle-and-phases-grew-beyond-original-scope-and-three-axis-table-and-at-node-required-host-only-name-a-9e6d7a4a--three-cycles-with-dependencies.md)
- [§Four-cycles-on-strict-by-default-with-opt-in-extension](endo-but-for-bots--llm-designs-daemon-make-archive--source-only-archive-replaces-precompiled-bundle-and-phases-grew-beyond-original-scope-and-three-axis-table-and-at-node-required-host-only-name-a-9e6d7a4a--four-cycles-on-strict-by-defau.md)
- [§Five-cycles-on-no-new-abstractions discipline](endo-but-for-bots--llm-designs-daemon-make-archive--source-only-archive-replaces-precompiled-bundle-and-phases-grew-beyond-original-scope-and-three-axis-table-and-at-node-required-host-only-name-a-9e6d7a4a--five-cycles-on-no-new-abstract.md)
- [§Three-cycles-with-explicit-flow-and-convenience-wrapper](endo-but-for-bots--llm-designs-daemon-make-archive--source-only-archive-replaces-precompiled-bundle-and-phases-grew-beyond-original-scope-and-three-axis-table-and-at-node-required-host-only-name-a-9e6d7a4a--three-cycles-with-explicit-flo.md)
