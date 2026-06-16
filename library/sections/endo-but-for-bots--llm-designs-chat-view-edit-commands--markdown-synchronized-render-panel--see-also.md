---
title: See also
source: designs/chat-view-edit-commands.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 2691e7d52d061c0a10b89864e879188f2d4e11d7
source_date: 2026-03-21
source_authors: [Kris Kowal]
ingested: 2026-05-28
ingested_by: scholar
topics: [chat-ui]
status: current
notes: |
  The most complex part of the design, deferred to Phase 4. The
  source's own framing is that the synchronized-scroll mechanism is
  non-trivial enough to ship the rest of the design first. This
  section consolidates the source's *Markdown: synchronized render
  panel* subsection and threads it to the chat-markdown-render
  pipeline reuse that makes the consistency-across-surfaces claim
  load-bearing.
parent: endo-but-for-bots--llm-designs-chat-view-edit-commands--markdown-synchronized-render-panel
---

- [[endo-but-for-bots--llm-designs-chat-markdown-render--package-extraction-and-typed-ast]] — the `@endo/markmdown` package extraction the renderer reuses; the typed-AST boundary the producer-typed-shape rule names.
- [[endo-but-for-bots--llm-designs-chat-markdown-render--delimiter-realignment-and-flanking-rules]] — the state-machine scanner inside the parser; the deliberate divergences (no raw HTML, hard-break-on-newline) the editor preview inherits.
- [[producer-typed-shape-consumer-rendering]] — the principle the parser/consumer split codifies; this section is one more instance.
- [[endo-but-for-bots--llm-designs-chat-view-edit-commands--phases-dependencies-and-design-decisions]] — Phase 4 and the design decision that justifies the separation.
- [[endo-but-for-bots--llm-designs-chat-color-schemes--implementation-and-monaco-bridge]] — the Monaco-iframe `set-theme` post-message bridge the editor preview's Monaco instance honors; the editor preview is one more consumer of the scheme.

Source: [designs/chat-view-edit-commands.md](https://github.com/endojs/endo-but-for-bots/blob/2691e7d52d061c0a10b89864e879188f2d4e11d7/designs/chat-view-edit-commands.md) at commit `2691e7d5`.
