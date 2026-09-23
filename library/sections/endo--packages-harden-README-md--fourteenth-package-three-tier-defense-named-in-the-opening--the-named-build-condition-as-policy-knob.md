---
title: §the-named-build-condition-as-policy-knob
source: endo--packages-harden-README-md
url: https://github.com/endojs/endo/blob/master/packages/harden/README.md
authors: [Kris Kowal, Mark S. Miller, Jean-Francois Paradis, Endo project (collective)]
repo: endojs/endo
path: packages/harden/README.md
total-lines: 158
ingest-cycle: 337
ingest-date: 2026-06-15
lane: designs
section-tags:
  - the-named-three-tier-defense-named-in-the-opening
  - the-named-threat-model-named-first
  - the-named-supply-chain-attack-IS-named-threat-model
  - the-named-place-to-stand-toward-its-own-defense-metaphor
  - the-named-dual-purpose-of-harden
  - the-named-Object-Symbol.for-harden-intrinsic
  - the-named-intrinsic-over-endowment-discipline
  - the-named-build-condition-as-policy-knob
  - the-named-two-named-build-conditions
  - the-named-multiple-instances-first-call-wins
  - the-named-shim-like-behavior-pre-lockdown
  - the-named-with-OR-without-NOT-both-policy
  - the-named-temporal-ordering-creates-vulnerability
  - the-named-helpful-stack-on-misuse
  - the-named-stack-points-to-the-offending-module
  - the-named-isFake-deprecated-with-named-regret
  - the-named-honest-regret-in-README
  - the-named-migration-path-with-named-alternative
  - the-named-Without-HardenedJS-degradation-mode
  - the-named-partial-safety-with-named-tradeoff
  - the-named-test-and-UI-framework-acknowledgment
  - the-named-six-section-policy-README-shape
  - the-named-fourteenth-package-in-the-pivot-cluster
  - twenty-eight-cycles-with-named-pivot-domain-stay
  - fifty-six-citation-arc-closures-in-pivot-now
  - the-named-substrate-package-with-policy-README
parent: endo--packages-harden-README-md--fourteenth-package-three-tier-defense-named-in-the-opening
---

Two build conditions named in the README:

| Build condition | Section | Behavior |
|---|---|---|
| `-C hardened` | "With HardenedJS" (lines 61-68) | Smallest version; throws if `harden` not present |
| `-C harden:unsafe` | "Without HardenedJS" (lines 83-85) | Opt out of safety guarantees; avoid transitive-harden computation cost |

**§the-named-build-condition-as-policy-knob** — first-explicit-observation. The build condition is a **policy knob exposed at build time**. The two conditions span the safety-vs-cost spectrum:
- `-C hardened` — *we assert this code runs in HardenedJS; fail loud if not*
- `-C harden:unsafe` — *we opt out of safety; pay no harden cost*

**§the-named-two-named-build-conditions** — first-explicit-observation. The README names BOTH endpoints of the policy spectrum, not just one. Compare to cycle 183 @endo/init's §tolerance-ladder-via-separate-entry-point-files (four entry-point files for four safety levels); §the-named-build-condition-as-policy-knob is the build-time variant of the same tolerance-discipline. **§two-shapes-of-policy-knob** (separate-entry-point-files + build-condition) — first-explicit-observation as a tier-3 meta-pattern.

**§the-named-fail-loud-or-pay-cost-binary-choice** — first-explicit-observation. The build conditions encode a binary policy: either *fail loud in non-HardenedJS environments* OR *don't pay the harden cost*. There is no middle ground at build time; the middle ground (degraded-mode harden) is the default. Three named modes:
1. `-C hardened` — strict-only mode
2. (default) — degraded-mode (own-properties only; no prototype-chain traversal)
3. `-C harden:unsafe` — no-harden mode

**§the-named-three-build-time-modes** — first-explicit-observation.
