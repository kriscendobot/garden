---
title: "@endo/eventual-send/src/no-shim.js — the no-shim module + hp as alias of global + XXX comment as named workaround + three export styles"
source-slug: endo--packages-eventual-send-src-no-shim-js
source-url: https://github.com/endojs/endo/blob/master/packages/eventual-send/src/no-shim.js
authors: [Endo Project Contributors]
repo: endojs/endo
path: packages/eventual-send/src/no-shim.js
total-lines: 23
ingest-cycle: 254
ingest-date: 2026-06-10
lane: chat
---

# The no-shim module + hp as alias of global + XXX comment as named workaround + three export styles

[`@endo/eventual-send/src/no-shim.js`](../sources/endo--packages-eventual-send-src-no-shim-js.md) is a §23-line-file that captures the platform's already-installed `HandledPromise` global and re-exports the `E` proxy + everything from `./exports.js`. The §counterpart to a shim — when the platform already has the global installed, the no-shim consumes it without installing.

## §The no-shim module — fourth shape of platform-bridge discipline

```js
const hp = HandledPromise;
```

§The-no-shim-module assumes the platform shim has already installed `HandledPromise` globally. §No-shim-IS-the-consumer-side of the pony-shim split. §When-the-application-knows-the-shim-has-already-installed-the-global, §use-the-no-shim-module + §skip-the-installation-step.

§Four-cycles-with-platform-bridge-discipline now: §cycle-188 monkey-patch-the-platform-shape + §cycle-242 elevator-module + §cycle-245 pony-shim (installs onto platform prototype) + §cycle-254 no-shim (consumes already-installed global). §Four-different-shapes-of-platform-bridge — each shape trades off differently.

§The-no-shim-and-pony-shim-are-complements: §the-pony-shim installs the global + §the-no-shim assumes it's been installed + §the-application chooses which entrypoint to import. §When-shipping-a-library-that-uses-a-global, §provide-both-a-shim-and-a-no-shim-entrypoint + §let-the-consumer-choose-installation-responsibility.

§First-explicit-observation in library of §the-no-shim-module-as-counterpart-to-the-pony-shim as named architecture-pattern.

## §`const hp = HandledPromise;` — capture the global at module load

```js
const hp = HandledPromise;
```

§Capture-the-global-at-module-load + §use-the-local-alias-throughout-the-module. §The-`hp`-name-is-a-shorter-alias for repeated reference. §When-a-module-references-a-platform-global-multiple-times, §capture-it-as-a-local-binding-at-module-load + §the-local-binding-IS-the-snapshot-of-the-global-at-load-time.

§Defense-against-later-global-replacement: §after-module-load, §reassigning-`globalThis.HandledPromise`-doesn't-affect-this-module + §the-module-uses-the-version-of-HandledPromise-that-existed-at-load-time.

§Sibling-pattern-to-cycle-245's-destructure-globalThis-at-top — §two-different-shapes-of-capture-the-global-at-module-load: §cycle-245 destructures-multiple-globals + §cycle-254 captures-a-single-global-as-named-local. §When-the-module-needs-many-globals, §destructure + §when-the-module-needs-one-global, §single-named-local.

§First-explicit-observation in library of §capture-the-global-at-module-load-as-defense-against-later-global-replacement.

## §The XXX comment as named workaround

```js
// XXX module exports for HandledPromise fail if these aren't in scope
/** @import {Handler, HandledExecutor} from './handled-promise.js' */
/** @import {ECallableOrMethods, EGetters, ERef, ESendOnlyCallableOrMethods, LocalRecord, RemoteFunctions} from './E.js' */
```

§The-XXX-comment names a workaround that's there for a specific reason — *module exports for HandledPromise fail if these aren't in scope*. §The-`@import`-tags-are-typedef-only-imports + §they-exist-only-because-TypeScript-checks-them-for-the-exports-below.

§XXX-as-named-workaround-prefix vs TODO: §XXX-marks-something-that-is-known-to-be-suboptimal-but-functional + §TODO-marks-something-that-is-incomplete-or-broken. §The-distinction-is-thin-but-the-Endo-codebase-honors-it.

§First-explicit-observation in library of §XXX-comment-as-named-workaround-prefix-as-distinct-from-TODO.

§Sibling-pattern-to-cycle-241's-`@ts-expect-error 2454` and cycle-245's-TS-flow-inference-workaround-via-local-rebinding and cycle-245's-`// TODO`-with-named-confusing-case — §four-cycles-with-named-TypeScript-or-tooling-workaround (241 + 245 + 245 + 254). §Each-cycle-has-a-different-shape-of-workaround-comment; §the-XXX-marker-names-the-functional-imperfection-distinct-from-broken-incomplete.

