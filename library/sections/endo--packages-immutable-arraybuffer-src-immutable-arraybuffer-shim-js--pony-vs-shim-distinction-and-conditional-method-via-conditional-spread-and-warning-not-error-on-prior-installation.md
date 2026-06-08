---
title: "@endo/immutable-arraybuffer/src/immutable-arraybuffer-shim.js — Pony vs shim distinction + conditional method via conditional spread + warning-not-error on prior installation + non-enumerable class-prototype emulation"
source-slug: endo--packages-immutable-arraybuffer-src-immutable-arraybuffer-shim-js
source-url: https://github.com/endojs/endo/blob/master/packages/immutable-arraybuffer/src/immutable-arraybuffer-shim.js
authors: [Endo Project Contributors]
repo: endojs/endo
path: packages/immutable-arraybuffer/src/immutable-arraybuffer-shim.js
total-lines: 97
ingest-cycle: 245
ingest-date: 2026-06-08
lane: chat
---

# Pony vs shim distinction + conditional method via conditional spread + warning-not-error on prior installation + non-enumerable class-prototype emulation

[`@endo/immutable-arraybuffer/src/immutable-arraybuffer-shim.js`](../sources/endo--packages-immutable-arraybuffer-src-immutable-arraybuffer-shim-js.md) is a §97-line-file that installs the immutable-ArrayBuffer proposal methods onto the platform's `ArrayBuffer.prototype`. The §shim wraps a §pony module that does the actual work without modifying the platform.

## §Pony vs shim distinction

The file imports from `./immutable-arraybuffer-pony.js`:

```js
import {
  isBufferImmutable,
  sliceBufferToImmutable,
  optTransferBufferToImmutable as optXferBuf2Immu,
} from './immutable-arraybuffer-pony.js';
```

§Pony-vs-shim-distinction: §the-pony-is-the-would-be-implementation-as-standalone-functions + §the-shim-installs-the-pony's-functions-as-methods-on-the-platform-prototype. §The-pony-is-importable-without-side-effects + §the-shim-modifies-the-platform-at-import-time.

§When-a-proposal-wants-to-add-methods-to-a-platform-prototype, §split-into-pony-and-shim + §the-pony-is-the-mechanism + §the-shim-is-the-installation. §The-consumer-can-choose-to-import-the-pony-or-the-shim — §importing-the-pony-doesn't-mutate-anything + §importing-the-shim-installs-the-methods-everywhere-in-the-realm.

§First-explicit-observation in library of §pony-vs-shim-distinction as borrowable pattern. §Three-cycles-with-platform-bridge-discipline now (cycle 188 monkey-patch + cycle 242 elevator-module + cycle 245 pony-shim) — §three-different-shapes-of-platform-bridge. §Each-shape-trades-off-differently: §monkey-patch-replaces-the-platform-shape + §elevator-isolates-the-platform-import + §pony-shim-separates-the-mechanism-from-the-installation.

## §Destructure globalThis at top

```js
const {
  ArrayBuffer,
  JSON,
  Object,
  Reflect,
  // eslint-disable-next-line no-restricted-globals
} = globalThis;
```

§Destructure-the-needed-globals-at-the-top-of-the-file with §eslint-disable-no-restricted-globals comment. §The-eslint-disable-comment-is-positioned-INSIDE-the-destructure-not-above-it — §the-disable-comment-attaches-to-the-closing-brace-line + §the-rule-applies-to-the-`} = globalThis` access. §When-a-project-has-no-restricted-globals-enforcement, §destructure-the-globals-at-module-load-and-disable-the-rule-with-an-inline-comment-at-the-access-site.

§Sibling-pattern-to-cycle-237's-`const { stringify: q } = JSON` (single global destructure) — §two-cycles-with-explicit-globalThis-destructure. §Cycle-237-destructured-from-JSON-without-eslint-comment; §cycle-245-destructures-from-globalThis-with-eslint-comment.

§The-`@endo/no-polymorphic-call`-eslint-disable on a different line — §two-different-named-eslint-disables in the same file. §Two-eslint-disables-with-distinct-named-justifications: §no-restricted-globals (canonical) + §no-polymorphic-call ("Allowing polymorphic calls because these occur during initialization"). §When-an-eslint-disable-is-applied, §provide-named-justification-in-the-comment-line-above.

## §TS flow-based inference workaround via local copy

