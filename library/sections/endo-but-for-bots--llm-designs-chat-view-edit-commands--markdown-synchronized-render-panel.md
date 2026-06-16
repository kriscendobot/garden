---
title: Markdown synchronized render panel
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
kind: index
section_count: 5
---

> Abstract: Markdown files (`.md` extension) get special treatment in
> both `/view` and `/edit`. `/view` renders Markdown as formatted HTML
> by default with a toggle to show raw source. `/edit` uses a
> side-by-side layout: Monaco editor on the left, live-rendered HTML
> preview on the right, **with scroll synchronization between the two
> panels so that the preview tracks the cursor's location in the
> source**. The renderer is the same pipeline used to display chat
> messages (the `chat-markdown-render` work, eventually `@endo/markmdown`
> as a standalone package), guaranteeing that *the rendered preview in
> the editor matches what users see in messages*. The synchronized
> scroll is acknowledged as the most complex part of the design and is
> phased separately (Phase 4) so the core `/view` and `/edit`
> commands can ship without it; an initial implementation renders
> Markdown as plain text in Monaco and adds the synchronized preview
> in a follow-up phase.

Sections:

- [What `/view` does for Markdown](endo-but-for-bots--llm-designs-chat-view-edit-commands--markdown-synchronized-render-panel--what-view-does-for-markdown.md)
- [What `/edit` does for Markdown](endo-but-for-bots--llm-designs-chat-view-edit-commands--markdown-synchronized-render-panel--what-edit-does-for-markdown.md)
- [Why the renderer must match the chat message pipeline](endo-but-for-bots--llm-designs-chat-view-edit-commands--markdown-synchronized-render-panel--why-the-renderer-must-match-the-chat-message-pipeline.md)
- [Phasing the complexity out of the critical path](endo-but-for-bots--llm-designs-chat-view-edit-commands--markdown-synchronized-render-panel--phasing-the-complexity-out-of-the-critical-path.md)
- [See also](endo-but-for-bots--llm-designs-chat-view-edit-commands--markdown-synchronized-render-panel--see-also.md)

Source: [designs/chat-view-edit-commands.md](https://github.com/endojs/endo-but-for-bots/blob/2691e7d52d061c0a10b89864e879188f2d4e11d7/designs/chat-view-edit-commands.md) at commit `2691e7d5`.
