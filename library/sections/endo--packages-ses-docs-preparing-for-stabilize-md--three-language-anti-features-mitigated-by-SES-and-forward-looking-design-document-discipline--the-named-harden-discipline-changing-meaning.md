---
title: §the-named-harden-discipline-changing-meaning
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

Line 11: *"Where `harden` made the object at every step frozen, that PR changes `harden` to also make those objects non-trapping."*

Line 30: *"Although we think of `passStyleOf` as requiring its input to be hardened, `passStyleOf` instead checked that each relevant object is frozen. Manually freezing all objects reachable from a root object had been equivalent to hardening that root object. With these changes, even such manual transitive freezing will not make an object passable. To prepare for these changes, use `harden` explicitly instead."*

**§the-named-harden-discipline-changing-meaning** — first-explicit-observation. The SEMANTICS of harden vs Object.freeze is changing:
- **Before**: harden = transitive Object.freeze; passStyleOf checks frozen
- **After**: harden = transitive Object.freeze + non-trapping mark; passStyleOf checks both

**§the-named-discipline-semantics-evolution-with-named-migration** — first-explicit-observation as a tier-3 meta-pattern. When a discipline's semantics change, the document names BOTH the old semantics AND the new semantics AND the migration path (*"use `harden` explicitly instead"*).
