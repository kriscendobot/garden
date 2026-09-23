---
title: §The-no-new-abstractions discipline
source-slug: endo-but-for-bots--llm-designs-endoclaw-skill-registry
section-id: no-new-abstractions-and-capability-declaration-via-directory-structure-and-decentralized-by-default-and-federation-by-reference
url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/endoclaw-skill-registry.md
authors: [Kris Kowal (prompted)]
repo: endojs/endo-but-for-bots
path: designs/endoclaw-skill-registry.md
total-lines: 252
status: Not Started
ingest-cycle: 222
ingest-date: 2026-06-08
lane: designs
parent: endo-but-for-bots--llm-designs-endoclaw-skill-registry--no-new-abstractions-and-capability-declaration-via-directory-structure-and-decentralized-by-default-and-federation-by-reference
---

The §Endo-Idiom section opens with the load-bearing principle:

> **No new abstractions.** The registry is an EndoDirectory. Skill descriptors are EndoDirectories. Metadata entries are string values stored via `write`. Everything uses the existing pet-name storage system — `list`, `lookup`, `write`, `followNameChanges`.

§The-three-recursive-levels: registry = directory + descriptors = directories + metadata = string values. §Borrowable-pattern: §when-a-feature-could-be-its-own-system, §see-if-it-fits-inside-an-existing-primitive-instead. §The-design-rejects-inventing-a-skill-format + §reuses-the-pet-name-storage-shape.

§Three-cycles-with-no-new-abstractions discipline now in library:
- Cycle 211 @endo/common (§tree-shaking-friendly via §one-file-per-export — no new build system, just convention).
- Cycle 214 lal-reply-chain-transcripts (§no-daemon-changes-required — leverages existing API).
- Cycle 222 endoclaw-skill-registry (§the-registry-IS-the-directory).

§Three-different-substrates-where-the-discipline-applies (package shape / agent loop / capability storage). §The-discipline-is-the-same-across-substrates.
