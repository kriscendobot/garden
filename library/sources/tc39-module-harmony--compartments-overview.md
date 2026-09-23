---
source_kind: web
source_url: https://raw.githubusercontent.com/tc39/proposal-compartments/master/README.md
source_content_sha256: 4823bfbcfa07cc0962718d1846c3eb8b001fc1abf921f86b1539f30fc157b70f
source_authors: [Mark S. Miller, Caridy Patiño, Patrick Soquet, Kris Kowal, Jack Works, Guy Bedford]
source_date: 2024-01-01
retrieved: 2026-07-21
ingested: 2026-07-21
ingested_by: scholar
section_count: 1
status: current
notes: "TC39 Compartments proposal (Stage 1), the hub README. Default branch is `master`. Fetched direct via scripts/jobs/fetch-source.sh; idempotency anchor is source_content_sha256. source_date is an era approximation. Canonical human page: https://github.com/tc39/proposal-compartments. This is the UPSTREAM TC39 proposal; the garden's fresh minimal-Compartments design (journal/projects/proposal-compartments) diverges from it (has ABANDONED module descriptors, keys module instances on an opaque ModuleSource). The layered explainer files 1-static-analysis, 2-virtual-module-source, 3-evaluator, 4-compartment, and GRAPH.md are DEFERRED to follow-on job scholar-research-module-harmony-intersection. Part of the tc39-module-harmony cluster."
---

The TC39 **Compartments** proposal isolates and grants limited power to programs within a shared realm: a compartment shares a realm's intrinsics but has its own evaluators (`eval`, `Function`, a new `Module`) and its own global object. Refactored after cross-proposal coherence work into five lower-level layers — Module+ModuleSource, static analysis, virtual module sources, Evaluators, Compartment — from which compartments can be built in user code. This hub section maps the five layers; layer-0 detail is ingested under `tc39-module-harmony--compartments-module-and-source--*`. It is the intersection contract the garden's fresh minimal design inherits and partly diverges from.

| Section | Topics | Status |
|---------|--------|--------|
| [five-layer-compartment-structure](../sections/tc39-module-harmony--compartments-overview--five-layer-compartment-structure.md) | module-harmony, compartments | current |
