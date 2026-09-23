---
title: §Three-method JSDoc overview at the file level
source-slug: endo--packages-eventual-send-src-no-shim-js
source-url: https://github.com/endojs/endo/blob/master/packages/eventual-send/src/no-shim.js
authors: [Endo Project Contributors]
repo: endojs/endo
path: packages/eventual-send/src/no-shim.js
total-lines: 23
ingest-cycle: 254
ingest-date: 2026-06-10
lane: chat
parent: endo--packages-eventual-send-src-no-shim-js--the-no-shim-module-and-hp-as-alias-of-global-and-XXX-comment-as-named-workaround-and-three-export-styles
---

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
