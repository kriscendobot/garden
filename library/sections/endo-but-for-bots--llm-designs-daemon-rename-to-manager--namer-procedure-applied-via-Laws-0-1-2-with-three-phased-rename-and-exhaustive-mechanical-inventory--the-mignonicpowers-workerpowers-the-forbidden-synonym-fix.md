---
section: namer-procedure-applied-via-Laws-0-1-2-with-three-phased-rename-and-exhaustive-mechanical-inventory
source: endo-but-for-bots--llm-designs-daemon-rename-to-manager
topics: [daemon, agent-conventions, repository-governance]
status: current
title: The §MignonicPowers → WorkerPowers — the §forbidden-synonym fix
parent: endo-but-for-bots--llm-designs-daemon-rename-to-manager--namer-procedure-applied-via-Laws-0-1-2-with-three-phased-rename-and-exhaustive-mechanical-inventory
---

`MignonicPowers` (adjective form of "mignon", small/dainty
subordinate) is described as **opaque**:

> *"Mignonic" is a metaphor (small/dainty subordinate) that is
> opaque to a non-French reader and adds no information not
> already carried by `Worker`.*

The §opaque-metaphor-to-non-native-readers observation: a
metaphor that *requires cultural / linguistic context* fails Law
0 for readers without that context.

The §forbidden-synonym argument:

> *The codebase already uses `Worker` everywhere else for the
> same entity (`EndoWorker`, `WorkerInterface`, `WorkerFormula`,
> `provideWorker`). Keeping `Mignonic` solely on the powers
> shape is exactly the forbidden synonym.*

The §two-names-for-one-thing-is-the-forbidden-synonym
principle: the namer procedure forbids *multiple names for the
same entity*. The §existing-name-wins-the-tie tiebreaker.

The §prompt-author's-spelling-correction discipline: the user
prompted "Mignion"; the actual identifier is `MignonicPowers`.
The design *corrects the prompt* and cites the source location
(`packages/daemon/src/types.d.ts` line 89). The §verify-the-
prompt-before-acting habit.
