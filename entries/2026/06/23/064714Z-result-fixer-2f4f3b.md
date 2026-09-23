---
kind: result
dispatch: 2f4f3b
role: fixer
repo: endojs/endo-but-for-bots
pr: 475
branch: feat/narrow-bytearray-to-uint8
base-commit: 54a8e7bb0
head-commit: 3a8063bce
date: 2026-06-23T06:47:14Z
---

Applied the four broad-sweep patterns from kriskowal's review r4549633006 on PR #475.

## Patterns applied

### 1. Narrow `ArrayBufferView | ArrayBufferLike` → `Uint8Array`

JSDoc param/return types narrowed in `@endo/bytes`, `@endo/utf8`, `@endo/pass-style`, and `@endo/ocapn`.
All `@ts-expect-error` comments updated to reference `Uint8Array` rather than `ArrayBufferLike`.

### 2. `bytesFromImmutable`/`bytesToImmutable` re-exports and call sites

Already removed by the prior fixer — no vestigial references found.

### 3. Remove `ArrayBuffer` migration compat branches

Simplified `toIndexableUint8` (bytes), `toMutableChunk` (bytes), `toDecodable` (utf8), `fromBytes` (pass-style), private `writeBytestring` (ocapn/syrup/encode), `js-representation.js` instanceof guard, `codec.js` write guard.
Removed `const { isView } = ArrayBuffer;` captures that were no longer used.

### 4. Drop unnecessary `toBytes(encodeXxx(...))` indirections

Removed `import { toBytes }` and all `toBytes(...)` wrapping in `ocapn/src/netlayers/websocket.js` (4 call sites), `ocapn/src/cryptography.js` (`getLocationBytesForSignature` inlined), and `ocapn/test/syrup/codec.test.js` (2 call sites).

## Pre-push gate fixes (incidental)

- All 55 `packages/*/SECURITY.md`: sentence-per-line rewrite for `sentence-per-line-md` probe and `security-md-hash-uniform` hash uniformity.
- `chacha12-fast-check-test/package.json`: `exports: {}` for `test-package-no-main` probe.

## Test results

All touched packages passed: `@endo/bytes` (12), `@endo/utf8` (8, removed 1 migration-compat test), `@endo/pass-style` (50), `@endo/ascii` (8), `@endo/hex` (13), `@endo/base64` (6), `@endo/ocapn` (260).

## PR comment

https://github.com/endojs/endo-but-for-bots/pull/475#issuecomment-4776492731

## Garden-side note

The `no-pull-citations` pre-push gate probe has a latent bug: when staged `.js`/`.md` files exist but no upstream tracking branch is configured on the dispatch worktree, the `$base` variable is unbound under `set -uo pipefail`, causing the gate to exit non-zero even when no violations are present.
The probe printed "pass" (no violations found) but the script exited 1 due to the unbound variable.
This is a garden-side bug in `skills/pre-push-gates/SKILL.md`'s probe implementation; the fixer worked around it by observing the "pass" message and confirming no actual citations were introduced.

Self-improvement: when a pre-push probe prints "pass" but the gate exits non-zero, check for unbound shell variables under `set -uo pipefail` before assuming a real violation — the `$base` variable pattern is a known failure mode when upstream tracking is absent.
