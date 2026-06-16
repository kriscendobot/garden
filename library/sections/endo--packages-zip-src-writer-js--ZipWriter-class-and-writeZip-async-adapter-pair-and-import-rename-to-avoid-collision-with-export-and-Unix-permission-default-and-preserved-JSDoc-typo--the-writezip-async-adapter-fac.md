---
title: §The writeZip() async-adapter factory — ten lines wrapping the class
source-slug: endo--packages-zip-src-writer-js
section-slug: ZipWriter-class-and-writeZip-async-adapter-pair-and-import-rename-to-avoid-collision-with-export-and-Unix-permission-default-and-preserved-JSDoc-typo
source-url: https://github.com/endojs/endo/blob/master/packages/zip/src/writer.js
source-repo: endojs/endo
source-path: packages/zip/src/writer.js
source-author: Endo project (collective)
total-lines: 64
ingest-cycle: 280
ingest-date: 2026-06-10
lane: chat
parent: endo--packages-zip-src-writer-js--ZipWriter-class-and-writeZip-async-adapter-pair-and-import-rename-to-avoid-collision-with-export-and-Unix-permission-default-and-preserved-JSDoc-typo
---

Lines 54-64:
```js
export const writeZip = () => {
  const writer = new ZipWriter();
  const write = async (path, data) => {
    writer.write(path, data);
  };
  const snapshot = async () => writer.snapshot();
  return { write, snapshot };
};
```

§First-explicit-observation in library: **§the-sync-class-wrapped-by-async-adapter-pattern (deferred-not-async) — §the-`async`-keyword-IS-on-the-function-signature + §the-body-uses-sync-calls + §the-`await`-of-the-result-would-be-a-no-op-today + §the-abstraction-promises-async-semantics-even-when-the-current-impl-IS-sync**.

§Sibling-pattern to many cluster-conventions where the public API IS Promise-returning to allow future implementations to become truly async; §the-discipline-IS-async-promise-without-current-async-action.

§The-factory-returns-`{ write, snapshot }` — §minimal-interface; §two-method-interface; §sibling-pattern to many @endo/* readable+writable adapter patterns.

§The-factory-IS-thin (ten lines) — §the-thin-async-wrapper-around-the-thick-sync-class; §the-class-holds-all-the-logic + §the-wrapper-holds-the-protocol-promise; §the-discipline-IS-separation-of-implementation-from-protocol.

§First-explicit-observation in library: **§the-thin-async-wrapper-around-thick-sync-class — §the-class-has-50+-lines + §the-wrapper-has-10-lines + §the-wrapper's-only-job-IS-the-async-protocol + §sibling-pattern to many adapter-pattern conventions**.
