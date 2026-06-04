---
source: packages/harden/make-selector.js
source_repo: endojs/endo
source_url: https://github.com/endojs/endo/blob/master/packages/harden/make-selector.js
source_path: packages/harden/make-selector.js
section_kind: source
ingested: 2026-06-03
ingested_by: scholar
contributors:
  - Mark S. Miller (prompted)
topics:
  - hardened-javascript
  - patterns
  - tooling
genre: §endo-source-comment-fragment
cycle: 175
lane: chat
status: current
---

# Race to install harden at Object @harden with three-tier lookup and pin on first install

> §Chat-lane after cycle 174's designs-lane. §Endo-source-
> comment-fragment genre. **§Cycle-108's-coordinated-update-
> commit-e56bf00f-anchor**: the §adopt-@endo/harden
> discipline that triggered the 15-file e56bf00f cluster
> (cycles 108/110/115/118/123/125/132/134/138/140/144/167/
> 169/171/173) traces back to this file's selector.

`packages/harden/make-selector.js` (69 lines) implements
the **§race-to-install-harden-at-a-well-known-slot**
mechanism. The single most structurally interesting move
is the **§three-tier-lookup** (`Object[@harden]` →
`globalThis.harden` → fresh make) that lets multiple
harden implementations coexist while §pinning-the-first-
to-arrive.

## §Why-this-file-exists

§Multiple-`@endo/harden`-implementations-may-load in the
same realm: the "unsafe" no-op variant, the "shallow"
default, the SES lockdown-installed `harden`. They race
to install at a well-known slot; the first wins.

§Without-a-coordinated-slot: each importer would get its
own `harden`, breaking the §harden-everywhere-with-the-
same-function invariant. §Object-identity-of-harden-
matters for SES's WeakSet-based bookkeeping.

§The-coordination-protocol is this file: a §race-with-
last-resort-fresh-make.

## §The-well-known-slot: `Object[Symbol.for('harden')]`

```js
const symbolForHarden = Symbol.for('harden');
```

§Symbol.for(name)-is-realm-cross-cutting: the same symbol
across all packages that look it up by this name.
§Different-from-unique-symbol: §Symbol.for-is-the-
canonical-registered-symbol.

§Why-on-Object-not-globalThis: §Object-is-the-realm-
canonical-base-class; §every-realm-has-it. §Putting-
harden-here makes it discoverable from any code that has
`Object`.

§Cycle-142's-passStyle-helpers-PASS_STYLE used the same
`Symbol.for(name)` pattern. §Registered-symbols-as-
canonical-slots is the §coordination-via-registered-
symbols discipline.

## §Three-tier-lookup (the master move)

```js
const selectHarden = () => {
  // Tier 1: Object[@harden]
  const { [symbolForHarden]: objectHarden } = Object;
  if (objectHarden) {
    if (typeof objectHarden !== 'function') throw Error(...);
    return objectHarden;
  }

  // Tier 2: globalThis.harden
  const { harden: globalHarden } = globalThis;
  if (globalHarden) {
    if (typeof globalHarden !== 'function') throw Error(...);
    return globalHarden;
  }

  // Tier 3: fresh make + pin
  const harden = makeHardener();
  Object.defineProperty(Object, symbolForHarden, {
    value: harden,
    configurable: false,
    writable: false,
  });
  return harden;
};
```

§Three-tier-lookup-with-fallthrough:

| Tier | Source | When |
|------|--------|------|
| 1 | `Object[@harden]` | New convention; this file's preferred slot |
| 2 | `globalThis.harden` | HardenedJS / SES legacy convention |
| 3 | Fresh `makeHardener()` | Neither exists; install + pin |

§Each-tier-falls-through-to-the-next. §New-then-legacy-
then-make. §Backward-compatible-with-three-flavors.

§Type-check-the-existing-implementation: if the slot is
populated but not a function, throw. §Defensive-against-
collisions with code that put something else in the slot.

§The-throw-message-tells-you-what-was-expected: `@endo/
harden expected callable Object[@harden]`. §Helpful-
diagnostic for the bug.

## §Pin-on-first-install (tier 3)

```js
Object.defineProperty(Object, symbolForHarden, {
  value: harden,
  configurable: false,
  writable: false,
});
```

§Non-configurable-and-non-writable: §nobody-can-replace-
this-later, not even the same code re-importing.

