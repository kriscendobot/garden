---
title: The single most structurally interesting move
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

**§the-named-omissions-organized-by-removed-property** — the doc enumerates omissions from standard EcmaScript, each tied to a **named property being eliminated**:

| Omitted feature | Named property being eliminated |
|---|---|
| Math.random | Non-determinism |
| Date.now / new Date() | Non-determinism |
| RegExp static properties | Global communications channel |
| Intl | Ambient authority + non-determinism |
| Function constructors | Evaluators |
| import() / import.meta | (also relates to ambient authority + non-determinism) |
| Annex B | Backward-compat cruft |

**§the-named-omissions-organized-by-removed-property** — first-explicit-observation as a tier-3 meta-pattern. The taxonomy is organized by WHAT PROPERTY is being eliminated, not by spec section. Tier-3 framing: when documenting a security-focused subset of a language, organize omissions by the SECURITY PROPERTY being preserved (or anti-property being eliminated).

**§three-named-anti-properties-being-eliminated** — non-determinism + ambient authority + global communications channels. The three security-relevant anti-properties that distinguish a standalone SES from standard JS.

**§the-named-three-anti-properties-equal-the-three-attack-categories** — first-explicit-observation. Compare to cycle 345 @endo/ses README's §the-named-three-attack-categories-lockdown-defends-against (prototype-pollution + man-in-the-middle + covert-communication-channels). Cycle 351's three anti-properties are the **language-feature-level** equivalent:

| Cycle 345 attack category | Cycle 351 anti-property |
|---|---|
| Covert communication channels | Non-determinism (timing channels) + global communications channels (RegExp static state) |
| Man-in-the-middle | (prevented by frozen intrinsics) |
| Prototype pollution | (prevented by frozen intrinsics) |
| (implicit: ambient authority) | Ambient authority (Intl, evaluators) |

**§two-shapes-of-defense-taxonomy** — cycle 345 names attacks; cycle 351 names properties eliminated. Same architecture from two angles. First-explicit-observation as a tier-3 meta-pattern.
