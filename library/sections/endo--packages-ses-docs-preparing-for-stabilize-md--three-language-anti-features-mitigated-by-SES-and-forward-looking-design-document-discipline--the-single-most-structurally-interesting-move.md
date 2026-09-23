---
title: The single most structurally interesting move
source: endo--packages-ses-docs-preparing-for-stabilize-md
url: https://github.com/endojs/endo/blob/master/packages/ses/docs/preparing-for-stabilize.md
authors: [Mark S. Miller, Endo project (collective)]
repo: endojs/endo
path: packages/ses/docs/preparing-for-stabilize.md
total-lines: 30
ingest-cycle: 349
ingest-date: 2026-06-15
lane: designs
section-tags:
  - the-named-three-language-anti-features-mitigated-by-SES
  - the-named-Stabilize-proposal-with-three-integrity-traits
  - the-named-return-override-mistake
  - the-named-assignment-override-mistake
  - the-named-proxy-based-reentrancy-hazard
  - the-named-fixed-overridable-non-trapping-three-traits
  - the-named-forward-looking-design-document-discipline
  - the-named-prepare-for-future-changes-discipline
  - the-named-placeholder-names-are-not-final
  - the-named-bikeshedding-process-acknowledged
  - the-named-by-default-discipline-with-named-opt-in
  - the-named-E-returns-proxy-with-frozen-trivial-target
  - the-named-top-level-target-discipline
  - the-named-TC39-stage-1-named
  - the-named-draft-PR-named-with-issue-number
  - the-named-harden-discipline-changing-meaning
  - the-named-30-line-forward-looking-design-doc
  - the-named-streak-of-zero-cross-package
  - forty-cycles-with-named-pivot-domain-stay
  - one-hundred-thirty-five-citation-arc-closures-in-pivot-now
parent: endo--packages-ses-docs-preparing-for-stabilize-md--three-language-anti-features-mitigated-by-SES-and-forward-looking-design-document-discipline
---

**§the-named-three-language-anti-features-mitigated-by-SES** — lines 3-6 of the document name **THREE distinct JavaScript language anti-features** and the **THREE Stabilize-proposal integrity traits** that mitigate each:

| Integrity trait | Language anti-feature mitigated | Mechanism |
|---|---|---|
| **fixed** | Return-override mistake | Prevents objects with this trait from being stamped with new class-private-fields |
| **overridable** | Assignment-override mistake | Enables non-writable properties inherited from an object with this trait to be overridden by property assignment on an inheriting object |
| **non-trapping** | Proxy-based reentrancy hazards | Proxy whose target carries this trait never traps to its handler; just performs the default action directly |

**§the-named-three-language-anti-features-mitigated-by-SES** — first-explicit-observation as a tier-3 meta-pattern. Cycle 345 @endo/ses README named ONE language anti-feature (the assignment-override mistake). Cycle 349 reveals SES mitigates **THREE distinct anti-features**, each with its own named integrity trait.

**§the-named-Stabilize-proposal-with-three-integrity-traits** — first-explicit-observation. The TC39 Stabilize proposal organizes the mitigations into three orthogonal integrity traits with placeholder names (fixed + overridable + non-trapping).

**§the-named-return-override-mistake** + **§the-named-assignment-override-mistake** + **§the-named-proxy-based-reentrancy-hazard** — three distinct JS language warts named individually. Compare to:

| Cycle | Anti-feature named |
|---|---|
| 345 | Override mistake (= assignment-override) — one anti-feature |
| **349** | **return-override + assignment-override + proxy-reentrancy** — three anti-features |

**§the-named-language-anti-features-as-orthogonal-traits** — first-explicit-observation as a tier-3 meta-pattern. The three traits are *orthogonal* — they address different attack surfaces. Tier-3 framing: when a security project mitigates multiple language anti-features, organize them as orthogonal traits (not a single composite property).

**§three-shapes-of-language-anti-feature-mitigation** — first-explicit-observation:

1. **Spec-level mitigation**: TC39 integrity traits (Stabilize proposal)
2. **Library-level mitigation**: SES taming + harden (existing)
3. **User-level workaround**: defineProperties workaround (cycle 345's README)
