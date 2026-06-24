---
title: §the-`*`-IS-a-string-replacement-token-not-a-glob (first-explicit-observation)
section-slug: endo-but-for-bots--pkg-compartment-mapper-designs-subpath-pattern-replacement--node-parity-by-construction-with-shared-assertions-and-string-token-not-glob-and-write-back-with-named-tag
source-slug: endo-but-for-bots--pkg-compartment-mapper-designs-subpath-pattern-replacement
url: https://github.com/endojs/endo-but-for-bots/blob/master/packages/compartment-mapper/designs/subpath-pattern-replacement.md
authors: [Endo project (collective)]
status: (no explicit metadata table)
ingest-cycle: 287
ingest-date: 2026-06-10
lane: designs
scope: full
total-lines: 271
parent: endo-but-for-bots--pkg-compartment-mapper-designs-subpath-pattern-replacement--node-parity-by-construction-with-shared-assertions-and-string-token-not-glob-and-write-back-with-named-tag
---

> "In Node.js, the `*` wildcard in subpath patterns is a **string replacement token**, not a glob. All instances of `*` on the right side of a pattern are replaced with the text matched by `*` on the left side. `*` **matches across `/` separators** — it is not limited to a single path segment."

**§the-named-pejorative-of-mistaken-mental-model**: the design pre-empts the reader's likely-incorrect mental model ("`*` is glob-like and bounded by path-separators") by *explicitly naming* the correct semantics with bolded emphasis. **§the-named-counter-intuitive-semantic IS the spec's load-bearing claim** — most readers would assume globbiness; the design names the deviation upfront.

§the-defensively-bolded-counter-claim: bold formatting on the *not-this* claim, not the *is-this* claim. **`not a glob`** + **`matches across `/` separators`**. The design's bold formatting reflects the asymmetry between *what readers will assume* and *what is true*.
