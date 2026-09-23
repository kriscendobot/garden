---
title: §`const hp = HandledPromise;` — capture the global at module load
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
const hp = HandledPromise;
```

§Capture-the-global-at-module-load + §use-the-local-alias-throughout-the-module. §The-`hp`-name-is-a-shorter-alias for repeated reference. §When-a-module-references-a-platform-global-multiple-times, §capture-it-as-a-local-binding-at-module-load + §the-local-binding-IS-the-snapshot-of-the-global-at-load-time.

§Defense-against-later-global-replacement: §after-module-load, §reassigning-`globalThis.HandledPromise`-doesn't-affect-this-module + §the-module-uses-the-version-of-HandledPromise-that-existed-at-load-time.

§Sibling-pattern-to-cycle-245's-destructure-globalThis-at-top — §two-different-shapes-of-capture-the-global-at-module-load: §cycle-245 destructures-multiple-globals + §cycle-254 captures-a-single-global-as-named-local. §When-the-module-needs-many-globals, §destructure + §when-the-module-needs-one-global, §single-named-local.

§First-explicit-observation in library of §capture-the-global-at-module-load-as-defense-against-later-global-replacement.
