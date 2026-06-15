---
title: "@endo/ses docs/draft-standalone-spec.md — omissions organized by removed property (non-determinism + ambient authority + global communication channels + evaluators); shim-vs-standalone-engine distinction; forward-looking architectural blueprint"
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
---

# `@endo/ses docs/draft-standalone-spec.md` — omissions organized by removed property

The 201-line forward-looking architectural blueprint for what a STANDALONE SES engine would look like (vs the current shim-based implementation). Cycle 351 designs-lane after cycle 350's chat-lane. **§forty-two-cycles-with-named-pivot-domain-stay** (310-351).

## The single most structurally interesting move

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

## §the-named-shim-vs-standalone-engine-distinction

Opening lines 3-9:

> In the Realms, Frozen Realms, Realms shim, and SES shim work, we've generally worked towards standardizing the APIs for dynamically *creating* a SES world from within a standard EcmaScript world. For IoT or blockchain purposes, the more relevant question is: What is the resulting standard SES world, independent of whether it was created from within a standard EcmaScript world, or whether it was implemented directly by a standalone SES engine that supports only SES?

**§the-named-shim-vs-standalone-engine-distinction** — first-explicit-observation as a tier-3 meta-pattern. SES has **two implementation strategies**:
- **Shim-based**: dynamically *create* a SES world from JS (the current packages/ses implementation)
- **Standalone engine**: directly *implement* SES (what this spec describes)

Tier-3 framing: when a security-focused language subset exists, two implementation strategies are possible — shim it onto the full language OR build a native engine that ONLY supports the subset. The standalone variant is **simpler** because it has nothing to suppress.

## §the-named-throws-rather-than-returns-discipline

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

## §the-named-deterministic-replication-as-canonical-use-case

Lines 10-13:

> (We use "blockchain" here as shorthand for the more general category of deterministically replicated SES computation, whether on a blockchain, permissioned BFT system, or whatever.)

**§the-named-deterministic-replication-as-canonical-use-case** — first-explicit-observation. The document uses "blockchain" as a shorthand for the broader category of *deterministically replicated SES computation*. The canonical use case is replicas converging by computing the same way; non-determinism breaks consensus.

**§the-named-blockchain-as-shorthand-for-deterministic-replication** — first-explicit-observation. The document acknowledges that "blockchain" is an imprecise term; the actual category is "deterministic replication" which subsumes blockchain + BFT + other.

## §the-named-shared-globals-vs-shared-intrinsics-distinction

Lines 50-56:

> We define the *shared globals* as all the standard shared global variable bindings defined by the above, i.e., without `Intl` by default, with `Realm` (see below), without `eval`, without `Function`, without anything outside the EcmaScript 2018 spec, and with `BigInt`. We define the *shared intrinsics* as all the objects transitively reachable from the shared globals. Note that no global objects or evaluators are reachable from the shared intrinsics.

**§the-named-shared-globals-vs-shared-intrinsics-distinction** — first-explicit-observation. Two formally defined concepts:
- **Shared globals**: the global variable bindings (named by the spec)
- **Shared intrinsics**: all objects transitively reachable from the shared globals

**§the-named-formal-definitions-in-design-doc** — first-explicit-observation as a tier-3 meta-pattern. When a design document needs precision, italicize-define key terms before using them. Compare to cycle 345 @endo/ses README's §the-named-host-program-vs-guest-program-vocabulary (also in-section definitions).

## §the-named-rom-able-immutable-discipline

Lines 96-101:

> Freeze all shared intrinsics. With the above omissions, there is no hidden state or ambient authority among the shared intrinsics, so transitive freezing means that the shared intrinsics are immutable and rom-able. Since no global objects or evaluators are reachable from the shared intrinsics. They can be placed in ROM without the bookkeeping needed for them to point at any objects not in ROM.

**§the-named-rom-able-immutable-discipline** — first-explicit-observation as a tier-3 meta-pattern. When shared intrinsics are frozen + no hidden state + no ambient authority + no reachable globals or evaluators, they become **ROM-able** (can be placed in read-only memory). This is the IoT-friendly property — no GC, no mutable refs, no kernel mapping.

