---
title: "@endo/import-bundle/src/{source-map-node,source-map-node-powers}.js — platform-bound bootstrap + powers-injected factory pair + sha512-sharded cache with two-character prefix + minimal-platform typedef"
source-slug: endo--packages-import-bundle-src-source-map-node-pair
section-slug: platform-bound-bootstrap-plus-powers-injected-factory-pair-and-sha512-sharded-cache-with-two-character-prefix-and-minimal-platform-typedef
source-url: https://github.com/endojs/endo/blob/master/packages/import-bundle/src/source-map-node.js
source-repo: endojs/endo
source-path: packages/import-bundle/src/source-map-node.js + source-map-node-powers.js
source-author: Endo project (collective)
total-lines: 45 (10 + 35)
ingest-cycle: 276
ingest-date: 2026-06-10
lane: chat
---

# `@endo/import-bundle/src/source-map-node.js` + `source-map-node-powers.js` — the platform-bound + powers-injected pair

**45 lines total** across two files: an 11-line **platform-bound bootstrap** (`source-map-node.js`) plus a 35-line **powers-injected factory** (`source-map-node-powers.js`). The pair instantiates a **named platform-binding pattern**: the bootstrap binds to Node's platform modules at module load; the factory accepts those modules as injected powers without naming them at runtime.

§First-explicit-observation in library: **§the-platform-bound-bootstrap-plus-powers-injected-factory-pair-as-named-discipline — §when-a-module-needs-Node-platform-bindings, §a-thin-Node-bootstrap-imports-the-platform-modules-and-passes-them-as-powers-to-a-platform-agnostic-factory + §the-pair-IS-the-canonical-shape-for-Node-bound-functionality**.

§Sibling-pattern to cycle 245's panic-cluster pre-lockdown-capture and cycle 254's pony-vs-shim distinction — but here the structural shape is two-file-pair where one file imports platform globals and the other accepts them as parameters.

§Two-cycles-with-platform-binding-as-explicit-pair (245 panic-cluster's pre-lockdown-capture + 276 import-bundle's source-map-node-pair); §the-discipline-IS-the-same: §the-platform-binding-IS-explicit-not-implicit + §the-implementation-IS-platform-independent.

## §The 11-line platform-bound bootstrap

`source-map-node.js`:
```js
/* global process */
import url from 'node:url';
import os from 'node:os';
import { makeEndoSourceMapLocator } from './source-map-node-powers.js';

export const computeSourceMapLocation = makeEndoSourceMapLocator({
  url,
  os,
  process,
});
```

§The-file-does-three-things-only:
1. §**Imports node:url and node:os** — Node-specific platform modules via `node:` URL scheme.
2. §**Names `process` as a global** via the `/* global process */` ESLint directive.
3. §**Delegates to the factory** with `{url, os, process}` as the powers triple.

§First-explicit-observation in library: **§the-thin-Node-bootstrap-IS-only-three-things — §named-platform-imports + §global-process-named-via-eslint-comment + §single-call-to-the-platform-agnostic-factory**.

§The-`/* global process */`-comment IS the §named-eslint-directive-as-named-discipline; §sibling-pattern to cycle 245's eslint-disable comments and cycle 254's named-eslint-disable. §three-cycles-with-named-eslint-directive-as-acknowledged-platform-binding (245 + 254 + 276); §the-eslint-comment-IS-part-of-the-platform-binding-vocabulary.

§The-`node:`-URL-scheme — §sibling-pattern to Node.js's modern import discipline; §the-import-IS-explicit-that-this-IS-a-Node-built-in; §two-cycles-with-`node:`-URL-imports-as-named-discipline (this is the first explicit observation; could be a recurring pattern).

§First-explicit-observation in library: **§the-`node:`-URL-scheme-import-as-named-Node-built-in-discipline — §`node:url`-and-`node:os`-not-`url`-and-`os` + §the-`node:`-prefix-IS-the-explicit-marker-that-this-IS-a-platform-binding-not-a-userland-package**.

