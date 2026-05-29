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

## What `/view` does for Markdown

`/view` on a `.md` blob renders the source as formatted HTML by
default. A toggle lets the user switch to a raw-source view (Monaco
in plain-text read-only mode, the same renderer the design's default
table assigns to plain text). The default rendering is a deliberate
inversion of the editor's default: a viewer expects the rendered
form because the user came to *read*; an editor expects the source
form because the user came to *write*. The toggle lets either user
swap.

## What `/edit` does for Markdown

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

## Why the renderer must match the chat message pipeline

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

## Phasing the complexity out of the critical path

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

## See also

- [[endo-but-for-bots--llm-designs-chat-markdown-render--package-extraction-and-typed-ast]] — the `@endo/markmdown` package extraction the renderer reuses; the typed-AST boundary the producer-typed-shape rule names.
- [[endo-but-for-bots--llm-designs-chat-markdown-render--delimiter-realignment-and-flanking-rules]] — the state-machine scanner inside the parser; the deliberate divergences (no raw HTML, hard-break-on-newline) the editor preview inherits.
- [[producer-typed-shape-consumer-rendering]] — the principle the parser/consumer split codifies; this section is one more instance.
- [[endo-but-for-bots--llm-designs-chat-view-edit-commands--phases-dependencies-and-design-decisions]] — Phase 4 and the design decision that justifies the separation.
- [[endo-but-for-bots--llm-designs-chat-color-schemes--implementation-and-monaco-bridge]] — the Monaco-iframe `set-theme` post-message bridge the editor preview's Monaco instance honors; the editor preview is one more consumer of the scheme.

Source: [designs/chat-view-edit-commands.md](https://github.com/endojs/endo-but-for-bots/blob/2691e7d52d061c0a10b89864e879188f2d4e11d7/designs/chat-view-edit-commands.md) at commit `2691e7d5`.
