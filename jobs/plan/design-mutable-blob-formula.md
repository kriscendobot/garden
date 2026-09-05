---
gate: deferred
priority: normal
role: designer
posted_by: liaison
posted_at: 2026-09-05T04:34:58Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Design: a mutable-blob daemon formula (readable-blob / blob / appendable-blob)

Repo: **endojs/endo-but-for-bots**. Deliverable: a single self-contained design at
`designs/mutable-blob-formula.md`, complete enough for a later builder dispatch to
implement from. Read `designs/CLAUDE.md` (or equivalent) first and match the project's
design conventions; do not invent new metadata fields.

Maintainer prompt (kriskowal, 2026-09-05), to be expanded — not narrowed:

> Design a new Endo daemon formula type for mutable block storage of a file, such that
> the storage block can be resized. This would be in contrast to readable blobs, but
> should have the same semantics for methods they have in common. It might follow that
> we should support append-only files as well, which the platform would be free to
> optimize differently, such that we have readable-blob, blob, and appendable-blob.

## What the design must cover

1. **The mutable blob formula.** A new daemon formula type for mutable *block* storage
   of a file, whose storage block can be **resized**. Specify the formula, how an
   instance is persisted in the daemon's state directory, and its lifecycle.

2. **Semantic compatibility with readable blobs — this is the crux.** The mutable blob
   stands *in contrast to* readable blobs, but wherever the two share a method, the
   **semantics must be the same**. Enumerate the common surface explicitly and state,
   method by method, what "the same semantics" means when the underlying bytes can
   change size underneath a reader. Say what a reader holding a readable view observes
   when a writer resizes — that is the question this design exists to answer.

3. **The likely trio.** It may follow that append-only files deserve their own type,
   which the platform would be **free to optimize differently** (an append-only file
   admits cheaper durability and concurrency than a general mutable one). Evaluate
   whether the right shape is the trio **`readable-blob`, `blob`, `appendable-blob`** —
   and say so plainly if the evidence points elsewhere. Treat the trio as a strong
   hypothesis to test, not a settled conclusion.

4. **Substitutability.** Which of the three can stand where another is expected, and in
   which direction. If `appendable-blob` is a narrowing of `blob`, and every one of them
   is readable, make that relationship explicit rather than implied.

## Prior art to consult first

The garden already carries related readable-blob work — consult it before drafting so
this design extends the existing vocabulary instead of forking it:

- `design-readableblob-range-attenuation` and `build-readableblob-range-attenuation`
  (range attenuation over readable blobs)
- `endojs-endo-but-for-bots-pr826-design-readable-blob-lines` (readable-blob lines)

Use [library-lookup] for the rest (formulas, the daemon state directory layout, how
existing blob types are persisted and named).

Where a real fork exists that only the maintainer can settle — most likely the
read-during-resize semantics, and whether the trio is the right factoring — put it in
`## Open questions`. Per the garden's carve-out, a design landing with a non-empty
open-questions section is presented as a review PR rather than landed bare.
