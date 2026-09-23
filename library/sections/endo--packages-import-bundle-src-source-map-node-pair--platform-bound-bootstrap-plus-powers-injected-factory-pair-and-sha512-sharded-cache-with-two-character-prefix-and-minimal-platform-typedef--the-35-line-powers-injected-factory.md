---
title: §The 35-line powers-injected factory
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
parent: endo--packages-import-bundle-src-source-map-node-pair--platform-bound-bootstrap-plus-powers-injected-factory-pair-and-sha512-sharded-cache-with-two-character-prefix-and-minimal-platform-typedef
---

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
