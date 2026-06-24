---
title: Single most structurally interesting move
section-slug: endo--packages-zip-src-buffer-reader-js--WeakMap-private-fields-with-bound-get-helper-and-can-assertCan-do-it-triad-and-IE10-historical-ghost-comment-and-findLast-reverse-search
source-slug: endo--packages-zip-src-buffer-reader-js
url: https://github.com/endojs/endo/blob/master/packages/zip/src/buffer-reader.js
authors: [Endo project (collective)]
repo: endojs/endo
path: packages/zip/src/buffer-reader.js
total-lines: 274
ingest-cycle: 292
ingest-date: 2026-06-11
lane: chat
scope: full
parent: endo--packages-zip-src-buffer-reader-js--WeakMap-private-fields-with-bound-get-helper-and-can-assertCan-do-it-triad-and-IE10-historical-ghost-comment-and-findLast-reverse-search
---

**§the-`can`/`assertCan`/X-triad-for-each-operation** — the reader exposes **three named methods for each pre-conditional operation**: a predicate (`canSeek`), an assertion (`assertCanSeek`), and the operation (`seek`). The predicate lets the caller branch; the assertion lets the caller throw at their own boundary; the operation lets the caller proceed.

This is **§the-named-triad-shape-richer-than-the-typical-binary-pair**. The typical API exposes only an assertion + the operation; the reader exposes ALL THREE. The cost IS more method names; the benefit IS that the API supports the *full lattice of caller intents*: "is this safe?" + "throw if not safe" + "just do it".

The triad shape generalizes beyond reading: any operation with a pre-condition can expose a `canX`/`assertCanX`/`X` triple. The discipline IS to *not* fold the predicate into the assertion — keeping them separate lets the caller choose. **§the-named-three-named-shapes-for-the-same-underlying-check IS the named API-richness-discipline.**

The reader has this richness; the writer (cycle 290) doesn't (only `ensureCanX` assertions, no `canX` predicates). The asymmetry IS task-asymmetry: parsers more often need to inspect before committing.
