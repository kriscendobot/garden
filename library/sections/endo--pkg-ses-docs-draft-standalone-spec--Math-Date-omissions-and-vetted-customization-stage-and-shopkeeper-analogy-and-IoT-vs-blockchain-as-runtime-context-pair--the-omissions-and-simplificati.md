---
title: "§the-`## Omissions and Simplifications` section as named subtractive-spec discipline (first-explicit-observation)"
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

The largest section IS **`## Omissions and Simplifications`** — naming what's *removed* from full EcmaScript to get to standalone SES. **§the-subtractive-spec-discipline**: instead of describing the full spec from scratch, the doc references EcmaScript and names the *delta*. This is **§the-spec-as-named-delta-from-a-reference-spec**.

§named-omissions-list:
- All support for sloppy mode (the spec's syntactic shortcut)
- Everything outside ES2018 (except `BigInt`)
- `import()` and `import.meta` expressions
- Annex B (with named ses-permitted exceptions)
- `RegExp` static properties (global communications channel)
- `Math.random()` (source of non-determinism)
- `Date.now()`, `new Date()`, `Date(...)` (three named Date constructor variants all-blocked)
- `Intl` by default (internationalization APIs)
- Function constructors via `.constructor` (always throw)

**§nine-named-omissions** as the categorical-list of "what's not in standalone SES".
