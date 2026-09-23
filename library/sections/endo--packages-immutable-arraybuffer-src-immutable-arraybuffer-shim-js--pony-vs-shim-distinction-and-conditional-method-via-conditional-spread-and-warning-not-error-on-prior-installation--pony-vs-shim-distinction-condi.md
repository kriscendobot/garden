---
title: Pony vs shim distinction + conditional method via conditional spread + warning-not-error on prior installation + non-enumerable class-prototype emulation
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

[`@endo/immutable-arraybuffer/src/immutable-arraybuffer-shim.js`](../sources/endo--packages-immutable-arraybuffer-src-immutable-arraybuffer-shim-js.md) is a §97-line-file that installs the immutable-ArrayBuffer proposal methods onto the platform's `ArrayBuffer.prototype`. The §shim wraps a §pony module that does the actual work without modifying the platform.
