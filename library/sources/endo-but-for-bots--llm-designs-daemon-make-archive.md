---
title: "daemon-make-archive — Source-only archives replace precompiled bundles; phases grew beyond original scope"
source-slug: endo-but-for-bots--llm-designs-daemon-make-archive
url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/daemon-make-archive.md
authors: [Kris Kowal (prompted)]
repo: endojs/endo-but-for-bots
path: designs/daemon-make-archive.md
total-lines: 813
status: In Progress (2026-04-23 → 2026-04-24; Phases 1-5 complete; Phases 6-7-8 added; Status flipped back to In Progress)
ingest-cycle: 236
ingest-date: 2026-06-08
lane: designs
---

# daemon-make-archive.md

An 813-line **In Progress** design. §The-original-scope-was-Phases-1-5-replacing-makeBundle-with-makeArchive. §After-completion-Phases-6-7-8-were-added (§the-Status-flipped-back-to-In-Progress) for §`@node`-host-only-special-name + §`makeFromTree` + §`makeUnconfinedFromTree`.

## Key design moves

- **§Phases-grew-beyond-original-scope-and-Status-flipped-back-to-In-Progress** — new design-evolution-record shape (twenty-eighth member; twelfth-different-shape in 2026-06 cluster).
- **§Source-only-archive-replaces-precompiled-bundle** — §three-named-problems-with-old-format + §four-named-properties-of-replacement.
- **§Three-axis-table** (Method × Source × Confinement) producing §four-shapes-of-make.
- **§@node as required-host-only-special-name** with §three-properties (required + host-only + XS-rejects-makeUnconfined-with-redirect-message).
- **§State-purge-as-acceptable-design-cost** (no migration path; all users purge state for Phase 6).
- **§Naming-by-source-shape-not-by-product** (`makeFromTree` not `makeCaplet`).
- **§Composable-alternative**: §stageTree-as-public-primitive + §makeUnconfinedFromTree-as-convenience-wrapper.
- **§thisDiesIfThatDies** as named lifetime-linkage mechanism for scratch directory.
- **§Source-only-contract-preserved-via-parser-map-omits-precompiled-parsers** — §the-absence-of-code-IS-the-enforcement.
- **§The-legacy-Node.js-bridge-stays-open-indefinitely** with §goal-is-to-make-rarely-necessary-not-to-remove.
- **§Nine-Design-Decisions** with named rationale per decision.
- **§Four-buckets** classify every caplet source (preferred + two legacy bridges + ad-hoc eval).
- **§Open-optimisation-tracked-as-follow-up-not-required-for-correctness**.
- **§Fourth-Prompt-section-instance with §Follow-on-prompt** (first cycle with two prompts).

## Section files

- [§source-only-archive-replaces-precompiled-bundle + §phases-grew-beyond-original-scope + §three-axis-table + §@node-required-host-only-name + §composable-stageTree-plus-convenience-wrapper](../sections/endo-but-for-bots--llm-designs-daemon-make-archive--source-only-archive-replaces-precompiled-bundle-and-phases-grew-beyond-original-scope-and-three-axis-table-and-at-node-required-host-only-name-and-composable-stageTree-plus-convenience-wrapper.md) — full design ingest.

## Ingest scope

Cycle 236 (designs-lane): full 813-line ingest. §Twelfth-different-shape-of-design-evolution-record in 2026-06 cluster (cycles 214 + 216 + 218 + 220 + 222 + 224 + 226 + 227 + 228 + 230 + 232 + 236). §First-cycle-with-a-Follow-on-prompt-section.