## §The 35-line powers-injected factory

`source-map-node-powers.js`:
```js
import { whereEndoCache } from '@endo/where';

/**
 * @typedef {object} Process
 * @property {Record<string, string | undefined>} env
 * @property {string} platform
 */

/**
 * @param {object} powers
 * @param {typeof import('node:url')} powers.url
 * @param {typeof import('node:os')} powers.os
 * @param {Process} powers.process
 */
export const makeEndoSourceMapLocator = powers => {
  const { url, os, process } = powers;

  const home = os.userInfo().homedir;
  const cacheDirectory = whereEndoCache(process.platform, process.env, {
    home,
  });
  const cacheLocation = url.pathToFileURL(cacheDirectory);

  const whereSourceMap = ({ sha512 }) => {
    const sha512Head = sha512.slice(0, 2);
    const sha512Tail = sha512.slice(2);
    return `${cacheLocation}/source-map/${sha512Head}/${sha512Tail}.map.json`;
  };

  return whereSourceMap;
};
```

§The-factory-does-five-things:
1. §**Destructures the powers** — `const { url, os, process } = powers;`.
2. §**Computes the user home** — `os.userInfo().homedir`.
3. §**Names the cache directory** via the cluster-helper `whereEndoCache(platform, env, {home})`.
4. §**Converts to a file URL** via `url.pathToFileURL(cacheDirectory)`.
5. §**Returns a `whereSourceMap` closure** that computes a per-sha512 source-map file path.

§First-explicit-observation in library: **§the-powers-injection-pattern-with-typed-typedef-for-each-power — §the-`@param {object} powers`-JSDoc-has-three-property-types (powers.url + powers.os + powers.process) + §each-power-IS-named-and-typed-explicitly + §the-typedef-IS-the-API-contract**.

§The-`typeof import('node:url')`-JSDoc-type — §the-power's-type-IS-`typeof-the-node:url-module`; §sibling-pattern to capability-systems' minimal-authority discipline; §the-power-IS-typed-to-the-full-platform-module-not-a-narrowed-shape (for `url` and `os`).

§The-`Process`-typedef-with-only-two-fields — §the-power-IS-typed-to-a-minimal-shape-not-the-full-Node-Process-type:

```js
@typedef {object} Process
@property {Record<string, string | undefined>} env
@property {string} platform
```

§First-explicit-observation in library: **§minimal-platform-typedef-with-only-the-fields-the-module-needs — §the-design-doesn't-import-the-full-Node-Process-type + §it-defines-a-minimal-shape-with-just-`env`-and-`platform` + §the-discipline-IS-principle-of-least-authority-applied-to-types**.

§The-`Record<string, string | undefined>` type for env — §acknowledges-that-env-vars-can-be-undefined; §sibling-pattern to many cross-platform conventions where the env is a partial dictionary.

§Two-cycles-with-typed-typedef-for-narrowed-platform-authority (this might be first-explicit-observation; needs cross-check).

## §sha512-sharded cache with two-character prefix

Lines 28-32 carry the §sha512-sharded-cache-with-two-character-prefix discipline:

```js
const whereSourceMap = ({ sha512 }) => {
  const sha512Head = sha512.slice(0, 2);
  const sha512Tail = sha512.slice(2);
  return `${cacheLocation}/source-map/${sha512Head}/${sha512Tail}.map.json`;
};
```

§First-explicit-observation in library: **§sha512-sharded-cache-with-two-character-prefix-and-remaining-tail — §the-first-two-characters-of-the-hash-IS-the-directory-shard + §the-remaining-characters-IS-the-filename + §the-shard-prevents-filesystem-fanout (one directory holding 100k+ files is slow on many filesystems)**.

§Sibling-pattern to git's loose-object storage (the-`.git/objects/ab/cdef...`-shape); §two-named-content-addressed-storage-with-sha-sharding-disciplines (git's loose objects + Endo's source-map cache); §the-discipline-IS-canonical-across-systems.

