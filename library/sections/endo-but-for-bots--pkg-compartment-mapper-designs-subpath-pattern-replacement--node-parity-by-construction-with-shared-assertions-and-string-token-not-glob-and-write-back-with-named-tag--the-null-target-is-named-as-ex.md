---
title: §the-null-target-IS-named-as-explicit-exclusion-shape (first-explicit-observation)
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

> "Null-target patterns (`to: null`) match normally but return `{ result: null }` to signal exclusion."

**§the-null-target-IS-a-named-three-state-result-shape** (first-explicit-observation): matching can return `{ result: <string> }` (matched + replaced), `{ result: null }` (matched + excluded), or no-match. **Three named outcomes from one matcher**, not two. The null-target wraps the second outcome in a structured marker rather than collapsing to "no match".

§the-explicit-exclusion-IS-distinct-from-implicit-no-match shape: a successful match with a null-result *prevents* further fallback to scope descriptors; an absent match *would have* fallen through.
