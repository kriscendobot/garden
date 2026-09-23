---
section: in-memory-zip-as-exo-readable-tree-with-asymmetric-by-design-read-API-and-resolved-questions-trail
source: endo-but-for-bots--llm-designs-exo-zip-package
topics: [exo, daemon, marshal]
status: current
title: The §single-chunk-streamBase64 acceptable
parent: endo-but-for-bots--llm-designs-exo-zip-package--in-memory-zip-as-exo-readable-tree-with-asymmetric-by-design-read-API-and-resolved-questions-trail
---

§Design Decision 5:

> *`@endo/zip`'s reader buffers each entry's decompressed
> bytes in memory. `streamBase64()` therefore yields a single
> chunk. Chunking at, say, 64 KiB is straightforward to add
> later without changing the API.*

The §no-API-change-needed-for-future-chunking observation.
The async iterator returned by `streamBase64()` is *defined
to yield one or more chunks*; yielding one is a valid
implementation. A future implementation yielding multiple
chunks works *without breaking callers*.

The §forward-compatible-by-iterator-shape discipline: an
async iterator's contract is "you'll get *some chunks*";
*how many* is the implementation's choice. Changing from one
to many doesn't change the contract.
