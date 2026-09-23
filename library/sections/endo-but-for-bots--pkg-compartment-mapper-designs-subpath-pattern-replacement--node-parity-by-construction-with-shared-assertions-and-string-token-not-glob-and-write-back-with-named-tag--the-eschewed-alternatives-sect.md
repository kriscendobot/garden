---
title: §the-Eschewed-Alternatives-section-with-named-rejected-shapes (first-explicit-observation)
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

The design names **two eschewed alternatives** with rejection rationale:

1. **Per-segment matching via prefix tree** — "An earlier approach split specifiers on `/` and matched `*` within a single path segment using a prefix tree. This did not match Node.js semantics, where `*` spans `/` boundaries. Prefix/suffix string matching on the full specifier is simpler and correct."
2. **Array fallback values** — "Node.js allows array values in exports as fallback lists... Pattern resolution in the compartment-mapper is a pure string operation with no filesystem access. Array fallbacks would require threading read powers through the pattern matcher and changing the `SubpathReplacer` signature. Node.js documentation discourages array fallbacks."

**§the-`Eschewed Alternatives`-section-name as named-design-doc-shape** (first-explicit-observation): a section that names what was *considered and rejected*. Compare cycle 283's §three-named-rejected-alternatives-with-reasons (loopback TCP + kernel credential check; cryptographic attestation) — but cycle 283 called these "alternatives... considered and rejected" inline; cycle 287 elevates them to a named section. **§two-cycles-with-named-rejected-alternatives-shape** (283 inline + 287 dedicated section).

§the-rejected-shapes-IS-named-design-content not just-omission. The design teaches the reader *what was tried first and why it was insufficient*.