§Why-this-matters: §later-imports-find-it-via-tier-1 (no
fresh make). §The-harden-identity-is-stable across all
later imports.

§The-comment-warns:

> *We should not reach this point if a harden
> implementation already exists here. The non-
> configurability of this property will prevent any
> HardenedJS's lockdown from succeeding. Versions that
> predate the introduction of Object[@harden] will be
> unable to remove the unknown intrinsic. Versions that
> permit Object[@harden] fail explicitly.*

§Explicit-incompatibility-with-pre-Object[@harden]-
HardenedJS-versions. §Honest-warning: pinning this slot
on an older HardenedJS implementation will *break*
lockdown.

§The-trade-off: §forward-compat-via-pin vs §backward-
compat-via-non-installation. §This-file-chooses-forward-
compat.

## §Lazy-initialization-via-IIFE-closure

```js
let selectedHarden;

const harden = object => {
  if (!selectedHarden) {
    selectedHarden = selectHarden();
  }
  return selectedHarden(object);
};
Object.freeze(harden);
```

§Lazy-first-call: §selectHarden-runs-once-per-instance.
§Subsequent-calls-skip-the-tier-walk.

§Why-lazy: §at-module-load-time-Object[@harden]-may-not-
yet-be-installed. §SES-might-be-loading-in-parallel.
§Defer-the-selection-until-first-actual-use.

§Object.freeze(harden) on the wrapper: §the-selector-
itself-cannot-be-modified. §Defensive-harden-of-the-
harden-selector.

§Two-levels-of-defensiveness: the wrapper is frozen; the
underlying harden (if from tier 3) is pinned in
Object[@harden].

## §Why-the-IIFE-not-just-immediate-call

§Race-window: between this module's load and `harden`'s
first call, another module might install harden. §Don't-
race-at-module-load; §race-at-first-call.

§Cycle-138's-safe-promise has a similar §defer-to-first-
use pattern but for different reasons (avoid Promise.
prototype reentrancy at load time). §Two-different-
reasons-for-deferred-evaluation.

§The-IIFE-makes-the-tier-walk-cheap-after-first-call:
§selectedHarden-is-the-fast-path.

## §No-harden-of-the-result

Notice: the wrapper *doesn't* harden the result of
calling the underlying harden. The underlying harden
already returns its argument (typically the same object,
post-harden); the wrapper just forwards.

§Pass-through-by-design: §the-wrapper-is-a-selector-not-
a-transformer. §Any-transformation-is-the-underlying-
harden's-job.

§The-only-thing-the-wrapper-adds: §the-tier-walk-on-
first-call.

## §Race-semantics-when-multiple-implementations-load

Suppose `@endo/harden` and `@endo/harden` (different
versions) both load in the same realm:

1. First-loader calls `makeHardenerSelector(makeA)`.
2. `harden` is exported but not yet called.
3. Second-loader calls `makeHardenerSelector(makeB)`.
4. `harden` is exported but not yet called.
5. First call to either: tier walk → both tier 1 and tier
   2 empty → makeA runs (or makeB, depending on call
   order) → pin.
6. Subsequent calls (from either loader): tier 1 finds
   the pinned harden. §Both-loaders-share-the-same-
   harden.

§Object-identity-equality across loaders: §`hardenA ===
hardenB`-after-first-call.

§The-pin-makes-the-race-resolve-once. §No-double-install.
§No-tug-of-war.

## §Comparison-with-cycle-108's-coordinated-update

Cycle 108 noted the §adopt-`@endo/harden` migration across
the @endo monorepo (commit `e56bf00f`). The §harden-import
discipline introduced *because* of this file:

```js
import harden from '@endo/harden';
```

§Every-file-imports-its-own-harden. §The-selector-makes-
them-all-be-the-same-harden-instance at runtime.

§Cycle-108's-15-file-cluster (now grown to cycles 108/
110/115/118/123/125/132/134/138/140/144/167/169/171/173)
all import from this package. §The-coordinated-update is
visible because every file got the same import-discipline
applied simultaneously.

## §The-throw-on-non-function discipline

```js
if (typeof objectHarden !== 'function') {
  throw new Error('@endo/harden expected callable Object[@harden]');
}
```

§Fail-loud-on-corruption: §if-something-else-took-the-
slot-throw. §Don't-silently-fall-through.

