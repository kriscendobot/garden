---
title: A Taxonomy of Exo-making Functions
source: packages/exo/docs/exo-taxonomy.md
source_repo: endojs/endo
source_commit: 01ba3f7d57c9
source_date: 2023-01-27
source_authors: [Mark S. Miller]
ingested: 2026-05-14
ingested_by: scholar
topics: [exo]
status: current
---

> Abstract: Mark Miller's taxonomy of the Exo-making functions. Frames the design space along two axes: (1) make-instance vs define-class vs define-class-kit, and (2) heap vs virtual vs durable. Plus the make-vs-prepare distinction for durable variants. Older document (2023); still the cleanest map of why each form exists.

# A Taxonomy of Exo-making Functions

An Exo is a Far object protected by an interface guard. We chose the term "exo" because
* It means "outside". An exo object is reachable from outside the vat. Other vats can hold a reference (a capability) to an exo, and anyone with a reference to an exo can send it messages.
* It alludes to "ExoSkeleton", a protective outside layer that is an effective first defense against many threats. Likewise, an exo's interface guard is a great first layer of type-like ([pattern](https://github.com/endojs/endo/tree/master/packages/patterns)-based) input validation protecting against many kinds of bad messages. The programmer's remaining burden to make the exo objects fully defensive thus becomes easier.

"Exo" also forms a nice pairing with [Endo](https://github.com/endojs/endo) itself.


Source: [packages/exo/docs/exo-taxonomy.md](https://github.com/endojs/endo/blob/01ba3f7d57c9/packages/exo/docs/exo-taxonomy.md) at commit `01ba3f7d`.
