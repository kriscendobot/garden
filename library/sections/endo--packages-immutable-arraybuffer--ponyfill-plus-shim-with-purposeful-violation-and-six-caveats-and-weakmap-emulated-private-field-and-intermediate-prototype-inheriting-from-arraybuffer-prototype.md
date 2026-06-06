---
title: §Ponyfill-plus-shim with §Purposeful-Violation-section + §six-named-caveats + §WeakMap-as-emulated-private-field-because-Hermes-no-class-private-fields + §intermediate-prototype-inheriting-from-ArrayBuffer-prototype + §three-platform-degradation-with-known-deficient-platforms-named + §by-copy-network-protocol-rationale + §ROM-vs-RAM-Moddable-XS-rationale + §concordance-sniff-defense-via-toStringTag — @endo/immutable-arraybuffer
source: endo packages/immutable-arraybuffer/{src/immutable-arraybuffer-pony.js,src/immutable-arraybuffer-shim.js,README.md}
source-slug: endo--packages-immutable-arraybuffer
ingest-cycle: 201
ingest-date: 2026-06-06
lane: chat
authors: [Mark Miller, Kris Kowal, Endo contributors]
related:
  - endo--packages-panic (cycle 197: ponyfill+shim distinction sibling; both with caveat-emptor)
  - endo--packages-pass-style (cycle 71+: pass-style substrate that this enables — immutable bulk binary data)
  - endo--packages-marshal-src-marshal-justin-and-marshal-stringify-js (cycle 189: marshal substrate; this enables ByteArray pass-style)
  - endo--packages-trampoline-memoize-nat-trio (cycle 199: §minimal-dependency-discipline sibling; @endo/marshal aspiration)
  - endo--packages-harden-make-selector-js (cycle 175: §pin-on-first-install — this design's §shim-installs-without-pin-with-warning is the inverse)
keywords:
  - ponyfill-plus-shim pattern (sibling to cycle 197 panic)
  - Purposeful-Violation section in README
  - concordance-sniff-defense via Symbol.toStringTag
  - six-named-Caveats
  - WeakMap-as-emulated-private-field (Hermes-no-class-private-fields)
  - intermediate-prototype-inheriting-from-ArrayBuffer-prototype
  - five-throw-methods (resize / transfer / transferToFixedLength / transferToImmutable + slice-stays-mutable)
  - six-getter-overrides (byteLength / detached / maxByteLength / resizable / immutable / toStringTag)
  - structuredClone-or-transfer-fallback
  - three-platform-degradation (Hermes / Node ≤16 / some JavaScriptCore)
  - capture-before-scuttled (pre-lockdown discipline)
  - method-binding-pre-defineProperty (avoid-post-hoc-prototype-lookups)
  - by-copy-network-protocol-rationale (immutable bulk binary data)
  - ROM-vs-RAM Moddable-XS rationale (place voluminous fixed data into ROM)
  - zero-length-slice-as-genuine-ArrayBuffer-enforcement
  - modern-shim-practice-frowns-on-conditional-installation
  - shim-still-runs-after-native-implementation (deliberate-policy-with-named-future-cleanup-step)
  - belt-and-suspenders freeze on must-not-escape factory
  - brand-check via WeakMap.has(this)
  - cycle 201 milestone (post-cycle-200)
  - nineteenth-member of small-files-with-large-knowledge-density family
  - thirty-fifth consecutive designs/chat alternation cycle 166-201
---

# @endo/immutable-arraybuffer — §ponyfill+shim + §Purposeful-Violation + §six-named-Caveats + §WeakMap-as-emulated-private-field + §intermediate-prototype-inheriting-from-ArrayBuffer-prototype + §three-platform-degradation + §by-copy-network-protocol-rationale + §ROM-vs-RAM-Moddable-XS-rationale

## Source

- `endo packages/immutable-arraybuffer/src/immutable-arraybuffer-pony.js` — 253 lines (ponyfill: `transferBufferToImmutable`, `sliceBufferToImmutable`, `isBufferImmutable`)
- `endo packages/immutable-arraybuffer/src/immutable-arraybuffer-shim.js` — 97 lines (shim: installs `sliceToImmutable`, `immutable`, `transferToImmutable` on `ArrayBuffer.prototype`)
- `endo packages/immutable-arraybuffer/README.md` — 75 lines
- Cycle 201 of `/loop resume the librarian work.` (chat-lane; alternates from cycle 200's designs-lane milestone worker-rust-xs; §thirty-fifth consecutive designs/chat alternation cycle 166-201)

§Nineteenth-member of §small-files-with-large-knowledge-density family (cycles 165-201 chat-lane).

## Single most structurally interesting move

§Ponyfill-plus-Shim pattern (sibling to cycle 197 @endo/panic) + §Purposeful-Violation section explicitly named in the README + §WeakMap-as-emulated-private-field-because-Hermes-no-class-private-fields + §intermediate-prototype-`ImmutableArrayBufferInternalPrototype`-inheriting-from-ArrayBuffer.prototype + §three-platform-degradation-with-known-deficient-platforms-named (Hermes / Node ≤16 / some JavaScriptCore) + §by-copy-network-protocol-rationale combined with §ROM-vs-RAM-Moddable-XS-rationale as §two-named-motivations.

§The-emulated-immutable-buffers-inherit-from-ArrayBuffer.prototype-transitively, so §`x instanceof ArrayBuffer`-acts-as-proposed. §The-emulated-internal-class-prototype is §an-artifact-of-the-emulation-not-encapsulated — §trivially-discoverable-as-the-object-emulated-immutable-buffers-directly-inherit-from. §Honest-about-the-emulation's-leaky-edges.

## §Ponyfill+Shim pattern (sibling to cycle 197 panic)

§The-package-exports-both-shapes:
- **§Ponyfill** (`index.js` → `src/immutable-arraybuffer-pony.js`): §defines-and-exports-new-things-without-modifying-old-things. Exports `transferBufferToImmutable(buffer)`, `sliceBufferToImmutable(buffer, start?, end?)`, `isBufferImmutable(buffer)` as standalone functions. §A-ponyfill-by-definition-cannot-add-to-ArrayBuffer.prototype, so it must expose §brand-new-functions.
- **§Shim** (`shim.js`): §modifies-the-existing-JavaScript-primordials-as-needed. Trivially derived from the ponyfill's exports. Imports `@endo/immutable-arraybuffer/shim.js` §will-cause-the-prototype-additions.

§Cycle-197-@endo/panic-was-ponyfill-only — the panic README explicitly defers the shim "until the proposal gets farther along in the tc39 stage process". §Cycle-201-@endo/immutable-arraybuffer-is-ponyfill-plus-shim — both shapes shipped simultaneously because §the-proposal's-status allows both.

§Two-named-policies-for-the-shim:
- §Modern-shim-practice-frowns-on-conditional-installation (at least for proposals prior to stage 3): §so-changes-to-the-proposal-since-an-old-shim-was-distributed-don't-need-to-worry-about-the-proposal-breaking-old-code-depending-on-the-old-shim. §If-we-detect-a-prior-installation, §warn-and-continue (overwriting).
- §Shim-still-runs-after-native-implementation: §"current-code-will-still-replace-it-with-the-shim-implementation, in-accord-with-shim-best-practices". §Will-require-a-later-manual-step-to-delete-the-shim, after-manual-analysis-of-the-compat-implications.

§Borrowable-pattern: §deliberate-policy-with-named-future-cleanup-step. §The-design-acknowledges-the-shim-is-not-the-end-state and §names-the-cleanup-step-explicitly.

## §Purposeful Violation section — concordance-sniff-defense

The README has §an-explicitly-named-section called **§Purposeful Violation**:

> Since the `ImmutableArrayBufferInternal` class is only an artifact of the ponyfill and shim (i.e., is absent both from the real proposal and from native implementations), `ImmutableArrayBufferInternal` should not need its own `Symbol.toStringTag` property. Especially not one that differs from `ArrayBuffer.prototype`. Adding one reduces the fidelity of the ponyfill and shim. Nevertheless, we set `ImmutableArrayBufferInternal.prototype[Symbol.toStringTag]` to `'ImmutableArrayBuffer'`. Why?
>
> At [concordance describe.js#L36] Node's concordance, in order to render diagnostic output for an object, sniffs the result of `toString()`. If the result seems to indicate that the object is an ArrayBuffer, then concordance assumes it can do things with the object (`Buffer.from`) that can only be done on genuine ArrayBuffers. To avoid this, the ponyfill and shim ensures that the sniff will not match `'ArrayBuffer'`.
>
> Ava also uses Node's concordance for its diagnostic output, which is how we discovered the problem.

§Purposeful-Violation as §a-README-section-shape is §a-rare-pattern in the library — §an-explicit-named-acknowledgment that §the-implementation-deviates-from-fidelity for §a-named-pragmatic-reason. §Concordance-sniff-defense is §the-named-pragmatic-reason; §Ava-uses-concordance is §how-it-was-discovered.

§The-pattern: §when-you-must-violate-fidelity-name-the-violation-and-its-rationale. §Sibling-to cycle 197 panic's §"defer-to-the-whose-shim-ran-first" typo-preservation (the source is honest about its imperfections) and cycle 196 endoclaw's §"contitues-a-claw" typo-preservation. §Honest-source-discipline at different scales.

§Borrowable-pattern: §Purposeful-Violation-section in README documenting §named-deliberate-deviations from §the-fidelity-target.

§Sibling-pattern to cycle 198 patterns-diagnostic-feedback's §the-data-is-already-there-just-locked discovery: both designs §explicitly-name-the-cost-of-a-design-choice. §198-names-a-discovery-driven-redesign; §201-names-a-fidelity-violation-driven-defense.

## §Six-named Caveats — honest enumeration of limitations

The README has §six-named-Caveats explicitly listed:

1. **§Platform-degradation**: ponyfill+shim rely on either `structuredClone` or `ArrayBuffer.prototype.transfer`. §Hermes / Node ≤16 / some JavaScriptCore versions have neither. §On-such-platforms the ponyfill and shim §fail-to-initialize.
2. **§No-intermediate-prototype-in-the-proposal**: the proposal modifies `ArrayBuffer.prototype` itself. §The-ponyfill-and-shim's-emulated-immutable-buffers-inherit-directly-from-an-intermediate-prototype. §Differential-behavior-via-overrides on `immutableArrayBufferPrototype`.
3. **§Intermediate-prototype-discoverable**: §the-intermediate-prototype is §an-artifact-of-the-emulation but is §not-encapsulated. §Trivially-discoverable as the object emulated immutable buffers directly inherit from.
4. **§Not-real-exotic-objects**: §the-shim's-emulated-immutable-buffers-are-not-real-ArrayBuffer-exotic-objects. §If-they-were, §the-shim-would-not-be-able-to-protect-them-from-being-written. §Cannot-be-plug-compatible — §cannot-be-used-as-the-backing-stores-of-DataViews-or-TypedArrays. §Follow-on-shims-might-modify-DataView-and-TypedArray (but §hard-and-beyond-the-ambition-of-this-ponyfill+shim).
5. **§Cannot-be-cloned-or-transferred-between-JS-threads** unlike genuine ArrayBuffer or SharedArrayBuffer.
6. **§Shim-still-runs-after-native-implementation** (the deliberate policy named earlier).
7. **§Not-hardened-by-itself** — §plain-JavaScript-ponyfill/shim, §not-Hardened-JavaScript-polyfill/shim. §The-ses-shim-is-expected-to-import-these and §treat-the-resulting-objects-as-additional-primordials, §to-be-hardened-during-lockdown's-harden-phase.

§Seven-Caveats actually — README says six but I count seven distinct named limitations. §The-enumeration-is-greppable and §each-caveat-names-its-shape.

§Borrowable-pattern: §named-Caveats-section as §honest-enumeration-of-limitations. §Sibling-pattern to cycle 197 panic's §caveat-emptor-at-the-end (single caveat) vs cycle 201's §enumerated-Caveats (six+).

## §WeakMap-as-emulated-private-field — Hermes-no-class-private-fields

```js
/**
 * If we could use classes with private fields everywhere, this would have
 * been a `this.#buffer` private field on an `ImmutableArrayBufferInternal`
 * class. But we cannot do so on Hermes. So, instead, we
 * emulate the `this.#buffer` private field, including its use as a brand check.
 * Maps from all and only emulated Immutable ArrayBuffers to real ArrayBuffers.
 */
const buffers = new WeakMap();
```

§Explicit-honest-acknowledgment that §the-natural-shape-would-be-class-private-fields but §Hermes-doesn't-support-them. §WeakMap-emulates-private-field-AND-brand-check simultaneously.

§Sibling-pattern: cycle 199 @endo/memoize's §encapsulated-pumpkin-sentinel (`harden({})` "must not escape this module") + cycle 197 panic's §registered-symbol + §local-symbol-vs-Eval-Twin-Problem. §Three-different-ways-to-emulate-private-state in §JavaScript-without-class-private-fields:
- §Pumpkin-sentinel (cycle 199): §reference-equality-marker.
- §Registered-symbol (cycle 197): §Symbol.for crossing twin boundaries.
- §WeakMap (cycle 201): §key-based-lookup with §brand-check via §has().

§The-WeakMap-approach is §the-only-one-that-also-serves-as-brand-check by-construction.

§Borrowable-pattern: §WeakMap-as-emulated-private-field-AND-brand-check when §class-private-fields-are-not-available.

§Method-binding-pre-defineProperty:

```js
for (const methodName of ['get', 'has', 'set']) {
  defineProperty(buffers, methodName, { value: buffers[methodName] });
}
```

§Avoid-post-hoc-prototype-lookups: §the-WeakMap's-own-`get`/`has`/`set` methods are pinned as own properties (vs inherited from `WeakMap.prototype`). §Defense-against-prototype-tampering after pre-lockdown imports. §Sibling-pattern to cycle 199 trampoline's §classic-uncurry-this and cycle 181 base64's §Reflect.apply-defensive-binding.

## §Five-throw-methods + §six-getter-overrides on the intermediate prototype

```js
const ImmutableArrayBufferInternalPrototype = {
  __proto__: arrayBufferPrototype,
  get byteLength() { return apply(arrayBufferByteLength, getBuffer(this), []); },
  get detached() { getBuffer(this); return false; },
  get maxByteLength() { return apply(arrayBufferByteLength, getBuffer(this), []); },
  get resizable() { getBuffer(this); return false; },
  get immutable() { getBuffer(this); return true; },
  slice(start, end) { return arrayBufferSlice(getBuffer(this), start, end); },
  sliceToImmutable(start, end) { return sliceBufferToImmutable(getBuffer(this), start, end); },
  resize(_newByteLength) { getBuffer(this); throw TypeError('Cannot resize an immutable ArrayBuffer'); },
  transfer(_newLength) { getBuffer(this); throw TypeError('Cannot detach an immutable ArrayBuffer'); },
  transferToFixedLength(_newLength) { getBuffer(this); throw TypeError('Cannot detach an immutable ArrayBuffer'); },
  transferToImmutable(_newLength) { getBuffer(this); throw TypeError('Cannot detach an immutable ArrayBuffer'); },
  [toStringTag]: 'ImmutableArrayBuffer',
};
```

§Six-getter-overrides (`byteLength`, `detached`, `maxByteLength`, `resizable`, `immutable`, plus `toStringTag` data property) + §five-method-overrides (`slice` returns mutable copy, `sliceToImmutable` returns immutable, `resize`/`transfer`/`transferToFixedLength`/`transferToImmutable` all throw with shape-specific message).

§Brand-check-via-`getBuffer(this)` on every accessor — even the §getters-that-don't-need-the-buffer-value (`detached`, `resizable`, `immutable`) §call-`getBuffer(this)`-for-the-brand-check-side-effect. §The-getter-must-fail-if-called-on-a-non-emulated-instance.

§Two-distinct-throw-messages: §"Cannot-resize-an-immutable-ArrayBuffer" for resize; §"Cannot-detach-an-immutable-ArrayBuffer" for the three transfer-* methods. §Two-error-categories with named-rationale.

§Slice-stays-mutable distinguishes from §sliceToImmutable: §`buffer.slice(0, 100)` on an immutable buffer §still-returns-a-mutable-copy (matching ArrayBuffer.prototype.slice's behavior); §`buffer.sliceToImmutable(0, 100)` returns a §new-immutable. §The-symmetry: §`transferToImmutable` for transfer; §`sliceToImmutable` for slice; §both-named-with-the-same-pattern.

## §structuredClone-or-transfer-fallback

```js
let optArrayBufferTransfer;

if (optTransfer) {
  optArrayBufferTransfer = arrayBuffer => apply(optTransfer, arrayBuffer, []);
} else if (optStructuredClone) {
  optArrayBufferTransfer = arrayBuffer => {
    // Hopefully, a zero-length slice is cheap, but still enforces that
    // `arrayBuffer` is a genuine `ArrayBuffer` exotic object.
    arrayBufferSlice(arrayBuffer, 0, 0);
    return optStructuredClone(arrayBuffer, { transfer: [arrayBuffer] });
  };
} else {
  optArrayBufferTransfer = undefined;
}
```

§Three-tier-fallback: §`ArrayBuffer.prototype.transfer` (modern Node 21+) → §`structuredClone({transfer: [...]})` (Node 17+) → §undefined (graceful degradation, ponyfill+shim fail to initialize).

§Sibling-pattern to cycle 197 panic's §three-layer-dispatch-chain (console.error → globalThis[PanicEndowmentSymbol] → process.abort → globalThis.panic → throw). §Both-designs §enumerate-mechanisms-from-best-to-degraded with §explicit-named-fallbacks.

§Zero-length-slice-as-genuine-ArrayBuffer-enforcement (`arrayBufferSlice(arrayBuffer, 0, 0)` before structuredClone): §the-side-effect-is-enforcing-that-arrayBuffer-is-a-genuine-ArrayBuffer-exotic-object (slice would throw on a non-exotic). §`Hopefully-a-zero-length-slice-is-cheap` — §honest-comment-naming-the-cost-uncertainty.

§Borrowable-pattern: §method-call-as-type-enforcement-side-effect when §the-thrown-error-from-the-method-is-the-desired-validation. §Sibling-pattern to cycle 199 memoize's §non-weak-key-compat-early-error (try `memo.set(arg, ...)` so the WeakMap throws if arg isn't a valid key).

## §Capture-before-scuttled (pre-lockdown discipline)

```js
const {
  ArrayBuffer,
  Object,
  Reflect,
  Symbol,
  TypeError,
  Uint8Array,
  WeakMap,
  // Capture structuredClone before it can be scuttled.
  structuredClone: optStructuredClone,
} = globalThis;
```

§"Capture-structuredClone-before-it-can-be-scuttled" — §named-pre-lockdown-discipline. §The-import-is-named-and-the-reason-is-named.

§Eight-intrinsics-captured at module load: ArrayBuffer / Object / Reflect / Symbol / TypeError / Uint8Array / WeakMap / structuredClone. §Each-captured-before-they-might-be-tampered-with.

§Sibling-pattern: cycle 181 base64's §Reflect.apply-captured-at-module-load + cycle 199 trampoline's §classic-uncurry-this + cycle 175 harden-selector's §pin-on-first-install. §Capture-before-scuttling is §a-recurring-pre-lockdown-discipline-pattern across @endo packages.

## §By-copy network protocol rationale + §ROM-vs-RAM Moddable XS rationale

§Two-named-motivations explicitly in the README:

### Motivation 1: §ROM-vs-RAM Moddable XS rationale

> Some JavaScript implementations, like Moddable XS, bring JavaScript to embedded systems, like device controllers, where ROM is much more plentiful and cheaper than RAM. These systems need to place voluminous fixed data into ROM, and currently do so using semantics outside the official JavaScript standard.

§Embedded-systems-need-immutable-data-in-ROM-not-RAM. §Currently-done-with-semantics-outside-the-official-standard. §The-proposal-would-bring-the-mechanism-into-the-standard.

### Motivation 2: §By-copy network protocol rationale

> The OCapN network protocol treats strings and byte-arrays as distinct forms of bulk data to be transmitted by copy. At JavaScript endpoints speaking OCapN such as `@endo/pass-style` + `@endo/marshal`, JavaScript strings represent OCapN strings. The immutability of strings in the JavaScript language reflects their by-copy nature in the protocol. Likewise, to reflect an OCapN byte-array well into the JavaScript language, we need an immutable container of bulk binary data. There currently are none. An Immutable `ArrayBuffer` would provide exactly the low-level machinery we need.

§The-network-capability-protocol-treats-byte-arrays-as-bulk-data-transmitted-by-copy. §JavaScript-strings-reflect-this-by-copy-nature-via-immutability. §An-immutable-ArrayBuffer is §the-symmetric-shape for byte-arrays. §@endo/pass-style + @endo/marshal are the §JavaScript-endpoints that would consume this.

§Two-motivations-from-orthogonal-domains (embedded ROM systems + by-copy network protocols) converging on the same primitive. §Borrowable-pattern: §named-motivations-from-orthogonal-domains as §the-shape-of-a-proposal-rationale.

§The-proposal-target: §`ArrayBuffer.prototype.transferToImmutable()`-method + §`ArrayBuffer.prototype.immutable`-getter. §Two-named-additions.

## §The-emulated-immutable-buffers-inherit-from-ArrayBuffer.prototype-transitively

> The emulated immutable buffers inherit directly from an intermediate prototype we refer to as `immutableArrayBufferPrototype`. This intermediate prototype contains all the methods and read-only accessor properties proposed here, as well as overrides of those inherited from `ArrayBuffer.prototype` as needed to emulate the behavior of an immutable instance. For each emulated immutable buffer, the implementation encapsulates a genuine `ArrayBuffer` that it has exclusive access to, so it can enforce immutability simply by never modifying it.

§Encapsulated-genuine-ArrayBuffer-with-exclusive-access — §security-demands-exclusive-access. §Immutability-enforced-by-never-modifying-it. §The-emulated-immutable-buffer §holds-a-genuine-ArrayBuffer-in-the-WeakMap and §exposes-an-overridden-API that §never-touches-the-underlying-buffer-mutably.

§`makeImmutableArrayBufferInternal`-must-not-escape:

```js
// Since `makeImmutableArrayBufferInternal` MUST not escape,
// this `freeze` is just belt-and-suspenders.
freeze(makeImmutableArrayBufferInternal);
```

§Belt-and-suspenders-freeze. §The-comment-names-that-the-factory-must-not-escape (the module exports only the high-level functions, not the internal factory) and §freezes-anyway-as-defense-in-depth.

§Sibling-pattern: cycle 199 memoize's §encapsulated-pumpkin-marked-"must-not-escape-this-module" + cycle 175 harden-selector's §pin-on-first-install. §Honor-system-discipline-with-named-defense-in-depth.

## §Shim conditional-installation-with-warning policy

```js
// Modern shim practice frowns on conditional installation, at least for
// proposals prior to stage 3. This is so changes to the proposal since
// an old shim was distributed don't need to worry about the proposal
// breaking old code depending on the old shim. Thus, if we detect that
// we're about to overwrite a prior installation, we simply issue this
// warning and continue.
const overwrites = ownKeys(arrayBufferMethods).filter(
  key => key in arrayBufferPrototype,
);
if (overwrites.length > 0) {
  console.warn(
    `About to overwrite ArrayBuffer.prototype properties ${stringify(overwrites)}`,
  );
}
```

§Modern-shim-practice-frowns-on-conditional-installation. §The-rationale: §so-changes-to-the-proposal-since-an-old-shim-was-distributed-don't-need-to-worry-about-the-proposal-breaking-old-code-depending-on-the-old-shim. §Old-shim's-shape-wins by §overwriting-the-native if it ran first.

§Warning-when-overwriting + §TODO-about-lockdown'd-primordials: "if the primordials are frozen after the prior implementation, such as by `lockdown`, then this precludes overwriting as expected. However, for this case, the following warning text will be confusing."

§Honest-TODO-comment naming §the-known-broken-interaction with §lockdown.

§Borrowable-pattern: §warning-not-error-when-overwriting + §named-future-fix for the §lockdown-broken-interaction.

## §Borrowable patterns (tier-1)

1. **§Ponyfill+Shim pattern (full version)** — both shapes exported simultaneously; sibling to cycle 197 panic's ponyfill-only.
2. **§Purposeful-Violation-section in README** — §explicit-named-acknowledgment of §named-deliberate-deviations from §the-fidelity-target with §named-pragmatic-reason.
3. **§Concordance-sniff-defense via Symbol.toStringTag** — when a diagnostic library sniffs `toString()`, set the tag to something that doesn't match the sniffed pattern.
4. **§Six+-named Caveats** as §honest-enumeration-of-limitations in README.
5. **§WeakMap-as-emulated-private-field-AND-brand-check** when §class-private-fields-are-not-available (e.g., Hermes).
6. **§Method-binding-pre-defineProperty** on the WeakMap (`buffers.has = buffers.has`) to §avoid-post-hoc-prototype-lookups.
7. **§Intermediate-prototype-`InternalPrototype`-inheriting-from-the-host-prototype** when §the-proposal-modifies-the-host-prototype-directly but §the-emulation-cannot.
8. **§Five-throw-methods-on-immutable-prototype** with §two-distinct-error-messages (resize vs detach) for §two-error-categories.
9. **§Slice-stays-mutable / sliceToImmutable distinction** — §explicit-method-naming-with-the-shape.
10. **§Brand-check-via-`getBuffer(this)`-on-every-accessor** — even getters that don't need the buffer-value call it for the side-effect.
11. **§Three-tier-fallback: native-transfer → structuredClone → undefined** with §named-known-deficient-platforms (Hermes / Node ≤16 / some JavaScriptCore).
12. **§Zero-length-slice-as-genuine-ArrayBuffer-enforcement** — method-call-as-type-enforcement-side-effect.
13. **§Capture-before-scuttled** pre-lockdown discipline with §named-imports-and-named-rationale-in-comment.
14. **§Belt-and-suspenders-freeze on must-not-escape factory** — honor-system-discipline-with-defense-in-depth.
15. **§Modern-shim-practice-frowns-on-conditional-installation** as §named-shim-philosophy.
16. **§Shim-still-runs-after-native-implementation** as §deliberate-policy-with-named-future-cleanup-step.
17. **§Warning-not-error-when-overwriting** with §TODO-comment naming §the-known-broken-interaction with §lockdown.
18. **§Two-named-motivations-from-orthogonal-domains** (ROM-vs-RAM embedded + by-copy network protocol) converging on the same primitive — as §the-shape-of-a-proposal-rationale.
19. **§Plain-JavaScript-not-Hardened-JavaScript** disclaimer + §expected-interaction-with-ses-shim-lockdown-harden-phase.
20. **§Encapsulated-genuine-ArrayBuffer-with-exclusive-access** for §immutability-enforced-by-never-modifying-it.

## §Synthesis-target

Slot machine library §immutable-game-state-shapes can §borrow-the-WeakMap-as-emulated-private-field-AND-brand-check directly — §a-game-state-object whose §internal-fields-are-private-via-WeakMap with §brand-check for §"only-our-emulated-states-pass-this-check".

§Ponyfill+Shim-pattern borrowable for any §new-method-on-existing-prototype where §the-callers-might-prefer-either-shape.

§Purposeful-Violation-section borrowable as §a-README-shape for §named-deliberate-deviations from fidelity that need to be discoverable by future maintainers.

§Three-tier-fallback borrowable for any §feature-that-requires-platform-support with §known-deficient-platforms-named-explicitly.

§Two-named-motivations-from-orthogonal-domains converging on the same primitive borrowable as §the-shape-of-a-proposal-rationale.

§Concordance-sniff-defense borrowable wherever §a-diagnostic-library-uses-pattern-matching that the emulation needs to defeat.

§Capture-before-scuttled borrowable for any §pre-lockdown-utility that needs §prototype-tamper-resistance.

## §Cycle 201 meta-observations

§The-thirty-fifth-consecutive-designs/chat-alternation-cycle 166-201. §Cycle-200-milestone-passed; §cycle-201-is-the-first-cycle-of-the-third-hundred.

§Papers-lane-blocked 95+ consecutive cycles (since cycle ~106). §The-papers-lane-block is now §nearly-half-of-the-total-cycle-count.

§Library-reaches-706-sections at cycle 201.

§Nineteenth-member of §small-files-with-large-knowledge-density family.

§Library-protocol-applied: §grep-by-source-page-existence-with-the-`endo--packages-immutable-arraybuffer`-full-slug-prefix — §no-prior-ingest-found. §Caught-via-the-protocol-from-cycle-200's-double-pivot.

§Three-WeakMap-for-private-state-patterns now in the library:
- Cycle 199 memoize: §encapsulated-pumpkin-sentinel (reference-equality marker; not a WeakMap but the same idiom).
- Cycle 201 immutable-arraybuffer: §WeakMap-as-emulated-private-field-AND-brand-check.
- Cycle 150 pass-style typeGuards: §confirm-with-Rejector-trio + §two-level-rejection-discipline (different shape entirely).

§The-Eval-Twin-Problem-chain extends: cycles 197 panic + 199 memoize.md + 201 implicit (`@endo/immutable-arraybuffer` is `not by itself a Hardened JavaScript polyfill/shim` — the ses-shim is expected to import and harden).

§Honest-design-evolution-record family is not extended this cycle (no explicit prior-design narrative; §Purposeful-Violation is a §different-shape — honest-named-deviation-from-fidelity, not honest-named-prior-design-discarded).
