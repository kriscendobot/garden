---
title: §Pony vs shim distinction
source-slug: endo--packages-immutable-arraybuffer-src-immutable-arraybuffer-shim-js
source-url: https://github.com/endojs/endo/blob/master/packages/immutable-arraybuffer/src/immutable-arraybuffer-shim.js
authors: [Endo Project Contributors]
repo: endojs/endo
path: packages/immutable-arraybuffer/src/immutable-arraybuffer-shim.js
total-lines: 97
ingest-cycle: 245
ingest-date: 2026-06-08
lane: chat
parent: endo--packages-immutable-arraybuffer-src-immutable-arraybuffer-shim-js--pony-vs-shim-distinction-and-conditional-method-via-conditional-spread-and-warning-not-error-on-prior-installation
---

The file imports from `./immutable-arraybuffer-pony.js`:

```js
import {
  isBufferImmutable,
  sliceBufferToImmutable,
  optTransferBufferToImmutable as optXferBuf2Immu,
} from './immutable-arraybuffer-pony.js';
```

§Pony-vs-shim-distinction: §the-pony-is-the-would-be-implementation-as-standalone-functions + §the-shim-installs-the-pony's-functions-as-methods-on-the-platform-prototype. §The-pony-is-importable-without-side-effects + §the-shim-modifies-the-platform-at-import-time.

§When-a-proposal-wants-to-add-methods-to-a-platform-prototype, §split-into-pony-and-shim + §the-pony-is-the-mechanism + §the-shim-is-the-installation. §The-consumer-can-choose-to-import-the-pony-or-the-shim — §importing-the-pony-doesn't-mutate-anything + §importing-the-shim-installs-the-methods-everywhere-in-the-realm.

§First-explicit-observation in library of §pony-vs-shim-distinction as borrowable pattern. §Three-cycles-with-platform-bridge-discipline now (cycle 188 monkey-patch + cycle 242 elevator-module + cycle 245 pony-shim) — §three-different-shapes-of-platform-bridge. §Each-shape-trades-off-differently: §monkey-patch-replaces-the-platform-shape + §elevator-isolates-the-platform-import + §pony-shim-separates-the-mechanism-from-the-installation.
