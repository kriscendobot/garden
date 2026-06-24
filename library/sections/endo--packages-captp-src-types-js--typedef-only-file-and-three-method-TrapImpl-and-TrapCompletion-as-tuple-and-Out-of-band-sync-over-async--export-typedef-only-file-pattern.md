---
title: §`export {};` — typedef-only file pattern
source-slug: endo--packages-captp-src-types-js
source-url: https://github.com/endojs/endo/blob/master/packages/captp/src/types.js
authors: [Endo Project Contributors]
repo: endojs/endo
path: packages/captp/src/types.js
total-lines: 49
ingest-cycle: 249
ingest-date: 2026-06-08
lane: chat
parent: endo--packages-captp-src-types-js--typedef-only-file-and-three-method-TrapImpl-and-TrapCompletion-as-tuple-and-Out-of-band-sync-over-async
---

```js
export {};
```

§The-`export {};`-statement makes the file a module without exports. §The-file's-purpose-is-the-JSDoc-typedefs-not-the-runtime-exports. §When-a-file-contains-only-TypeScript-typedefs-via-JSDoc, §use-`export {};`-to-mark-it-as-a-module-not-a-script.

§First-explicit-observation in library of §`export {};`-typedef-only-file-pattern. §Sibling-pattern-to-cycle-239's-get-interface.js (which is also typedef-shaped but exports the constant `GET_INTERFACE_GUARD`) — §two-different-shapes-of-typedef-heavy-file: §with-named-constant-export (239) + §without-runtime-export (249).

§The-file-IS-the-protocol-contract-not-the-implementation. §Sibling-pattern-to-cycle-239's-protocol-artifact-shape — §two-cycles-with-protocol-artifact-as-named-file-shape. §Cycle-239-is-a-protocol-artifact-with-implementation-elsewhere-AND-a-constant-export; §cycle-249-is-pure-protocol-artifact-with-implementation-in-trap.js.
