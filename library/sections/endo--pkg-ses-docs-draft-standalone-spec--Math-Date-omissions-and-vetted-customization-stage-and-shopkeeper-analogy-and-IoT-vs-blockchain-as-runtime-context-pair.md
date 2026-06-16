---
title: "@endo/ses/docs/draft-standalone-spec.md — Draft SES spec for IoT and blockchain; ambient-authority-and-non-determinism omissions (Math.random + Date.now + Date constructor); vetted-customization-stage; shopkeeper analogy; build-time-vs-runtime mapping"
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
kind: index
section_count: 22
---

Sections:

- [`@endo/ses/docs/draft-standalone-spec.md` (full design)](endo--pkg-ses-docs-draft-standalone-spec--Math-Date-omissions-and-vetted-customization-stage-and-shopkeeper-analogy-and-IoT-vs-blockchain-as-runtime-context-pair--endo-ses-docs-draft-standalone-spec-md-full-design.md)
- [§the-"Draft Spec"-genre-as-named-tentativeness-marker (first-explicit-observation)](endo--pkg-ses-docs-draft-standalone-spec--Math-Date-omissions-and-vetted-customization-stage-and-shopkeeper-analogy-and-IoT-vs-blockchain-as-runtime-context-pair--the-draft-spec-genre-as-named.md)
- [§the-IoT-vs-blockchain-as-named-runtime-context-pair (first-explicit-observation)](endo--pkg-ses-docs-draft-standalone-spec--Math-Date-omissions-and-vetted-customization-stage-and-shopkeeper-analogy-and-IoT-vs-blockchain-as-runtime-context-pair--the-iot-vs-blockchain-as-named.md)
- [§the-shorthand-definition-disclaimer (first-explicit-observation)](endo--pkg-ses-docs-draft-standalone-spec--Math-Date-omissions-and-vetted-customization-stage-and-shopkeeper-analogy-and-IoT-vs-blockchain-as-runtime-context-pair--the-shorthand-definition-disclaimer-first-explicit-observation.md)
- [§the-`## Omissions and Simplifications` section as named subtractive-spec discipline (first-explicit-observation)](endo--pkg-ses-docs-draft-standalone-spec--Math-Date-omissions-and-vetted-customization-stage-and-shopkeeper-analogy-and-IoT-vs-blockchain-as-runtime-context-pair--the-omissions-and-simplificati.md)
- [§the-three-named-Date-constructor-variants-all-block (first-explicit-observation)](endo--pkg-ses-docs-draft-standalone-spec--Math-Date-omissions-and-vetted-customization-stage-and-shopkeeper-analogy-and-IoT-vs-blockchain-as-runtime-context-pair--the-three-named-date-construct.md)
- [§the-Math.random-and-Date.now-as-named-sources-of-non-determinism (first-explicit-observation)](endo--pkg-ses-docs-draft-standalone-spec--Math-Date-omissions-and-vetted-customization-stage-and-shopkeeper-analogy-and-IoT-vs-blockchain-as-runtime-context-pair--the-math-random-and-date-now-a.md)
- [§the-shared-globals-and-shared-intrinsics-named-definitions (first-explicit-observation)](endo--pkg-ses-docs-draft-standalone-spec--Math-Date-omissions-and-vetted-customization-stage-and-shopkeeper-analogy-and-IoT-vs-blockchain-as-runtime-context-pair--the-shared-globals-and-shared.md)
- [§the-`## Additions` section as named additive-spec discipline (first-explicit-observation)](endo--pkg-ses-docs-draft-standalone-spec--Math-Date-omissions-and-vetted-customization-stage-and-shopkeeper-analogy-and-IoT-vs-blockchain-as-runtime-context-pair--the-additions-section-as-named.md)
- [§the-vetted-customization-code-named-stage (first-explicit-observation)](endo--pkg-ses-docs-draft-standalone-spec--Math-Date-omissions-and-vetted-customization-stage-and-shopkeeper-analogy-and-IoT-vs-blockchain-as-runtime-context-pair--the-vetted-customization-code-named-stage-first-explicit-observation.md)
- [§the-shopkeeper-analogy as named-domain-shift discipline (first-explicit-observation)](endo--pkg-ses-docs-draft-standalone-spec--Math-Date-omissions-and-vetted-customization-stage-and-shopkeeper-analogy-and-IoT-vs-blockchain-as-runtime-context-pair--the-shopkeeper-analogy-as-name.md)
- [§the-build-time-vs-runtime-mapping (first-explicit-observation)](endo--pkg-ses-docs-draft-standalone-spec--Math-Date-omissions-and-vetted-customization-stage-and-shopkeeper-analogy-and-IoT-vs-blockchain-as-runtime-context-pair--the-build-time-vs-runtime-mapping-first-explicit-observation.md)
- [§the-frozen-shared-intrinsics-IS-ROM-able (first-explicit-observation)](endo--pkg-ses-docs-draft-standalone-spec--Math-Date-omissions-and-vetted-customization-stage-and-shopkeeper-analogy-and-IoT-vs-blockchain-as-runtime-context-pair--the-frozen-shared-intrinsics-is-rom-able-first-explicit-observation.md)
- [§the-`Function !== Function.prototype.constructor`-invariant (first-explicit-observation)](endo--pkg-ses-docs-draft-standalone-spec--Math-Date-omissions-and-vetted-customization-stage-and-shopkeeper-analogy-and-IoT-vs-blockchain-as-runtime-context-pair--the-function-function-prototyp.md)
- [§the-`TBD:` section as named-open-questions discipline (first-explicit-observation)](endo--pkg-ses-docs-draft-standalone-spec--Math-Date-omissions-and-vetted-customization-stage-and-shopkeeper-analogy-and-IoT-vs-blockchain-as-runtime-context-pair--the-tbd-section-as-named-open.md)
- [§the-`## Work in Progress` section as named-deferred-topic-marker (first-explicit-observation)](endo--pkg-ses-docs-draft-standalone-spec--Math-Date-omissions-and-vetted-customization-stage-and-shopkeeper-analogy-and-IoT-vs-blockchain-as-runtime-context-pair--the-work-in-progress-section-a.md)
- [§the-`## Stage Separated SES`-section-IS-named-distinct-from-standalone-SES (first-explicit-observation)](endo--pkg-ses-docs-draft-standalone-spec--Math-Date-omissions-and-vetted-customization-stage-and-shopkeeper-analogy-and-IoT-vs-blockchain-as-runtime-context-pair--the-stage-separated-ses-sectio.md)
- [§the-direct-eval-syntax-low-priority-named-omission (first-explicit-observation)](endo--pkg-ses-docs-draft-standalone-spec--Math-Date-omissions-and-vetted-customization-stage-and-shopkeeper-analogy-and-IoT-vs-blockchain-as-runtime-context-pair--the-direct-eval-syntax-low-pri.md)
- [Patterns from prior cycles, reaffirmed](endo--pkg-ses-docs-draft-standalone-spec--Math-Date-omissions-and-vetted-customization-stage-and-shopkeeper-analogy-and-IoT-vs-blockchain-as-runtime-context-pair--patterns-from-prior-cycles-reaffirmed.md)
- [Borrowing tiers](endo--pkg-ses-docs-draft-standalone-spec--Math-Date-omissions-and-vetted-customization-stage-and-shopkeeper-analogy-and-IoT-vs-blockchain-as-runtime-context-pair--borrowing-tiers.md)
- [Synthesis target](endo--pkg-ses-docs-draft-standalone-spec--Math-Date-omissions-and-vetted-customization-stage-and-shopkeeper-analogy-and-IoT-vs-blockchain-as-runtime-context-pair--synthesis-target.md)
- [Single most structurally interesting move](endo--pkg-ses-docs-draft-standalone-spec--Math-Date-omissions-and-vetted-customization-stage-and-shopkeeper-analogy-and-IoT-vs-blockchain-as-runtime-context-pair--single-most-structurally-interesting-move.md)
