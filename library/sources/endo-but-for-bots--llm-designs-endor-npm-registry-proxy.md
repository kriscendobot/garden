---
title: "endor-npm-registry-proxy — Go-style Minimal Version Selection + CAS plus registry table replacing node_modules"
source-slug: endo-but-for-bots--llm-designs-endor-npm-registry-proxy
url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/endor-npm-registry-proxy.md
authors: [Kris Kowal (prompted)]
repo: endojs/endo-but-for-bots
path: designs/endor-npm-registry-proxy.md
total-lines: 406
status: In Progress (Phases 1 and 3 implemented; Phases 2, 4, 5 remaining; 2026-04-17)
ingest-cycle: 230
ingest-date: 2026-06-08
lane: designs
---

# endor-npm-registry-proxy.md

A 406-line **In Progress** design. The CAS-plus-registry-table substitute for `node_modules`. `endor run entry.js` resolves, fetches, and executes npm packages without `npm` CLI, without `node_modules`, and without `package-lock.json`.

## Key design moves

- **§Status-with-Phases-implemented-vs-remaining-by-name** — Phase 1 + Phase 3 implemented with file paths; Phase 2/4/5 remaining with one-line summaries. New design-evolution-record shape.
- **§The-load-bearing-substitution** — enumerate the existing substrate's prerequisites and eliminate each one.
- **§Architecture-overview-ASCII-diagram** showing three named components + shared CAS storage.
- **§Two-table-SQLite-schema** (packages + package_meta) with §two-different-cache-grains.
- **§Go-style-Minimal-Version-Selection** (MVS) — §pick-the-version-that-was-explicitly-required + §avoid-untested-upgrades.
- **§Four-step-algorithm** (collect → group + greatest-mentioned-minor → co-versioned workspaces → resolve transitively).
- **§Comparison-with-Go's-MVS table** — §five-aspects-named-side-by-side.
- **§Six-step-package-fetching-pipeline** (metadata → select → tarball → integrity → CAS-extract → registry-update).
- **§Six-step-integration-with-`endor run`** for bare-specifier resolution.
- **§Offline-mode + §registry-table-as-implicit-lock-file**.
- **§CAS-tree-structure** with §three-named-fields-per-entry; §automatic-deduplication-at-blob-level.
- **§Five-Design-decisions** with §named-rationale-per-decision.
- **§Five-Known-gaps** section with checkboxes + §intentionally-omitted-pre/post-install-scripts.
- **§Configuration-via-env-var-and-.endorrc** + §honor-npm's-.npmrc-token-format.
- **§Five-Implementation-Phases** each with §named-test-per-phase.
- **§The-Prompt-section** (third cycle with Prompt-section-captured: 198 + 224 + 230); §a-design-doc-as-a-design-reminder.

## Section files

- [§Go-style-MVS + §CAS-plus-registry-table-replaces-node_modules + §five-Implementation-Phases + §five-Design-decisions + §three-cycles-with-Prompt-section](../sections/endo-but-for-bots--llm-designs-endor-npm-registry-proxy--Go-style-MVS-and-CAS-plus-registry-table-replaces-node_modules-and-five-Implementation-Phases-and-five-Design-decisions-and-three-cycles-with-Prompt-section.md) — full design ingest.

## Ingest scope

Cycle 230 (designs-lane): full 406-line ingest. §Ten-different-shapes-of-design-evolution-record in 2026-06 cluster now (cycle 230 adds the tenth: §phases-by-number-with-implementation-files-and-remaining-one-line-purposes).
