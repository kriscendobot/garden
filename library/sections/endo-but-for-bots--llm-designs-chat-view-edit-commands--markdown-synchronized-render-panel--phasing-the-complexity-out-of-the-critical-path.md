---
title: Phasing the complexity out of the critical path
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

The design names the synchronized split-view as the most complex
part and phases it separately:

> This two-panel layout is the most complex part of the design. It
> can be delivered incrementally: an initial implementation can
> render Markdown as plain text in Monaco and add the synchronized
> preview in a follow-up phase.

In Phases 1 through 3 (the *Phases* table in the
[[endo-but-for-bots--llm-designs-chat-view-edit-commands--phases-dependencies-and-design-decisions]]
section) Markdown editing falls back to the plain-text Monaco editor
without the right-side preview. Markdown viewing in Phase 1 falls
back the same way. Phase 4 layers the synchronized split-view on top,
without changing the Phase-1-3 commands' shape.

This phasing reflects a recurring pattern in the chat-design corpus:
the *most complex sub-feature is phased separately, behind a flag or
a follow-up phase, so the core surface ships*. The same pattern
shows up in the chat-color-schemes 4-step rollout with Step 1
visually invisible (see [[endo-but-for-bots--llm-designs-chat-color-schemes--implementation-and-monaco-bridge]]),
and in the chat-markdown-render four-phase plan with Phase 0
visually-invisible scaffold (see
[[endo-but-for-bots--llm-designs-chat-markdown-render--render-mode-toggle-and-phased-rollout]]).
The maintainer's discipline is consistent: ship the bones first;
add the visible complexity once the bones hold.

Source: [designs/chat-view-edit-commands.md](https://github.com/endojs/endo-but-for-bots/blob/2691e7d52d061c0a10b89864e879188f2d4e11d7/designs/chat-view-edit-commands.md) at commit `2691e7d5`.
