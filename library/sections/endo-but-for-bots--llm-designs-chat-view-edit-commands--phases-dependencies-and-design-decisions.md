---
title: Phases, dependencies, and design decisions
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
  Combines the design's *Phases*, *Dependencies*, and *Design
  Decisions* sections into one section. The four-phase rollout is the
  delivery shape; the dependency table is what the design assumes;
  the five design decisions are the load-bearing trade-offs the
  design names explicitly.
kind: index
section_count: 5
---

> Abstract: Four-phase rollout: Phase 1 ships `/view` with plain-text
> Monaco read-only; Phase 2 adds `/edit` with mutable-save (and
> immutable save-as-new); Phase 3 adds extension-based language-mode
> selection in Monaco; Phase 4 adds the Markdown split view with
> synchronized scroll. Five dependencies are listed: the command-bar
> infrastructure (command-bar), the Markdown pipeline reuse
> (chat-markdown-render), focus-mode (chat-focus-message), and two
> daemon-side prerequisites for writable directory entries
> (daemon-mount, daemon-checkin-checkout). Five load-bearing design
> decisions are recorded: modal overlay (not embedded panel); Monaco
> reuse (not a new editor); Markdown split view phased separately;
> immutable blobs produce new formulas on save (content-addressed
> immutability); content type from extension (not MIME sniffing).

Sections:

- [Phases](endo-but-for-bots--llm-designs-chat-view-edit-commands--phases-dependencies-and-design-decisions--phases.md)
- [Dependencies](endo-but-for-bots--llm-designs-chat-view-edit-commands--phases-dependencies-and-design-decisions--dependencies.md)
- [Design decisions](endo-but-for-bots--llm-designs-chat-view-edit-commands--phases-dependencies-and-design-decisions--design-decisions.md)
- [Prompt](endo-but-for-bots--llm-designs-chat-view-edit-commands--phases-dependencies-and-design-decisions--prompt.md)
- [See also](endo-but-for-bots--llm-designs-chat-view-edit-commands--phases-dependencies-and-design-decisions--see-also.md)

Source: [designs/chat-view-edit-commands.md](https://github.com/endojs/endo-but-for-bots/blob/2691e7d52d061c0a10b89864e879188f2d4e11d7/designs/chat-view-edit-commands.md) at commit `2691e7d5`.
