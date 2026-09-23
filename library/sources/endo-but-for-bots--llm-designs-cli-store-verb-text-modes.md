---
title: "cli-store-verb-text-modes — Unified axis scheme on `endo store` replaces multiplied verbs"
source-slug: endo-but-for-bots--llm-designs-cli-store-verb-text-modes
url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/cli-store-verb-text-modes.md
authors: [Kris Kowal (prompted)]
repo: endojs/endo-but-for-bots
path: designs/cli-store-verb-text-modes.md
total-lines: 446
status: Proposed (2026-05-08)
ingest-cycle: 240
ingest-date: 2026-06-08
lane: designs
---

# cli-store-verb-text-modes.md

A 446-line **Proposed** design that reshapes the `endo store` verb family around three orthogonal axes (source/sink, representation, where-it-lives-in-the-formula-graph), subsuming PR #128's `endo write-text` / `endo read-text` into representation flags. §Reshape-blocker-for-PR-#128 as named relationship type.

## Key design moves

- **§Reshape-blocker-for-PR** as new named relationship type — thirtieth honest-design-evolution-record family member; fourteenth-different-shape in 2026-06 cluster.
- **§The-third-axis-was-introduced-without-naming** — when an axis is introduced without naming, the fix is to name the axis not to add more verbs.
- **§Three-orthogonal-axes mixed in existing verbs** as the load-bearing observation.
- **§Survey-table-of-existing-verbs** as the baseline against which the reshape is measured.
- **§Mutual-exclusion-of-flag-groups** names the axes.
- **§Same-flag-for-read-and-write** (`-p <file>`) — symmetry by verb pair, not by flag prefix.
- **§No-encoding-flag** — the daemon does not negotiate codecs; UTF-8 only, invalid input rejected at the CLI boundary.
- **§Blobs-are-bytes** as load-bearing maxim attributed to a specific PR review comment.
- **§No-content-type-on-blobs** — out-of-band metadata stays out of band; three named locations (pet-name + consumer-expectation + sibling-formula).
- **§Two-different-API-shapes-for-two-different-substrates** (formula-creation `endo store` + mount-mutation `endo write`).
- **§Alt-3-as-state-dependent-dispatch-anti-pattern** — when a verb's effect depends on implicit state, the script cannot defend against the state changing.
- **§Internal-consistency-test-as-design-discipline** — the argument that justifies the reshape must apply to the symmetric decisions inside it.
- **§Reserved-future-siblings** (`edit`, `patch`) with explicit non-prejudgment of sibling shape.
- **§Sibling-design** with §PR-stacking-discipline named explicitly (PR #153 lands first, #162 on top).
- **§Three-named-things-per-deferral** (feature + trigger + cost).
- **§Decisions-section-quotes-the-maintainer-review-verbatim**.
- **§Subsumes-old-verb annotations** in canonical-form examples — the reader sees which old verb each line replaces.

## Section files

- [§unified-axis-scheme-replaces-multiplied-verbs + §reshape-blocker-for-PR + §blobs-are-bytes + §three-orthogonal-axes + §same-flag-for-read-and-write](../sections/endo-but-for-bots--llm-designs-cli-store-verb-text-modes--unified-axis-scheme-replaces-multiplied-verbs-and-reshape-blocker-for-PR-and-blobs-are-bytes-and-three-orthogonal-axes-and-same-flag-for-read-and-write.md) — full 446-line design ingest.

## Ingest scope

Cycle 240 (designs-lane): full 446-line ingest. §First-explicit-observation of four patterns: §PR-stacking-discipline-named-explicitly + §three-named-things-per-deferral + §state-dependent-dispatch-anti-pattern-named-as-such + §Subsumes-old-verb-annotations-in-canonical-form-examples.
