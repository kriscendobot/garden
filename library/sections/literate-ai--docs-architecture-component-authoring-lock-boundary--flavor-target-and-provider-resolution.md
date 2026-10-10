---
title: Flavor, target, policy, and provider-resolution fields
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

> Abstract: The new Component lock holds only exact selected Flavor slot results and target/policy identities, while rejected or unrelated candidates live solely in a ComponentResolutionAudit, so an unrelated Flavor change refreshes the audit deterministically without changing derivation identity; alternative implementation-provider resolution is a separate project-owned capability resolution bound into ComponentLock.provider_resolutions.

| Meaning | Class | Destination |
| --- | --- | --- |
| slot declaration and user `+flavor`/`-flavor` override | Authored intent or selector | authoring/project request |
| Flavor coordinate/value constraint | Resolvable selector | authoring/project request |
| selected exact Flavor revision per slot | Resolved identity | `NodeTargetFlavorSelection` in the node lock |
| target name | Authored selection | Component lock and every node selection |
| exact target-profile and selection-policy identities | Resolved identity | Component lock and every node selection; all must agree |
| resolver implementation/policy identity | Resolved identity | Component lock |
| rejected, conflicting, unavailable, or unrelated candidates and reasons | Catalog audit | `ComponentResolutionAudit` only |

`FlavorSetLock` remains a compatibility contract; it includes rejected candidates, so its identity is not the selected derivation identity used by the new Component lock, which contains only exact selected slot results. Changing an unrelated Flavor therefore leaves the selected lock and downstream derivation identity unchanged while changing the resolution audit and requiring the lock/audit admission pair to be refreshed before the next lifecycle. That refresh is deterministic and model-free.

Alternative implementation-provider resolution is separate from Flavor-slot selection. A project owns provider IDs, capability declarations, requirements, preference, and fallback order; a Flavor may supply one exact override declaration. The canonical resolver validates sufficiency and binds the complete result into `ComponentLock.provider_resolutions`, and generation keys repeat those identities. Capability-catalog drift therefore changes lock and plan identity, and a newly sufficient preferred provider deterministically replaces an earlier fallback (see the upstream `provider-resolution.md`).

Source: [docs/architecture/component-authoring-lock-boundary.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/architecture/component-authoring-lock-boundary.md) at commit `fcc40bc`.
