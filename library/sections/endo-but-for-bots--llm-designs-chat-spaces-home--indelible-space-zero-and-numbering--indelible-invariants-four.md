---
title: Indelible invariants (four)
source: designs/chat-spaces-home.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 7f5671c6114a0100d8cc51064f9f68acf5a00ffb
source_date: 2026-03-02
source_authors: [Kris Kowal]
topics: [chat-ui, agent-conventions]
status: current
notes: **Status: Complete** upstream. Sibling refinement of [[endo-but-for-bots--llm-designs-chat-spaces-gutter--motivation-and-architecture]] covering the *configurable home space*. The *config-key* numbering (`spaces/0` for home, `spaces/1..9` for user spaces) IS implemented in source. The *keyboard-shortcut* numbering shown in this section's table (`Cmd+0` for home) is **aspirational** — the current source implements `Cmd+1` = home, `Cmd+2..9` = first 8 user spaces, with no `Cmd+0`. The design's table and the source are out of step on this one point. See the section body for the resolution + cycle-58 result for the upstream PR proposal.
parent: endo-but-for-bots--llm-designs-chat-spaces-home--indelible-space-zero-and-numbering
---

| Invariant | What it means |
|---|---|
| **Always first** | Position 0 in the gutter (in source, keyboard `Cmd+1`; the design's table claims `Cmd+0`, but that is aspirational — see *Numbering scheme* below) |
| **Always named "Home"** | Name is enforced on save regardless of stored config |
| **Always bound to root agent** | `profilePath` is always `[]` |
| **Cannot be deleted** | The Delete menu item is hidden for Home (see the sibling section on context-menu scope) |
