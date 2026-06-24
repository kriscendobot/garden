---
title: '@endo/import-bundle: src/compartment-wrapper.js'
source_repo: endojs/endo
source_url: https://github.com/endojs/endo/blob/master/packages/import-bundle/src/compartment-wrapper.js
source_paths:
  - packages/import-bundle/src/compartment-wrapper.js
  - packages/import-bundle/src/compartment-wrapper.md
authors:
  - Kris Kowal (prompted)
  - Brian Warner (prompted)
ingested: 2026-06-05
ingested_by: scholar
topics:
  - compartments
  - hardened-javascript
  - bundles
sections:
  - endo--packages-import-bundle-src-compartment-wrapper-js--inescapable-compartment-wrapper-with-dual-signature-compatibility-and-propagate-the-wrapper-to-child-compartments.md
genre: §endo-source-comment-fragment §canonical-inescapable-compartment-pattern
cycle: 193
lane: chat
---

# @endo/import-bundle/src/compartment-wrapper.js (+ .md)

## §Abstract

137-line source + co-located markdown design doc implementing
`wrapInescapableCompartment(OldCompartment,
inescapableTransforms, inescapableGlobalProperties)` — the
§canonical-inescapable-compartment-pattern. §A-wrapper-
Compartment that imposes options transitively on every child
Compartment, so confined code cannot escape by creating a
new Compartment.

§Five-named-mechanisms-composed:

1. §Dual-signature-compatibility via §`__options__`-sigil
   detection — supports both the deprecated positional
   `new Compartment(globals, modules, options)` and the new
   `new Compartment(options)` shape during migration.
2. §`new.target===undefined`-throw enforces constructor-only-
   call (the real Compartment is a class; `Compartment(...)`
   without `new` should error).
3. §Propagate-the-wrapper-to-child-compartments via
   `c.globalThis.Compartment = NewCompartment` (transitive
   confinement; new child Compartments inherit the wrapper).
4. §Prototype-preserving-for-instanceof via
   `NewCompartment.prototype = OldCompartment.prototype` (so
   `instanceof Compartment` still works elsewhere).
5. §`Reflect.construct(OldCompartment, [newOptions],
   new.target)` for subclass-forwarding.

§Additional-disciplines: §SECURITY-NOTE-prefix in comments
for security-disclosure (non-SES leak); §`Reflect.ownKeys`-
not-`Object.keys` for §full-key-enumeration (symbols + non-
enumerable); §named-TODO with shape-of-future-fix for module-
table-divergence; §co-located-design-doc-pattern (compartment-
wrapper.md alongside compartment-wrapper.js); §writable:true,
configurable:true, enumerable:false for globalThis-properties
convention.

§Canonical-consumer named in trailing comment: Agoric
swingset's "dynamic vats."

## §Files and identifiers

| File | Lines | Role |
|------|-------|------|
| `packages/import-bundle/src/compartment-wrapper.js` | 137 | This source |
| `packages/import-bundle/src/compartment-wrapper.md` | — | Co-located design doc |
| `packages/import-bundle/src/index.js` | 245 | Consumer (not ingested) |

## §Provenance and dependencies

- §Built-on `ses` (the `Compartment` class is provided by SES).
- §Built-on `Reflect.construct` + `Reflect.ownKeys` +
  `Object.defineProperty` (ECMAScript intrinsics; not
  imported).
- §Co-located-design-doc `compartment-wrapper.md` predates
  this analysis and names the §three-requirements that the
  source implements (wrap-constructor + merge-options-in-
  order + propagate-wrapper).
- §Canonical-consumer: Agoric swingset (each "dynamic vat"
  wraps its Compartment via this function).

## §Related sources in the library

- §Cycle 175 (`endo--packages-harden-make-selector-js.md`) —
  §race-to-install-at-well-known-slot pattern. §Cycle-193-
  compartment-wrapper does §not-pin properties; relies on
  §reinstall-per-Compartment for inescapable-defense instead.
- §Cycle 181 (`endo--packages-base64-src-encode-decode-js.md`)
  — §Reflect.apply-captured-at-module-load sibling. §Cycle-
  193 uses `Reflect.construct` for subclass-forwarding.
- §Cycle 183 (`endo--packages-init-and-lockdown.md`) —
  §domainTaming-unsafe-always-injected with §"For now we are
  resigned to leave this hole open" comment. §Both-are-
  §security-disclosure-with-named-mitigation patterns.
- §Cycle 185 (`endo--packages-check-bundle-js.md`) — §three-
  class-property-rejection for §invariant-preserving-
  discipline.
- §Cycle 188 (`endo-but-for-bots--llm-designs-daemon-rust-
  xs-performance.md`) — §working-copy-inventory + §named-
  TODO patterns.
- §Cycle 189 (`endo--packages-marshal-src-marshal-justin-
  and-marshal-stringify-js.md`) — §TODO-in-comment naming
  known-blockers + §honest-uncertainty-named-in-comment.
- §Cycle 190 (`endo-but-for-bots--llm-designs-endo-posix-
  sandbox.md`) — §source-mirror-to-PLAN with §named-update-
  protocol. §Cycle-193's-co-located-design-doc is the
  §package-level variant of that pattern.

## §Comment fragments worth preserving

```
// SECURITY NOTE: if this were used outside of SES, this might leave
// c.prototype.constructor pointing at the original (untamed) Compartment,
// which would allow a breach. Kris says this will be hard to fix until he
// rewrites the compartment shim, possibly as a plain function instead of a
// class. Under SES, OldCompartment.prototype.constructor is tamed
```

§SECURITY-NOTE-prefix for §greppable-security-disclosure.
§"Kris says" attribution-in-source. §"hard-to-fix-until-
rewrite" §honest-deferral.

```
// This is the new Compartment constructor. We name it `Compartment` so
// that it's .name property is correct, but we hold it in 'NewCompartment'
// so that lint doesn't think we're shadowing the original.
```

§Preserve-.name-via-function-name-while-binding-to-a-
different-local (lint-friendly shadowing).

```
// The confinement applies to all compartments too. This relies upon the
// child's normal Compartment behaving the same way as the parent's,
// which will cease to be the case soon (their module tables are
// different). TODO: update this when that happens, we need something
// like c.globalThis.Compartment = wrap(c.globalThis.Compartment), but
// there are details to work out.
```

§Named-TODO with §shape-of-future-fix sketched-in-comment.
§The-load-bearing-assumption-named (child's Compartment
behaves same as parent's).

```
// Use Reflect.ownKeys, not Object.keys, because we want both
// string-named and symbol-named properties. Note that
// Reflect.ownKeys also includes non-enumerable keys.
// This differs from the longer term agreement discussed at
// https://www.youtube.com/watch?v=xlR21uDigGE in these ways:
```

§URL-attribution-in-source (TC39 Compartments meeting). §Four-
deviations-from-longer-term-agreement named explicitly.

```
// swingset would do this to each dynamic vat
//  c.globalThis.Compartment = wrapCompartment(c.globalThis.Compartment, ..);
```

§Trailing-comment-as-integration-example. §Named-canonical-
consumer (Agoric swingset / dynamic vats).
