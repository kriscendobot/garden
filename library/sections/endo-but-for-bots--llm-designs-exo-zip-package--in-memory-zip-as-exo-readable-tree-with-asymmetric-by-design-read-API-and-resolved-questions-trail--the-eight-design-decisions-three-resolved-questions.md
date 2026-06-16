---
section: in-memory-zip-as-exo-readable-tree-with-asymmetric-by-design-read-API-and-resolved-questions-trail
source: endo-but-for-bots--llm-designs-exo-zip-package
topics: [exo, daemon, marshal]
status: current
title: The §eight Design Decisions + §three Resolved Questions
parent: endo-but-for-bots--llm-designs-exo-zip-package--in-memory-zip-as-exo-readable-tree-with-asymmetric-by-design-read-API-and-resolved-questions-trail
---

The design ends with **eight Design Decisions** + **three
Resolved Questions**. The §resolved-questions-not-open-
questions distinction:

> *The original design carried three Open Questions that were
> resolved inline by the maintainer in review
> [4255618212]. Their resolutions are folded into the design
> body above.*

The §captured-resolution-trail discipline: the design *was*
open-questions-bearing; the maintainer *resolved* them in
review; the design *captures* the resolutions but also
preserves *what they were*. Future readers see *the trail of
decisions*, not just the decisions themselves.

The three resolved questions:

1. **`Uint8Array` vs `ReaderRef` input** → `Uint8Array`
   (Decision 7).
2. **`@endo/exo-zip` vs sibling export from `@endo/zip`** →
   separate package (Decision 8).
3. **Walker location** → walker stays inline at the consumer
   (Decision 4 + the §asymmetric-by-design narrative).

The §three-step-design-lifecycle observation: open question →
review resolution → folded into design body. The *trail* is
preserved.
