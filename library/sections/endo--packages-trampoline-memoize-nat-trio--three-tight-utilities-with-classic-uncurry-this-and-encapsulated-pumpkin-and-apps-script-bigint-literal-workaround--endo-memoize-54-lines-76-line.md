---
title: "@endo/memoize (54 lines + 76-line README + 176-line docs/memoize.md) — §encapsulated-pumpkin + §four-tier-safety-hierarchy"
source: endo packages/{trampoline,memoize,nat}/{src/*.js,README.md,docs/memoize.md}
source-slug: endo--packages-trampoline-memoize-nat-trio
ingest-cycle: 199
ingest-date: 2026-06-06
lane: chat
authors: [Mark Miller, Kris Kowal, Endo contributors]
related:
  - endo--packages-base64 (cycle 181: §three-tier-dispatch + §Reflect.apply capture sibling)
  - endo--packages-cli-src-utility-cluster (cycle 195: §six-tight-utilities-with-no-internal-dependencies sibling)
  - endo--packages-panic (cycle 197: §Eval-Twin-Problem cross-reference; memoize.md cites endojs/endo#1583)
  - endo--packages-pass-style (cycle 71+: passStyleOf is the §canonical-memoize-user named in memoize.md)
keywords:
  - three-tight-utilities cluster
  - classic-uncurry-this via bind.bind(bind.call)
  - encapsulated-pumpkin sentinel for recursion-protection
  - contingent-safety framing
  - four-tier safety hierarchy (defensiveness / unobservable / preserves-isolation / not-communications-channel)
  - sync/async two-color sharing via generator trampoline
  - generator-throw send-error-into-generator
  - Apps-Script-bigint-literal-workaround
  - two-different-error-types (TypeError type / RangeError range)
  - safely-representable IEEE-754 integer discipline
  - freeze-as-harden-substitute pending PR #3008
parent: endo--packages-trampoline-memoize-nat-trio--three-tight-utilities-with-classic-uncurry-this-and-encapsulated-pumpkin-and-apps-script-bigint-literal-workaround
---

### §The encapsulated-pumpkin idiom

```js
/**
 * Must not escape this module.
 */
const encapsulatedPumpkin = harden({});
```

§The-pumpkin-must-not-escape — the comment is §the-honor-system-discipline (the module's authors commit to never returning `encapsulatedPumpkin` from any export). The empty hardened object is §the-canonical-sentinel: §reference-equality-not-content-equality is the discriminator (`memoedResult === encapsulatedPumpkin`).

§Why-`harden({})`-not-`Symbol()`: §a-hardened-empty-object is §a-valid-WeakMap-key (whereas a primitive Symbol might or might not be one depending on engine version) AND §the-§== Symbol === sentinel approach has §Eval-Twin issues (registered symbols are twin-safe but local symbols are not; the pumpkin pattern is local to the module).

### §Three-uses-of-one-sentinel

The same `memo.set(arg, encapsulatedPumpkin)` line plays three roles:

1. **§Recursion-protection**: §`if (memoedResult === encapsulatedPumpkin) throw new TypeError('no recursion through memoization with same arg')` — if the same arg is seen mid-call (the previous call hasn't yet returned), throw.
2. **§Non-weak-key-compat-early-error**: §`memo.set(arg, encapsulatedPumpkin)` throws synchronously if `arg` isn't a valid WeakMap key. §The-error-is-raised-before-`fn`-is-called (so the user sees a WeakMap error not a confusingly-late mismatch later).
3. **§Try/catch-cleanup-on-fn-throw**: §`try { result = fn(arg); } catch (e) { memo.delete(arg); throw e; }` — if `fn` throws, the recursion-protection marker is removed so a later call can retry. §Throws-from-`fn(arg)`-are-not-memoized; §rejected-promises-returned-by-`fn(arg)`-***are***-memoized (the docs make this distinction explicit).

§One-sentinel-three-purposes is §code-density-with-named-effect. §Each-purpose-would-otherwise-require-its-own-check.

### §The four-tier safety hierarchy in docs/memoize.md

The docs distinguish §four-progressively-stronger-safety-properties, each with §a-list-of-named-requirements:

1. **§Base-semantics**: §Hardened-JS-substrate must hold (WeakMap conforms to spec, methods conform). §`lockdown()` makes this §non-violable post-lockdown.
2. **§Defensiveness**: §`fn` must throw on §invalid-WeakMap-keys and §non-memoization-candidates.
3. **§Unobservable-Memoization**: §three-requirements:
   - §`fn` transitively-immutable-and-powerless (no mutable state, no ability to cause effects).
   - §`fn(arg)` must not cause effects on success; §if-`arg`-is-a-proxy-this-is-hard-to-meet.
   - §`fn(arg)` deterministic: always returns the same result for the same arg.
4. **§Preserving-Isolation** (§not-a-communications-channel): §four-requirements, including §determinism-with-fresh-identity-allowance:
   - §fn transitively-immutable-and-powerless.
   - §fn(arg) returns without effects.
   - §result-objects: §transitively-immutable-and-powerless; §equivalent-aside-from-object-identity; §either-always-same-identity-or-fresh-allocation-per-call.

§The-hierarchy-is-monotonic — each tier strengthens the previous. §The-docs-make-clear-that-§"contingent-safety" framing applies because §the-tooling-cannot-check-or-enforce-the-requirements.

### §passStyleOf cited as the canonical memoize-user

> For example, the function `passStyleOf` from the package `@endo/pass-style` internally uses a memo for a huge efficiency gain, but is nevertheless **defensive / unobservable / not a communications channel**.

§The-docs-name-the-flagship-consumer — §passStyleOf-case-splits-and-only-memoizes-its-internal-algorithm-for-the-WeakMap-key-cases. §passStyleOf-itself-is-not-the-memoFn but rather a wrapper that delegates the WeakMap-key case to an internally-memoized helper.

§Cross-reference: cycle 71+ pass-style ingests confirm passStyleOf uses memoization internally. The memoize.md doc §cites-it-as-the-pattern-to-emulate.

### §The Eval-Twin Problem reference

> But because of JavaScript's [Eval Twin](https://github.com/endojs/endo/issues/1583) problem, such a module should also be prepared to be haphazardly duplicated. Ideally, such a module should act in such a way that its haphazard duplication is unobservable, so when the haphazardness of its duplication changes, those changes are not disruptive.

§Sibling-to cycle 197 @endo/panic which §explicitly-cites-#1583. §The-memoize-doc names the §haphazard-duplication-must-be-unobservable design discipline. §When-twin-duplication-changes-it-should-not-be-disruptive.

### §`harden(memoize)` after `harden(memoFn)`

The module ends with `harden(memoize)` (after the inner `harden(memoFn)` inside the returned closure). §Both-the-factory-and-the-products-are-hardened. §Sibling-pattern to cycle 175 harden-selector and other discipline patterns.
