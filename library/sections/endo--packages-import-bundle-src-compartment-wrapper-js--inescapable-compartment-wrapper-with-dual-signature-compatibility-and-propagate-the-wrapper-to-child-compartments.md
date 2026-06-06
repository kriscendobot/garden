---
source: packages/import-bundle/src/compartment-wrapper.js
source_repo: endojs/endo
source_url: https://github.com/endojs/endo/blob/master/packages/import-bundle/src/compartment-wrapper.js
source_path: packages/import-bundle/src/compartment-wrapper.js
section_kind: source
ingested: 2026-06-05
ingested_by: scholar
contributors:
  - Kris Kowal (prompted)
  - Brian Warner (prompted)
topics:
  - compartments
  - hardened-javascript
  - bundles
genre: §endo-source-comment-fragment §canonical-inescapable-compartment-pattern
cycle: 193
lane: chat
status: current
---

# Inescapable Compartment wrapper with dual-signature compatibility, propagate-the-wrapper-to-child-compartments, and prototype-preserving for instanceof

> §Chat-lane after cycle 192's designs-lane. §The-twenty-
> seventh-consecutive designs/chat alternation cycle (166-
> 193). §First-pivot-this-session: cycle 158 already covered
> loopback.js comprehensively, so I picked compartment-
> wrapper.js (fresh; §sibling-to-cycle-176-endor-architecture's
> §five-embedded-JS-bundles-via-include_str — both deal with
> Compartment-level confinement).

`packages/import-bundle/src/compartment-wrapper.js` (137
lines) implements `wrapInescapableCompartment(OldCompartment,
inescapableTransforms, inescapableGlobalProperties)` — the
§canonical-inescapable-compartment-pattern that lets a parent
impose options that propagate transitively to every child
Compartment.

§The-package-also-ships-a-design-doc: `compartment-wrapper.md`
in the same directory. §The-design-doc-and-the-source-are-
adjacent — a §local-design-doc-pattern that mirrors the
cycle 190-endo-posix-sandbox §source-mirror-to-PLAN pattern
but at the package layer instead of the workspace layer.

§The-single-most-structurally-interesting-move is §five-named-
mechanisms-composed: §dual-signature-compatibility (positional
vs options-bag) + §new.target-required-throw + §propagate-the-
wrapper-to-child-compartments-via-globalThis.Compartment-
reassignment + §prototype-preserving-for-instanceof + §SECURITY-
NOTE-about-non-SES-leak. §Five-moves-in-137-lines.

## §The-§inescapable-options-shape (the design anchor)

> §Compartment-wrapper.md prose (the §local-design-doc):
> "To prevent code from escaping a transform by evaluating
> its code in a new child `Compartment`, the creator of the
> confined compartment must replace its `Compartment`
> constructor with a wrapped version. The wrapper will modify
> the arguments to include the transforms (and other
> options). It must merge the provided options with the
> imposed ones in the right order, to ensure they cannot be
> overridden (i.e. the imposed transforms must appear at the
> *end* of the list). Finally, it must also propogate the
> wrapper itself to the new child Compartment, by modifying
> `c.thisGlobal.Compartment` on each newly created
> compartment."

§Three-named-requirements:

1. §Wrap-the-Compartment-constructor.
2. §Merge-options-in-the-right-order (imposed at the end).
3. §Propagate-the-wrapper to each new child.

