---
ts: 2026-06-11T03:39:52Z
kind: result
role: liaison
dispatch: 8c4d64
host: endolin
model: opus-4-7-1m
---

# librarian cycle 292 — chat-lane — `@endo/zip/src/buffer-reader.js`

Cycle 292 (chat-lane after cycle 291 designs-lane @endo/ses/docs/draft-standalone-spec.md). One source ingested: `@endo/zip/src/buffer-reader.js` (274 lines). **Symmetric counterpart to cycle 290's buffer-writer.js** (188 lines), but with richer API (~1.5× lines) reflecting parser task-asymmetry.

## Library state

- 798 sections (up from 797 at cycle 291).
- 338 source documents (up from 337).
- §one-hundred-and-twenty-fifth consecutive designs-chat alternation cycles 166-250 + 252-292 (251 was out-of-band).
- §the-zip-cluster-source-file-deep-ingest-progresses (9 of 12 files now per-file ingested).
- §two-named-reader-writer-pairs-in-the-cluster (high-level cycles 280 + 284 + low-level cycles 290 + 292).

## Files written

- `library/sections/endo--packages-zip-src-buffer-reader-js--WeakMap-private-fields-with-bound-get-helper-and-can-assertCan-do-it-triad-and-IE10-historical-ghost-comment-and-findLast-reverse-search.md` (new section file; 274-line file in full scope).
- `library/sources/endo--packages-zip-src-buffer-reader-js.md` (new source page).
- `library/sections/README.md` (Total bumped 797 → 798; sources 337 → 338; new entry added).
- `library/sources/README.md` (new row inserted).
- `library/keywords.md` (new keyword entries + 45 first-explicit-observations + new counter rows).
- `inboxes/endolin/scholar.md` (drain marker bumped `pending-cycle-291` → `pending-cycle-292`).

## First-explicit-observations (forty-five)

