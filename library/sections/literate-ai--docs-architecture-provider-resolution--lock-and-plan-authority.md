---
title: Provider resolution: lock and plan authority
source: docs/architecture/provider-resolution.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-29
source_authors: [Jordan Hubbard]
ingested: 2026-10-10
ingested_by: scholar
topics: [agentic-sdlc, tooling]
status: current
---

> Abstract: `ComponentLock.provider_resolutions` stores complete canonical resolution results, so a capability change alters catalog and resolution identities and stales an old lock by identity rather than timestamp; every `ComponentGenerationKey` repeats the selected identities so caches cannot keep an old choice. Re-resolution restarts from the request (a newly sufficient preferred provider wins at once). `litai lock` / `lock --check` / `plan` author, validate, and project the results; products consume them and must not reimplement ordering, sufficiency, override validation, or provenance.

`ComponentLock.provider_resolutions` stores complete canonical results. A provider capability change therefore changes the catalog and resolution identities, making an old lock stale by identity rather than by an ambient timestamp. Every `ComponentGenerationKey` repeats the selected resolution identities, so execution-plan and generated-source cache identities cannot silently retain an old provider choice.

Re-resolving after catalog evolution starts from the request again. If the preferred provider gains the missing capability, it is selected immediately even when the prior lock selected a fallback.

**CLI surface.**

- `litai lock COMPONENT` authors the exact result into `component.lock.json` and reports the resolution ID, selected provider, fallback reason, result identity, and exact override declaration/provenance identities.
- `litai lock --check` validates the same inputs without writing.
- `litai plan COMPONENT` projects every complete provider result from the admitted lock under `resolution.provider_resolutions`.

**Python API.** Both authored and already-projected integration surfaces are exported:

```python
from literate_ai.contracts import (
    ProviderCapabilitySet,
    ProviderOverrideDeclaration,
    ProviderResolutionDeclaration,
    ProviderResolutionRequest,
    resolve_provider,
    resolve_provider_declaration,
)
```

Derived products should normally author `component.md` and `flavor.md` and consume the selected result from the lock or plan. Product APIs may project mission declarations into these contracts directly, but must not reimplement ordering, sufficiency, override validation, or provenance rules.

Source: [docs/architecture/provider-resolution.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/architecture/provider-resolution.md) at commit `fcc40bc`.