§Why-loud-not-silent: §the-slot-has-a-known-purpose; if
something else is there, §the-program-state-is-broken.
§Better-to-throw-at-first-call-than-to-silently-use-the-
wrong-function.

§The-two-error-messages-are-symmetric: tier 1 and tier 2
both throw the same shape, with different slot names.

## §The-non-configurability-is-load-bearing

§Non-configurable-and-non-writable together mean: §the-
property-cannot-be-removed-or-replaced.

§Why-both: `writable: false` blocks `Object[@harden] =
...`; `configurable: false` blocks `delete Object[@harden]`
and `defineProperty(...)` overrides.

§Both-needed because §JavaScript-has-two-mutation-paths
for own properties.

§The-result: §once-this-line-runs-the-slot-is-permanent
for the lifetime of the realm.

## §The-globalThis-fallback-is-the-legacy-bridge

> *`// @ts-ignore globalThis.harden is a HardenedJS
> convention`*

§HardenedJS-convention: `globalThis.harden` is what SES's
lockdown() installs. §Pre-`@endo/harden` code looked
there.

§This-selector-bridges-the-two-conventions: §accept-
either-and-make-them-equivalent. §No-need-to-rewrite-
existing-code that uses `globalThis.harden`.

§Migration-aided-by-bridge: §existing-`globalThis.harden`-
code-continues-to-work; §new-code-uses-`Object[@harden]`-
directly-via-this-selector.

## §Gap-revealing-comparison with garden cycles

| Cycle | Connection |
|-------|------------|
| 108 (coordinated update) | §This-file-is-the-anchor-of-the-e56bf00f-cluster |
| 142 (passStyle-helpers) | §Symbol.for(name)-as-coordination-slot sibling |
| 138 (safe-promise) | §Defer-to-first-use sibling (different reason) |
| 167 (where/index.js) | §Small-files-with-large-knowledge-density sibling |
| 169 (atomics.js) | §Same |
| 171 (stream/index.js) | §Same |
| 173 (promise-executor-kit.js) | §Same — sixth member of the family |
| 98 (assert.js) | §SES-substrate sibling; assert.js coordinates errors, this coordinates harden |

## §Tier-1 vocabulary borrowing candidates

§Race-to-install-at-well-known-slot (multiple
implementations coordinate via a shared symbol).

§Three-tier-lookup-with-fallthrough (Object[@harden] →
globalThis.harden → fresh make).

§Pin-on-first-install (non-configurable + non-writable to
prevent replacement).

§Defer-to-first-use (lazy IIFE-closure pattern).

§Symbol.for(name)-as-coordination-slot (registered
symbols cross realm boundaries cleanly).

§Type-check-the-existing-implementation (defensive against
collisions; fail loud not silent).

§Fail-loud-on-corruption-with-helpful-diagnostic-message.

§Tier-2: §legacy-bridge-via-fallback (accept both old and
new conventions during migration), §forward-compat-via-
pin-vs-backward-compat-via-non-installation (honest
trade-off).

## §Synthesis-target

§Slot-machine-library may need similar §coordination-
mechanism if multiple modules want to install the same
service. The §race-to-install-at-well-known-slot pattern
is borrowable for any module that needs a §singleton-
service-across-realm.

§Symbol.for(name)-as-coordination-slot is the §portable-
way-to-share-state-across-modules-without-a-direct-
dependency.

## §Small-file-but-foundational

69 lines. §The-coordination-protocol-for-harden-is-here.
§Every-other-@endo-file's `import harden from '@endo/
harden'` flows through this selector.

§Sixth-member-of-the-§small-files-with-large-knowledge-
density family:
- Cycle 165: ocap-kernel platform-specific.md (92 lines)
- Cycle 167: @endo/where/index.js (115 lines)
- Cycle 169: @endo/captp/atomics.js (170 lines)
- Cycle 171: @endo/stream/index.js (247 lines)
- Cycle 173: @endo/promise-kit/src/promise-executor-kit.js
  (55 lines)
- Cycle 175: @endo/harden/make-selector.js (69 lines)

§Pattern-confirmed: §the-substrate-files-are-often-the-
shortest. §Reading-the-shortest-files-tells-you-the-
substrate.

§Authored-by-Mark-S.-Miller — same author as cycle 90
(track-turns.js) + cycle 96 (console.js) + cycle 106
(tame-console.js) + cycle 150 (typeGuards.js). §Five-
Mark-Miller-files-now-ingested.
