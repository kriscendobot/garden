---
title: "@endo/ses/docs/guide.md — HardenedJS and Endo programming guide (652 lines)"
source-slug: endo--pkg-ses-docs-guide
url: https://github.com/endojs/endo/blob/master/packages/ses/docs/guide.md
authors: [Endo project (collective)]
repo: endojs/endo
path: packages/ses/docs/guide.md
total-lines: 652
ingest-cycle: 293
ingest-date: 2026-06-11
lane: designs
---

# `@endo/ses/docs/guide.md`

A 652-line comprehensive programming guide for HardenedJS (formerly SES) and Endo. Covers what HardenedJS is + what Lockdown does + what's removed + what's added + Realms + Compartments + the historical narrative + concrete code examples.

## Key moves

- **§the-`group: Documents` + `category: Guides`-TypeDoc-style-frontmatter** — `children: []` empty-leaf-marker; the-frontmatter-IS-the-documentation-site-grouping-vocabulary.
- **§HardenedJS-as-named-rebranding-of-SES** — "SES is an old umbrella term"; the-named-rebranding-with-named-lingering-instances; §three-cycles-with-named-naming-evolution-as-pedagogy (277 filename-conventions + 291 Draft-Spec-tentative + 293 HardenedJS-IS-renamed-from-SES).
- **§the-three-parts-of-HardenedJS** — Lockdown + Harden + Compartment; three-named-distinct-shapes-of-API-units (one-time-function + per-object-function + class-constructor).
- **§the-named-irreversibility-of-Lockdown** — "irreversibly repairs and hardens".
- **§Lockdown-IS-two-phases-with-vetted-shims-between** — Repair Intrinsics + (vetted shims) + Harden Intrinsics.
- **§the-named-vetted-shim-as-named-pre-Lockdown-modifier**.
- **§the-OCap-three-requirements** — protect-invariants + capability-IS-reference + only-way-to-get-IS-given; the-OCap-IS-three-named-axioms.
- **§the-historical-narrative-of-JavaScript** — web-sandbox-for-strangers + sandbox-broke-when-multiple-strangers-shared + HardenedJS-finer-grain-OCap; the-narrative-IS-the-named-motivation; three-named-historical-moments.
- **§the-`'ses'`-import-as-shim-pattern** — `require("ses"); lockdown();` mutates environment in place; the-named-side-effect-import; the-`ses-lockdown.js`-wrapper-module-pattern.
- **§the-UMD-build-IS-the-named-browser-distribution-format** — `<script src="...ses.umd.min.js">`; §three-named-distribution-shapes-for-SES (CJS + ESM + UMD).
- **§the-Promise-queue-vs-I/O-queue-two-named-queue-shape** — Promise queue (ambient) + I/O queue (capability-gated); the-named-priority-ordering (Promise higher); the-named-capability-gate-on-the-I/O-queue.
- **§the-Math.random + Date.now + new Date + Date() blocking** — reaffirms cycle 291; §two-cycles-with-the-three-named-Date-constructor-variants-all-block (291 + 293).
- **§the-`permits.js`-IS-the-named-source-of-truth-for-globals** — data-driven not code-driven; the-named-versioning-of-the-permits-list anchors docs to SES-v0.8.0.
- **§three-named-Realms-vs-Compartments-distinctions** — realm has distinct intrinsics + compartment shares intrinsics + each has own globalThis; the-named-claims-stated-as-code-equations (`c.globalThis === globalThis` → false; `c.globalThis.JSON === JSON` → true).
- **§the-spec-states-its-invariants-as-equations** — extends cycle 291's `Function !== Function.prototype.constructor` pattern.
- **§the-`start compartment`-IS-the-named-bootstrap-compartment** — the initial compartment that IS not constructed; ambient authorities; the-named-asymmetry-of-the-initial-compartment-vs-constructed-compartments.
- **§the-SwingSet's-TimerService-as-named-out-of-band-time-access** — named substitution for the removed ambient authority; pedagogy bridge from platform-removal to named-application-replacement.
- **§the-`harden(console.log)` as named-example** — the capability IS hardened at the boundary before passing into the compartment.
- **§the-`Compartment.evaluate` named-string-source-evaluation**.
- **§the-named-two-named-Compartment-shapes** — single-program-evaluation + multi-module-system; named progressive disclosure.
- **§the-named-Compartment-as-named-module-system-boundary** — compartments can re-export each other's modules.
- **§the-Markdown-link-to-tc39-terminology-glossary** — the-named-vocabulary-deference; the-named-external-glossary-link-IS-the-named-pedagogy-discipline.

## Section files

- [§HardenedJS renamed from SES + §three parts (Lockdown + Harden + Compartment) + §Lockdown-IS-two-phases-with-vetted-shims-between + §Promise-queue vs I/O-queue two-queue-shape + 37 more first-explicit-observations](../sections/endo--pkg-ses-docs-guide--HardenedJS-renamed-from-SES-and-three-parts-and-Lockdown-two-phases-with-vetted-shims-between-and-Promise-queue-vs-IO-queue.md) — full 652-line guide in scope.

## Ingest scope

Cycle 293 (designs-lane after cycle 292 chat-lane @endo/zip/src/buffer-reader.js per-file deep ingest). Full 652-line guide in scope. **First-explicit-observations (forty-one)** covering the named rebranding, the three named primitives, Lockdown's two-phase decomposition with vetted-shims-between, the OCap three-requirements, the historical-narrative-as-named-motivation, the named distribution shapes, the Promise-queue-vs-I/O-queue two-named-queue-shape with capability-gate-on-I/O, the permits.js as named source of truth, the three named Realms-vs-Compartments distinctions stated as code equations, the start-compartment bootstrap discipline, the SwingSet TimerService as out-of-band time-source substitution, the harden-at-the-boundary capability injection pattern, and the named external glossary link.
