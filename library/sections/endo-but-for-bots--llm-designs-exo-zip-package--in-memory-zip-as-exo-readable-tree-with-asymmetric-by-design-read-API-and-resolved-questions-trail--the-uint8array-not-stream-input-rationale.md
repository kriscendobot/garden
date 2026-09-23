---
section: in-memory-zip-as-exo-readable-tree-with-asymmetric-by-design-read-API-and-resolved-questions-trail
source: endo-but-for-bots--llm-designs-exo-zip-package
topics: [exo, daemon, marshal]
status: current
title: The §Uint8Array-not-stream input rationale
parent: endo-but-for-bots--llm-designs-exo-zip-package--in-memory-zip-as-exo-readable-tree-with-asymmetric-by-design-read-API-and-resolved-questions-trail
---

§Design Decision 7 is the most substantively reasoned:

> *Accepting a stream would let very large archives skip the
> buffering step in principle, but `@endo/zip` requires the
> full bytes to parse the central directory anyway, and a
> stream alone is not enough: lazy zip access needs a
> *seekable* stream concept, which the project does not yet
> define. Streaming zip support is deferred until that
> concept exists.*

The §defer-streaming-zip-until-seekable-stream-exists
discipline. Three constraints converge:

1. **`@endo/zip` needs central-directory bytes** — at the
   end of the file, with random-access reads.
2. **No seekable-stream concept exists in @endo** — current
   `ReaderRef` is one-shot forward-only.
3. **Inventing seekable-stream is out of scope** — a separate
   (large) design.

The §three-constraint-combination locks in `Uint8Array`. The
§future-compatibility-via-overload note: *`makeExoZip` can
grow an overload without breaking the `Uint8Array` callers*.
