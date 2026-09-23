---
section: in-memory-zip-as-exo-readable-tree-with-asymmetric-by-design-read-API-and-resolved-questions-trail
source: endo-but-for-bots--llm-designs-exo-zip-package
topics: [exo, daemon, marshal]
status: current
title: The §separate-package-not-sibling-export discipline
parent: endo-but-for-bots--llm-designs-exo-zip-package--in-memory-zip-as-exo-readable-tree-with-asymmetric-by-design-read-API-and-resolved-questions-trail
---

§Design Decision 8:

> *`@endo/zip` is deliberately dependency-free. Folding the
> adapter in (even as a sibling entry point) would entrain
> Passable / exo machinery into `@endo/zip`'s core library.
> A separate package keeps `@endo/zip` minimal and isolates
> the exo / `@endo/platform` dependency chain to the
> adapter.*

The §package-cleanliness-as-design-constraint observation.
Adding a sibling export to `@endo/zip` would *transitively*
add `@endo/passable`, `@endo/exo`, `@endo/platform`, etc., to
*every* consumer of `@endo/zip`. The separate package
*isolates* the dependency surface.

The §don't-pollute-a-clean-package discipline. Where cycle
142's passStyle-helpers.js avoids depending on SES (and
duplicates `isTypedArray`), this design avoids forcing exo
machinery into `@endo/zip`.
