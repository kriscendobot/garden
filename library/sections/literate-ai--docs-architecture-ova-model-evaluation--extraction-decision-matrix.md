---
title: OVA evaluation: the extraction decision matrix
source: docs/architecture/ova-model-evaluation.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-29
source_authors: [Jordan Hubbard]
ingested: 2026-10-10
ingested_by: scholar
topics: [agentic-sdlc]
status: current
---

> Abstract: A per-area decision matrix assigns each OVA subsystem a disposition (generalize, redesign, extract behind a port, split, replace, keep only as an example, or reject outright for the mutating reverse-dependents record), names its literate-ai destination (domain models, ports and adapters, CAS package storage, workflow engine, conformance samples, central security domain), and states what remains in OVA as an adapter or downstream integration.

| OVA area | Decision | literate-ai destination | What remains in OVA |
|---|---|---|---|
| Strict schemas, path validation, canonical digests | Generalize | `domain/identity`, per-context models | OVA schema compatibility mapper |
| `OvaComponentSpec` and manifests | Redesign | `ComponentDefinition`, `ComponentRevision`, `component.json` | `ova.yaml` reader and OVA extension fields |
| OpenSpec artifact loading and drift check | Extract behind port | `ports/specs`, `adapters/specs/openspec` | OVA capability vocabulary/spec content |
| Prompt journal | Redesign | immutable `IntentEvent` plus OpenSpec projection | OVA prompt capture UI hook |
| Skills with content digests | Generalize | `ToolRecipeRef`/`SkillRef` | OVA-specific authoring skills |
| Catalog and generated registry | Generalize | descriptor registry and revision registry ports | Omniverse/Isaac catalog entries |
| Source cache, leases, Git/local snapshots | Generalize and harden | source domain plus Git/local/CAS adapters | OVA source-provider configuration |
| CodeGraph index and evidence | Generalize behind port | knowledge domain plus CodeGraph adapter | OVA query templates and capability questions |
| Composition and dependency locks | Redesign | policy-driven resolver | foundation/physics provider policy |
| Complete vocabulary | Redesign | descriptor vocabulary plus lazy grounded closure | OVA catalog presentation |
| Model portfolio/groups/selectors | Generalize | model domain and provider adapters | NVIDIA defaults and OVA UI wording |
| Staged generator and evidence policy | Generalize as workflow engine | run/workflow application services | OVA workflow/profile and prompts |
| Python syntax validator | Extract as plugin example | validator adapter | Omniverse/Isaac validators |
| Source/object package cache | Redesign as immutable CAS | package domain/storage ports | OVA legacy-cache importer |
| Reverse dependents | Reject current mutation | separate dependency graph projection | none |
| Python bytecode builder | Keep only as example adapter | optional Python builder | native OVA/Kit/Isaac builders |
| Component linker | Generalize | artifact closure resolver | OVA runtime linking/launch adapter |
| Filesystem publication | Generalize | filesystem publisher adapter | OVA Settings actions |
| Settings service/UI | Split | typed settings core; optional headless API | Litestar templates/routes and runtime settings |
| Sample ladder | Extract pattern and neutral samples | `samples/` and conformance suite | graphics/robotics samples |
| OVA self-host sample | Replace with neutral snapshot-replication proof | framework readiness sample | OVA-on-framework self-host integration |
| Security classification plan | Move and implement centrally | security domain/policy/runner ports | OVA platform-specific isolation profiles |

Source: [docs/architecture/ova-model-evaluation.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/architecture/ova-model-evaluation.md) at commit `fcc40bc`.
