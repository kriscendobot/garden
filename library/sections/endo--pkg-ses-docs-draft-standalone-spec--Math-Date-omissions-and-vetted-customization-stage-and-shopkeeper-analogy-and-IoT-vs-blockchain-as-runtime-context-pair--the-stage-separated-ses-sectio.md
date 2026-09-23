---
title: "§the-`## Stage Separated SES`-section-IS-named-distinct-from-standalone-SES (first-explicit-observation)"
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

> "Full SES, as embedded into EcmaScript, supports running vetted customization code in a freezable realm prior to freezing it into a SES realm."

**§the-named-distinction-between-full-SES-and-standalone-SES + the-named-distinction-between-stage-separated-SES-and-the-frozen-SES-environment**. **§three-named-SES-variants** in the doc:

1. **Full SES** (browser/Node; shim-based; multi-root-realm).
2. **Standalone SES** (IoT/blockchain; bespoke engine; possibly no evaluators).
3. **Stage-separated SES** (the pre-freeze-then-freeze pattern within either).

§the-named-multi-variant-discipline: the spec doesn't describe ONE SES; it names ITS VARIANTS and how they relate.
