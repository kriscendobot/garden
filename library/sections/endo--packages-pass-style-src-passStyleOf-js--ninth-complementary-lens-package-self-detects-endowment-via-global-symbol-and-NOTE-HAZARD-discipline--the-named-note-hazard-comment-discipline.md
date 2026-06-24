---
title: §the-named-NOTE-HAZARD-comment-discipline
source: endo--packages-pass-style-src-passStyleOf-js
url: https://github.com/endojs/endo/blob/master/packages/pass-style/src/passStyleOf.js
authors: [Mark S. Miller, Kris Kowal, Endo project (collective)]
repo: endojs/endo
path: packages/pass-style/src/passStyleOf.js
total-lines: 405
ingest-cycle: 350
ingest-date: 2026-06-15
lane: chat
section-tags:
  - the-named-package-self-detects-endowment-via-global-symbol
  - the-named-PassStyleOfEndowmentSymbol-as-canonical-name
  - the-named-NOTE-HAZARD-comment-discipline
  - the-named-liveslots-as-canonical-endower
  - the-named-isFrozen-check-at-the-evolution-points
  - the-named-TypedArrays-get-special-treatment-error-distinction
  - the-named-confirmCanBeValid-then-assertRestValid-two-phase-validation
  - the-named-helper-table-with-assertions-on-table-construction
  - the-named-defensive-init-pattern-for-registries
  - the-named-PASS_STYLE-as-well-known-tag-symbol
  - the-named-complementary-lens-re-ingest
  - nine-cycles-with-named-complementary-lens-re-ingest
  - the-named-citation-arc-from-cycle-71-takes-279-cycles-to-close
  - forty-one-cycles-with-named-pivot-domain-stay
  - one-hundred-forty-two-citation-arc-closures-in-pivot-now
parent: endo--packages-pass-style-src-passStyleOf-js--ninth-complementary-lens-package-self-detects-endowment-via-global-symbol-and-NOTE-HAZARD-discipline
---

Lines 222-233 contain a structured comment block:

> If there is already a PassStyleOfEndowmentSymbol property on the global, then presumably it was endowed for us by liveslots with a `passStyleOf` function, so we should use and export that one instead.
> Other software may have left it for us here, but it would require write access to our global, or the ability to provide endowments to our global, both of which seems adequate as a test of whether it is authorized to serve the same role as liveslots.
>
> **NOTE HAZARD**: This use by liveslots does rely on `passStyleOf` being deterministic. If it is not, then in a liveslot-like virtualized environment, it can be used to detect GC.

**§the-named-NOTE-HAZARD-comment-discipline** — first-explicit-observation as a tier-3 meta-pattern. The comment NAMES a specific HAZARD that arises from the discipline:
- The **hazard**: non-determinism in passStyleOf can be a GC-detection side-channel
- The **dependency**: liveslots' use relies on determinism
- The **environment**: liveslot-like virtualized environments

Compare to cycle 342 @endo/lockdown/pre.js's NOTE-TO-REVIEWERS-pattern (merge-defense for commented-out options); cycle 350's NOTE-HAZARD is a DIFFERENT shape — it warns the IMPLEMENTOR/MAINTAINER about a property they must preserve (determinism) for safety in a downstream context.

**§two-shapes-of-NOTE-prefix-comment** (cycle 342 NOTE-TO-REVIEWERS-merge-defense + cycle 350 NOTE-HAZARD-determinism-dependency) — first-explicit-observation as a tier-2 multi-cycle pattern.

**§the-named-liveslots-as-canonical-endower** — first-explicit-observation. The comment names **liveslots** as the canonical user of the endowment slot. Liveslots is Agoric's vat-runtime; this passStyleOf interface is one of the integration points.

**§the-named-authorization-via-write-access-to-global** — first-explicit-observation. The comment names the AUTHORIZATION model: *"would require write access to our global, or the ability to provide endowments to our global, both of which seems adequate as a test of whether it is authorized"*. The implicit-authorization-via-capability-of-write-access discipline.
