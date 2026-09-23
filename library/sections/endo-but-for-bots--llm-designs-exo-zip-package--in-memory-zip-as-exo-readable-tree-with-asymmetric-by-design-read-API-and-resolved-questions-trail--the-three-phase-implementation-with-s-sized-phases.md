---
section: in-memory-zip-as-exo-readable-tree-with-asymmetric-by-design-read-API-and-resolved-questions-trail
source: endo-but-for-bots--llm-designs-exo-zip-package
topics: [exo, daemon, marshal]
status: current
title: The §three-phase-implementation with §S-sized-phases
parent: endo-but-for-bots--llm-designs-exo-zip-package--in-memory-zip-as-exo-readable-tree-with-asymmetric-by-design-read-API-and-resolved-questions-trail
---

§Implementation Phases:

1. **Package skeleton (S)** — minimal scaffold + stub.
2. **`makeExoZip` read path (S)** — full implementation +
   tests.
3. **PR #128 `checkin.js` reshape (S)** — drop
   `extractZipToTemp` + try/finally.

All three are **size S** (small). Phases 1+2 land in a single
*feat* PR; phase 3 is a follow-on retargeting PR #128. The
§small-S-phases-can-bundle observation: when all phases are
small, the natural-PR-boundary follows code-locality, not
phase-boundary.