§The-cache-IS-keyed-by-sha512-not-sha256 (cycle 275's weblet-application used SHA-256 for blob-storage; cycle 276's source-map cache uses SHA-512). §two-named-content-addressed-storage-hashes-in-the-cluster (SHA-256 + SHA-512); §sibling-pattern to many systems that use SHA-256 for content addressing but SHA-512 for source-maps + secure caches.

§First-explicit-observation in library: **§the-cluster-uses-named-different-hash-sizes-for-different-content-addressed-storage-uses (SHA-256 for blobs in cycle 275 + SHA-512 for source-maps in cycle 276)**.

## §The whereEndoCache cluster helper — nested powers injection

Line 19-20:
```js
const cacheDirectory = whereEndoCache(process.platform, process.env, {
  home,
});
```

§The-`whereEndoCache`-call-takes-its-own-powers-triple: §platform + §env + §`{home}`-object. §the-pattern-IS-nested-powers-injection — the factory accepts powers; then passes them onward to a cluster helper that takes its own powers.

§First-explicit-observation in library: **§nested-powers-injection-as-named-discipline — §a-powers-injected-factory-may-pass-its-powers-onward-to-other-powers-injected-functions + §each-layer-IS-explicit-about-what-it-needs + §no-implicit-platform-access-anywhere-in-the-chain**.

§Sibling-pattern to capability-systems' chain-of-authority discipline; §the-authority-flows-from-the-thin-Node-bootstrap-down-through-the-factory-into-the-cluster-helper-with-no-ambient-access-at-any-layer.

§The-`{home}`-object-as-third-argument — §named-object-destructure with one field; §sibling-pattern to many "options" arguments in JS APIs; §the-API-allows-future-extension by adding more fields to the options object without changing the function signature.

## §The url.pathToFileURL conversion

Line 22: `const cacheLocation = url.pathToFileURL(cacheDirectory);`

§First-explicit-observation in library: **§the-url.pathToFileURL-conversion-IS-named-cross-platform-discipline — §the-cacheDirectory-IS-a-platform-specific-path (Unix-style or Windows-style) + §`url.pathToFileURL`-converts-it-to-a-platform-agnostic-file-URL + §the-rest-of-the-code-uses-the-URL-form**.

§Sibling-pattern to many Node modules that take URLs not paths; §the-discipline-IS-the-platform-binding-only-at-the-boundary + §the-URL-form-IS-platform-agnostic-thereafter.

## §The arrow-function factory returning an arrow-function closure

Lines 15 + 28: `makeEndoSourceMapLocator` (factory) and `whereSourceMap` (returned closure).

§Two-named-arrow-functions-pair — §the-outer-factory-receives-powers-and-returns-a-closure-that-captures-them + §the-inner-closure-receives-the-runtime-argument (sha512) and-uses-the-captured-powers; §the-pattern-IS-currying-with-explicit-binding-step.

§First-explicit-observation in library: **§the-make-X-locator-pattern — §`makeEndoSourceMapLocator(powers)`-returns-a-`whereSourceMap(details)`-closure + §the-prefix-`make`-and-the-prefix-`where`-IS-the-cluster's-canonical-naming + §sibling-pattern to many @endo/* `makeXXX` factories**.

## §Cycle 276 first-explicit-observations roundup (eleven)

1. §the-platform-bound-bootstrap-plus-powers-injected-factory-pair-as-named-discipline.
2. §the-thin-Node-bootstrap-IS-only-three-things (platform imports + global process + single call to factory).
3. §the-`node:`-URL-scheme-import-as-named-Node-built-in-discipline.
4. §the-powers-injection-pattern-with-typed-typedef-for-each-power.
5. §minimal-platform-typedef-with-only-the-fields-the-module-needs.
6. §sha512-sharded-cache-with-two-character-prefix-and-remaining-tail.
7. §the-cluster-uses-named-different-hash-sizes-for-different-content-addressed-storage-uses (SHA-256 cycle 275 + SHA-512 cycle 276).
8. §nested-powers-injection-as-named-discipline.
9. §the-url.pathToFileURL-conversion-IS-named-cross-platform-discipline.
10. §the-make-X-locator-pattern (`makeEndoSourceMapLocator` returns `whereSourceMap` closure).
11. §three-cycles-with-named-eslint-directive-as-acknowledged-platform-binding (245 + 254 + 276).

