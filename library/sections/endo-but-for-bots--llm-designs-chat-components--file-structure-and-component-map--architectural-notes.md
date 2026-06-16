---
title: Architectural notes
source: designs/chat-components.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 3b031592e5f97a86e317cb96f1b7c44abb4e41f9
source_date: 2026-03-02
source_authors: [Kris Kowal]
topics: [chat-ui, agent-conventions]
status: current
notes: **Status: Complete** upstream. Sibling of [[endo-but-for-bots--llm-designs-chat-invariants--overview-and-six-invariants]]; this document is the *architecture* counterpart to invariants' *interface contract*. Extracted from `packages/chat/DESIGN.md`.
parent: endo-but-for-bots--llm-designs-chat-components--file-structure-and-component-map
---

The split into per-concern files (Core / UI / Utilities / Command system / Autocomplete / Eval / Message / Spaces) is the result of **extracting** components from a previously-monolithic `chat.js`. Each grouped sub-set is a *layer* — the UI layer mounts components, the command layer is a registry + selector + executor + dynamic form, the autocomplete layer has three peer modules (token / single-path / multi-path) that share conventions but no code (per the autocomplete-list-navigation invariant in
[[endo-but-for-bots--llm-designs-chat-invariants--overview-and-six-invariants]]).

The presence of `playwright.config.ts` alongside source files indicates **E2E tests live in the same package**, not under a sibling `chat-test` package — a project-specific testing convention.

The `monaco-wrapper.js` module is a deliberate boundary: Monaco itself runs in a sandboxed iframe, and the wrapper is what crosses the boundary. The wrapper is also the only place in the package that touches non-SES-safe code, since Monaco is too large to ship under SES.