Tier-3 framing: when designing a security-focused subset, the ability to put intrinsics in ROM is a measurable end-state property — it certifies the absence of state.

## §the-named-IoT-and-blockchain-may-omit-evaluators

Lines 60-62:

> Some IoT and blockchain configurations may omit all runtime evaluators.

**§the-named-IoT-and-blockchain-may-omit-evaluators** — first-explicit-observation. Even the runtime evaluators (eval, Function constructor, Realm.makeCompartment) are OPTIONAL in extreme configurations. The minimum standalone SES engine has NO runtime evaluation capability.

**§the-named-function-constructors-not-evaluators** — line 47: *"Because these function constructors always throw, we do not consider them to be evaluators."* The TAXONOMY distinguishes evaluators from non-evaluators based on whether they can construct code.

**§the-named-makeRootRealm-feature-test-discipline** — lines 87-94: *"On platforms that do not support `Realm.makeRootRealm`, the property must be absent so that SES code can feature-test for it."* The discipline: missing capabilities should be ABSENT, not present-but-broken, so callers can feature-test.

## Closes citation arcs

| Closes arc with | Arc length | Subject |
|---|---|---|
| Cycle 350 (passStyleOf.js) | 1 cycle | Cross-package |
| Cycle 349 (preparing-for-stabilize.md) | 2 cycles | Sibling forward-looking SES doc |
| Cycle 345 (@endo/ses README) | 6 cycles | §two-shapes-of-defense-taxonomy |
| Cycle 87 (pass-style/error.js V8 stack accessor) | 264 cycles | Non-determinism / covert-channel theme |
| Cycle 152 (memo-race Promise.race) | 199 cycles | Non-determinism in scheduling |
| Cycle 156 (finalize.js gc-as-side-channel) | 195 cycles | Non-determinism + side-channel |
| Cycle 342 (lockdown pre.js NOTE-TO-REVIEWERS) | 9 cycles | §three-shapes-of-discipline-violation-visibility |
| Cycle 337 (@endo/harden helpful-stack) | 14 cycles | §three-shapes-of-discipline-violation-visibility |

**§eight-citation-arc-closures-in-cycle-351**. **§one-hundred-forty-eight-citation-arc-closures-in-pivot-now** (142 + 6 net new).

## Tier-3 meta-patterns

- **§the-named-omissions-organized-by-removed-property**
- **§the-named-three-anti-properties-equal-the-three-attack-categories**
- **§two-shapes-of-defense-taxonomy** (attack-categories + property-eliminated)
- **§the-named-shim-vs-standalone-engine-distinction**
- **§the-named-throws-rather-than-returns-discipline**
- **§three-shapes-of-discipline-violation-visibility** (helpful-stack + console-warn + throw-on-denied-capability)
- **§the-named-rom-able-immutable-discipline**
- **§the-named-formal-definitions-in-design-doc**
- **§the-named-deterministic-replication-as-canonical-use-case**

## Library state after cycle 351

- §library-reaches-863-sections from 394 source documents
- §one-hundred-and-eighty-fourth consecutive designs-chat alternation
- §forty-two-cycles-with-named-pivot-domain-stay (310-351)
- §nineteen-named-packages-in-the-pivot-cluster
- §one-hundred-forty-eight-citation-arc-closures-in-pivot-now (142 + 6 net new)
- §the-named-omissions-organized-by-removed-property established as tier-3 meta-pattern
- §the-named-shim-vs-standalone-engine-distinction established as tier-3 meta-pattern
- §the-named-throws-rather-than-returns-discipline established as tier-3 meta-pattern
- §three-shapes-of-discipline-violation-visibility established as tier-3 meta-pattern
- §the-named-rom-able-immutable-discipline established as tier-3 meta-pattern
- §two-shapes-of-defense-taxonomy established as tier-3 meta-pattern
