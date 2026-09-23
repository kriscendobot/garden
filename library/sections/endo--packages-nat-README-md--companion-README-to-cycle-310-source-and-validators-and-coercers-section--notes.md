---
title: Notes
section-slug: endo--packages-nat-README-md--companion-README-to-cycle-310-source-and-validators-and-coercers-section
source-slug: endo--packages-nat-README-md
url: https://github.com/endojs/endo/blob/master/packages/nat/README.md
authors: [Endo project (Google Caja origin + Agoric maintainership; collective)]
repo: endojs/endo
path: packages/nat/README.md
total-lines: 116
ingest-cycle: 311
ingest-date: 2026-06-11
lane: designs
scope: full
parent: endo--packages-nat-README-md--companion-README-to-cycle-310-source-and-validators-and-coercers-section
---

- Cycle 311 IS the first cycle to ingest a README *immediately after* its sibling source file (cycle 310). Most prior packages had their READMEs ingested first; cycle 310-311 inverted the order (source first, then README). **§the-named-source-first-then-README-ingest-order**: extends the cluster's flexibility about ingestion order.
- The named-Validators-and-Coercers-section IS structurally rich: it names a precise terminology AND it names that some functions (`Nat`) don't fit cleanly into either category at all abstraction levels. The "interesting mixture" framing IS rare in API documentation; most APIs are classified as one or the other.
- The named-skippable-marker-discipline (explicit "A skippable detail" label) IS a pedagogical pattern worth borrowing: the README acknowledges that not every reader needs every detail.
- The named-iff-discipline (using "iff" for if-and-only-if in API documentation) IS unusual; most documentation uses just "if" even when both directions hold. The explicit "iff" signals mathematical precision.
- The named-Caja-origin acknowledges a deep chain: Google Caja (Mark Miller's first secure-JavaScript project) → @endo (Agoric's continuation) → garden library (this cycle). **§the-named-deep-historical-chain**.
