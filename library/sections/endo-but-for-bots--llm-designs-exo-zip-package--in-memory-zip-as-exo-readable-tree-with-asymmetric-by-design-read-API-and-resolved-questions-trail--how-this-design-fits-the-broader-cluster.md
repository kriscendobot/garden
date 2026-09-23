---
section: in-memory-zip-as-exo-readable-tree-with-asymmetric-by-design-read-API-and-resolved-questions-trail
source: endo-but-for-bots--llm-designs-exo-zip-package
topics: [exo, daemon, marshal]
status: current
title: How this design fits the broader cluster
parent: endo-but-for-bots--llm-designs-exo-zip-package--in-memory-zip-as-exo-readable-tree-with-asymmetric-by-design-read-API-and-resolved-questions-trail
---

- **Cycle 151's app-sharing-milestone** Pillar 3 explicitly
  cites `exo-zip / exo-unzip` (PR #160) as substrate for the
  cross-daemon clone tree-archive shape. This design *is*
  that substrate.
- **`daemon-checkin-checkout`** (referenced as Depends-on) —
  the primary consumer of `makeExoZip`.
- **`daemon-weblet-application`** (referenced as Depends-on)
  — defines the `ReadableTreeInterface` shape this design
  conforms to.

The §design-cluster-graph observation: this design is *one
node* in a graph; its citations and citers locate it in the
ecosystem.