```js
import {
  optTransferBufferToImmutable as optXferBuf2Immu,
} from './immutable-arraybuffer-pony.js';

// Even though the imported one is not exported by the pony as a live binding,
// TS doesn't know that,
// so it cannot do its normal flow-based inference. By making and using a local
// copy, no problem.
const optTransferBufferToImmutable = optXferBuf2Immu;
```

§The-import-is-renamed-to-a-short-alias + §the-local-binding-renames-it-back-to-the-canonical-name. §Why-the-double-rename: §TS-doesn't-know-the-import-isn't-a-live-binding + §TS-can't-do-flow-based-inference-on-imported-bindings + §making-a-local-copy-makes-the-flow-analysis-work.

§When-TypeScript's-flow-inference-fails-on-an-imported-binding, §rebind-it-locally-to-give-the-checker-a-fresh-binding-it-can-narrow. §The-comment-explicitly-names-the-cause-and-the-workaround.

§First-explicit-observation in library of §TS-flow-inference-workaround-via-local-rebinding as borrowable pattern. §Sibling-to-cycle-241's-`@ts-expect-error 2454` (acknowledgment of executor synchronous run) — §two-different-shapes-of-TypeScript-workaround. §Cycle-241-uses-expect-error-with-cited-error-code; §cycle-245-uses-local-rebinding-with-prose-explanation.

