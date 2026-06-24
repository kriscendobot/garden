---
title: "@endo/hex — Uint8Array↔hex string conversion (ponyfill for Stage-4 TC39 proposal-arraybuffer-base64)"
source-slug: endo--packages-hex
url: https://github.com/endojs/endo/tree/master/packages/hex
authors: [Endo contributors]
repo: endojs/endo
path: packages/hex
total-lines: 172 source lines (60 encode + 112 decode); ~80 lines README
status: shipping
ingest-cycle: 215
ingest-date: 2026-06-07
lane: chat
---

# @endo/hex

A small two-file `@endo` package that exposes `encodeHex(bytes): string` and `decodeHex(string, name?): Uint8Array`. It is a §ponyfill for the TC39 `Uint8Array.prototype.toHex` and `Uint8Array.fromHex` intrinsics (proposal-arraybuffer-base64, Stage 4) — on engines that ship the native intrinsics, the package §dispatches-to-them-at-module-load; on older engines and in SES-locked-down compartments that have removed the intrinsics, the package §falls-through-to-a-portable-pure-JS-implementation.

## Key design moves

- **§Ponyfill-with-load-time-dispatch** — the export binding is selected once at module evaluation; no per-call branching.
- **§Pre-lockdown-capture** — captures `Uint8Array.prototype.toHex` and `Uint8Array.fromHex` before SES lockdown freezes the prototype; post-lockdown mutation cannot redirect.
- **§Reflect.apply-as-the-defensive-uncurry** — `const { apply } = Reflect;` then `apply(nativeToHex, bytes, [])` so a tampered `Function.prototype.call` cannot redirect the native intrinsic invocation.
- **§Direct-nibble-computation-from-charcodes** — no lookup table for the polyfill; 2.5-3x faster than table-based on V8 / Node 22 for ~1 MiB inputs; avoids module-scope mutable data.
- **§`c | 0x20`-fold-uppercase-onto-lowercase trick** with §range-check-still-rejects-bit-folded-non-letters.
- **§Native-error-rerun-polyfill-for-better-diagnostic** — on native throw, runs the polyfill to produce a precise offset diagnostic; falls back to propagating native error if polyfill disagrees.
- **§Name-for-error-diagnostics parameter** — optional second arg appears in error messages as §caller-supplied-context-string for debugging.
- **§Two-different-shapes-for-dispatching-to-native**: unconditional for encode (cannot fail on valid input); rerun-polyfill-on-failure for decode (can fail on invalid input).
- **§Harden-every-export** (polyfills + dispatched defaults).
- **§Document-where-the-polyfill-is-known-to-be-slow** (XS) + §point-at-the-native-intrinsic-as-the-eventual-answer.

## Section files

- [§Ponyfill-with-load-time-dispatch + §Pre-lockdown-capture + §Native-error-rerun-polyfill-for-better-diagnostic](../sections/endo--packages-hex--ponyfill-with-load-time-dispatch-and-pre-lockdown-capture-and-native-error-rerun-polyfill-for-better-diagnostic.md) — full design ingest.

## Ingest scope

Cycle 215 (chat-lane): full ingest of the two-file source package and README as one section. The README, encode.js, and decode.js together carry the design vocabulary.
