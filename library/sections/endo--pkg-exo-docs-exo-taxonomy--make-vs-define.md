---
title: Make instance vs Define class vs Define class kit
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

> Abstract: The first axis. makeExo: one instance per call. defineExoClass: class declaration returning a maker for many instances. defineExoClassKit: class declaration returning a maker for cohorts of facets sharing one state. Each form trades off composition cost vs the kind of state it manages.

## Make instance vs Define class vs Define class kit

### make*Exo
Each call to `makeExo` makes and returns a new fresh Exo instance. Note that there is no `makeVirtualExo` or `makeDurableExo`, although the latter is largely covered by `prepareExo`.

### define*ExoClass
Each call to `defineExoClass`, `defineVirtualExoClass`, or `defineDurableExoClass` defines a class-like category of Exo instances, and makes and returns a "make" function that makes new instances of that category. The arguments to the "define" function describe what all instances of the category have in common, and the arguments to the returned "make" function describe what is specific to the instance being created.

### define*ExoClassKit
We often call a record of named entangled Xs an "XKit", by analogy to a "toolkit" being a collection of closely related tools. Each call to `defineExoClassKit`, `defineVirtualExoClassKit`, or `defineDurableExoClassKit` defines a kit of entangled Exo classes, and makes and returns a "makeKit" function that makes new instances of that kit. Each instance of the kit is a collection of "facets" that share common encapsulated state.


Source: [packages/exo/docs/exo-taxonomy.md](https://github.com/endojs/endo/blob/01ba3f7d57c9/packages/exo/docs/exo-taxonomy.md) at commit `01ba3f7d`.
