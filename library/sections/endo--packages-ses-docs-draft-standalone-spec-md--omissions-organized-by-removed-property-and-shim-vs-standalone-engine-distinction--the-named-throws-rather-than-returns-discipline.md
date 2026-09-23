---
title: §the-named-throws-rather-than-returns-discipline
source: endo--packages-ses-docs-draft-standalone-spec-md
url: https://github.com/endojs/endo/blob/master/packages/ses/docs/draft-standalone-spec.md
authors: [Mark S. Miller, Kris Kowal, Endo project (collective)]
repo: endojs/endo
path: packages/ses/docs/draft-standalone-spec.md
total-lines: 201
ingest-cycle: 351
ingest-date: 2026-06-15
lane: designs
section-tags:
  - the-named-shim-vs-standalone-engine-distinction
  - the-named-omissions-organized-by-removed-property
  - the-named-non-determinism-as-removed-feature
  - the-named-ambient-authority-as-removed-feature
  - the-named-global-communications-channel-language
  - the-named-throws-rather-than-returns-discipline
  - the-named-deterministic-replication-as-canonical-use-case
  - the-named-blockchain-as-shorthand-for-deterministic-replication
  - the-named-shared-globals-vs-shared-intrinsics-distinction
  - the-named-rom-able-immutable-discipline
  - the-named-IoT-and-blockchain-may-omit-evaluators
  - the-named-function-constructors-not-evaluators
  - the-named-makeRootRealm-feature-test-discipline
  - forty-two-cycles-with-named-pivot-domain-stay
  - one-hundred-forty-eight-citation-arc-closures-in-pivot-now
parent: endo--packages-ses-docs-draft-standalone-spec-md--omissions-organized-by-removed-property-and-shim-vs-standalone-engine-distinction
---

When a capability is removed, the method THROWS rather than returns:

```
- Math.random() throws a `TypeError` rather than provide a random number
- Date.now() throws a `TypeError` rather than returning the millisecods
- new Date() ... throws a `TypeError` rather than returning a date instance
- Date(...) ... throws a `TypeError` rather than a string presenting the current time
```

**§the-named-throws-rather-than-returns-discipline** — first-explicit-observation as a tier-3 meta-pattern. Tier-3 framing: when DENYING a capability that was previously available, throw on call rather than silently returning a degraded value. The throw makes the discipline-violation VISIBLE at runtime.

Compare to:
- Cycle 342 @endo/lockdown/pre.js's §the-named-discipline-violation-visible (console.warn on sniff detection)
- **Cycle 351 standalone-spec's §the-named-throws-rather-than-returns-discipline** (throw on denied capability)

**§three-shapes-of-discipline-violation-visibility** — cycle 337 helpful-stack (lockdown throws) + cycle 342 console-warn (override sniff detected) + cycle 351 throw-on-denied-capability. First-explicit-observation as a tier-3 meta-pattern.
