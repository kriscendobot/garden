---
title: "§the-`## Additions` section as named additive-spec discipline (first-explicit-observation)"
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

The complementary section is `## Additions` — what standalone SES *adds* beyond EcmaScript. **§the-Omissions + Additions pair-of-named-sections** (first-explicit-observation): the delta IS a *bidirectional* description — *what's removed* + *what's new*. **§three-cycles-with-Omissions-and-Additions-or-similar-symmetric-pair-of-sections** (?) — actually first instance.

§named-additions-list:
- `Realm.makeCompartment(options)` — compartment-creation method.
- `Realm.prototype.global` — getter-only accessor.
- `Realm.prototype.evaluateProgram(programSrc, endowments)` — program evaluation.
- `Realm.prototype.evaluateExpr(exprSrc, endowments)` — expression evaluation.
- `Realm.makeRootRealm(options)` — *optional* root-realm creation (feature-detected).

**§the-feature-detection-via-property-presence as named discipline** (first-explicit-observation in this context): "On platforms that do not support `Realm.makeRootRealm`, the property must be absent so that SES code can feature-test for it." **§the-named-feature-test-IS-property-presence**.