## §Recurring meta-pattern counters bumped at cycle 276

- §**two-cycles-with-platform-binding-as-explicit-pair** (245 panic-cluster pre-lockdown-capture + 276 import-bundle's source-map-node-pair).
- §**three-cycles-with-named-eslint-directive-as-acknowledged-platform-binding** (245 + 254 + 276).
- §**two-named-content-addressed-storage-hashes-in-the-cluster** (SHA-256 cycle 275 + SHA-512 cycle 276).
- §**one-hundred-and-ninth consecutive designs-chat alternation cycles 166-250 + 252-276** (251 was out-of-band).

## §Synthesis target — slot machine library

§The-platform-bound-bootstrap-plus-powers-injected-factory-pair applies to the §game-engine-cluster:

- §**`game-engine-node-bootstrap.js`** — thin Node-platform-bound bootstrap that imports Node-specific modules (e.g., `node:os` for game-cache-location) and delegates to a powers-injected factory.
- §**`game-engine-node-powers.js`** — the powers-injected factory that takes `{os, process}` as parameters; platform-agnostic implementation.
- §**§minimal-game-platform-typedef** — only the fields the game-engine-cluster needs (`platform` + `env`) rather than the full Node Process type.
- §**§nested powers injection** — the game-engine factory passes its powers onward to cluster helpers.
- §**§the make-X-locator pattern** — `makeGameStateLocator(powers)` returns a `whereGameState(details)` closure.
- §**§sha-sharded game-state cache** with two-character-prefix shard + remaining-tail filename.

## §Tier-1 borrowing

§the-platform-bound-bootstrap-plus-powers-injected-factory-pair + §the-thin-Node-bootstrap-IS-only-three-things + §the-`node:`-URL-scheme-import-as-named-Node-built-in-discipline + §the-powers-injection-pattern-with-typed-typedef-for-each-power + §minimal-platform-typedef-with-only-the-fields-the-module-needs + §sha512-sharded-cache-with-two-character-prefix + §nested-powers-injection-as-named-discipline + §the-url.pathToFileURL-conversion-IS-named-cross-platform-discipline + §the-make-X-locator-pattern.

## §Tier-2 borrowing

§three-cycles-with-named-eslint-directive-as-acknowledged-platform-binding + §the-cluster-uses-named-different-hash-sizes-for-different-content-addressed-storage-uses + §the-`Record<string, string | undefined>`-type-acknowledges-that-env-vars-can-be-undefined.

## §Tier-3 borrowing

§two-cycles-with-platform-binding-as-explicit-pair + §library-reaches-782-sections at cycle 276 + §one-hundred-and-ninth consecutive designs-chat alternation cycles 166-250 + 252-276.

## Pattern summary (tag-prefixed)

§the-platform-bound-bootstrap-plus-powers-injected-factory-pair + §the-thin-Node-bootstrap-IS-only-three-things (named platform imports + global process via eslint comment + single call to factory) + §the-`node:`-URL-scheme-import-as-named-Node-built-in-discipline + §three-cycles-with-named-eslint-directive-as-acknowledged-platform-binding (245 + 254 + 276) + §the-powers-injection-pattern-with-typed-typedef-for-each-power + §minimal-platform-typedef-with-only-the-fields-the-module-needs + §the-`Record<string, string | undefined>`-type-acknowledges-undefined-env-vars + §sha512-sharded-cache-with-two-character-prefix-and-remaining-tail + §the-cluster-uses-named-different-hash-sizes-for-different-content-addressed-storage-uses (SHA-256 + SHA-512) + §nested-powers-injection-as-named-discipline + §the-url.pathToFileURL-conversion-IS-named-cross-platform-discipline + §the-make-X-locator-pattern.
