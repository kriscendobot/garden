---
title: §the-`Function !== Function.prototype.constructor`-invariant (first-explicit-observation)
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

> "Each compartment scope has its own `Function`, which does evaluate. All compartment scopes share the same `Function.prototype` and therefore the same `Function.prototype.constructor` which is a function that only throws. Thus, in all compartment scopes, `Function !== Function.prototype.constructor`"

**§the-named-counter-intuitive-invariant**: in standalone SES, `Function` (the eval-capable constructor) IS distinct from `Function.prototype.constructor` (the always-throw stub). This breaks the JS expectation that `F.prototype.constructor === F`.

§the-named-prototype-vs-constructor-decoupling: the prototype chain points back to the throw-only stub; the actual `Function` IS a separate per-compartment binding. **§the-decoupling-IS-the-named-isolation-mechanism**.

§the-counter-intuitive-invariant-IS-named-explicitly: the doc states the invariant as an equation rather than burying it in prose. §the-spec-states-its-counter-intuitive-claims-as-equations.
