---
title: "@endo/module-source — §ModuleSource-class-as-parsed-cache + §invisible-combining-character-as-identifier-prefix + §babel-NESM-RESM-matrix + §AbstractModuleSource-forward-compatibility + §shebang-comment-out-trick + §deep-freeze-everything"
source-slug: endo--packages-module-source
section-id: ModuleSource-class-as-parsed-cache-and-invisible-combining-character-as-identifier-prefix-and-babel-NESM-RESM-matrix-and-AbstractModuleSource-forward-compatibility
url: https://github.com/endojs/endo/tree/master/packages/module-source
authors: [Endo contributors]
repo: endojs/endo
path: packages/module-source/src/{module-source.js, transform-analyze.js, transform-source.js, babel-plugin.js, parse-babel.js, hidden.js}
status: shipping
ingest-cycle: 223
ingest-date: 2026-06-08
lane: chat
---

# @endo/module-source — the ModuleSource shim for SES Compartments

`@endo/module-source` provides the `ModuleSource` shim for SES (a class that captures the effort of parsing and analyzing module text so multiple Compartments can share a cache of parsed sources). 1088 source lines across 6 files: `module-source.js` (152 lines, the class), `transform-analyze.js` (189), `transform-source.js` (63), `babel-plugin.js` (636 — the heavy lifting), `parse-babel.js` (28), `hidden.js` (20).

## §The-ModuleSource-class as parsed-cache

The class captures the result of one Babel parse + analyze, so the cache can be shared across Compartments:

> ModuleSource captures the effort of parsing and analyzing module text so a cache of ModuleSources may be shared by multiple Compartments.

§Borrowable-pattern: §parsed-result-as-shareable-cache-across-compartments. §Sibling to cycle 221 @endo/bundle-source's §SHA-512-content-addressed-source-map-cache — both designs §cache-parsed-or-derived-data; cycle 221 caches by content-hash + filesystem; cycle 223 caches in-memory by reference.

### §Class-constructor-must-be-invoked-with-`new`

```js
if (new.target === undefined) {
  throw TypeError(
    "Class constructor ModuleSource cannot be invoked without 'new'",
  );
}
```

§The-constructor-guard-against-being-called-as-a-function. §Borrowable-pattern: §explicit-`new.target`-check + §TypeError-named-with-class-name + §the-error-mentions-`new`-explicitly. §A-`function`-declaration-can-be-called-without-`new`-with-undefined-this; §this-check-catches-the-mistake-with-a-clear-message.

§Sibling to cycle 222 endoclaw-skill-registry's §discriminated-union-via-key-presence — both designs §catch-the-mistake-early-with-a-clear-error.

### §Two-form-of-options with normalization

```js
if (typeof opts === 'string') {
  opts = { sourceUrl: opts };
}
```

§Single-line-normalization at the top of the constructor. §The-shorthand (`new ModuleSource(source, 'url.js')`) §is-equivalent-to-the-long-form (`new ModuleSource(source, { sourceUrl: 'url.js' })`). §Borrowable-pattern: §when-the-most-common-option-is-a-string, §accept-it-as-shorthand-and-normalize.

§Sibling to cycle 215 @endo/hex's §name-for-error-diagnostics-parameter — both designs §a-common-second-argument-can-be-passed-as-a-bare-string.

## §The-deep-freeze-of-everything

```js
this.imports = freeze([...keys(imports)]);
this.exports = freeze([...].sort());
this.reexports = freeze([...exportAlls].sort());
// ...
for (const entry of values(liveExportMap)) {
  freeze(entry);
}
for (const entry of values(fixedExportMap)) {
  freeze(entry);
}
for (const reexports of values(reexportMap)) {
  for (const pair of reexports) {
    freeze(pair);
  }
  freeze(reexports);
}
this.__liveExportMap__ = freeze(liveExportMap);
this.__reexportMap__ = freeze(reexportMap);
this.__fixedExportMap__ = freeze(fixedExportMap);
// ...
freeze(this);
```

§Three-levels-of-freezing: §inner-entries + §map-values + §the-instance-itself. §Borrowable-pattern: §when-an-object-graph-must-be-immutable, §traverse-it-and-freeze-each-level-explicitly. §Object.freeze-is-shallow + §the-class-explicitly-traverses-the-Map-values-to-freeze-them.

