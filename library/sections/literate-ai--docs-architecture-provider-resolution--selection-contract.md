---
title: Provider resolution: the capability-based selection contract
source: docs/architecture/provider-resolution.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-29
source_authors: [Jordan Hubbard]
ingested: 2026-10-10
ingested_by: scholar
topics: [agentic-sdlc, dynamic-composition]
status: current
---

> Abstract: Literate AI resolves interchangeable providers without owning a project's policy: a Component's `component.md` declares stable provider IDs, exact capability sets, required capabilities, one preferred provider, and an ordered fallback list; a Flavor may override with one exact provider. A fixed four-step policy (override alone or fail closed; preferred if sufficient; fallbacks in declared order; otherwise fail without weakening requirements) yields a result recording selection, request, catalog and policy identities, and fallback reason.

A project supplies stable provider IDs, each provider's exact capability set, required capabilities, one preferred provider, and an ordered fallback list. The canonical resolver owns only the deterministic selection semantics and identity evidence.

`ProviderResolutionDeclaration`, `ProviderResolutionRequest`, and `ProviderCapabilitySet` are provider-neutral public contracts. A Component authors each named declaration in `component.md`; a selected Flavor may author one exact `provider_overrides` entry for that declaration. Required capabilities and each capability set use unique lexical order. Fallback order is explicit and must not repeat the preferred provider. Resolution IDs are unique across the locked Component closure.

```yaml
provider_resolutions:
  - resolution_id: storage
    preferred_provider: native
    required_capabilities:
      - transactions
    fallback_order:
      - portable
    capability_sets:
      - provider_id: native
        capabilities:
          - snapshots
          - transactions
      - provider_id: portable
        capabilities:
          - transactions
```

A Flavor override is deliberately smaller and cannot replace the catalog or weaken the requirements:

```yaml
provider_overrides:
  - resolution_id: storage
    provider_id: portable
```

**Fixed resolution policy:**

1. An explicit Flavor override is evaluated alone. It succeeds only when that provider satisfies every requirement; otherwise resolution fails closed.
2. Without an override, the preferred provider is selected whenever sufficient.
3. Fallback candidates are considered in declared order only after the preferred provider is insufficient. Input catalog traversal order has no effect.
4. If no candidate satisfies every requirement, resolution fails without dropping, weakening, or partitioning requirements.

The result records the selected provider, exact request, evaluated capability-set identities, exact catalog identity, canonical resolver-policy identity, fallback reason, and (only for an override) the exact Flavor declaration and provenance identities.

Source: [docs/architecture/provider-resolution.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/architecture/provider-resolution.md) at commit `fcc40bc`.
