---
title: "@endo/immutable-arraybuffer/src/immutable-arraybuffer-shim.js — Pony vs shim distinction + modern-shim installation"
source-slug: endo--packages-immutable-arraybuffer-src-immutable-arraybuffer-shim-js
url: https://github.com/endojs/endo/blob/master/packages/immutable-arraybuffer/src/immutable-arraybuffer-shim.js
authors: [Endo Project Contributors]
repo: endojs/endo
path: packages/immutable-arraybuffer/src/immutable-arraybuffer-shim.js
total-lines: 97
status: published
ingest-cycle: 245
ingest-date: 2026-06-08
lane: chat
---

# @endo/immutable-arraybuffer/src/immutable-arraybuffer-shim.js

A 97-line file that installs the immutable-ArrayBuffer proposal methods onto the platform's `ArrayBuffer.prototype` via the canonical modern-shim discipline. The §shim wraps a §pony module that does the actual work without modifying the platform.

## Key design moves

- **§Pony vs shim distinction** — pony is the mechanism (no side effects), shim is the installation (mutates the platform prototype).
- **§Conditional method via conditional spread** — `transferToImmutable` only added if `optTransferBufferToImmutable` is present.
- **§The `opt` prefix** on pony functions that may or may not be exported.
- **§Better-fidelity emulation of class prototype** via non-enumerable properties.
- **§Strip enumerability via defineProperty loop** after object-literal construction.
- **§Warning-not-error on prior installation** as modern-shim discipline.
- **§Install via defineProperties + getOwnPropertyDescriptors** — canonical batch-install pattern.
- **§TS flow-inference workaround via local rebinding** — comment explains why the import is re-aliased back to canonical name.
- **§Destructure globalThis at top** with `eslint-disable-no-restricted-globals`.
- **§Two eslint-disables with distinct named justifications**.
- **§Getter-as-property syntax** for read-only properties on platform prototypes.
- **§The TODO names a known confusing case** in an acknowledged edge (post-lockdown).

## Section files

- [§pony-vs-shim-distinction + §conditional-method-via-conditional-spread + §warning-not-error-on-prior-installation](../sections/endo--packages-immutable-arraybuffer-src-immutable-arraybuffer-shim-js--pony-vs-shim-distinction-and-conditional-method-via-conditional-spread-and-warning-not-error-on-prior-installation.md) — full 97-line module ingest.

## Ingest scope

Cycle 245 (chat-lane): full 97-line module ingest. §First-explicit-observation of five patterns: §pony-vs-shim-distinction + §strip-enumerability-via-defineProperty-loop + §warning-not-error-on-prior-installation as modern-shim discipline + §install-via-defineProperties-plus-getOwnPropertyDescriptors + §TS-flow-inference-workaround-via-local-rebinding.