§Sibling to cycle 217 @endo/errors' §harden-every-export (cycle 217 uses harden; cycle 223 uses Object.freeze because §it-must-load-before-SES-lockdown-allows-harden). §The-difference: §harden-is-deep-but-requires-SES-lockdown; §Object.freeze-is-shallow-but-works-pre-lockdown.

§Why-Object.freeze-and-not-harden — §honest-disclosure-of-load-order-constraint at the top of the file: `const freeze = Object.freeze;` with a cast comment `// Disable readonly markings.` §No-explicit-pre-lockdown-correctness-argument-in-this-file but §the-pattern-matches-the-sixth-member of the §freeze-not-harden-with-named-correctness-argument family (cycles 132 + 146 + 154 + 199 + 219 + 223).

## §The-`__double-underscore__`-private-names-convention

```js
this.__syncModuleProgram__ = functorSource;
this.__liveExportMap__ = freeze(liveExportMap);
this.__reexportMap__ = freeze(reexportMap);
this.__fixedExportMap__ = freeze(fixedExportMap);
this.__needsImport__ = needsImport;
this.__needsImportMeta__ = needsImportMeta;
```

§Five-named-`__double-underscore__`-private-fields. §These-are-the-SES-Compartment-internal-contract — SES's compartment loader reads these fields to wire up the live + fixed + reexport behavior.

§Borrowable-pattern: §the-`__double-underscore__`-naming-convention as §an-explicit-but-not-language-enforced-private-field. §Different-from-the-`__HIDE_`-prefix (cycle 217 @endo/errors) which is the §censor-protocol; §the-`__double-underscore__`-fields-are-the-substrate-internal-contract.

§eslint-disable-no-underscore-dangle in the file header — the linter would normally complain. §The-comment-and-the-eslint-disable-explicitly-acknowledge-the-naming-deviation.

## §The-babel-vs-babelStar-NESM-RESM matrix as opening comment

```js
// If all ESM implementations were correct, it would be sufficient to
// `import babel` instead of `import * as babel`.
// However, the `node -r esm` emulation of ESM produces a linker error,
// claiming there is no export named default.
// Also, the behavior of `import * as babel` changes from Node.js 14 to 16.
// Node.js 14 produces an extraneous { default } wrapper around the exports
// namespace and 16 introduces lexical static analysis of exported names, so
// comes closer to correct, and at least consistent with `node -r esm`.
//
// Node.js 14:
//   NESM:
//     babel:     exports
//     babelStar: { default: exports }
//   RESM:
//     babel:     linker error: no export named default
//     babelStar: exports
// Node.js 16:
//   NESM:
//     babel:     exports
//     babelStar: exports + trash
//   RESM:
//     babel:     linker error: no export named default
//     babelStar: exports
```

§Four-by-two-matrix-encoded-as-comment: §two-Node-versions × §two-ESM-emulators × §two-import-forms. §The-comment-maps-each-cell-to-its-observed-behavior. §Honest-acknowledgment-of-platform-quirks.

§Five-different-runtime-version-or-environment-compat-hacks-and-disclosures family now (cycles 199 + 205 + 213 + 217 + 223):

| Cycle | Source | Compat hack or disclosure |
| --- | --- | --- |
| 199 | @endo/nat | Apps-Script bigint-literal-workaround |
| 205 | @endo/evasive-transform | Babel-traverse default-import-workaround |
| 213 | @endo/stream-node | Node-14 unhandled-error-race-defense |
| 217 | @endo/errors | Pre-1.13.0 SES Agoric-bootstrap-vat tolerance |
| 223 | @endo/module-source | Node 14 vs 16 vs `node -r esm` babel-default-export matrix |

§Five-named-runtime-environment-issues. §The-pattern-evolves: cycle 199's nat says "this trick"; cycle 205 explains the workaround; cycle 213 names the race; cycle 217 names the bootstrap vat; cycle 223 gives a 4-cell matrix. §The-honest-disclosure-discipline-deepens-cycle-by-cycle.

## §The-shebang-comment-out-trick

```js
if (moduleSource.startsWith('#!')) {
  // Comment out the shebang lines.
  moduleSource = `//${moduleSource}`;
}
```

§A-shebang-line-handled-by-comment-prefixing. §The-shebang-prefix (`#!/usr/bin/env node`) is a §Unix-convention that JavaScript parsers reject; §prepending-`//`-converts-it-to-a-line-comment without changing the source length or column numbers.

