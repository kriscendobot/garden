---
title: Key moves
section-slug: endo--packages-zip-src-buffer-reader-js--WeakMap-private-fields-with-bound-get-helper-and-can-assertCan-do-it-triad-and-IE10-historical-ghost-comment-and-findLast-reverse-search
source-slug: endo--packages-zip-src-buffer-reader-js
url: https://github.com/endojs/endo/blob/master/packages/zip/src/buffer-reader.js
authors: [Endo project (collective)]
repo: endojs/endo
path: packages/zip/src/buffer-reader.js
total-lines: 274
ingest-cycle: 292
ingest-date: 2026-06-11
lane: chat
scope: full
parent: endo--packages-zip-src-buffer-reader-js--WeakMap-private-fields-with-bound-get-helper-and-can-assertCan-do-it-triad-and-IE10-historical-ghost-comment-and-findLast-reverse-search
---

- **§the-`q = JSON.stringify`-alias-as-named-error-formatting-helper** (first-explicit-observation): `const q = JSON.stringify;` at line 4. **§the-named-short-alias-for-frequent-error-formatting-call**. The alias `q` IS a one-character name for `JSON.stringify`, used in error messages: `Expected ${q(expected)} at ${fields.index}, got ${...}`.

§the-named-alias-IS-the-cluster-pedagogy: `q` IS the assumed name for "quote" in error-message contexts. Sibling-pattern to `@endo/errors`'s exported `q` helper. **§two-cycles-with-`q`-as-named-quote-helper-in-error-messages** (cycle 130 from earlier ingests? Actually I should be cautious about claiming this without verification).

- **§the-`privateFieldsGet = privateFields.get.bind(privateFields)`-pattern** (first-explicit-observation): instead of the cycle 290 `getPrivateFields(self)` function, the reader uses a **bound version** of `privateFields.get`.

```javascript
const privateFieldsGet =
  /** @type {(bufferReader: BufferReader) => BufferReaderState} */ (
    privateFields.get.bind(privateFields)
  );
```