§The-rename-alias-`optXferBuf2Immu` is itself notable — §a-short-alias-for-a-long-name (sibling pattern to cycle 237's `q` = `JSON.stringify`). §Two-different-naming-conventions-for-rename-aliases: §single-letter (cycle 237 `q`) + §abbreviated-camel-case (cycle 245 `optXferBuf2Immu`). §When-a-name-is-imported-frequently-with-context-where-the-short-form-suffices, §use-a-short-alias.

## §Conditional method via conditional spread

```js
const arrayBufferMethods = {
  sliceToImmutable(start = undefined, end = undefined) { ... },
  get immutable() { return isBufferImmutable(this); },

  ...(optTransferBufferToImmutable
    ? {
        transferToImmutable(newLength = undefined) { ... },
      }
    : {}),
};
```

§Conditional-method-via-conditional-spread + §the-method-only-exists-if-the-platform-supports-it (`optTransferBufferToImmutable` is the optional pony function — present iff the platform has the underlying API).

§When-a-shim-method-depends-on-an-optional-platform-feature, §use-conditional-spread-not-conditional-Object.defineProperty + §the-method-is-either-present-or-absent-not-present-with-a-throw. §Sibling-to-cycle-238's-structural-attenuation-not-behavioral-attenuation — §the-method-IS-absent-not-present-with-a-throw.

§Three-cycles-with-explicit-absence-as-attenuation (238 + 242 + 245). §Cycle-238's-readOnly-returns-the-readable-interface-not-a-frozen-copy; §cycle-242's-no-help()-in-this-layer; §cycle-245's-conditional-spread-when-platform-feature-is-absent.

§The-`opt`-prefix on `optTransferBufferToImmutable` is the naming convention for the optional pony function — §the-pony-exports-the-function-only-if-the-platform-supports-it. §When-a-pony-function-may-or-may-not-be-exported, §prefix-with-`opt`-to-signal-the-optional-availability.

## §Better-fidelity emulation of class prototype via non-enumerable properties

```js
// Better fidelity emulation of a class prototype
for (const key of ownKeys(arrayBufferMethods)) {
  defineProperty(arrayBufferMethods, key, {
    enumerable: false,
  });
}
```

§Better-fidelity-emulation-of-class-prototype as named design move. §Class-prototype-methods-are-non-enumerable-by-default + §object-literal-methods-are-enumerable-by-default + §so-the-shim-must-strip-enumerability-to-match-class-prototype-semantics.

§When-installing-methods-on-a-built-in-prototype, §strip-enumerability-via-defineProperty-loop + §the-result-IS-better-fidelity-emulation-of-a-class. §First-explicit-observation in library of §strip-enumerability-via-defineProperty-loop as the shim-installation discipline.

§The-comment-explicitly-names-the-purpose: §better-fidelity-emulation. §When-a-design-move-improves-fidelity-not-functionality, §name-it-as-fidelity-improvement.

## §Warning-not-error on prior installation

```js
const overwrites = ownKeys(arrayBufferMethods).filter(
  key => key in arrayBufferPrototype,
);
if (overwrites.length > 0) {
  console.warn(
    `About to overwrite ArrayBuffer.prototype properties ${stringify(overwrites)}`,
  );
}
```

§Modern-shim-practice-frowns-on-conditional-installation. §The-comment-block-explains-why:

> Modern shim practice frowns on conditional installation, at least for proposals prior to stage 3. This is so changes to the proposal since an old shim was distributed don't need to worry about the proposal breaking old code depending on the old shim. Thus, if we detect that we're about to overwrite a prior installation, we simply issue this warning and continue.

§Warning-not-error-on-prior-installation as named modern-shim discipline. §The-shim-installs-unconditionally-with-a-warning + §the-warning-IS-the-diagnostic-but-not-a-blocker. §When-a-shim-might-overwrite-a-prior-installation, §warn-but-don't-fail + §the-warning-IS-the-evidence-of-the-overwrite.

§First-explicit-observation in library of §warning-not-error-on-prior-installation as modern-shim discipline. §Sibling-to-cycle-237's-`Beware`-prefix-marks-actionable-warning — §two-different-shapes-of-warning-discipline. §Cycle-237's-Beware-prefix-marks-the-comment + §cycle-245's-console.warn-IS-the-runtime-diagnostic.

## §The TODO with named confusing-warning acknowledgment

```js
// TODO, if the primordials are frozen after the prior implementation, such as
// by `lockdown`, then this precludes overwriting as expected. However, for
// this case, the following warning text will be confusing.
```

§The-TODO-names-a-known-confusing-case + §the-fix-is-not-attempted-yet + §the-comment-is-the-acknowledgment. §When-a-design-discipline-conflicts-with-another-discipline-in-a-specific-scenario, §name-the-conflict-as-a-TODO + §don't-pretend-the-conflict-doesn't-exist.

§The-specific-conflict: §post-lockdown-primordials-are-frozen + §the-shim-cannot-overwrite + §but-the-warning-text-still-mentions-`About to overwrite`-which-is-confusing. §When-a-warning-message-can-be-misleading-in-an-edge-case, §name-the-edge-case-as-a-TODO + §don't-rewrite-the-message-prematurely-because-the-overwhelming-case-is-the-common-case.

§Sibling-pattern-to-cycle-235's-`sanity-check-with-c8-ignore` — §two-cycles-with-explicit-acknowledgment-of-a-known-imperfection. §Cycle-235's-c8-ignore-acknowledges-unreachable-code; §cycle-245's-TODO-acknowledges-misleading-warning-text.

## §Install via defineProperties + getOwnPropertyDescriptors

```js
defineProperties(
  arrayBufferPrototype,
  getOwnPropertyDescriptors(arrayBufferMethods),
);
```

§Canonical-install-pattern: §defineProperties + §getOwnPropertyDescriptors. §The-property-descriptors-from-the-source-object-are-copied-to-the-target + §the-non-enumerable-flag-set-earlier-IS-preserved + §the-getter-`get immutable()`-IS-installed-as-an-accessor-not-a-data-property.

§When-installing-methods-and-getters-onto-a-prototype-uniformly, §use-defineProperties-with-getOwnPropertyDescriptors-not-iteration-with-defineProperty. §The-batch-IS-the-correctness-mechanism — §each-property-keeps-its-original-descriptor-flags (writable, configurable, enumerable, get, set).

§First-explicit-observation in library of §install-via-defineProperties-plus-getOwnPropertyDescriptors as canonical shim-install pattern.

## §Getter as property syntax

```js
get immutable() {
  return isBufferImmutable(this);
},
```

§The-`get immutable()`-syntax IS the getter declaration inside an object literal. §The-getter-is-a-non-method-property + §accessing-`buffer.immutable`-calls-the-function + §the-getter-IS-the-shape-of-a-read-only-property.

§When-a-platform-prototype-needs-a-read-only-property-not-a-method, §use-the-getter-syntax + §the-consumer-accesses-without-calling-parentheses + §the-shape-matches-how-built-in-platform-properties-typically-look (e.g., `Array.prototype.length` is a property, not a method).

§Sibling-pattern-to-cycle-235's-`get nodes()-returns-new-Set` — §two-cycles-with-getter-syntax-on-object. §Cycle-235's-getter-makes-a-defensive-copy; §cycle-245's-getter-is-a-pure-predicate-with-no-side-effects.

## §Borrowable patterns

**Tier-1 (highest borrowing value):**

- §Pony-vs-shim-distinction — pony is the mechanism, shim is the installation; first-explicit-observation in library.
- §Conditional-method-via-conditional-spread when platform feature is optional.
- §The-`opt`-prefix on pony functions that may or may not be exported.
- §Better-fidelity-emulation-of-class-prototype via non-enumerable properties.
- §Strip-enumerability-via-defineProperty-loop after object-literal construction.
- §Warning-not-error-on-prior-installation as modern-shim discipline.
- §Install-via-defineProperties-plus-getOwnPropertyDescriptors as canonical batch-install pattern.
- §TS-flow-inference-workaround-via-local-rebinding when the imported binding isn't live.

**Tier-2 (file-shape patterns):**

- §Destructure-globalThis-at-top with eslint-disable-no-restricted-globals.
- §Two-eslint-disables-with-distinct-named-justifications.
- §Getter-as-property-syntax for read-only properties on platform prototypes.
- §The-TODO-names-a-known-confusing-case in an acknowledged edge.

**Tier-3 (named comparisons):**

- §Three-cycles-with-platform-bridge-discipline (188 monkey-patch + 242 elevator-module + 245 pony-shim).
- §Three-different-shapes-of-platform-bridge.
- §Three-cycles-with-explicit-absence-as-attenuation (238 + 242 + 245).

## §Synthesis target — slot machine library

For a slot machine library:

- §Pony-vs-shim-distinction for §game-rule-engine-pony-vs-shim — the pony is the standalone rule logic, the shim installs the rules onto the game-engine prototype.
- §Conditional-method-via-conditional-spread for §game-rule-features-that-depend-on-optional-game-engine-extensions.
- §The-`opt`-prefix for §game-engine-functions-that-may-or-may-not-be-available.
- §Better-fidelity-emulation-of-class-prototype for §game-engine-method-installation-matching-class-semantics.
- §Strip-enumerability-via-defineProperty-loop for §game-engine-methods-not-leaking-via-Object.keys-iteration.
- §Warning-not-error-on-prior-installation for §game-rule-update-warns-but-doesn't-block-redeploy.
- §Install-via-defineProperties-plus-getOwnPropertyDescriptors for §game-engine-installs-rule-set-as-batch.
- §TS-flow-inference-workaround-via-local-rebinding for §game-engine-TypeScript-edge-cases.
- §Getter-as-property-syntax for §game-state-properties-not-methods.

## §Library meta-counters

- §Library-reaches-751-sections at cycle 245 (chat-lane @endo/immutable-arraybuffer/src/immutable-arraybuffer-shim).
- §Seventy-ninth-consecutive designs-chat alternation cycle (cycles 166-245).
- §First-direct-ingest from `@endo/immutable-arraybuffer/src/`.
- §Three-cycles-with-platform-bridge-discipline (188 monkey-patch + 242 elevator-module + 245 pony-shim) — §three-different-shapes-of-platform-bridge.
- §Three-cycles-with-explicit-absence-as-attenuation (238 structural-attenuation + 242 no-help-in-this-layer + 245 conditional-method-via-conditional-spread).
- §Two-cycles-with-explicit-globalThis-destructure (237 + 245).
- §Two-different-naming-conventions-for-rename-aliases (237 single-letter `q` + 245 abbreviated `optXferBuf2Immu`).
- §Two-different-shapes-of-TypeScript-workaround (241 `@ts-expect-error 2454` + 245 local-rebinding-for-flow-inference).
- §Two-different-shapes-of-warning-discipline (237 `Beware`-prefix in comments + 245 `console.warn` at runtime).
- §Two-cycles-with-explicit-acknowledgment-of-a-known-imperfection (235 c8-ignore + 245 TODO with named confusing case).
- §Two-cycles-with-getter-syntax-on-object (235 + 245).
- §First-explicit-observation of §pony-vs-shim-distinction as borrowable pattern.
- §First-explicit-observation of §strip-enumerability-via-defineProperty-loop.
- §First-explicit-observation of §warning-not-error-on-prior-installation as modern-shim discipline.
- §First-explicit-observation of §install-via-defineProperties-plus-getOwnPropertyDescriptors.
- §First-explicit-observation of §TS-flow-inference-workaround-via-local-rebinding.

(Endo Project Contributors authored)
