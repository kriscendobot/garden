---
title: See also
source: designs/chat-spaces-gutter.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 3b031592e5f97a86e317cb96f1b7c44abb4e41f9
source_date: 2026-02-26
source_authors: [Kris Kowal]
topics: [chat-ui, agent-conventions]
status: current
parent: endo-but-for-bots--llm-designs-chat-spaces-gutter--interactions-keyboard-and-future
---

- [[space]] — concept page collecting all sections that touch the space concept.
- [[endo-but-for-bots--llm-designs-chat-spaces-home--indelible-space-zero-and-numbering]] — refines the home space (Space 0). The chat-spaces-home design's *Numbering Scheme* table shows `Cmd+0 = Home` and `Cmd+1..9 = user spaces`, but that is **aspirational** — the current source `packages/chat/spaces-gutter.js` (verified cycle 58) implements the handler shown above: `Cmd+1..9 → allSpaces[num - 1]` where `allSpaces = [homeSpaceConfig, ...userSpaces]` and there is no `Cmd+0`. The handler shown in *this* section is the **current source-of-truth**. Aligning the design table to source, or building `Cmd+0` to align source to design, is open work; see cycle-58 result for the investigation and PR proposal.
