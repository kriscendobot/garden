---
title: What `/edit` does for Markdown
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

`/edit` on a `.md` blob uses a side-by-side layout:

- **Left:** Monaco editor showing the Markdown source. The user
  edits here.
- **Right:** Live-rendered HTML preview of the source. The preview
  updates on every edit (debounced).
- **Scroll synchronization:** scroll position is synchronized between
  the two panels so that the preview tracks the cursor's location in
  the source.

The scroll-synchronization piece is the non-trivial part. It requires
mapping editor lines to rendered DOM elements (or rendered DOM
elements back to editor lines, since either side may scroll) and
keeping the mapping fresh as the user edits. Variable-height
rendered blocks (a heading, a paragraph, a fenced code block, an
image, a table) make the mapping non-linear: ten editor lines may
correspond to a single dense paragraph or to ten short headings, and
the relationship changes as the user edits. The design's *Design
Decisions* subsection (see the [[endo-but-for-bots--llm-designs-chat-view-edit-commands--phases-dependencies-and-design-decisions]]
section) records this explicitly as the reason Phase 4 is separated
out.

Source: [designs/chat-view-edit-commands.md](https://github.com/endojs/endo-but-for-bots/blob/2691e7d52d061c0a10b89864e879188f2d4e11d7/designs/chat-view-edit-commands.md) at commit `2691e7d5`.
