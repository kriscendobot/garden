---
source_kind: web
source_url: https://raw.githubusercontent.com/tc39/proposal-shadowrealm/main/README.md
source_content_sha256: 09b2b5df4561f0eabe6665a9fbc67bbd359670054ef19c4ce70e3c872a70903b
source_authors: [Dave Herman, Caridy Patiño, Mark S. Miller, Leo Balter, Rick Waldron, Chengzhong Wu]
source_date: 2024-12-01
retrieved: 2026-07-29
ingested: 2026-07-29
ingested_by: scholar
section_count: 1
status: current
notes: "TC39 ShadowRealm API proposal README (Stage 2.7). Repo is proposal-shadowrealm, default branch `main`. Fetched direct via scripts/jobs/fetch-source.sh (source_fetched_via=direct); idempotency anchor is source_content_sha256. Single-section ingest per conventions.md § Sectioning shapes (single-screen reference doc): the README is a status card and the substance lives in explainer.md, ingested separately as tc39-module-harmony--shadowrealm-explainer. source_date is an era approximation from the latest listed presentation (2024-12 Stage 3 request). source_authors are the six champions the README lists by GitHub handle (@dherman, @caridy, @erights, @leobalter, @rwaldron, @legendecas), expanded to names. Canonical human page: https://github.com/tc39/proposal-shadowrealm. Ingested as one of the three module-harmony NEIGHBOR proposals flagged but deferred by the layer-4 cycle (job scholar-research-module-harmony-compartment-layer4); part of the tc39-module-harmony cluster."
---

The ShadowRealm proposal's front page: current stage (**2.7**, which corrects the "Stage 3" the library's `module-harmony-intersection-surface` concept previously carried), the six champions, the entire API in four lines of TypeScript (`constructor()`, `importValue(specifier, bindingName)`, `evaluate(sourceText)`, both returning only a primitive or a callable), the presentation timeline from the 2018 Stage 2 request through the December 2024 Stage 3 request, and a four-bullet history recording the move from an exposed-`globalThis` model to a lean isolated-realms API, the ES2015-era origins that never went through the stages process, and Dave Herman's "What are Realms?" gist as the original idea. Its one-sentence definition: "ShadowRealms are a distinct global environment, with its own global object containing its own intrinsics and built-ins."

| Section | Topics | Status |
|---------|--------|--------|
| [overview](../sections/tc39-module-harmony--shadowrealm-readme--overview.md) | module-harmony | current |
