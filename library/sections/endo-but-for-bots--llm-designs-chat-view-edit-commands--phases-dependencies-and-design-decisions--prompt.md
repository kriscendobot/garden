---
title: Prompt
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
parent: endo-but-for-bots--llm-designs-chat-view-edit-commands--phases-dependencies-and-design-decisions
---

The source document closes with the original prompt that produced
the design:

> Design Chat /view and /edit commands that operate on directory
> entries that correspond to blobs. These would open a viewer or
> Monaco editor. Allow for the possibility this could be complicated
> for Markdown in particular, which would enjoy a synchronized
> render panel.

The Markdown synchronized render panel reappears as the design's
most complex sub-feature and is phased to Phase 4 for that reason.

Source: [designs/chat-view-edit-commands.md](https://github.com/endojs/endo-but-for-bots/blob/2691e7d52d061c0a10b89864e879188f2d4e11d7/designs/chat-view-edit-commands.md) at commit `2691e7d5`.
