---
id: object-as-process
aliases: ["object as process", "object as computer", "each object is a computer", "objects with independent control paths", "data and function as processes"]
topics: [programming-language-design]
status: current
---

# Object as process

The **object-as-process** model treats every object as a small computer with state, inputs, outputs, computation, and potentially its own control path. Data and functions differ by behavior and rate of change rather than belonging to separate ontological categories. Objects coordinate by messages and returned results, and system facilities can be reconstructed within the same model. Kay's 1972 DynaBook paper states this as the language foundation for a user-extensible personal medium; Smalltalk, Actors, E, and Endo develop later branches of the same lineage.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [objects as processes](../sections/web--kay-personal-computer-for-children-1972--objects-as-processes.md) | States the uniform stateful-process, independent-control-path, and message-evaluation model. |

## See also

- [[e-language]]: the later capability-secure distributed-object branch of the lineage.
- [[vat-and-compartment]]: the unit that combines heap, event loop, and isolation in E and Endo.
- [[granovetter-operator]]: reference passing by message, the connectivity primitive later made explicit by capability systems.
- [[security-as-extreme-modularity]]: the security reading of strict object modularity.
