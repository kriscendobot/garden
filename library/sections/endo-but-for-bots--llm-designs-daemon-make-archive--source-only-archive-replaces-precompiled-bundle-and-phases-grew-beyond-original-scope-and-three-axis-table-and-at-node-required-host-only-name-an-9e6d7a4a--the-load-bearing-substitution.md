---
title: "§The-load-bearing-substitution: source-only-archive replaces precompiled-bundle"
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

§Three-named-problems with the old `makeBundle` format:

1. §Bundles-are-JSON-wrapped-binary that has to be decoded and re-parsed before execution.
2. §Precompiled-module-formats-carry-Babel-compiled-functor-source — §significantly-larger + §cannot-be-re-shared-with-workers-that-lack-the-precompile-parsers.
3. §Rust-workers-cannot-read-a-base-64-JSON-wrapper-out-of-band + §cannot-reuse-the-CAS for module sources.

§The-replacement `makeArchive`:

1. §Takes-a-readable-blob-reference-to-a-ZIP-file containing `compartment-map.json` + modules in §source-formats (no precompiled).
2. §Lets-Node.js-workers-compile-each-module-at-runtime via `@endo/module-source`.
3. §Lets-Rust-workers-read-the-content-directly-from-the-CAS + §run-in-process.
4. §Removes-`makeBundle`-entirely — §replaces-every-`-b`/`--bundle`-CLI-option-with-`-z`/`--archive`.

§Borrowable-pattern: §when-a-format-has-three-named-problems-that-the-replacement-eliminates, §enumerate-them + §enumerate-the-replacement's-four-named-properties + §the-substitution-is-defined-by-the-three-eliminations + §the-four-additions. §Sibling to cycle 230 endor-npm-registry-proxy's §enumerate-the-existing-substrate's-prerequisites-and-eliminate-each-one. §Two-cycles-with-this-shape now.
