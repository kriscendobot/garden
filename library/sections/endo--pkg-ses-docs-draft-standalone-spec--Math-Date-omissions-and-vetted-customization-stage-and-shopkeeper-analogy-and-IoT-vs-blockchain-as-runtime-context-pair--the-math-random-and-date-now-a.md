---
title: §the-Math.random-and-Date.now-as-named-sources-of-non-determinism (first-explicit-observation)
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

> "Math.random() throws a TypeError rather than provide a random number, which would be a source of non-determinism."
> "Date.now() throws a TypeError rather than returning the millisecods representing the current time."

**§two-named-sources-of-non-determinism in the JS standard library**: random + clock. **§the-non-determinism-IS-the-named-property-being-defended-against**. In a deterministically-replicated computation, *both* must be blocked for the computation to converge across replicas.

§the-non-determinism-IS-the-named-attack-vector-for-replicated-computation. Sibling-pattern to capability theory's *ambient authority* — the random and clock are *ambient* sources of variability.