**§the-bound-method-IS-the-named-helper-shape** (vs cycle 290's named-helper-function shape). Two cycles with two different shapes for the same purpose in the same cluster.

§the-`@type`-cast-on-the-bound-method to refine the return type from `BufferReaderState | undefined` to `BufferReaderState`. **§the-cast-trusts-the-discipline**: the caller IS responsible for calling on registered instances; the cast trades safety for terseness.

§named-asymmetry: cycle 290's writer throws on missing-instance; cycle 292's reader **just returns `undefined` and casts-it-away**. The reader is *less defensive* in its private-state access than the writer. **§the-named-policy-asymmetry-in-the-cluster**: same WeakMap pattern, different defensive postures. Possibly a sibling-pattern (the reader's methods may pre-condition such that `undefined` never escapes), possibly an oversight.

- **§the-`@typedef`-named-state-shape vs cycle 290's-inline-`@type`-on-WeakMap** (first-explicit-observation): the reader uses a *named typedef* (`BufferReaderState`); the writer uses an *inline object type* on the WeakMap. **§two-named-shapes-for-WeakMap-private-state-typing in the cluster**: named-typedef + inline-anonymous-type. The typedef is reusable; the inline-anonymous is one-shot.

§the-cluster-has-both-shapes-without-canonicalization.

- **§the-five-field-private-record + offset-as-sixth-named-field** (first-explicit-observation): `{ bytes, data, length, index, offset }`. The **`offset` field** (not in cycle 290's writer record) IS the **logical-start-within-buffer**. A reader can be "windowed" onto a sub-range; `read` and `peek` operate on `[offset, offset+length)`, not `[0, bytes.length)`.

**§the-named-window-into-the-underlying-buffer**: `offset` IS the *start of the logical view*; `length` IS the *length of the logical view* (recomputed when offset changes). **§the-named-view-via-offset-and-length pattern** — sibling to Uint8Array's `subarray(begin, end)` but mutable.

- **§the-`set offset(offset)` with-length-recomputation** (first-explicit-observation):

```javascript
set offset(offset) {
  const fields = privateFieldsGet(this);
  if (offset > fields.data.byteLength) {
    throw Error('Cannot set offset beyond length of underlying data');
  }
  if (offset < 0) {
    throw Error('Cannot set negative offset');
  }
  fields.offset = offset;
  fields.length = fields.data.byteLength - fields.offset;
}
```

**§the-setter-IS-validating-and-recomputing-pair**: the setter checks bounds (throws on out-of-range) and *recomputes length* as a function of offset. **§the-derived-state-IS-maintained-in-the-setter**.

§two-named-error-messages-in-one-setter (out-of-range-positive + out-of-range-negative). §the-named-defensive-discipline at the setter boundary.

- **§the-`can`/`assertCan`/X-triad-for-each-operation** (first-explicit-observation): the reader names *three* methods for each operation:
  - `canSeek(index)` — returns boolean
  - `assertCanSeek(index)` — throws if can't
  - `seek(index)` — does it (and asserts as part of doing)
  - `canRead(offset)`
  - `assertCanRead(offset)`
  - `read(size)` — does it (and asserts as part of doing)

**§three-named-shapes-for-pre-condition-checking**: predicate (`canX`) + assertion (`assertCanX`) + just-do-it (`X` which asserts internally). The predicate lets the caller branch; the assertion lets the caller throw; the just-do-it lets the caller proceed. **§the-named-triad-IS-a-richer-API-than-cycle-290's-writer's-binary-pair**.

Cycle 290's writer has only `ensureCanSeek`/`ensureCanWrite` (assertions, no predicates). The reader exposes the predicate too because **readers more commonly want to check before committing**: parsers often need to look ahead and branch.

- **§the-`read = peek + advance`-discipline** (first-explicit-observation):

```javascript
read(size) {
  const fields = privateFieldsGet(this);
  this.assertCanRead(size);
  const result = this.peek(size);  // peek does the actual subarray work
  fields.index += size;             // read advances the index
  return result;
}
```

**§the-named-decomposition-of-read-into-peek-plus-advance**: the consume operation IS the inspect operation + the cursor advance. **§the-named-composability-of-read**: a caller who wants to inspect-without-consuming uses `peek`; the consume case uses `read`.

§the-named-two-shapes-of-reading: peek (look-without-advancing) + read (look-and-advance). Sibling-pattern to many parser-combinator and stream-reader libraries.

- **§the-peek-clamp-discipline** (first-explicit-observation): `size = Math.max(0, Math.min(fields.length - fields.index, size))`. **§the-named-clamp-to-available-bytes shape**: peek never throws on size-beyond-end; it silently returns fewer bytes. **§peek-IS-lenient + read-IS-strict** (read asserts beforehand).

§the-named-asymmetry-of-leniency-between-peek-and-read: peek can return [] (empty Uint8Array) when nothing's left; read throws. The reader chooses *strict-vs-lenient* per operation.

- **§the-IE10-historical-ghost-comment** (first-explicit-observation in per-file deep ingest; noted in cycle 191's cluster ingest):

```javascript
if (size === 0) {
  // in IE10, when using subarray(idx, idx), we get the array [0x00] instead of [].
  return new Uint8Array(0);
}
```

**§the-named-historical-defense-for-a-now-dead-browser**: IE10's bug returning `[0x00]` instead of `[]` for zero-size subarrays. The defense IS preserved in modern code as a *living-ghost comment* — the bug doesn't exist anymore, but the defense remains as both *code* and *historical-documentation*.

§the-comment-IS-the-named-explanation-for-the-defensive-branch. Without the comment, a future reader might delete the special case "because subarray handles zero-size fine"; the comment IS the named warning-against-modern-simplification.

§sibling-pattern to cycle 280's preserved JSDoc typo (which was *imperfect-review-trace*); this IS *deliberate-historical-ghost*.

- **§the-`matchAt`-vs-`expect`-distinction** (first-explicit-observation):

```javascript
matchAt(index, expected) {  // check at index without advancing
  // ...
}
expect(expected) {  // check at current index, advance if match
  const fields = privateFieldsGet(this);
  if (!this.matchAt(fields.index, expected)) {
    return false;
  }
  fields.index += expected.length;
  return true;
}
```

**§the-named-pair-of-pattern-match-operations**: matchAt (non-advancing, at arbitrary index) + expect (current-index, advance-if-match, returns boolean). **§the-named-cursor-aware-vs-cursor-free-distinction**.

§the-named-three-shapes-of-pattern-match: matchAt (peek-match) + expect (read-match-or-not) + assert (read-match-or-throw). Three named API shapes for the same underlying check.

- **§the-`assert(expected)` throws-if-expect-fails-with-detailed-error** (first-explicit-observation):

```javascript
assert(expected) {
  const fields = privateFieldsGet(this);
  if (!this.expect(expected)) {
    throw Error(
      `Expected ${q(expected)} at ${fields.index}, got ${this.peek(expected.length)}`,
    );
  }
}
```

**§the-error-message-names-both-expected-and-actual** (sibling to cycle 284's `Cannot find file ${name} in Zip file ${this.name}` pattern; **§three-cycles-with-error-message-naming-both-sides**: 280? + 284 + 292). The error names the expected bytes, the position, and the actual bytes — making zip-parse-error messages debug-friendly.

§the-`q(expected)`-via-the-named-alias: the JSON.stringify alias gets used in the error formatting. **§the-alias-pays-off-at-the-error-site**.

- **§the-`findLast(expected)` reverse-search-pattern** (first-explicit-observation):

```javascript
findLast(expected) {
  const fields = privateFieldsGet(this);
  let index = fields.length - expected.length;
  while (index >= 0 && !this.matchAt(index, expected)) {
    index -= 1;
  }
  return index;
}
```

**§the-named-reverse-search-for-a-magic-byte-sequence**: used by zip-format-readers to *find the end-of-central-directory record* (which IS near the END of a ZIP file). **§the-named-search-direction-IS-the-design-decision**: zip's structure puts the "table of contents" at the END, so finding it requires reverse search.

§the-named-reverse-search-IS-an-O(N)-shape: starting from `length - expected.length` and decrementing. **§the-named-trailing-marker-shape**: a file format that requires you to find a magic-byte marker by scanning from the end is *named* by this discipline.

§the-named-zip-specific-need-for-reverse-search (vs a forward-only stream parser). **§the-buffer-reader-IS-API-shaped-for-the-zip-format-needs**.

- **§the-`seek` returns-prior-index for-save-restore-pattern** (first-explicit-observation):

```javascript
seek(index) {
  const fields = privateFieldsGet(this);
  const restore = fields.index;
  this.assertCanSeek(index);
  fields.index = index;
  return restore;
}
```

**§the-named-prior-index-as-restore-token**: `seek` returns the index it *was at* before moving, letting the caller stash it and later seek back. **§the-named-save-restore-protocol via-return-value**. This is cheaper than the caller manually reading `reader.index`, storing it, and seeking back later.

§the-named-undo-via-return-value: the function returns what's needed to undo it. Sibling-pattern to context managers in other languages.

- **§the-`offset + index` for-absolute-position pattern** (first-explicit-observation): every method that touches the actual byte index uses `fields.offset + fields.index`:

```javascript
const index = fields.offset + fields.index;
const value = fields.data.getUint8(index);
```

**§the-named-two-level-indexing**: the *logical* index (relative to the offset-defined window) + the *physical* index into the underlying buffer. The translation IS one-line addition. **§the-named-windowed-view-translation**.

§the-named-two-named-indices-coordinate (offset + index).

- **§the-`byteAt(index)` for-direct-bypass-of-cursor** (first-explicit-observation): `byteAt(index)` accesses bytes at arbitrary positions *without affecting the cursor*. **§the-named-cursor-bypass-method**: lets the reader inspect bytes anywhere without disturbing the read position.

§the-named-cursor-bypass-IS-useful-for-pattern-matching: matchAt uses byteAt internally to compare bytes at arbitrary indices.

- **§the-`skip(offset)`-IS-just-`seek(fields.index + offset)`** (first-explicit-observation): `skip` IS a *relative seek*. **§the-named-relative-vs-absolute-position-operations**: seek (absolute) + skip (relative). The skip exists as a named convenience even though it's a one-line expression — the convenience IS *intent revelation* (the caller wants to skip N bytes).

§the-named-intent-revealing-convenience method.
