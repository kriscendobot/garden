---
title: What `/view` does for Markdown
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

`/view` on a `.md` blob renders the source as formatted HTML by
default. A toggle lets the user switch to a raw-source view (Monaco
in plain-text read-only mode, the same renderer the design's default
table assigns to plain text). The default rendering is a deliberate
inversion of the editor's default: a viewer expects the rendered
form because the user came to *read*; an editor expects the source
form because the user came to *write*. The toggle lets either user
swap.

Source: [designs/chat-view-edit-commands.md](https://github.com/endojs/endo-but-for-bots/blob/2691e7d52d061c0a10b89864e879188f2d4e11d7/designs/chat-view-edit-commands.md) at commit `2691e7d5`.
