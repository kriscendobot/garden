---
ts: 2026-06-11T02:34:07Z
kind: result
role: liaison
dispatch: 52675e
host: endolin
model: opus-4-7-1m
---

# librarian cycle 290 — chat-lane — `@endo/zip/src/buffer-writer.js`

Cycle 290 (chat-lane after cycle 289 designs-lane packages/chat/designs/outliner_drag_and_drop.md). One source ingested: `@endo/zip/src/buffer-writer.js` (188 lines). **Per-file deep ingest** of file that was part of cycle 191's zip-cluster ingest at cluster-scope. Implements a **doubling-capacity Uint8Array builder** with **WeakMap-private-fields** for state encapsulation.

## Library state

- 796 sections (up from 795 at cycle 289).
- 336 source documents (up from 335).
- §one-hundred-and-twenty-third consecutive designs-chat alternation cycles 166-250 + 252-290 (251 was out-of-band).
- §the-zip-cluster-source-file-deep-ingest-progresses (8 of 12 files now per-file ingested).

## Files written

- `library/sections/endo--packages-zip-src-buffer-writer-js--WeakMap-private-fields-with-getPrivateFields-helper-and-doubling-capacity-strategy-and-three-named-assertion-functions-and-binary-write-API.md` (new section file; 188-line file in full scope).
- `library/sources/endo--packages-zip-src-buffer-writer-js.md` (new source page).
- `library/sections/README.md` (Total bumped 795 → 796; sources 335 → 336; new entry added).
- `library/sources/README.md` (new row inserted).
- `library/keywords.md` (new keyword entries + 35 first-explicit-observations + new counter rows).
- `inboxes/endolin/scholar.md` (drain marker bumped `pending-cycle-289` → `pending-cycle-290`).

## First-explicit-observations (thirty-five)

1. **§the-WeakMap-private-fields-pattern** (per-file deep ingest extending cycle 191's cluster-scope).
2. **§the-`@type {WeakMap<Class, { ... }>}` named-JSDoc-on-the-WeakMap** — full private-state shape documented at WeakMap declaration.
3. **§the-`getPrivateFields(self)`-named-private-getter-helper** — throws if instance never registered.
4. **§the-WeakMap-IS-the-capability-discriminator**.
5. **§the-`assertNatNumber`-named-assertion-helper** — combines `Number.isSafeInteger` + `>= 0`.
6. **§the-`/** @type {number} */ (n) >= 0`-inline-type-cast** — §two-cycles-with-`@type`-inline-cast-on-unknown-parameter (288 BlobPart + 290 number).
7. **§the-five-field-private-record** — length + index + bytes + data + capacity.
8. **§the-doubling-capacity-strategy** — `while (capacity < required) { capacity *= 2; }`; amortized O(1) append.
9. **§the-while-loop-IS-the-named-grow-to-fit-shape**.
10. **§the-getter-and-setter-pair-for-`index`** — setter delegates to `seek(index)`.
11. **§the-setter-IS-a-method-not-a-mutation**.
12. **§the-`ensureCanSeek` vs `ensureCanWrite`-named-pre-conditions** — composition pattern.
13. **§the-`fields.length = Math.max(...)`-named-watermark-update** — grow-only state.
14. **§the-`DataView.setUint8/16/32`-named-binary-write-primitives**.
15. **§the-DataView-IS-the-named-binary-write-substrate**.
16. **§the-bytes-vs-data-view-pair** — Uint8Array + DataView same buffer.
17. **§the-`littleEndian`-parameter-optional** — default IS big-endian.
18. **§the-named-binary-format-discriminator**.
19. **§the-`subarray()` returning-a-view-vs-`slice()` returning-a-copy** — named-view-and-copy-pair.
20. **§the-double-subarray-call-pattern** — `bytes.subarray(0, length).subarray(begin, end)`.
21. **§the-`copyWithin`-named-internal-bytes-copy-pattern**.
22. **§the-default-capacity-16-as-named-initial-buffer-size** — power of 2 aligning with doubling.
23. **§the-class-method-IS-a-thin-wrapper-around-private-fields** — every method starts with `const fields = getPrivateFields(this);`.
24. **§the-named-shell-and-state-shape**.
25. **§the-no-`harden`-on-private-fields** — privacy IS what protects, not freezing.
26. **§the-named-error-class-tells-the-class-of-failure** — `Error` for runtime-state + `TypeError` for input-validation.
27. **§three-cycles-with-`Error()`-without-`new`-shorthand** (280 + 284 + 290).
28. **§the-`set index(index)`-argument-name-same-as-property-pattern** — syntactic shadowing.
29. **§the-`fields.bytes.set(bytes, fields.index)`-named-bulk-byte-write** — Uint8Array.set IS the named bulk-write primitive.
30. **§the-`fields.index += N`-named-cursor-advance-pattern**.
31. **§the-cursor-and-watermark-coordinate** — two named state coordinates.
32. **§the-`get length()` and `get index()`-but-no-bytes-getter**.
33. **§three-cycles-with-public-API-narrower-than-private-state** (284 + 286 + 290).
34. **§named-two-shapes-of-missing-in-the-zip-cluster** — read-throws + stat-returns-undefined + get-private-fields-throws.
35. **§the-WeakMap-private-fields-IS-structurally-opaque** — survives `Object.getOwnPropertyNames` unlike `#`-prefix fields.

## Synthesis target

Slot machine library `@game/replay/src/buffer-writer.js`: WeakMap-private-fields with `getPrivateFields(self)` helper + `assertNatNumber` (Number.isSafeInteger + non-negative) + five-field private record + doubling-capacity-strategy + getter-and-setter-pair where setter delegates to `seek(index)` + `ensureCanSeek` and `ensureCanWrite` as named pre-conditions + watermark update + DataView's `setUint8/16/32` for binary primitives + optional `littleEndian` parameter + `subarray()` view + `slice()` copy + `copyWithin` for internal byte copy + 16-byte default initial capacity + Uint8Array + DataView pair viewing same buffer + Error class for runtime-state failures + TypeError class for input-validation failures.

## Single most structurally interesting move

**§the-named-shell-and-state-shape** with **§the-`getPrivateFields(this)`-bridge** — every public method on `BufferWriter` IS a thin wrapper that:

1. Calls `getPrivateFields(this)` to get the private state.
2. Mutates that state in some named way.
3. Updates the watermark via `Math.max(fields.index, fields.length)`.

The WeakMap IS the state-storage; the class IS the API-surface; `getPrivateFields(this)` IS the bridge. **§the-class-IS-a-named-protocol-not-a-data-container** — the state lives off-instance.

This pattern predates ECMAScript's `#`-prefix private fields by years AND has a property `#`-fields don't: **the private state IS not even on the instance's own structural form**, so any code that observes the instance (e.g., via `Object.getOwnPropertyNames` or `Object.entries`) sees nothing private. **§the-WeakMap-private-fields-IS-structurally-opaque**, not just access-restricted.

## Next cycle

Cycle 291 — designs-lane next.
