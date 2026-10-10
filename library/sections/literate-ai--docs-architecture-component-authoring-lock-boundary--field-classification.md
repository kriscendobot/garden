---
title: Field classification rule and Component field ownership
source: docs/architecture/component-authoring-lock-boundary.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-29
source_authors: [Jordan Hubbard]
ingested: 2026-10-10
ingested_by: scholar
topics: [agentic-sdlc]
status: current
---

> Abstract: Every Component field falls in one class (authored intent, resolvable selector, resolved identity, runtime evidence, or catalog audit) with a defined identity effect; authored pins remain intent but the exact selection is repeated in the lock, selectors resolve to exact references, source snapshots and parent runs are forbidden in both authoring and lock, and authored specification-root order is preserved into a derived specification-set identity.

| Class | Owner | Identity effect |
| --- | --- | --- |
| Authored intent | person or authoring agent | changes the authoring identity |
| Resolvable selector | person or authoring agent | changes authoring identity; resolution produces an exact lock value |
| Resolved identity | deterministic resolver | changes the selected lock and downstream derivation when selected |
| Runtime evidence | lifecycle or inverse-translation process | never changes authoring or lock identity |
| Catalog audit | resolver observation | changes audit identity only when unselected candidates change |

An explicit authored pin is still authored intent: it constrains resolution and outranks defaults, but the exact selected reference is repeated in the lock so consumers need only one exact authority record.

Component field highlights (authoring → lock):

- coordinate, version: authored; repeated in the lock for review and lookup.
- display name, description, profiles, entrypoints, optional lifecycle `kind`: authored; represented by `authoring_identity`, not copied as behavior.
- `provides`: authored capability; becomes a public-interface reference and binding. The public-interface location is a `ComponentContentSelector` resolving to an exact `ContentReference`.
- `requires` (capability, version range, edge kind, optionality, constraints): a narrowed portable contract; becomes an exact `ExecutableComponentEdge` plus identity-bound constraint satisfaction.
- specification provider and ordered roots; skill, workflow, routing-policy, and acceptance-contract paths: selectors with optional pins, each resolving to an exact content reference.
- `flavor_slots`: authored; the declaration repeats in each exact slot result. A capability required only by a selected Flavor (`FlavorDefinition.requires`) becomes a `LockedFlavorRequirement` plus an ordinary executable edge when selected.
- repository-source intent and `ComponentAssetSelector` assets: selectors resolving to an exact repository source lock and `ResolvedComponentAsset` with an exact `BlobRef`.
- preferred alternative provider with fallback order and optional Flavor override: resolves to a complete `ProviderResolution`.
- source snapshot, parent revisions, parent runs: runtime evidence, forbidden in both authoring and lock.

Specification-root order stays authored because providers may assign meaning to the first root. The lock preserves that order and derives `specification_set_identity` from the provider plus every ordered exact specification reference. Set-like collections use canonical semantic-key order, making accidental catalog traversal order structurally invalid rather than normalized after the fact.

Source: [docs/architecture/component-authoring-lock-boundary.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/architecture/component-authoring-lock-boundary.md) at commit `fcc40bc`.
