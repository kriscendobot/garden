---
title: `@endo/markmdown` extraction, typed AST shape, and dependency-injected highlighter
source: designs/chat-markdown-render.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 5e6dbb533c9b9853c681588541362dbdda3a91c6
source_date: 2026-03-27
source_authors: [Kris Kowal]
ingested: 2026-05-15
ingested_by: scholar
topics: [chat-ui, patterns]
status: current
kind: index
section_count: 8
---

> Abstract: The Markdown parser and renderer factor out of `packages/chat/markdown-render.js` into a new standalone package, `@endo/markmdown` (`packages/markmdown`). The package owns the parser (inline state-machine scanner + block parser) and produces a typed AST; it also provides a DOM renderer, but the parser can be consumed independently. Test fixtures live as paired `.md` / `.html` files under `packages/markmdown/test/fixtures/`, making the corpus reviewable in any editor and reusable to validate alternative implementations. The DOM renderer accepts an optional `highlightCode` callback via an options bag; `@endo/markmdown` carries no dependency on Monaco or any editor library. `@endo/chat` becomes a consumer that imports from `@endo/markmdown`, injects a Monaco-backed `highlightCode`, and post-processes the rendered DOM to replace Private-Use-Area placeholder characters with `md-chip-slot` spans. This is the producer-typed-shape / consumer-rendering discipline applied at the parser boundary.

Sections:

- [Package layout](endo-but-for-bots--llm-designs-chat-markdown-render--package-extraction-and-typed-ast--package-layout.md)
- [Test fixture convention](endo-but-for-bots--llm-designs-chat-markdown-render--package-extraction-and-typed-ast--test-fixture-convention.md)
- [Dependency injection for the code highlighter](endo-but-for-bots--llm-designs-chat-markdown-render--package-extraction-and-typed-ast--dependency-injection-for-the-code-highlighter.md)
- [Placeholder handling](endo-but-for-bots--llm-designs-chat-markdown-render--package-extraction-and-typed-ast--placeholder-handling.md)
- [The `@endo/chat` integration layer](endo-but-for-bots--llm-designs-chat-markdown-render--package-extraction-and-typed-ast--the-endo-chat-integration-layer.md)
- [Translation](endo-but-for-bots--llm-designs-chat-markdown-render--package-extraction-and-typed-ast--translation.md)
- [Implications for Endo](endo-but-for-bots--llm-designs-chat-markdown-render--package-extraction-and-typed-ast--implications-for-endo.md)
- [See also](endo-but-for-bots--llm-designs-chat-markdown-render--package-extraction-and-typed-ast--see-also.md)

Source: [designs/chat-markdown-render.md](https://github.com/endojs/endo-but-for-bots/blob/5e6dbb533c9b9853c681588541362dbdda3a91c6/designs/chat-markdown-render.md) at commit `5e6dbb53`.
