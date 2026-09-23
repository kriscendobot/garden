---
section: in-memory-zip-as-exo-readable-tree-with-asymmetric-by-design-read-API-and-resolved-questions-trail
source: endo-but-for-bots--llm-designs-exo-zip-package
topics: [exo, daemon, marshal]
status: current
title: The §reshape-blocker-for-PR-128 explicit dependency
parent: endo-but-for-bots--llm-designs-exo-zip-package--in-memory-zip-as-exo-readable-tree-with-asymmetric-by-design-read-API-and-resolved-questions-trail
---

> *Reshape blocker for: PR #128 (`checkin.js`). The PR's
> current `checkin.js` extracts to a temp directory; reshape
> merges this design's `makeExoZip` adapter and deletes
> `extractZipToTemp`.*

The §explicit-blockers-section discipline: the design *names
what's downstream of it*. PR #128 cannot land cleanly until
this design ships; the design knows that. The §design-
documents-its-downstream-impact pattern.
