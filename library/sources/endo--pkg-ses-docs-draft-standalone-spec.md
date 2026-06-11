---
title: "@endo/ses/docs/draft-standalone-spec.md — Draft SES spec for IoT and blockchain runtime contexts"
source-slug: endo--pkg-ses-docs-draft-standalone-spec
url: https://github.com/endojs/endo/blob/master/packages/ses/docs/draft-standalone-spec.md
authors: [Mark S. Miller (et al.)]
repo: endojs/endo
path: packages/ses/docs/draft-standalone-spec.md
total-lines: 201
ingest-cycle: 291
ingest-date: 2026-06-11
lane: designs
---

# `@endo/ses/docs/draft-standalone-spec.md`

A 201-line draft spec for standalone SES — the standardization pathway for Hardened JavaScript implementations targeting IoT and deterministically-replicated-computation use cases. Names omissions (what's removed from EcmaScript) + additions (what's added beyond EcmaScript) + three named SES variants + the vetted-customization-stage with the shopkeeper analogy + build-time-vs-runtime IoT mapping.

## Key moves

- **§the-"Draft Spec"-genre-as-named-tentativeness-marker** — title bears the tentativeness marker; §three-cycles-with-named-tentativeness-marker-locations (263 prose-hedge + 288 code-comment + 291 document-title).
- **§the-IoT-vs-blockchain-as-named-runtime-context-pair** — two named non-browser runtime contexts.
- **§the-shorthand-definition-disclaimer** — "blockchain" as shorthand for the more general category of deterministically replicated SES computation.
- **§the-named-incomplete-enumeration** — `(whether on X, Y, or whatever)` closer signals the enumeration IS not exhaustive.
- **§the-`## Omissions and Simplifications`-section-as-named-subtractive-spec-discipline** — the spec as named delta from a reference spec.
- **§nine-named-omissions** — sloppy mode + non-ES2018 + `import()` + Annex B + RegExp statics + Math.random + Date.now/new Date()/Date() + Intl + Function constructors via `.constructor`.
- **§the-three-named-Date-constructor-variants-all-block** — Date.now() + new Date() + Date(...) all throw TypeError; the-exhaustive-named-attack-surface-enumeration.
- **§two-named-sources-of-non-determinism** — random + clock; the-non-determinism-IS-the-named-attack-vector-for-replicated-computation.
- **§the-shared-globals-and-shared-intrinsics-named-definitions** — defined inline as transitively-reachable closure.
- **§the-`## Additions`-section-as-named-additive-spec-discipline** — paired with Omissions for bidirectional delta.
- **§the-feature-detection-via-property-presence** — `Realm.makeRootRealm` IS optional; absent property IS the feature-test.
- **§the-vetted-customization-code-named-stage** — pre-freeze phase where customizations CAN mutate; the-trust-IS-front-loaded-to-the-vetted-stage.
- **§the-shopkeeper-analogy as named-domain-shift discipline** — shopkeeper-IS-host + shop-preparation-IS-vetted-customization-stage + opening-the-doors-IS-the-freeze + customers-arriving-IS-untrusted-runtime-code.
- **§the-build-time-vs-runtime-mapping** for IoT — vetted-customization = build-time + frozen-runtime = runtime.
- **§three-named-instantiations-of-the-same-pre-freeze-vs-post-freeze-stage** — JS-engine + everyday-shop + IoT-lifecycle.
- **§the-named-cross-domain-stage-mapping-IS-the-named-generalization-axis**.
- **§the-frozen-shared-intrinsics-IS-ROM-able** — implementation target IS bare-metal microcontroller memory.
- **§the-`Function !== Function.prototype.constructor`-invariant** — counter-intuitive but enforced; stated as equation.
- **§the-`TBD:`-section-as-named-open-questions-list** — shorter alternative to `## Open Questions`; §three-cycles-with-named-open-questions-section-shapes (283 + 287 + 291).
- **§the-`## Work in Progress`-section-as-named-deferred-topic-marker** — named whole-topic deferral.
- **§the-`## Stage Separated SES`-section** — §three-named-SES-variants (Full SES + Standalone SES + Stage-separated SES).
- **§the-direct-eval-syntax-low-priority-named-omission** — explicit priority naming + named early-error discipline.
- **§four-cycles-with-no-metadata-table-shape** (285 + 287 + 289 + 291).

## Section files

- [§Math-and-Date-omissions + §vetted-customization-stage + §shopkeeper-analogy + §IoT-vs-blockchain-as-runtime-context-pair + 37 more first-explicit-observations](../sections/endo--pkg-ses-docs-draft-standalone-spec--Math-Date-omissions-and-vetted-customization-stage-and-shopkeeper-analogy-and-IoT-vs-blockchain-as-runtime-context-pair.md) — full 201-line draft spec in scope.

## Ingest scope

Cycle 291 (designs-lane after cycle 290 chat-lane @endo/zip/src/buffer-writer.js per-file deep ingest). Full 201-line spec in scope. **First-explicit-observations (forty-one)** covering the named tentativeness marker, the runtime-context pair, the subtractive-vs-additive spec discipline, the named omissions and additions enumerations, the named sources of non-determinism, the vetted-customization-stage with shopkeeper analogy, the three-named-SES-variants, the named ROM-ability property, the counter-intuitive Function-invariant stated as equation, the named open-questions section shapes, and the named cross-domain stage mapping.
