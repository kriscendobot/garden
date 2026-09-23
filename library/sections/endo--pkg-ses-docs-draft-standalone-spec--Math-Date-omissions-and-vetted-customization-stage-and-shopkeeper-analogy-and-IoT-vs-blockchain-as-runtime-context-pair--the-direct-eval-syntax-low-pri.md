---
title: §the-direct-eval-syntax-low-priority-named-omission (first-explicit-observation)
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

> "The direct-eval feature is impossible to shim and rarely needed anyway, and so is low priority. When omitted, the direct-eval syntax should also be statically rejected with an early error."

**§the-named-low-priority-omission with explicit rationale**: hard-to-shim + rarely-needed = deprioritized. §the-explicit-priority-naming-as-named-design-discipline.

§the-static-rejection-as-named-error-handling: when a feature IS omitted, the syntax should produce an *early error* (compile-time) rather than a *runtime* error. **§the-named-early-error-discipline**.
