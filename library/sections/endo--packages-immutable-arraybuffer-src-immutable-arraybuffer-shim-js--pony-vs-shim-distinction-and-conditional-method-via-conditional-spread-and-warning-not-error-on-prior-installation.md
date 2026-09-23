---
title: "@endo/immutable-arraybuffer/src/immutable-arraybuffer-shim.js — Pony vs shim distinction + conditional method via conditional spread + warning-not-error on prior installation + non-enumerable class-prototype emulation"
source-slug: endo--packages-immutable-arraybuffer-src-immutable-arraybuffer-shim-js
source-url: https://github.com/endojs/endo/blob/master/packages/immutable-arraybuffer/src/immutable-arraybuffer-shim.js
authors: [Endo Project Contributors]
repo: endojs/endo
path: packages/immutable-arraybuffer/src/immutable-arraybuffer-shim.js
total-lines: 97
ingest-cycle: 245
ingest-date: 2026-06-08
lane: chat
kind: index
section_count: 13
---

Sections:

- [Pony vs shim distinction + conditional method via conditional spread + warning-not-error on prior installation + non-enumerable class-prototype emulation](endo--packages-immutable-arraybuffer-src-immutable-arraybuffer-shim-js--pony-vs-shim-distinction-and-conditional-method-via-conditional-spread-and-warning-not-error-on-prior-installation--pony-vs-shim-distinction-condi.md)
- [§Pony vs shim distinction](endo--packages-immutable-arraybuffer-src-immutable-arraybuffer-shim-js--pony-vs-shim-distinction-and-conditional-method-via-conditional-spread-and-warning-not-error-on-prior-installation--pony-vs-shim-distinction.md)
- [§Destructure globalThis at top](endo--packages-immutable-arraybuffer-src-immutable-arraybuffer-shim-js--pony-vs-shim-distinction-and-conditional-method-via-conditional-spread-and-warning-not-error-on-prior-installation--destructure-globalthis-at-top.md)
- [§TS flow-based inference workaround via local copy](endo--packages-immutable-arraybuffer-src-immutable-arraybuffer-shim-js--pony-vs-shim-distinction-and-conditional-method-via-conditional-spread-and-warning-not-error-on-prior-installation--ts-flow-based-inference-workaround-via-local-copy.md)
- [§Conditional method via conditional spread](endo--packages-immutable-arraybuffer-src-immutable-arraybuffer-shim-js--pony-vs-shim-distinction-and-conditional-method-via-conditional-spread-and-warning-not-error-on-prior-installation--conditional-method-via-conditional-spread.md)
- [§Better-fidelity emulation of class prototype via non-enumerable properties](endo--packages-immutable-arraybuffer-src-immutable-arraybuffer-shim-js--pony-vs-shim-distinction-and-conditional-method-via-conditional-spread-and-warning-not-error-on-prior-installation--better-fidelity-emulation-of-c.md)
- [§Warning-not-error on prior installation](endo--packages-immutable-arraybuffer-src-immutable-arraybuffer-shim-js--pony-vs-shim-distinction-and-conditional-method-via-conditional-spread-and-warning-not-error-on-prior-installation--warning-not-error-on-prior-installation.md)
- [§The TODO with named confusing-warning acknowledgment](endo--packages-immutable-arraybuffer-src-immutable-arraybuffer-shim-js--pony-vs-shim-distinction-and-conditional-method-via-conditional-spread-and-warning-not-error-on-prior-installation--the-todo-with-named-confusing.md)
- [§Install via defineProperties + getOwnPropertyDescriptors](endo--packages-immutable-arraybuffer-src-immutable-arraybuffer-shim-js--pony-vs-shim-distinction-and-conditional-method-via-conditional-spread-and-warning-not-error-on-prior-installation--install-via-defineproperties-g.md)
- [§Getter as property syntax](endo--packages-immutable-arraybuffer-src-immutable-arraybuffer-shim-js--pony-vs-shim-distinction-and-conditional-method-via-conditional-spread-and-warning-not-error-on-prior-installation--getter-as-property-syntax.md)
- [§Borrowable patterns](endo--packages-immutable-arraybuffer-src-immutable-arraybuffer-shim-js--pony-vs-shim-distinction-and-conditional-method-via-conditional-spread-and-warning-not-error-on-prior-installation--borrowable-patterns.md)
- [§Synthesis target — slot machine library](endo--packages-immutable-arraybuffer-src-immutable-arraybuffer-shim-js--pony-vs-shim-distinction-and-conditional-method-via-conditional-spread-and-warning-not-error-on-prior-installation--synthesis-target-slot-machine-library.md)
- [§Library meta-counters](endo--packages-immutable-arraybuffer-src-immutable-arraybuffer-shim-js--pony-vs-shim-distinction-and-conditional-method-via-conditional-spread-and-warning-not-error-on-prior-installation--library-meta-counters.md)
