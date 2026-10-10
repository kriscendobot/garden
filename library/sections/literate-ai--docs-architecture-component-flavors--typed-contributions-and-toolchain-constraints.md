---
title: Typed Flavor contributions and toolchain-constraint artifacts
source: docs/architecture/component-flavors.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-29
source_authors: [Jordan Hubbard]
ingested: 2026-10-10
ingested_by: scholar
topics: [agentic-sdlc, tooling]
status: current
---

> Abstract: Flavors contribute through typed fields with per-field merge operators (additive set, keyed union, exact single selection, explicit conflict) rather than raw patch or last-wins merging; toolchain requirements are content-pinned typed JSON artifacts whose Component and Flavor constraints are intersected and fail closed on empty intersections or command disagreement.

Allowed contribution types:

| Contribution | Example |
|---|---|
| Capability/requirement | `platform.windows`, `compute.cuda >= 13` |
| Specification fragment | Windows service-install behavior |
| Workflow binding | use a Rust generation/build profile |
| Authoring skills | CUDA kernel or MSVC packaging skill |
| Validator | Windows ABI or CUDA compute-capability check |
| Builder/toolchain | exact MSVC, clang, nvcc, Python, or Cargo toolchain lock |
| Packaging/runtime | wheel, MSI, OCI, driver/runtime compatibility |

Flavor schemas define a merge operator per field: additive set, keyed union, exact single selection, or explicit conflict. Raw JSON/YAML patch operations, path-dependent precedence, and "last wins" are rejected; two contributions to the same singleton must be identity-equal or fail resolution.

Toolchain requirements are data, not instructions hidden in prose. A toolchain Flavor contributes an `exact-singleton` reference with content kind `toolchain-constraint`, using the closed `urn:literate-ai:schema:v2:toolchain-constraint` contract:

```json
{
  "schema": "urn:literate-ai:schema:v2:toolchain-constraint",
  "toolchain": "python",
  "minimum_version": [3, 11]
}
```

The optional `command` is an argument vector, never shell text; `minimum_version` and `required_version` are one-to-three-part integer prefixes. The contribution slot must equal the typed toolchain name, and the bytes must match the `ContentReference` digest and resolve to a regular file inside the project boundary before entering an effective revision.

A Component may pin the same typed artifact through `authoring_inputs` when the requirement belongs to the application rather than a target Flavor. Component and selected-Flavor constraints are intersected: the strongest minimum survives, compatible required prefixes narrow to the most specific, and command vectors must be exactly equal when several sources pin them. Empty intersections and command disagreements fail before toolchain discovery. Remediation metadata stays content-pinned and is diagnostic authority, not permission to install software; conflicting remediation records fail closed. Source content identities appear in plans and sample evidence.

Source: [docs/architecture/component-flavors.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/architecture/component-flavors.md) at commit `fcc40bc`.
