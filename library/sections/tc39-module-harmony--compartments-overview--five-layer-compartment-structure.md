---
title: TC39 Compartments — the five-layer structure and its module-harmony coherence
source_kind: web
source_url: https://raw.githubusercontent.com/tc39/proposal-compartments/master/README.md
source_content_sha256: 4823bfbcfa07cc0962718d1846c3eb8b001fc1abf921f86b1539f30fc157b70f
source_authors: [Mark S. Miller, Caridy Patiño, Patrick Soquet, Kris Kowal, Jack Works, Guy Bedford]
source_date: 2024-01-01
retrieved: 2026-07-21
ingested: 2026-07-21
ingested_by: scholar
topics: [module-harmony, compartments]
status: current
---

Abstract: The TC39 **Compartments** proposal (Stage 1; champions include Mark Miller, Kris Kowal, Caridy Patiño, Patrick Soquet, Guy Bedford) as it stands upstream — a compartment shares a realm's intrinsics but has its own evaluators (`eval`, `Function`, and a new `Module`) and its own **global object**, so it can be granted only the powerful objects it needs. Crucially, the proposal was refactored (after work with the module-blocks / module-fragments / deferred-import / import-reflection champions) into **five lower-level layers** — Module+ModuleSource, static analysis, virtual module sources, Evaluators, and Compartment — from which compartments can be built in *user code*. This layering is the intersection contract the fresh minimal-Compartments design inherits; this section is the map, the layer-0 detail lives in `tc39-module-harmony--compartments-module-and-source--*`. Note: this upstream proposal still carries module *descriptors* / module *instances* framing that the garden's fresh design has **abandoned** in favor of an opaque `ModuleSource` key — see [[module-harmony-intersection-surface]].

## Synopsis

Compartments are a mechanism for isolating and providing limited power to programs within a shared realm. Each compartment shares the intrinsics of a realm, but a different set of evaluators (`eval`, `Function`, and a new evaluator, `Module`) and a global object. Having a separate global object allows each compartment to be granted access to only those powerful objects it needs, its own isolated evaluators, powerless constructors, and shared prototypes.

The proposal was approved for Stage 1 with the charter "to compartmentalize host behaviors." The problem was excess authority flowing from global scope and host behaviors into third-party dependencies and plugins in large applications. Through exploring it, the champions discovered that the bulk of the solution by weight was *virtualizing the EcmaScript module loader*. They then worked with champions of module blocks, module fragments, deferred import, and import reflection to ensure these proposals were coherent, and discovered a set of lower-level interfaces from which compartments could be constructed in user code that were more coherent with these other proposals.

## The five layers

- **[Module and ModuleSource][0]** — first-class `Module` and `ModuleSource` constructors; extend dynamic import to operate on `Module` instances. ([Specification Changes][0-spec])
- **[Surface Module Source Static Analysis][1]** — extend `ModuleSource` instances to reflect static-analysis results (`import`/`export` bindings) so tools can inspect module graphs.
- **[Virtual Module Sources][2]** — extend the `Module` constructor to accept virtual module sources: objects implementing a protocol sufficient to virtualize evaluation of modules in languages not anticipated by ECMA-262 or hosts.
- **[Evaluators][3]** — an `Evaluators` constructor producing a new `eval`, `Function`, and `Module` such that execution contexts refer back to this set, with a given global object and virtualized host behavior for dynamic import in script contexts.
- **[Compartment][4]** — a high-level mechanism for isolating and providing limited power to programs within a shared realm, implementable in user code using `Evaluators`, `Module`, and `ModuleSource`.

`GRAPH.md` (deferred to a follow-on ingest) illustrates the motivation for each feature from these layers and related module proposals.

Source: [proposal-compartments/README.md](https://github.com/tc39/proposal-compartments/blob/master/README.md) at content sha256 `4823bfbc`. Stage 1; retrieved 2026-07-21.
