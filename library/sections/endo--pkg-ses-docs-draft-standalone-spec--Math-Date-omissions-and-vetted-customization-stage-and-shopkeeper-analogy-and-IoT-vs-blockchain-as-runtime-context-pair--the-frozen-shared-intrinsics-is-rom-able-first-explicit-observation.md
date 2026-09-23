---
title: §the-frozen-shared-intrinsics-IS-ROM-able (first-explicit-observation)
section-slug: endo--pkg-ses-docs-draft-standalone-spec--Math-Date-omissions-and-vetted-customization-stage-and-shopkeeper-analogy-and-IoT-vs-blockchain-as-runtime-context-pair
source-slug: endo--pkg-ses-docs-draft-standalone-spec
url: https://github.com/endojs/endo/blob/master/packages/ses/docs/draft-standalone-spec.md
authors: [Mark S. Miller (et al.)]
repo: endojs/endo
path: packages/ses/docs/draft-standalone-spec.md
total-lines: 201
ingest-cycle: 291
ingest-date: 2026-06-11
lane: designs
scope: full
parent: endo--pkg-ses-docs-draft-standalone-spec--Math-Date-omissions-and-vetted-customization-stage-and-shopkeeper-analogy-and-IoT-vs-blockchain-as-runtime-context-pair
---

> "Freeze all shared intrinsics. With the above omissions, there is no hidden state or ambient authority among the shared intrinsics, so transitive freezing means that the shared intrinsics are immutable and rom-able."

**§the-named-ROM-ability-property**: the frozen intrinsics can be placed in read-only memory (ROM) because they reference no objects outside ROM. **§the-named-implementation-target-IS-microcontroller-memory-shape**. §the-spec-anticipates-the-bare-metal-deployment-target.

§the-ROM-able-IS-the-named-bytes-in-static-memory shape: a property only achievable when *all* mutable state is gone. The omissions list IS what makes this possible.
