---
title: §the-vetted-customization-code-named-stage (first-explicit-observation)
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

**§the-named-pre-freeze-stage**: a discrete stage where code runs against *mutable* shared intrinsics, then the intrinsics are frozen. **§two-named-stages-in-SES-startup**: vetted-customization-stage + frozen-runtime-stage. The transition IS the freeze.

§the-vetted-IS-the-named-trust-boundary: the customization code IS *vetted* before being given access to the mutable pre-freeze world; once frozen, *no* code can mutate the intrinsics. **§the-trust-IS-front-loaded-to-the-vetted-stage**.

§the-"why-we-refer-to-them-as-vetted"-naming-rationale: the doc explains the term in line — "Although the customizations run confined, because they can arbitrarily mutate the shared intrinsic state before other code runs, all later code is fully vulnerable to these customizations." **§the-explicit-rationale-for-the-named-stage**.
