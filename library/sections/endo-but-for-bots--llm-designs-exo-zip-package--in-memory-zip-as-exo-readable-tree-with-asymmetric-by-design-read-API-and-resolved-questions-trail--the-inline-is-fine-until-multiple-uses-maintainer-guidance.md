---
section: in-memory-zip-as-exo-readable-tree-with-asymmetric-by-design-read-API-and-resolved-questions-trail
source: endo-but-for-bots--llm-designs-exo-zip-package
topics: [exo, daemon, marshal]
status: current
title: The §inline-is-fine-until-multiple-uses maintainer guidance
parent: endo-but-for-bots--llm-designs-exo-zip-package--in-memory-zip-as-exo-readable-tree-with-asymmetric-by-design-read-API-and-resolved-questions-trail
---

The asymmetry rationale concludes:

> *Per the maintainer's guidance on Open Question 3 (review
> [4255618212]), inline is fine until we find multiple uses.*

The §wait-for-second-consumer-before-extracting-a-helper
discipline. Same shape as the standard rule against
premature abstraction: a single consumer doesn't justify a
helper package; a *second* consumer reveals what the
abstraction's *boundary* should be.

The §maintainer-guidance-as-design-constraint pattern: the
design *cites* the maintainer's pull-request review
[#4255618212] as the authority for this decision. The
§authority-trail discipline.
