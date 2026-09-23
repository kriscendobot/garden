---
title: §the-`return table;`-after-mutation-without-`harden` shape (first-explicit-observation in context)
section-slug: endo--packages-zip-src-crc32-js--pre-pasted-from-pako-with-attribution-and-the-IEEE-reversed-polynomial-and-table-initialized-at-module-load-and-incremental-API-with-default-parameters
source-slug: endo--packages-zip-src-crc32-js
url: https://github.com/endojs/endo/blob/master/packages/zip/src/crc32.js
authors: [Endo project (collective, pre-pasted from pako)]
repo: endojs/endo
path: packages/zip/src/crc32.js
total-lines: 48
ingest-cycle: 286
ingest-date: 2026-06-10
lane: chat
scope: full
parent: endo--packages-zip-src-crc32-js--pre-pasted-from-pako-with-attribution-and-the-IEEE-reversed-polynomial-and-table-initialized-at-module-load-and-incremental-API-with-default-parameters
---

`makeTable` returns a plain JS array without `harden`. The exported `crc32` function then closes over this mutable table. **§the-module-scope-mutable-private-state pattern**: a module-scoped variable that IS mutable in principle but is treated as immutable by convention. Compare cycle 132's eventual-send local.js patterns — the table here is *not* hardened, *not* explicitly frozen, but is private-by-module-scope.

§the-private-by-module-scope IS distinct from §the-private-by-WeakMap (cycle 191 noted WeakMap-private-fields in buffer-reader.js + buffer-writer.js). Two named private-state shapes in the same package: WeakMap (for class-instance fields) + module-scope-closure (for module-load-time tables). **§two-named-private-state-shapes-in-the-zip-cluster**.
