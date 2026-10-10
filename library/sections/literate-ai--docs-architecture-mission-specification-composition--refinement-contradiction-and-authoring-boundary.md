---
title: Refinement, contradiction gates, and the authoring boundary
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

> Abstract: Because natural-language contradiction is not a schema decision, Literate AI splits the VFI "narrow but never contradict" rule into a deterministic structural gate and a pinned planning skill that treats children as refinements and surfaces semantic conflicts (never "nearest wins"), with human approval as the authority transition. `component.md` is the one-file authored default, and exact selections move to a generated `component.lock.json`.

The VFI proposal's "narrow but never contradict" rule is sound as an authoring policy, but arbitrary natural-language contradiction is not a JSON-Schema decision. Literate AI therefore separates two gates:

1. deterministic validation rejects structural ambiguity, cycles, missing nodes, identity mismatches, and invalid frontmatter; and
2. the exact planning skill instructs the coding agent to treat a child as a refinement, expose unresolved semantic conflicts, and never use "nearest wins" to erase a conflicting normative statement.

Human approval remains the authority transition for a semantic resolution. The prompt journal records what the model concluded. The document calls this more honest than describing an LLM judgment as mechanically proven validation.

**Authoring boundary.** `component.md` is now the one-file authored default, and `literate-markdown` reads its body as the root behavior node. The Component authoring and lock separation roadmap (`docs/roadmap/component-authoring-and-locks.md`) tracks the remaining lifecycle compatibility exit: exact selections belong in generated `component.lock.json`, while legacy welded JSON is read only by the explicit migration bridge. Larger mission designs add child documents only for real named boundaries, and split independently generated capabilities into Components with public contracts.

Source: [docs/architecture/mission-specification-composition.md](https://github.com/jordanhubbard/literate-ai/blob/fcc40bc617a2bc2455627db7396a1e016ebfbab6/docs/architecture/mission-specification-composition.md) at commit `fcc40bc`.
