---
title: Why the renderer must match the chat message pipeline
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

The Markdown renderer reuses the same rendering pipeline as Chat
message display, the `chat-markdown-render` work (see
[[endo-but-for-bots--llm-designs-chat-markdown-render--package-extraction-and-typed-ast]]
for the typed-AST package extraction and
[[endo-but-for-bots--llm-designs-chat-markdown-render--delimiter-realignment-and-flanking-rules]]
for the state-machine scanner). Two consequences of the reuse:

1. **Consistent styling.** A `.md` blob the user previews in the
   editor renders identically to a chat message containing the same
   Markdown. The user does not have to learn two slightly-different
   Markdown dialects depending on which surface is rendering.

2. **Consistent security.** The chat renderer already sanitizes HTML
   and refuses script execution. The editor preview inherits the same
   posture without re-litigating XSS hardening per consumer. The
   chat-markdown-render design's deliberate divergences (such as
   treating `\n` as a hard break, refusing raw HTML inline) apply
   uniformly.

This reuse is one application of the
[[producer-typed-shape-consumer-rendering]] discipline: `@endo/markmdown`
produces a typed AST; the chat-message envelope, the markdown viewer,
and the markdown editor preview are three consumers that each render
the AST. The producer owns the typed shape; each consumer owns its
rendering; the parser does not learn about the editor's
synchronized-scroll quirks or the chat envelope's token-chip
post-process. The same AST flows to all three.

Source: [designs/chat-view-edit-commands.md](https://github.com/endojs/endo-but-for-bots/blob/2691e7d52d061c0a10b89864e879188f2d4e11d7/designs/chat-view-edit-commands.md) at commit `2691e7d5`.