§Borrowable-pattern: §when-you-must-pass-source-text-through-a-parser-that-rejects-the-shebang, §comment-it-out-with-`//`-prefix. §The-source-length-changes-by-two-characters; §the-line-and-column-numbers-of-the-following-lines-stay-the-same.

§Sibling to cycle 218 familiar-localhttp-protocol's §canary-DNS-resolution — both designs §minimal-prefix-that-preserves-other-properties.

## §The-`sourceOptions`-as-shared-state-bag pattern (transform-analyze.js)

```js
const sourceOptions = {
  sourceUrl, sourceMap, sourceMapUrl, sourceMapHook,
  sourceType: 'module',
  fixedExportMap: Object.create(null),
  imports: Object.create(null),
  exportAlls: [],
  reexportMap: Object.create(null),
  liveExportMap: Object.create(null),
  hoistedDecls: [],
  importSources: Object.create(null),
  importDecls: [],
  dynamicImport: { present: false },
  importMeta: { present: false },
};
```

§The-collection-bag-pattern: §a-single-object-passed-to-the-babel-plugin holds §every-collection-the-plugin-populates. §The-Babel-plugin-mutates-this-object-during-traversal + §the-caller-reads-it-after.

§§Object.create(null)-for-prototype-free-maps — §the-imports-and-export-maps-have-no-prototype-chain-so-they-can't-have-collisions-with-Object.prototype-methods (e.g., a module exporting `'toString'` would otherwise collide).

§Borrowable-pattern: §Object.create(null)-for-string-keyed-maps where the keys come from untrusted source. §Sibling to cycle 217 @endo/errors' §destructure-with-underscore-prefix-to-deliberately-discard — both designs §defensive-shape-against-prototype-pollution.

§Ten-named-fields collected during traversal. §Each-field-is-a-different-shape (sets / objects / arrays / single-value-with-`present`-flag).

### §The-`{ present: false }` pattern

```js
dynamicImport: { present: false },
importMeta: { present: false },
```

§A-mutable-boolean-flag-wrapped-in-an-object. §Borrowable-pattern: §when-a-callee-needs-to-mutate-a-boolean-from-deep-inside-a-traversal, §wrap-it-in-an-object-so-the-mutation-is-visible-at-the-caller. §JavaScript-doesn't-have-out-parameters; §an-object-with-a-mutable-field-IS-the-out-parameter.

