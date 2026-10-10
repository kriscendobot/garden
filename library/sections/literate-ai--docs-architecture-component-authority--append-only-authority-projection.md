---
title: Component authority as an append-only evidence projection
source: docs/architecture/component-authority.md
source_repo: jordanhubbard/literate-ai
source_commit: fcc40bc617a2bc2455627db7396a1e016ebfbab6
source_date: 2026-09-29
source_authors: [Jordan Hubbard]
ingested: 2026-10-10
ingested_by: scholar
topics: [agentic-sdlc]
status: current
---

> Abstract: Which artifact holds a Component's implementation authority is recorded not in component.md but as an immutable, predecessor-chained projection under provenance/component-authority/ that moves source-authoritative to spec-assisted to derived-source-retained to regeneratively-qualified-fungible, where only regenerative qualification makes source fungible and any input change falls back to retained.

A Component's authored `component.md` says what the Component is and does; it does not say which artifact currently has implementation authority. Literate AI records that fact separately as an immutable, content-addressed projection under `provenance/component-authority/`.

States and transitions:

- `source-authoritative` (from source inventory) → `spec-assisted` (specification derivation) → `derived-source-retained` (human acceptance) → `regeneratively-qualified-fungible` (regenerative qualification).
- `regeneratively-qualified-fungible` → `derived-source-retained` on semantic, policy, or verifier invalidation.

Every arrow creates a new projection naming its predecessor and the exact evidence for the transition. The store rejects a skipped state, a fork from stale history, a rewrite at an existing digest, a broken predecessor, and content whose digest does not match its file name. Facts that do not exist yet are JSON `null`; Literate AI does not invent hashes to make an incomplete record look complete.

Human acceptance of a source-derived specification deliberately stops at `derived-source-retained`. Only a separate regenerative qualification can make source fungible. Qualification binds the Component revision, target lock, complete Flavor/skill/workflow/routing closure, verifier, policy, and evidence; a change to any of those makes the effective state retained-source again.

The original source is evidence, not generation input. Promotion journals live under `provenance/source-promotion/`, outside every Component and specification root, and the authority projection holds only the promotion record's content identity. Retention is independent of authority: neither a transition nor qualification deletes source.

`litai spec status . --json` distinguishes the recorded state from the effective state and lists machine-readable blockers such as `regenerative-qualification-required` or `verifier-changed`.

Source: [docs/architecture/component-authority.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/architecture/component-authority.md) at commit `fcc40bc`.
