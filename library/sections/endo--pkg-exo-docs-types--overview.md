---
title: Exo types (overview)
source: packages/exo/docs/types.md
source_repo: endojs/endo
source_commit: f7a88bbe5cc507799671d685571cad3c5af05b47
source_date: 2024-11-04
source_authors: [Kris Kowal]
ingested: 2026-05-14
ingested_by: scholar
topics: [exo, typescript-conventions]
status: current
---

> Abstract: How Exo's runtime method guards interact with static TypeScript annotations. Matrix of four behaviors based on whether the implementation is plain-or-typed and whether method guards are present. Tiny pointer-style doc (12 lines).

# Exo types

Exos have runtime guards and also static type annotations. Both are optional, leading to this matrix of behaviors:

| Impl   | Unguarded | Guarded |
| -- | -- | -- |
| **plain** | inferred from JS | guard wins |
| **typed** | impl wins | compatibility check[^1][^2] |

[^1]: We pick the impl type because it has the param names and the guard doesn't.
[^2]: Use `GuardedMethods<typeof exo>` to opt into the guard's type contract (e.g. `.optional()` params). Parameter names are not preserved (TS limitation).


Source: [packages/exo/docs/types.md](https://github.com/endojs/endo/blob/f7a88bbe5cc507799671d685571cad3c5af05b47/packages/exo/docs/types.md) at commit `f7a88bbe`.
