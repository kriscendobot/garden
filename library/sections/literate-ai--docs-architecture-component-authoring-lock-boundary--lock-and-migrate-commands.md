---
title: The litai lock and component migrate commands, and lock-only generation
source: docs/architecture/component-authoring-lock-boundary.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-29
source_authors: [Jordan Hubbard]
ingested: 2026-10-10
ingested_by: scholar
topics: [agentic-sdlc, tooling]
status: current
---

> Abstract: litai lock resolves component.md plus exact catalogs into canonical selected locks and target-scoped audits with non-mutating --check/--diff and atomic, input-revalidated replacement; litai component migrate is a one-way, non-destructive bridge from legacy welded component.json deprecated in 0.2.0 and removed in 0.3.0; plan and generate admit one current lock, never the legacy composer, and every downstream record binds the same ComponentLock.identity.

`litai lock [COMPONENT|PROJECT]` parses `component.md`, validates exact project and Flavor catalog inputs, applies ordered target selectors, resolves the reachable capability graph, and writes canonical selected locks plus target-scoped catalog audits. `--check` and `--diff` are non-mutating. Updates re-read every pinned input immediately before atomic replacement; interrupted or concurrently changed inputs preserve the previous lock. Repository-source selectors deliberately fail until an admitted exact `RepositorySourceLock` exists rather than fabricating a commit or tree.

`litai component migrate COMPONENT|PROJECT` is the explicit compatibility bridge. It reads legacy `component.json` and every welded repository-dependency document through one bounded, revalidated input closure, removes only mechanical resolver identities, proves `parse(render(authoring)) == authoring`, and atomically creates `component.md`. It never overwrites an existing authored document and never deletes or rewrites the legacy file; `--check`/`--diff` report missing/current/conflicting state without writing. Legacy authoring is deprecated in 0.2.0, supported for explicit migration and colocated equivalence evidence only through 0.2.x, and removed in 0.3.0. Deleting a newly created `component.md` leaves the Component migration-required; ordinary commands never silently restore welded authority.

Ordinary validation and generation do not read the legacy manifest. `litai plan` and `litai generate` admit one canonical current lock, treat target and Flavor CLI values as assertions, and project the recipe and CycloneDX graph directly from the lock, never invoking the legacy composer or Flavor resolver. The coding-agent context holds only the root Component's locked specifications and the exact public interfaces on its direct generation edges; acceptance oracles, dependency manifests, private specifications, skills, workflow, routing, and implementation text cannot enter the prompt, and the selected-byte closure is rechecked immediately before model egress.

Recipe, accepted-source, source-cache, CycloneDX, publication, import, receipt, and promotion contracts carry the same exact lock identity and reject substitution; source-to-specification promotion writes `component.md` and the exact lock directly. Planning, toolchain-closure, invalidation, rebuild-request, source-custody, cache-membership, SBOM, package/release, publication/import, and provisional-receipt records all bind `ComponentLock.identity`. The compact current receipt stores identities rather than repeating the lock. Deleting the legacy generation composer remains scope reduction before 0.3.0, not an open selected-authority binding.

Source: [docs/architecture/component-authoring-lock-boundary.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/architecture/component-authoring-lock-boundary.md) at commit `fcc40bc`.
