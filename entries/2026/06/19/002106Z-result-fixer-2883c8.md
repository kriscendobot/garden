---
ts: 2026-06-17T00:30:00Z
kind: result
role: fixer
repo: endojs/endo-but-for-bots
project: endo
---

Investigated erights inline comment 3439597839 on PR #468 (`packages/immutable-arraybuffer/src/lib.js` line 680): "Is this registration redundant?"

The registration `apply(weakmapSet, reverseBuffers, [genuineAB, firstArg])` at line 680 is NOT redundant and was NOT deleted.

Analysis:

- `makeImmutableArrayBufferInternal` (line 402) only populates `buffers` (wrapper -> genuine). It never touches `reverseBuffers`.
- `reverseBuffers` (genuine backing buffer -> immutable wrapper) has exactly one write site: line 680.
- `virtualTypedArrayBufferGetter` (lines 604-620) reads `reverseBuffers` to return the immutable wrapper when `view.buffer` is accessed on a freezable TypedArray wrapper. Without the line 680 registration, `view.buffer` falls through at line 615 and returns the genuine backing `ArrayBuffer` instead of the immutable wrapper, breaking the `view.buffer === iab` invariant.
- The `subarray` method (line 1114) explicitly documents this dependency: sub-views omit a `reverseBuffers.set` call because the parent's construction at line 680 already established the mapping.

Reply posted on comment 3439597839 (id 3439608965) explaining the analysis.

Self-improvement: nothing this time.
