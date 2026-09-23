---
title: §Source-only-contract-preserved-via-parser-map-omits-precompiled-parsers
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

> On the Node side the `parserForLanguage` map we hand to `parseArchive` simply omits the precompiled parsers, so attempting to import a precompiled module surfaces a clean "unknown language" error from compartment-mapper. On the Rust side, [...] no precompiled-parser code lives in the Rust worker at all.

§Borrowable-pattern: §enforce-a-source-only-contract-by-omitting-the-precompiled-parsers-from-the-parser-map + §the-error-emerges-from-the-existing-machinery-not-a-new-check. §The-absence-of-code-IS-the-enforcement.

§Sibling to cycle 231 @endo/marshal/encodeToCapData's §dont-encode-defaults-that-throw (strict-by-default with opt-in extension). §Cycle-236-is-strict-by-omission-of-the-parser; §cycle-231-is-strict-by-default-that-throws.

§Four-cycles-on-strict-by-default-with-opt-in-extension now (cycles 226 + 230 + 231 + 236).