§The-§imposed-transforms-must-appear-at-the-end discipline
matches the cycle 190-endo-posix-sandbox §anti-shadowing-rule
(caller-granted mounts land AFTER rootfs-derived $PATH so
they extend but can't override). §Both-are-§order-matters-
for-non-override patterns.

## §dual-signature-compatibility (the §migration-bridge)

```js
// In order to facilitate migration from the deprecated signature
// of the compartment constructor,
//   new Compartent(globals?, modules?, options?)
// to the new signature:
//   new Compartment(options?)
// where globals and modules are expressed in the options bag instead of
// positional arguments, this function detects the temporary sigil __options__
// on the first argument and coerces compartments arguments into a single
// compartments object.
const compartmentOptions = (...args) => {
  if (args.length === 0) {
    return {};
  }
  if (
    args.length === 1 &&
    typeof args[0] === 'object' &&
    args[0] !== null &&
    '__options__' in args[0]
  ) {
    const { __options__, ...options } = args[0];
    assert(
      __options__ === true,
      `Compartment constructor only supports true __options__ sigil, got ${__options__}`,
    );
    return options;
  } else {
    const [
      globals = ({}),
      modules = ({}),
      options = {},
    ] = args;
    assert.equal(
      options.modules,
      undefined,
      `Compartment constructor must receive either a module map argument or modules option, not both`,
    );
    assert.equal(
      options.globals,
      undefined,
      `Compartment constructor must receive either globals argument or option, not both`,
    );
    return {
      ...options,
      globals,
      modules,
    };
  }
};
```

§The-§__options__-sigil is the §temporary-migration-marker.
§The-old-signature: `new Compartment(globals, modules, options)`
(three positional arguments). §The-new-signature: `new
Compartment(options)` (one options-bag with `globals` and
`modules` as fields). §The-`__options__: true` flag in the
first arg signals "this is the new shape" so the wrapper can
disambiguate.

§Three-detection-branches:

1. §Zero-arguments → empty options.
2. §One-argument-with-`__options__`-true → new-shape; spread
   the options.
3. §Otherwise → old-shape; pull positional `globals`, `modules`,
   `options` with defaults.

§Two-double-binding-asserts in the old-shape branch: §`options.
modules`-must-be-undefined (don't pass modules both
positionally and in options) and §`options.globals`-must-be-
undefined (same). §The-double-binding-detection prevents
ambiguous calls.

§Compare-to-cycle-183-init's §LOCKDOWN_OPTIONS-sniff-with-
JSON-parse. §Both-are-§sniff-with-discipline patterns; cycle
193's sniff is §positional-vs-options-shape; cycle 183's is
§global-vs-env-variable.

§Compare-to-cycle-180-hex-package's §transitional-alias-
pattern (re-export `toHex` as `encodeHex`). §Both-are-§two-
signatures-coexist-during-migration patterns.

§The-§assert-message-includes-the-bad-value: "got ${__options__}".
§Diagnostic-discipline (sibling to cycle 177-netstring's
§four-pieces-of-context-per-error).

## §The-§NewCompartment-named-Compartment (the §.name-preservation idiom)

```js
// This is the new Compartment constructor. We name it `Compartment` so
// that it's .name property is correct, but we hold it in 'NewCompartment'
// so that lint doesn't think we're shadowing the original.
const NewCompartment = function Compartment(...args) {
  // ...
};
```

§Two-name-bindings-for-one-function: §the-function-name (used
for `NewCompartment.name === 'Compartment'`) + §the-local-
variable-name (`NewCompartment` so ESLint doesn't flag a
shadow).

§Why-`.name` matters: error messages, stack traces, debugger
displays. §A-wrapped-Compartment-that-says-"NewCompartment"-
in-a-trace would obscure the fact that it's-a-Compartment.

§Why-the-ESLint-workaround: `Compartment` is a free name in
the closure scope; declaring `function Compartment(...)` as a
local would §shadow-the-outer-name. §Lint-disagrees-on-this-
even-though-it's-fine; the §local-variable-named-differently
keeps lint happy.

§Compare-to-cycle-191-zip's §`@ts-expect-error missing
properties from ArrayBuffer` + cycle 188's §`@ts-expect-error
2454`. §Cycle-193-uses-a-naming-workaround instead of a
suppression-comment.

§Compare-to-cycle-146-E.js' §computed-property-key-preserves-
name idiom (`{ [propertyKey](...) {...} }[propertyKey]`). §Both-
are-§preserve-the-name-property patterns at different scales.

§Tier-1-borrowing: §preserve-.name-via-function-name-while-
binding-to-a-different-local for lint-friendly-shadowing.

## §new.target===undefined throw (the §constructor-only-discipline)

```js
// The real Compartment is defined as a class, so 'new Compartment()'
// works but not 'Compartment()'. We can behave the same way. It would be
// nice to delegate the 'throw' to the original constructor by knowing
// calling it the wrong way, but I don't know how to do that.
if (new.target === undefined) {
  // `newCompartment` was called as a function
  throw Error('Compartment must be called as a constructor');
}
```

§The-§new.target-required-check ensures the wrapper-Compartment
can only be called with `new`. §Without-it: a caller could
write `Compartment(...)` (no `new`) and get unexpected
behavior.

§The-comment-acknowledges-a-discipline-gap: "It would be nice
to delegate the 'throw' to the original constructor by
knowing calling it the wrong way, but I don't know how to do
that." §Honest-uncertainty-named-in-comment (sibling to cycle
189-marshal-justin's §honest-uncertainty about double-angle-
brackets).

§The-real-Compartment-is-a-class so §new-is-required; §the-
wrapper-uses-function-syntax (to preserve `.name`); §the-
wrapper-manually-enforces-the-constructor-requirement.

§Compare-to-cycle-146-E.js' §avoid-function-syntax-keeps-it-
non-constructable. §Different-direction: E avoids `new`-ability;
Compartment requires it.

## §Reflect.construct-for-subclass-compatibility

```js
const c = Reflect.construct(OldCompartment, [newOptions], new.target);
```

§Reflect.construct(target, argumentsList, newTarget) lets the
wrapper §forward-the-subclass-target. §If-a-user-subclasses-
NewCompartment as `class MyCompartment extends NewCompartment`,
the `new.target` will be `MyCompartment`, and `Reflect.construct`
preserves that prototype chain.

§Without-Reflect.construct: `new OldCompartment(newOptions)`
would always produce an `OldCompartment` instance, breaking
subclass inheritance.

§Compare-to-cycle-181-base64's §Reflect.apply-captured-at-
module-load. §Both-use-Reflect-method-static-forms; cycle 181
captures `apply` for defensive binding, cycle 193 uses
`construct` for subclass-forwarding.

## §propagate-the-wrapper-to-child-compartments

```js
// The confinement applies to all compartments too. This relies upon the
// child's normal Compartment behaving the same way as the parent's,
// which will cease to be the case soon (their module tables are
// different). TODO: update this when that happens, we need something
// like c.globalThis.Compartment = wrap(c.globalThis.Compartment), but
// there are details to work out.
c.globalThis.Compartment = NewCompartment;
```

§One-line-implementation-with-multi-line-comment. §The-§child-
Compartment's-Compartment-property is overwritten with the
wrapper. §This-propagates-the-inescapable-options to all
transitive children.

§The-comment-names-the-load-bearing-assumption: "This relies
upon the child's normal Compartment behaving the same way as
the parent's, which will cease to be the case soon (their
module tables are different)." §A-§named-TODO with the
specific-shape-of-the-future-fix.

§The-§TODO-with-named-shape pattern: "we need something like
`c.globalThis.Compartment = wrap(c.globalThis.Compartment)`,
but there are details to work out." §The-future-fix-is-sketched
even though not-implemented.

§Compare-to-cycle-189-marshal-justin's §TODO-in-comment naming
known-blockers and cycle 167-where/index.js' §named-TODO
§roaming-AppData-with-content-addressable-state-merge. §All-
three-are-§sketch-the-future-fix-in-source patterns.

## §prototype-preserving for `instanceof` (the canonical move)

```js
// ensure `(c isinstance Compartment)` remains true
NewCompartment.prototype = OldCompartment.prototype;
```

§The-§prototype-aliasing: the wrapper's `.prototype` is set
to the original Compartment's `.prototype`. §This-means
`instanceof NewCompartment === instanceof OldCompartment` —
the wrapped constructor doesn't break `instanceof` checks
elsewhere in the code.

§Why-this-works: `instanceof` walks the prototype chain
looking for the constructor's `.prototype`. §If-NewCompartment-
.prototype === OldCompartment.prototype, then any instance of
either tests true against both constructors.

§Compare-to-cycle-185-check-bundle's §three-class-property-
rejection (no getter properties + no non-string values). §Both-
are-§invariant-preserving-discipline at different layers;
cycle 185 preserves "bundle is a record-of-strings"; cycle
193 preserves "instanceof Compartment".

## §SECURITY-NOTE about non-SES leak (the §honest-discipline-gap)

```js
// SECURITY NOTE: if this were used outside of SES, this might leave
// c.prototype.constructor pointing at the original (untamed) Compartment,
// which would allow a breach. Kris says this will be hard to fix until he
// rewrites the compartment shim, possibly as a plain function instead of a
// class. Under SES, OldCompartment.prototype.constructor is tamed
```

§The-§SECURITY-NOTE-prefix names this comment-block as a
security disclosure. §Two-named-properties:

1. §Outside-of-SES, the wrapper might leak the untamed
   Compartment via `c.prototype.constructor`.
2. §Under-SES, `OldCompartment.prototype.constructor` is
   tamed, so the leak doesn't apply.

§The-§"Kris says" attribution-in-source preserves the
authority chain. §The-§"hard-to-fix-until-rewrite" honesty
names the §deferred-fix without committing.

§Compare-to-cycle-188-perf's §working-copy-inventory (eight
uncommitted change clusters) and cycle 184-metering's §six-
known-gaps. §All-three-are-§named-deferred-fixes-in-source.

§Compare-to-cycle-183-init's §domainTaming-unsafe-always-
injected with §"For now we are resigned to leave this hole
open" comment. §Both-are-§security-disclosure-with-named-
mitigation patterns; cycle 183 names the runtime mitigation
(contract code under XS); cycle 193 names the structural
mitigation (only used under SES).

§Tier-1-borrowing: §SECURITY-NOTE-prefix for §security-
disclosure-comments — distinctive from regular comments;
greppable.

## §Reflect.ownKeys-not-Object.keys (the §full-key-enumeration)

```js
// Use Reflect.ownKeys, not Object.keys, because we want both
// string-named and symbol-named properties. Note that
// Reflect.ownKeys also includes non-enumerable keys.
// This differs from the longer term agreement discussed at
// https://www.youtube.com/watch?v=xlR21uDigGE in these ways:
// ...
for (const prop of Reflect.ownKeys(inescapableGlobalProperties)) {
  Object.defineProperty(c.globalThis, prop, {
    value: inescapableGlobalProperties[prop],
    writable: true,
    enumerable: false,  // properties of globalThis are generally non-enumerable
    configurable: true,
  });
}
```

§Three-key-enumeration-decisions named-in-the-comment:

1. **§Reflect.ownKeys-not-Object.keys**: include symbol-
   named-properties + non-enumerable.
2. **§writable-true + configurable-true + enumerable-false**:
   match the convention for globalThis properties.
3. **§defineProperty-not-assignment**: explicit-descriptor-
   shape rather than implicit defaults.

§The-comment-cites-a-YouTube-discussion (TC39 Compartments
meeting). §URL-attribution-in-source — sibling to cycle 191-
zip's §`@see` URLs to Ralph-Brown-Interrupt-List + cycle 181-
base64's RFC-4648 citation.

§The-comment-also-names-four-deviations from the longer-term
TC39 agreement: §should-be-named-inescapableGlobals + §don't-
support-*Properties-options + §move-to-Compartment-itself +
§following-assign-semantics. §An-§honest-design-evolution-
record at the §implementation-vs-spec layer.

§Compare-to-cycle-185-check-bundle's §gap-between-design-and-
implementation (cycle 180-hex-package design predicted
§retained-at-boundary; actual source migrated). §Cycle-193's
gap is between §implementation and §future-spec rather than
§implementation and §design-document.

## §The-`writable: true`-rationale (the §global-properties-convention)

```js
// properties of globalThis are generally non-enumerable
```

§But-also-§writable. §Why: globalThis properties are usually
writable; otherwise common JS patterns (`globalThis.foo = bar`)
would throw. §The-Compartment-isolates-confined-code-from-the-
outer-realm; within the Compartment, code can reassign
globalThis properties as usual.

§The-§inescapable-defense-is-not-that-the-property-is-
immutable; it's-that-§the-Compartment-constructor-is-
replaced. §If-confined-code-overwrites-`globalThis.WeakMap`,
the next `new Compartment()` will re-install the wrapped
WeakMap from `inescapableGlobalProperties`.

§Compare-to-cycle-175-make-selector.js' §race-to-install-
at-well-known-slot + §pin-on-first-install. §Cycle-193-
compartment-wrapper does §not-pin; the inescapable-defense
relies on §reinstall-per-Compartment instead. §Different-
disciplines for different-threat-models.

## §The-trailing-comment (the §integration-example)

```js
// swingset would do this to each dynamic vat
//  c.globalThis.Compartment = wrapCompartment(c.globalThis.Compartment, ..);
```

§Two-line-trailing-comment names §the-canonical-consumer
(Agoric swingset; "dynamic vats" are Agoric's confined-code
units). §Sibling-to-cycle-187-shim's §three-purpose-prepare-
module which names AVA as the canonical consumer.

§The-comment-is-§integration-example-in-source — not a doctest,
not a usage doc, just a §two-line-hint about how the function
is used downstream.

§Compare-to-cycle-167-where/index.js' §named-TODO §roaming-
AppData-with-content-addressable-state-merge — both are §brief-
sketch-comments at function-end naming downstream-use.

## §The-co-located-design-doc (compartment-wrapper.md)

§The-package-ships-a-design-doc adjacent to the source:
`packages/import-bundle/src/compartment-wrapper.md`. §The-
design-doc-named-the-three-requirements that the source
implements (wrap-constructor + merge-options-in-order +
propagate-wrapper).

§Compare-to-cycle-190-endo-posix-sandbox's §source-mirror-to-
PLAN with §named-update-protocol. §Cycle-193's-co-located-
design-doc is the §smaller-scale variant of that pattern — a
package-level design doc alongside the source, with no
explicit update-protocol but with the §single-file proximity
acting as a §natural-reminder.

§Tier-1-borrowing: §co-located-design-doc-pattern for any
§sub-package-mechanism whose §rationale-deserves-prose
alongside the §implementation-source.

## §Cohesion notes

- §Inescapable-compartment-pattern with §three-named-
  requirements (wrap-constructor + merge-options-in-order +
  propagate-wrapper).
- §Dual-signature-compatibility via §`__options__`-sigil
  detection: §three-detection-branches (zero / new / old) +
  §two-double-binding-asserts in old-shape.
- §`NewCompartment`-as-local-name-but-`Compartment`-as-
  function-name preserves `.name` while satisfying ESLint.
- §`new.target===undefined`-throw enforces constructor-only-
  call with §honest-uncertainty-comment about delegating to
  the real Compartment.
- §`Reflect.construct(OldCompartment, [newOptions], new.target)`
  preserves subclass inheritance.
- §`c.globalThis.Compartment = NewCompartment` propagates the
  wrapper transitively, with §named-TODO about the module-
  table-divergence future-issue.
- §`NewCompartment.prototype = OldCompartment.prototype`
  preserves `instanceof Compartment`.
- §SECURITY-NOTE comment names the non-SES leak with §"Kris
  says"-attribution and §"hard-to-fix-until-rewrite" deferral.
- §`Reflect.ownKeys`-not-`Object.keys` includes symbol-named
  + non-enumerable keys; comment cites a TC39 YouTube
  discussion and names four deviations from longer-term
  agreement.
- §writable: true, configurable: true, enumerable: false for
  globalThis-properties convention.
- §Co-located-design-doc (compartment-wrapper.md) named-three-
  requirements that the source implements.
- §Trailing-comment names §canonical-consumer (Agoric
  swingset / dynamic vats).
- §The-design-doc-and-source-adjacent is the §local-design-
  doc-pattern at package scale (cycle 190 §source-mirror-to-
  PLAN at workspace scale).

## §Tier-1 borrowing

- §inescapable-compartment-wrapper-pattern (§three-named-
  requirements: wrap-constructor + merge-options-in-order +
  propagate-wrapper)
- §__options__-sigil for §dual-signature-compatibility-during-
  migration
- §preserve-.name-via-function-name-while-binding-to-a-
  different-local (lint-friendly shadowing)
- §`new.target===undefined`-throw for §constructor-only-
  discipline
- §`Reflect.construct(...)` for subclass-forwarding (sibling
  to cycle 181 base64's `Reflect.apply` capture)
- §propagate-the-wrapper-via-globalThis-Compartment-
  reassignment (transitive confinement)
- §prototype-aliasing for §instanceof-preserving
- §SECURITY-NOTE-prefix for §security-disclosure-comments
  (greppable; distinctive from regular comments)
- §`Reflect.ownKeys`-not-`Object.keys` for §full-key-
  enumeration (symbols + non-enumerable)
- §named-TODO-with-shape-of-future-fix
- §co-located-design-doc-pattern (compartment-wrapper.md
  alongside compartment-wrapper.js)

## §Synthesis-target

The §slot-machine-library's confinement-layer (if any) can
§borrow-the-inescapable-compartment-wrapper pattern directly.
§Three-named-requirements + §five-mechanisms-composed is the
canonical recipe.

§The-§__options__-sigil pattern is borrowable for any §dual-
signature-migration where a constructor or factory is moving
from positional-args to options-bag. §Detect-the-sigil-on-
arg-zero, branch on its presence.

§The-§SECURITY-NOTE-prefix is borrowable for any §security-
disclosure-comment in source — a §greppable-marker that
distinguishes security-relevant comments from incidental ones.
