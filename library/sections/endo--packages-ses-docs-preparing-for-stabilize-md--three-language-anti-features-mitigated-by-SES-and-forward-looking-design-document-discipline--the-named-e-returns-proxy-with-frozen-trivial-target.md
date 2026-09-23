---
title: §the-named-E-returns-proxy-with-frozen-trivial-target
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

Lines 22-26:

> Some proxies, such as that returned by `E(...)`, exist only to provide such trapping behavior. Their targets will typically be trivial useless empty frozen objects or almost empty frozen functions. Such frozen targets can be safely shared between multiple proxy instances because they are encapsulated within the proxy.

**§the-named-E-returns-proxy-with-frozen-trivial-target** — first-explicit-observation. The document NAMES the specific use case: E() (cycle 146) returns proxies whose targets are trivial frozen objects existing only to satisfy the Proxy invariant.

This **closes the citation arc** with cycle 146 (E.js) and cycle 154 (trap.js) — both files explicitly cited this very document (§stabilize-discipline + §preparing-for-stabilize.md references).

**§the-named-trivial-frozen-target-as-proxy-pattern** — first-explicit-observation as a tier-3 meta-pattern. When a Proxy exists only to provide trapping behavior, its target can be a TRIVIAL FROZEN OBJECT (not the actual data); the target satisfies Proxy invariants while the handler does the real work.

**§the-named-top-level-target-discipline** — line 26: *"their definitions should typically appear at top level of their module"*. The trivial target should be MODULE-LEVEL (not function-local) so it can be shared across proxy instances. **§the-named-shared-trivial-target-via-module-scope** — first-explicit-observation as a tier-3 meta-pattern.