1. **§the-`q = JSON.stringify`-alias-as-named-error-formatting-helper** — sibling to `@endo/errors`'s exported `q` helper.
2. **§the-`privateFieldsGet = privateFields.get.bind(privateFields)`-pattern** — bound version of `get` (cycle 290's writer used `getPrivateFields(self)` named function).
3. **§the-bound-method-IS-the-named-helper-shape** vs cycle 290's named-helper-function shape — §two-named-shapes-for-the-same-purpose-in-the-same-cluster.
4. **§the-named-policy-asymmetry-in-the-cluster** — writer throws on missing-instance; reader returns undefined and casts-it-away.
5. **§the-`@typedef`-named-state-shape** vs cycle 290's inline-anonymous-type — §two-named-shapes-for-WeakMap-private-state-typing-in-the-cluster.
6. **§the-six-field-private-record** — `{ bytes, data, length, index, offset }`; offset IS the new field vs writer's five-field record.
7. **§the-named-window-into-the-underlying-buffer** — offset + length define logical view.
8. **§the-named-view-via-offset-and-length-pattern**.
9. **§the-`set offset(offset)` with-length-recomputation** — setter validates + recomputes derived state.
10. **§two-named-error-messages-in-one-setter** — out-of-range-positive + out-of-range-negative.
11. **§the-`can`/`assertCan`/X-triad-for-each-operation** — three named methods per pre-conditional op.
12. **§three-named-shapes-for-pre-condition-checking** — predicate + assertion + do-it.
13. **§the-named-triad-IS-a-richer-API-than-cycle-290's-writer's-binary-pair**.
14. **§the-named-task-asymmetry-shape** — parsers need richer inspection primitives than emitters.
15. **§the-reader-API-IS-richer-than-the-writer-API** — by ~1.5× lines.
16. **§the-`read = peek + advance`-discipline**.
17. **§the-named-decomposition-of-read-into-peek-plus-advance**.
18. **§the-named-two-shapes-of-reading** — peek (look-without-advancing) + read (look-and-advance).
19. **§the-peek-clamp-discipline** — peek-IS-lenient + read-IS-strict.
20. **§the-IE10-historical-ghost-comment** — `// in IE10, when using subarray(idx, idx), we get the array [0x00] instead of []`.
21. **§the-named-historical-defense-for-a-now-dead-browser**.
22. **§the-comment-IS-the-named-warning-against-modern-simplification**.
23. **§the-`matchAt`-vs-`expect`-distinction** — matchAt (non-advancing, arbitrary index) + expect (current-index, advance-if-match).
24. **§the-named-pair-of-pattern-match-operations**.
25. **§the-named-cursor-aware-vs-cursor-free-distinction**.
26. **§the-named-three-shapes-of-pattern-match** — matchAt + expect + assert.
27. **§the-`assert(expected)` throws-with-detailed-error** — names both expected and actual.
28. **§the-`q(expected)`-via-the-named-alias** — the alias pays off at the error site.
29. **§three-cycles-with-error-message-naming-both-sides** — 284 (file-name + archive-name) + 292 (expected + actual + position).
30. **§the-`findLast(expected)`-reverse-search-pattern** — used for zip's end-of-central-directory.
31. **§the-named-reverse-search-for-a-magic-byte-sequence**.
32. **§the-named-trailing-marker-shape** — a file format with magic-byte marker at the end.
33. **§the-named-zip-specific-need-for-reverse-search**.
34. **§the-buffer-reader-IS-API-shaped-for-the-zip-format-needs**.
35. **§the-`seek` returns-prior-index-for-save-restore-pattern**.
36. **§the-named-prior-index-as-restore-token**.
37. **§the-named-save-restore-protocol-via-return-value**.
38. **§the-named-undo-via-return-value**.
39. **§the-`offset + index`-for-absolute-position-pattern** — two-level indexing.
40. **§the-named-two-level-indexing** — logical + physical.
41. **§the-named-windowed-view-translation**.
42. **§the-`byteAt(index)` for direct-bypass-of-cursor**.
43. **§the-named-cursor-bypass-method** — useful for pattern-matching.
44. **§the-`skip(offset)`-IS-just-`seek(fields.index + offset)`** — named relative-vs-absolute position operations.
45. **§the-named-intent-revealing-convenience-method**.

## Synthesis target

Slot machine library `@game/replay/src/buffer-reader.js`: WeakMap-private-fields with `privateFieldsGet = privateFields.get.bind(privateFields)` bound helper + `q = JSON.stringify` alias for error formatting + `@typedef BufferReaderState` named state shape + six-field private record (bytes + data + length + index + offset) + `set offset()` with length-recomputation + `can`/`assertCan`/X-triad for each operation + `read = peek + advance` discipline + peek-clamp + IE10-style historical-ghost comment + matchAt/expect/assert pattern-match triad + assert error message naming both expected and actual + findLast reverse-search for trailing-marker formats + seek returns prior index for save-restore + offset + index two-level indexing for windowed views + byteAt for cursor-bypass access + skip as relative seek convenience.

## Single most structurally interesting move

**§the-`can`/`assertCan`/X-triad-for-each-operation** — the reader exposes **three named methods for each pre-conditional operation**: a predicate (`canSeek`), an assertion (`assertCanSeek`), and the operation (`seek`). The predicate lets the caller branch; the assertion lets the caller throw at their own boundary; the operation lets the caller proceed.

This is **§the-named-triad-shape-richer-than-the-typical-binary-pair**. The typical API exposes only an assertion + the operation; the reader exposes ALL THREE. The cost IS more method names; the benefit IS that the API supports the *full lattice of caller intents*: "is this safe?" + "throw if not safe" + "just do it".

The triad shape generalizes beyond reading: any operation with a pre-condition can expose a `canX`/`assertCanX`/`X` triple. The discipline IS to *not* fold the predicate into the assertion — keeping them separate lets the caller choose. The reader has this richness; the writer (cycle 290) doesn't (only `ensureCanX` assertions, no `canX` predicates). The asymmetry IS task-asymmetry: parsers more often need to inspect before committing.

## Next cycle

Cycle 293 — designs-lane next.
