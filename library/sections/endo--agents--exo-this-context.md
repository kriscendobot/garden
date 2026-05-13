---
title: Exo `this` context
source: AGENTS.md
source_repo: endojs/endo
source_commit: 6ea51ece638e2c842a12ec23164c21cbc24f3cbe
source_date: 2026-03-21
source_authors: [Turadg Aleahmad]
ingested: 2026-05-13
ingested_by: liaison
topics: [exo, agent-conventions, typescript-conventions]
status: current
---

> Abstract: Exo methods receive a `this` context whose shape depends on the API: `makeExo` and `defineExoClass` expose `this.self`; `defineExoClassKit` exposes `this.facets` instead (no single self in a multi-facet kit). State (`this.state`) is present for the two class APIs, absent for `makeExo`. Never mix `self` and `facets` in the same `ThisType<>` annotation.

## Exo `this` context

Exo methods receive a `this` context (via `ThisType<>`) that differs between single-facet and multi-facet exos:

| API | `this.self` | `this.facets` | `this.state` |
|-----|-------------|---------------|--------------|
| `makeExo` | ✅ the exo instance | ❌ | ❌ (always `{}`) |
| `defineExoClass` | ✅ the exo instance | ❌ | ✅ from `init()` |
| `defineExoClassKit` | ❌ | ✅ all facets in cohort | ✅ from `init()` |

**Why no `self` on kits?** A kit has multiple facets (e.g. `public`, `admin`), each a separate remotable object. There is no single "self". Use `this.facets.facetName` to access any facet in the cohort.

When writing `ThisType<>` annotations in `types-index.d.ts`:

- Single-facet: `ThisType<{ self: Guarded<M>; state: S }>`
- Multi-facet: `ThisType<{ facets: GuardedKit<F>; state: S }>`

Never mix `self` and `facets` in the same context type.

Source: [AGENTS.md](https://github.com/endojs/endo/blob/6ea51ece638e2c842a12ec23164c21cbc24f3cbe/AGENTS.md) at commit `6ea51ece`.
