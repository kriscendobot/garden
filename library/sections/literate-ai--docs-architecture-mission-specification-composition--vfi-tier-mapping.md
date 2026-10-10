---
title: Mapping the VFI tiers onto Literate AI
source: docs/architecture/mission-specification-composition.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-29
source_authors: [Jordan Hubbard]
ingested: 2026-10-10
ingested_by: scholar
topics: [agentic-sdlc]
status: current
---

> Abstract: Each VFI proposal tier maps to a distinct Literate AI representation: the app to a root application Component, target choices to Flavor slots, third-party source to source or SBOM-recorded dependencies, core and each feature to independently generatable Components with capability contracts, and backend/frontend/protocol/test/KPI files to local specification nodes only when they carry feature-specific intent, so a 50-feature application is never one giant Component.

| VFI proposal concept | Literate AI representation | Reason |
| --- | --- | --- |
| VFI app | root application Component plus its local app specification | owns product objective and composition requirements |
| language, OS, runtime, frontend strategy, build system | Flavor slots and selected Flavors | target choices must be replaceable and conflict-aware |
| third-party source | repository-source dependency or an external package dependency recorded in the SBOM | not every dependency is a spec-driven Component |
| VFI core | independently generatable Component exposing a versioned capability contract | bounds source, tests, cache, build, and agent context |
| component contract | public capability-interface contract; reusable implementation guidance is a skill | behavior and conversion technique have different authority |
| each VFI feature | one Component, recursively composable through capability requirements | prevents application-wide context flattening |
| backend/frontend/protocol/test/KPI | local specification nodes when each subject is substantial; sections when it is not | file boundaries should improve navigation, not satisfy a ritual |
| cross-component flow | app integration spec or a dedicated integration/flow Component with explicit public interfaces | interactions need an owner and executable acceptance boundary |

A 50-feature VFI application should therefore not be one giant Component merely because all documents live under one conceptual product. The application Component composes feature Components. Each feature may use the familiar `spec.md`, `backend.md`, `frontend.md`, `protocol.md`, `test.md`, and optional `kpi.md` shape locally, but only when those files contain feature-specific intent.

Source: [docs/architecture/mission-specification-composition.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/architecture/mission-specification-composition.md) at commit `fcc40bc`.
