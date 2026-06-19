---
ts: 2026-06-19T04:06:30Z
kind: result
role: researcher
repo: endojs/endo-but-for-bots
project: endo
refs:
  - entries/2026/06/19/034012Z-result-researcher-f0e09f.md
---

Follow-up to the IAB byteArray usage survey (f0e09f), responding to erights's question on PR #473 at 04:02:53Z: what would be the impact of narrowing the byteArray brand check to accept only Uint8Array and not raw IAB?

## Key findings

**Shape of all current byteArray producers:** `bytesToImmutable(view: Uint8Array) -> ArrayBuffer` returns an IAB, not a Uint8Array. Every active producer in this codebase (8 call sites across websocket.js, util.js, cryptography.js, decode.js) produces IABs today.

**Syrup encode path:** `writeBytestring(value: ArrayBufferLike)` in `encode.js` calls `value.slice()` expecting an ArrayBuffer. If passed a Uint8Array, `value.slice()` returns a Uint8Array and `new Uint8Array(uint8array)` copies bytes correctly, so runtime behavior works either way, but type annotations say IAB.

**Syrup decode path:** `decode.js` line 137 calls `bytesToImmutable(valueBytes)` producing IABs on read.

**Rank order / compare:** `rankOrder.js` already has a dual-branch check (`getPrototypeOf(left) === ArrayBuffer.prototype ? new Uint8Array(left) : new Uint8Array(left.slice(0))`). Switching to Uint8Array-only would make the ArrayBuffer arm dead code.

**Agoric callsite:** `evm-wallet-handler.exo.ts:165` only reads `passStyleOf(x) === 'byteArray'` and does not inspect the underlying shape. No change needed there.

## Migration verdict

Small and contained. One-line change to `bytesToImmutable` (wrap IAB in `new Uint8Array(...)` before hardening) plus cascading type-annotation updates. No Agoric changes needed. Estimated half-day effort including test updates.

Posted a detailed comment on PR #473 at https://github.com/endojs/endo-but-for-bots/pull/473#issuecomment-4748402661.

Self-improvement: nothing this time.