§The-pattern-is-explicit: not `dynamicImport: false` (which can't be mutated through the reference) but `dynamicImport: { present: false }` (where `dynamicImport.present = true` is visible).

## §AbstractModuleSource for forward-compatibility (the most novel architectural move)

```js
function AbstractModuleSource() {
  // no-op, safe to super()
}

Object.setPrototypeOf(ModuleSource, AbstractModuleSource);
Object.setPrototypeOf(ModuleSource.prototype, AbstractModuleSource.prototype);

freeze(AbstractModuleSource);
freeze(AbstractModuleSource.prototype);
freeze(ModuleSource.prototype);
freeze(ModuleSource);
```

§The-prototype-chain-bridge anticipates the TC39 Source Phase Imports proposal, which would introduce a native `AbstractModuleSource` as a superclass of both `ModuleSource` and `WebAssembly.Module`. §The-shim-installs-an-intermediate-prototype-`AbstractModuleSource`-now-so-future-code-that-relies-on-its-existence-works.

§The-honest-disclosure-comment:

> We are attempting to ensure that a JavaScript shim (particularly ses) is forward-compatible as the engine evolves beneath it, with or without this ModuleSource shim, and with our without a native AbstractModuleSource which remains undecided. Lockdown does not gracefully handle the presence of an unexpected prototype, but can tolerate the absence of an expected prototype. So, we are providing AbstractModuleSource since we can better tolerate the various uncertain futures.

§Lockdown-can-tolerate-absence-but-not-presence-of-unexpected-prototype. §The-design-bet: §install-the-AbstractModuleSource-prototype-now-because-its-absence-can-be-tolerated-but-its-unexpected-presence-cannot. §When-the-native-version-arrives, §the-engine-may-replace-this-one + §the-existing-callers-keep-working.

§Borrowable-pattern: §the-asymmetric-tolerance-discipline — §when-future-evolution-could-go-multiple-ways + §one-direction-tolerates-the-shim + §the-other-direction-doesn't, §pick-the-shape-that-tolerates-both.

§Sibling to cycle 201 @endo/immutable-arraybuffer's §ponyfill+shim — both designs anticipate future native arrival. §Cycle-201 races to install + cycle-223 installs the prototype unconditionally + §two-different-future-arrival-shapes.

### §The-WebAssembly.Module-entanglement-deferred

> WebAssembly and ModuleSource are both in motion. The Source Phase Imports proposal implies an additional AbstractModuleSource layer above the existing WebAssembly.Module that would be shared by the JavaScript ModuleSource prototype chains. At time of writing, no version of WebAssembly provides the shared base class, and the ModuleSource *shim* gains nothing from sharing one when that prototype when it comes into being. So, we do not attempt to entangle our AbstractModuleSource with WebAssembly.Module.

§Honest-acknowledgment-of-what-the-shim-could-have-done-but-doesn't. §Borrowable-pattern: §name-the-temptation-and-resist-it-with-rationale. §The-design-doesn't-secretly-leave-out-WebAssembly-entanglement; §it-says-explicitly-why.

## §HIDDEN_PREFIX with invisible combining character (hidden.js)

```js
export const HIDDEN_PREFIX = '$h͏_';
export const HIDDEN_CONST_VAR_PREFIX = '$c͏_';
export const HIDDEN_A = `${HIDDEN_PREFIX}a`;
// ...
```

§The-single-most-structurally-novel-move. §`͏` is the Unicode §Combining-Grapheme-Joiner — §a-non-displayed-combining-character. The identifier `$h͏_a` §visually-looks-like-`$h_a` but is a §different-JavaScript-identifier-from-`$h_a` because of the invisible code point.

§No-collision-with-user-code because §user-code-wouldn't-accidentally-include-U+034F-in-identifiers. §The-prefix-is-functionally-invisible-but-uniquely-recognizable-by-the-parser.

§Borrowable-pattern: §use-an-invisible-Unicode-character-in-identifier-prefixes-to-avoid-collision-with-user-code. §Different-from-`__HIDE_`-prefix (cycle 217): the §`__HIDE_`-prefix-is-visible + §the-name-collision-is-prevented-by-convention; §the-`͏`-prefix-is-invisible + §the-name-collision-is-prevented-by-implausibility.

### §HIDDEN_META sized to match `import.meta`

```js
// HIDDEN_META is used to replace `import.meta`. The value fits the original
// length so it doesn't displace the column number of following text
export const HIDDEN_META = `${HIDDEN_PREFIX}___meta`;
```

§Source-map-friendly-replacement: §the-substitution-fits-the-original-length-so-column-numbers-don't-shift. §`import.meta` is 11 characters; `$h͏____meta` is also 11 characters (counting `͏` as 1 code-point but the underscore-padding compensates).

§Borrowable-pattern: §when-you-substitute-tokens-in-source-text, §size-the-replacement-to-match-the-original-length-so-source-maps-stay-aligned. §The-cost-of-deviation-is-broken-source-maps + §the-cost-of-conformance-is-padding-the-substitute.

§Sibling to cycle 215 @endo/hex's §`c | 0x20`-fold-uppercase-onto-lowercase trick — both designs §micro-optimization-where-the-format-matters-more-than-readability.

### §HIDDEN_IDENTIFIERS as the enumerated list

```js
export const HIDDEN_IDENTIFIERS = [
  HIDDEN_A,
  HIDDEN_IMPORT,
  HIDDEN_IMPORT_SELF,
  HIDDEN_IMPORTS,
  HIDDEN_ONCE,
  HIDDEN_META,
  HIDDEN_LIVE,
];
```

§Seven-named-hidden-identifiers as the §static-allow-list. §Borrowable-pattern: §enumerate-the-complete-set-of-reserved-identifiers-as-a-named-export so consumers can §audit + §validate + §collision-check at module load.

## §The-try-catch-wrap-with-cause pattern (transform-analyze.js)

```js
let scriptSource;
try {
  scriptSource = transformSource(moduleSource, sourceOptions);
} catch (err) {
  const moduleLocation = sourceUrl
    ? JSON.stringify(sourceUrl)
    : '<unknown>';
  throw SyntaxError(
    `Error transforming source in ${moduleLocation}: ${err.message}`,
    { cause: err },
  );
}
```

§The-Error-`cause`-option (ES2022) preserves the original error while adding context. §Borrowable-pattern: §wrap-the-error-with-location-context + §preserve-the-original-via-`cause`. §The-caller-can-still-walk-the-cause-chain to inspect the underlying Babel parse error.

§Sibling to cycle 215 @endo/hex's §native-error-rerun-polyfill-for-better-diagnostic — both designs §add-context-to-an-error-from-a-deeper-layer; cycle 215 reruns the polyfill; cycle 223 wraps with cause.

§JSON.stringify(sourceUrl)-or-`<unknown>` — §safe-quoting-with-fallback (the URL is JSON-escaped to avoid breaking the error message).

## Related material in the library

- **cycle 201 @endo/immutable-arraybuffer**: §ponyfill+shim sibling — both designs anticipate future native arrival.
- **cycle 215 @endo/hex**: §ponyfill-with-load-time-dispatch sibling + §native-error-rerun-polyfill-for-better-diagnostic sibling (different error-context pattern).
- **cycle 217 @endo/errors**: §`__HIDE_`-prefix-protocol sibling (cycle 223 has the `͏` invisible-prefix, cycle 217 has the visible `__HIDE_` prefix).
- **cycle 199 + 205 + 213 + 217 + 223**: §runtime-version-or-environment-compat-hacks family (cycle 223 adds the fifth member with the babel-NESM-RESM matrix).
- **cycle 132 + 146 + 154 + 199 + 219 + 223**: §freeze-not-harden-with-named-correctness-argument family (cycle 223 is the sixth member).
- **cycle 221 @endo/bundle-source**: §parsed-result-cache sibling (cycle 221 caches by SHA-512; cycle 223 caches by reference in-memory).
- **cycle 222 endoclaw-skill-registry**: §discriminated-union-via-key-presence sibling (cycle 223's `new.target === undefined` is a different shape of §catch-mistakes-early-with-clear-error).
- **cycle 218 familiar-localhttp-protocol**: §canary-DNS-resolution sibling (the §minimal-prefix-that-preserves-other-properties shape; cycle 223's shebang-comment-out is the same shape at the lexical layer).
- **cycle 200 worker-rust-xs**: §engine-level-confinement sibling (different layer, both deal with §SES-Compartment-internal-contract).
- **cycle 211 @endo/common**: §honest-disclosure-of-load-order-constraint sibling.

## §Library-reaches-729-sections at cycle 223 (chat-lane @endo/module-source).

## §Fifty-seventh consecutive designs-chat alternation cycles 166-223.

## §Six-cycles-using-freeze-not-harden-with-named-correctness-argument family

| Cycle | Source | Reason |
|-------|--------|--------|
| 132 | local.js | eventual-send evaluates before SES lockdown completes |
| 146 | E.js | `freeze` but not `harden` the proxy target so it remains trapping (stabilize-discipline) |
| 154 | trap.js | same as E.js (verbatim-comment-shared-across-derived-files) |
| 199 | trampoline | classic-uncurry-this with pre-lockdown capture |
| 219 | ses-ava | instantiation must precede lockdown; reachable objects are intrinsics |
| 223 | module-source | must be parseable pre-lockdown; cast comment names the readonly-marking workaround |

§Six-different-reasons-for-the-same-mechanism.

## §Five-different-runtime-version-or-environment-compat-hacks-and-disclosures family

| Cycle | Source | Hack or disclosure |
| --- | --- | --- |
| 199 | @endo/nat | Apps-Script bigint-literal-workaround |
| 205 | @endo/evasive-transform | Babel-traverse default-import-workaround |
| 213 | @endo/stream-node | Node-14 unhandled-error-race-defense |
| 217 | @endo/errors | Pre-1.13.0 SES Agoric-bootstrap-vat tolerance |
| 223 | @endo/module-source | Node 14 vs 16 vs `node -r esm` babel-default-export matrix |

§Five-different-environments. §The-disclosure-depth-deepens-cycle-by-cycle.