## §Three export styles in one file

```js
export const E = makeE(hp);
export { hp as HandledPromise };
export * from './exports.js';
```

§Three-different-export-styles: §named-export-via-binding-factory (`export const E = makeE(hp)`) + §named-export-via-rename-alias (`export { hp as HandledPromise }`) + §star-export-with-source (`export * from './exports.js'`).

§The-`export { hp as HandledPromise }` — §the-local-name-is-`hp`-but-the-external-name-is-`HandledPromise` + §the-`as`-clause-IS-the-renaming-on-export. §When-a-module-uses-a-short-local-alias-but-the-public-API-wants-the-canonical-name, §use-the-`export { local as Public }`-form. §Sibling-pattern-to-cycle-245's-`as` import-rename (cycle 245 imported with a rename; cycle 254 exports with a rename); §two-cycles-with-`as`-rename-in-module-boundary.

§The-`export *`-with-eslint-disable: `// eslint-disable-next-line import/export`. §The-eslint-rule-flags-conflicting-exports-but-the-author-knows-the-conflict-is-intentional. §The-eslint-disable-comment-IS-the-acknowledgment-of-the-known-conflict. §Sibling-pattern-to-cycle-245's-two-eslint-disables-with-distinct-named-justifications (two-cycles-with-named-eslint-disable-acknowledging-known-conflict).

§First-explicit-observation in library of §three-different-export-styles-in-one-file-as-named-shape.

## §Three-method JSDoc overview at the file level

```js
/**
 * E(x) returns a proxy on which you can call arbitrary methods. ...
 *
 * E.get(x) returns a proxy on which you can get arbitrary properties. ...
 *
 * E.when(x, res, rej) is equivalent to HandledPromise.resolve(x).then(res, rej)
 */
```

§The-JSDoc-attached-to-the-`export const E = makeE(hp)` line describes §three-API-shapes at the file level: §E(x).method() + §E.get(x).property + §E.when(x, res, rej). §The-JSDoc-IS-the-file's-API-reference + §the-comment-attaches-to-the-export-not-to-an-internal-function.

§File-level-API-overview-via-JSDoc-on-the-canonical-export. §When-a-file-exports-one-canonical-API-and-the-API-has-multiple-call-shapes, §attach-the-overview-JSDoc-to-the-canonical-export + §the-JSDoc-IS-the-file's-introduction.

§First-explicit-observation in library of §file-level-API-overview-via-JSDoc-on-canonical-export.

## §makeE(hp) — the factory parameterized by whatever HandledPromise is

```js
export const E = makeE(hp);
```

§makeE-IS-the-factory + §hp-IS-the-platform-or-shim-version-of-HandledPromise. §The-factory-doesn't-care-which-version-it-receives + §the-factory's-output-is-the-`E`-API.

§Dependency-injection-of-the-platform-substrate. §When-a-library-can-work-with-either-the-platform-global-or-a-shim, §factor-the-substrate-out-as-a-parameter-to-the-factory + §the-no-shim-and-the-shim-modules-both-call-the-same-factory-with-different-arguments.

§Sibling-pattern-to-cycle-242's-the-elevator-module — §two-cycles-with-dependency-injection-of-platform-substrate. §Cycle-242-injects-the-platform-fs-module-into-the-platform-agnostic-code; §cycle-254-injects-HandledPromise-into-the-platform-agnostic-E-factory.

§Three-cycles-with-platform-power-as-factory-argument (242 + 245 + 254). §Cycle-245's-pony-shim factory takes the pony and installs it; cycle-254's-no-shim factory takes the platform global and uses it.

## §The `hp` local name — short-alias convention

§The-`hp`-local-name is a short alias for `HandledPromise`. §Two-letters-vs-fourteen + §used-twice-within-the-module (in `makeE(hp)` + in `export { hp as HandledPromise }`). §Short-alias-when-the-canonical-name-is-long.

§Sibling-pattern-to-cycle-237's-`q`-as-alias-for-stringify and cycle-245's-`optXferBuf2Immu`-as-alias-for-optTransferBufferToImmutable — §three-cycles-with-short-alias-convention-for-long-canonical-name. §Different-shapes: §cycle-237 single-letter-alias + §cycle-245 abbreviated-camel-case + §cycle-254 two-letter-acronym. §Three-different-short-alias-styles in library now.

