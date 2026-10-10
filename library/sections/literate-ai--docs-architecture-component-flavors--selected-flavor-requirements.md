---
title: Selected-Flavor capability requirements
source: docs/architecture/component-flavors.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-29
source_authors: [Jordan Hubbard]
ingested: 2026-10-10
ingested_by: scholar
topics: [agentic-sdlc]
status: current
---

> Abstract: A selected Flavor may require a Component capability (for example a product packaging Component); the lock planner resolves Component-authored and selected-Flavor requirements to a deterministic fixed point as ordinary edges, records each as a LockedFlavorRequirement, and fails closed on requirement-ID collisions.

A Flavor may declare a Component capability in `requires` when selecting that target necessarily introduces behavior owned by another Component. Packaging is the canonical example: a product-specific `+ovpackage` Flavor can require an independently reusable publication Component without putting NVIDIA packaging policy in the portable base Component or in literate-ai.

These requirements are conditional composition authority, not hidden plugin hooks. The lock planner selects Flavors per reachable Component and then resolves the combined Component-authored and selected-Flavor requirements to a deterministic fixed point. Every selected requirement uses the ordinary unique-provider, semantic-version, constraint, optionality, and dependency-kind rules and produces an ordinary executable Component edge. A recursively introduced provider receives its own target/Flavor selection before its requirements are resolved. An unselected Flavor contributes no provider, edge, prompt material, or identity.

The locked consumer revision records a `LockedFlavorRequirement` holding the exact `FlavorRevision` and the exact requirement it declared. The binding must name a revision already selected for that node, and the requirement must occur in that revision's definition. Requirement IDs must be unique across the Component and all selected Flavors; collisions fail closed rather than creating precedence rules. Empty binding sets are omitted from the wire form, preserving existing lock bytes for Flavors that introduce no Component dependencies.

Source: [docs/architecture/component-flavors.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/architecture/component-flavors.md) at commit `fcc40bc`.
