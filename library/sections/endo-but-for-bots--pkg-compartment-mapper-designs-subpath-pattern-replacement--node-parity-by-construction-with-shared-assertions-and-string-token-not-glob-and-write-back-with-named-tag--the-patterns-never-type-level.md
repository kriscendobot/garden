---
title: "§the-`patterns: never` type-level enforcement (first-explicit-observation)"
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

> "Patterns are removed from the compartment map during archiving. ... Type-level enforcement: `DigestedCompartmentDescriptor` has `patterns: never`."

**§the-`never`-type-as-named-compile-time-guarantee** (first-explicit-observation): the archived shape's type definition explicitly forbids the `patterns` field at the type level. **The TypeScript `never` type IS the named compile-time bouncer** that prevents the field from existing in the archived shape.

§the-type-system-enforces-the-archival-discipline: if someone later accidentally adds `patterns: somethingElse` to a `DigestedCompartmentDescriptor`, the compile fails. The type IS the spec.
