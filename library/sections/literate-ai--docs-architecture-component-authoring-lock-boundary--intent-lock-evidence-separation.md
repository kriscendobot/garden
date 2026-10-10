---
title: Authored intent, selected lock, and runtime evidence; component.md as the single-file default
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

> Abstract: LOCK-200 separates authored intent (component.md, parsed fail-closed by a strict adapter), the deterministic resolver's selected component.lock.json, its all-candidates resolution audit, and later runtime evidence; component.md is by default the root behavioral specification whose full bytes are identity-bound, with extra Markdown or interface documents justified only by named boundaries and private test oracles kept out of agent context.

Literate AI separates what an author means (`component.md`, authored intent) from what a resolver selected (`component.lock.json`, selected derivation, plus a resolution audit of all candidates) and from what happened later (runtime evidence: receipts and provenance). The records may refer to one another by content identity but never share fields merely because one command computes them together. A deterministic resolver combines `component.md` with catalogs, target, and policy; plan, generate, and build consume the lock.

The document fixes field ownership for `LOCK-200`. A strict adapter parses constrained frontmatter and Markdown into `ComponentAuthoring`; unknown keys, unsafe YAML features, ambiguous scalars, escaping paths, and mismatched path-derived names fail closed. The existing `urn:literate-ai:schema:v2:component-definition` remains frozen and keeps its old welded meaning only for compatibility.

**Single-file default.** `component.md` is both the readable Component declaration and, by default, the root behavioral specification. Omitted provider/root fields deterministically select `literate-markdown` and `component.md` (a syntax default, not an ambient catalog search). Its entire bounded UTF-8 content is identity-bound and supplied once to the generation context, so changing behavioral prose changes the exact specification, revision, plan, and downstream derivation identities.

Additional Markdown documents are justified only by a named domain/module/protocol boundary inside the Component; a separate public-interface document only when another independently generated Component consumes it. Machine-normalized Component JSON is an inspection projection, not peer authoring authority.

Acceptance language and measurable examples belong in `component.md`. A repository may keep independent executable fixtures and expected-value oracles in a separate test catalog, content-bound to the exact Component/specification under test; those locations are not specification roots, and private oracle bytes are forbidden from coding-agent context.

Source: [docs/architecture/component-authoring-lock-boundary.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/architecture/component-authoring-lock-boundary.md) at commit `fcc40bc`.
