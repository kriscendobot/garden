---
title: "@endo/memoize README.md — companion README to cycle 312's source ingest; §two-named-instances-of-source-and-README-pair-pattern (nat 310-311 + memoize 312-313); §four-cycles-with-named-pivot-domain-stay; §the-named-Hardened-JavaScript-IS-named-target-environment; §the-named-component-of-SES-IS-named-security-scrutiny; §four-named-behavior-properties; §the-named-throws-vs-rejected-promises-asymmetry; §three-named-memoization-safety-properties (defensiveness + unobservable memoization + isolation preservation); §the-named-source-TODO-and-README-pointer-pair (cycle 312 source had TODO for memoize.md link; cycle 313 README materializes the link)"
section-slug: endo--packages-memoize-README-md--companion-README-to-cycle-312-source-and-named-memoization-safety-properties
source-slug: endo--packages-memoize-README-md
url: https://github.com/endojs/endo/blob/master/packages/memoize/README.md
authors: [Endo project (collective)]
repo: endojs/endo
path: packages/memoize/README.md
total-lines: 77
ingest-cycle: 313
ingest-date: 2026-06-11
lane: designs
scope: full
---

# `@endo/memoize README.md` (companion to cycle 312's source ingest)

A 77-line README for `@endo/memoize`. **The companion README to cycle 312's source ingest**. **The second instance of the source-and-README pair pattern**, after cycle 310-311's @endo/nat pair. **§two-named-instances-of-source-and-README-pair-pattern**: 310+311 (nat) + 312+313 (memoize). **§four-cycles-with-named-pivot-domain-stay**: 310 + 311 + 312 + 313 all @endo/* sources.

## Key moves

- **§the-named-second-instance-of-named-source-and-README-pair** (first-explicit-observation): the cluster's source-and-README pair pattern recurs. **§two-named-instances-of-source-and-README-pair-pattern**: nat (310-311) + memoize (312-313). **§the-named-source-and-README-pair-IS-named-recurring-shape**. **§the-named-pair-pattern-IS-named-extensible**.

§the-named-four-cycle-stay-after-pivot: cycles 310 + 311 + 312 + 313 ALL non-garden @endo/* sources. **§four-cycles-with-named-pivot-domain-stay**. **§the-named-pivot-IS-named-productive-four-cycles-in**.

- **§the-named-Hardened-JavaScript-IS-named-target-environment** (first-explicit-observation):

> Safe function memoization for Hardened JavaScript.

**§the-named-Hardened-JS-IS-named-target-environment-marker**: the one-line opening names the target environment explicitly. **§the-named-Hardened-JS-context-IS-named-discipline-source**: the safety properties of memoize derive from the Hardened-JS context.

§the-named-The-returned-memoized-function-IS-hardened: "The returned memoized function IS hardened, making it safe to use in Hardened JavaScript environments." **§the-named-output-IS-hardened-by-construction**.

§the-named-three-cycle-Hardened-JS-discipline: cycle 310 (Object.freeze as harden stand-in), cycle 312 (harden import directly + three harden call sites), cycle 313 (Hardened JS target explicitly named). **§three-cycles-with-named-Hardened-JS-discipline** (310 + 312 + 313).

- **§the-named-component-of-SES-IS-named-security-scrutiny** (first-explicit-observation):

> This package IS a component of SES and IS subject to the same security scrutiny. Any bug that compromises the safety properties of `memoize` should be reported as a security issue to the [SES security policy].

**§the-named-component-of-SES-IS-named-security-scrutiny**: @endo/memoize IS subject to SES-level security review. **§the-named-security-issue-routing-discipline**: bugs go to SES security policy, not the package issue tracker.

§the-named-cross-package-security-discipline: the README points at `../ses/SECURITY.md` — extends cycle 305 conventions.md's named-cross-cutting discipline to a security context. **§the-named-cross-package-security-routing**.

- **§the-named-Usage-section-IS-named-worked-example** (first-explicit-observation):

```js
import { memoize } from '@endo/memoize';

const expensiveComputation = obj => {
  // ... some costly operation
  return result;
};

const memoizedComputation = memoize(expensiveComputation);

const arg = harden({ data: 'example' });

const result1 = memoizedComputation(arg);
const result2 = memoizedComputation(arg);

result1 === result2; // true
```

**§the-named-API-shown-via-worked-example**. **§the-named-result1-equals-result2-IS-named-memoization-identity-property**: same-input-same-output identity equality. **§the-named-memoization-identity-claim**.

§the-named-harden-the-argument-IS-named-required-discipline: `harden({ data: 'example' })` in the example — arguments must be hardened. **§the-named-arg-must-be-hardened**. **§the-named-Hardened-JS-input-discipline**.

- **§four-named-behavior-properties** (first-explicit-observation):

| # | Property | Description |
|---|---|---|
| 1 | Caching | Results cached per argument identity using WeakMap. |
| 2 | Throws are not memoized | If the wrapped function throws, the exception propagates and no result IS cached. The next call with the same argument will invoke the function again. |
| 3 | Rejected promises are memoized | If the wrapped function returns a rejected promise, that promise IS cached like any other return value. |
| 4 | Invalid keys throw | If an argument IS not a valid WeakMap key (e.g., a primitive string or number), the memoized function throws before invoking the wrapped function. |

**§four-named-behavior-properties**. **§the-named-behavior-section-IS-named-explicit-contract**.

§the-named-throws-vs-rejected-promises-asymmetry: throws are NOT memoized (the function didn't complete); rejected promises ARE memoized (the function returned a value, the value IS a rejected promise). **§the-named-promise-rejection-IS-named-value-not-failure**. **§the-named-completion-vs-non-completion-distinction**. **§the-named-deliberate-asymmetry-IS-named-explicit**.

§the-named-throws-not-memoized-extends-cycle-312: cycle 312's named-exception-cleanup-discipline (memo.delete on fn throw) IS the implementation; cycle 313's named-throws-are-not-memoized IS the README-side documentation. **§two-cycles-with-named-throws-cleanup** (312 impl + 313 doc).

§the-named-invalid-keys-throw-extends-cycle-312: cycle 312's named-dual-purpose-sentinel-set (recursion-protection AND fail-fast-on-invalid-arg) IS the implementation; cycle 313's named-invalid-keys-throw IS the README-side documentation. **§two-cycles-with-named-fail-fast-on-invalid-arg** (312 impl + 313 doc).

- **§the-named-source-TODO-and-README-pointer-pair** (first-explicit-observation):

Cycle 312 (source): `See memoize.md for the Memoization Safety properties of memoize. (TODO turn into link once there's a URL)`.

Cycle 313 (README): `For detailed information about the safety properties of memoize ... see [docs/memoize.md](./docs/memoize.md).`

**§the-named-source-TODO-and-README-pointer-pair-across-cycles**: cycle 312's source had a TODO comment about the missing link; cycle 313's README materializes the link. **§the-named-TODO-resolution-confirmed**: cycle 313 IS evidence the link now exists. **§two-cycles-with-named-deferred-link-status** (312 TODO + 313 materialized).

- **§three-named-memoization-safety-properties** (first-explicit-observation):

> defensiveness, unobservable memoization, and isolation preservation

**§three-named-safety-properties**: defensiveness + unobservable-memoization + isolation-preservation. **§the-named-three-named-named-properties**.

§the-named-named-properties-pointer-without-explanation: the README names the three properties without explaining them here — the explanation IS deferred to `docs/memoize.md`. **§the-named-named-IS-named-without-explaining-discipline**. **§the-named-naming-creates-the-terminology-the-elaboration-fills-it**.

§the-named-unobservable-memoization-IS-the-key-property: a memoized function should be observationally equivalent to the un-memoized function from outside (modulo timing). **§the-named-observational-equivalence**.

- **§the-named-Install-section-IS-named-package-discovery** (first-explicit-observation):

```sh
npm install @endo/memoize
```

vs

```sh
yarn add @endo/memoize
```

**§two-named-package-manager-commands**: npm + yarn. **§the-named-multi-tool-install-discipline**.

- **§the-named-License-section-IS-named-Apache-2.0** (first-explicit-observation):

> [Apache-2.0](./LICENSE)

**§three-cycles-with-named-Apache-2.0-license-confirmation**: 310 nat src (license header) + 311 nat README (badge) + 313 memoize README (license link). **§the-named-Apache-2.0-IS-named-consistent-across-endo-packages**.

- **§six-named-README-sections** (first-explicit-observation): Overview + Usage + Behavior + Memoization Safety + Install + License. **§six-named-canonical-README-sections**. **§the-named-canonical-README-shape-for-endo-packages**.

§the-named-README-shape-IS-named-extends-from-nat-README: cycle 311's nat README also had Overview + Usage + Behavior + History + License + badges. The two READMEs share a shape but with some variation (memoize has Memoization-Safety section; nat has History section). **§two-cycles-with-named-README-shape-variation** (311 + 313). **§the-named-shape-IS-named-tailored-to-package-content**.

- **§the-named-cycle-313-IS-the-companion-README-to-cycle-312-source-and-named-memoization-safety-properties** (first-explicit-observation):

§two-named-instances-of-source-and-README-pair-pattern. **§the-named-pattern-recurs-with-distinct-content**: same shape (source + README), distinct content (validators-vs-coercers for nat, memoization-safety for memoize). **§the-named-shape-recurs-content-varies**.

§four-cycles-with-named-pivot-domain-stay: the named-stay-in-new-domain-after-pivot discipline (cycle 311 named with two cycles) extends to four cycles. **§the-named-stay-discipline-extends-with-each-cycle**.

## Cross-cycle pattern accumulation

- **§four-cycles-with-named-pivot-domain-stay**: 310 + 311 + 312 + 313.
- **§two-named-instances-of-source-and-README-pair-pattern**: nat (310 + 311) + memoize (312 + 313).
- **§three-cycles-with-named-Hardened-JS-discipline**: 310 + 312 + 313.
- **§two-cycles-with-named-throws-cleanup**: 312 impl + 313 doc.
- **§two-cycles-with-named-fail-fast-on-invalid-arg**: 312 impl + 313 doc.
- **§the-named-source-TODO-and-README-pointer-pair-across-cycles**: 312 (TODO comment) + 313 (link materialized).
- **§three-cycles-with-named-Apache-2.0-license-confirmation**: 310 source + 311 nat README + 313 memoize README.
- **§two-cycles-with-named-README-shape-variation**: 311 nat (Overview + Usage + Behavior + History + License + badges) + 313 memoize (Overview + Usage + Behavior + Memoization-Safety + Install + License).

## Notes

- The named-throws-vs-rejected-promises-asymmetry IS structurally interesting: most caching libraries treat both as "the call didn't return a usable value," but `@endo/memoize` deliberately distinguishes the *non-completion* of a throw from the *completion* of a returned-rejected-promise. The asymmetry IS principled: a thrown call has no return value; a returned-rejected-promise IS a returned value that happens to be a promise. **§the-named-principled-asymmetry-discipline**.
- The named-three-named-memoization-safety-properties (defensiveness + unobservable-memoization + isolation-preservation) IS the kind of terminology that becomes vocabulary across the @endo project. Naming creates a shared shorthand that subsequent design discussions can reference without re-explanation. **§the-named-vocabulary-creation-by-naming**.
- The named-source-TODO-and-README-pointer-pair-across-cycles (312 + 313) IS a worked example of how a TODO comment IS resolved over time. Cycle 312's source had `(TODO turn into link once there's a URL)`; the URL now exists and the README has the link. The source itself still carries the TODO comment — a stale-comment opportunity for a future improvement cycle.
- The named-pivot-IS-named-productive-four-cycles-in: with cycles 310-313 all sourcing from @endo/*, the named-deliberate-pivot has produced fresh patterns across four cycles. The cluster pattern surface IS fully refreshed.