## §Why a `no-shim` entrypoint exists at all

§The-`@endo/eventual-send` package has two entrypoints in its `package.json` (not shown here): §the-default-entrypoint installs the shim + §the-`no-shim`-entrypoint expects the global to already be installed. §This-pattern-IS-the-shim-or-not-shim-dispatch.

§When-an-application-aggregates-multiple-libraries-that-each-want-to-install-the-same-shim, §the-application-can-import-the-shim-once + §all-other-imports-use-the-no-shim-entrypoint + §double-installation-is-avoided.

§First-explicit-observation in library of §shim-vs-no-shim-package-entrypoints-as-named-dispatch-shape.

## §Borrowable patterns

**Tier-1 (highest borrowing value):**

- §The no-shim module as counterpart to the pony-shim — installation responsibility moves to the application.
- §Capture the global at module load — `const hp = HandledPromise;` as snapshot at load time + defense against later global replacement.
- §XXX comment as named workaround prefix — distinct from TODO; XXX = known-suboptimal-but-functional.
- §Three different export styles in one file — `export const`, `export { local as Public }`, `export * from './module'`.
- §`export { local as Public }` form when a module uses a short alias internally but the public API wants the canonical name.
- §File-level API overview via JSDoc on canonical export.
- §makeE(hp) factory — dependency-injection of the platform substrate.
- §Shim-vs-no-shim package entrypoints as named dispatch shape.

**Tier-2 (named comparisons):**

- §Four-cycles-with-platform-bridge-discipline (188 monkey-patch + 242 elevator + 245 pony-shim + 254 no-shim).
- §Three-cycles-with-short-alias-convention-for-long-canonical-name (237 `q` + 245 `optXferBuf2Immu` + 254 `hp`).
- §Three-cycles-with-platform-power-as-factory-argument (242 + 245 + 254).
- §Two-cycles-with-`as`-rename-in-module-boundary (245 import-rename + 254 export-rename).
- §Two-cycles-with-named-eslint-disable-acknowledging-known-conflict (245 + 254).

**Tier-3 (file-shape patterns):**

- §Twenty-three-lines-as-a-complete-no-shim-module.
- §The-JSDoc-IS-the-file's-API-reference (file-level overview attached to canonical export).

## §Synthesis target — slot machine library

For a slot machine library:

- §The-no-game-engine-module as counterpart to game-engine-installer — when the application has already installed the game engine, import via the no-shim entrypoint.
- §Capture-the-game-engine-at-module-load as defense against later replacement.
- §XXX-comment-as-named-workaround-prefix for known-suboptimal-but-functional game-rule scaffolding.
- §File-level-API-overview-via-JSDoc-on-canonical-export for §game-engine-API-documentation.
- §makeE(hp)-as-factory-parameterized-by-platform-substrate for §game-engine-factory-parameterized-by-game-engine-installation.
- §Shim-vs-no-shim-package-entrypoints for §game-engine-with-and-without-installation entrypoints.

## §Library meta-counters

- §Library-reaches-760-sections at cycle 254 (chat-lane @endo/eventual-send/src/no-shim).
- §Eighty-seventh-consecutive designs-chat alternation cycle (cycles 166-250 + 252-254; cycle 251 was out-of-band papers).
- §Seventh-direct-ingest from `@endo/eventual-send/src/` (E.js + handled-promise.js + local.js + message-breakpoints.js + track-turns.js + postponed.js + no-shim.js).
- §Forty-third-member of §small-files-with-large-knowledge-density family.
- §Four-cycles-with-platform-bridge-discipline (188 monkey-patch + 242 elevator + 245 pony-shim + 254 no-shim).
- §Three-cycles-with-short-alias-convention-for-long-canonical-name (237 + 245 + 254).
- §Three-cycles-with-platform-power-as-factory-argument (242 + 245 + 254).
- §Two-cycles-with-`as`-rename-in-module-boundary (245 import-rename + 254 export-rename).
- §Two-cycles-with-named-eslint-disable-acknowledging-known-conflict (245 + 254).
- §First-explicit-observation of five patterns: §the-no-shim-module-as-counterpart-to-the-pony-shim + §capture-the-global-at-module-load-as-defense-against-later-global-replacement + §XXX-comment-as-named-workaround-prefix-as-distinct-from-TODO + §three-different-export-styles-in-one-file-as-named-shape + §file-level-API-overview-via-JSDoc-on-canonical-export + §shim-vs-no-shim-package-entrypoints-as-named-dispatch-shape.

(Endo Project Contributors authored)
