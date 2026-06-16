---
title: Indelible Space 0, configurable surface, and the corrected numbering scheme
source: designs/chat-spaces-home.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 7f5671c6114a0100d8cc51064f9f68acf5a00ffb
source_date: 2026-03-02
source_authors: [Kris Kowal]
topics: [chat-ui, agent-conventions]
status: current
notes: **Status: Complete** upstream. Sibling refinement of [[endo-but-for-bots--llm-designs-chat-spaces-gutter--motivation-and-architecture]] covering the *configurable home space*. The *config-key* numbering (`spaces/0` for home, `spaces/1..9` for user spaces) IS implemented in source. The *keyboard-shortcut* numbering shown in this section's table (`Cmd+0` for home) is **aspirational** — the current source implements `Cmd+1` = home, `Cmd+2..9` = first 8 user spaces, with no `Cmd+0`. The design's table and the source are out of step on this one point. See the section body for the resolution + cycle-58 result for the upstream PR proposal.
kind: index
section_count: 4
---

The spaces gutter has a *home space* — Space 0, bound to the root
agent — that the previous design ([[endo-but-for-bots--llm-designs-chat-spaces-gutter--motivation-and-architecture]])
treated as a hardcoded constant. This design makes Space 0
**configurable in two fields (icon, scheme)** while keeping it
**indelible in four others (position, name, profile-path,
existence)**.

Sections:

- [Indelible invariants (four)](endo-but-for-bots--llm-designs-chat-spaces-home--indelible-space-zero-and-numbering--indelible-invariants-four.md)
- [Configurable surface (two fields)](endo-but-for-bots--llm-designs-chat-spaces-home--indelible-space-zero-and-numbering--configurable-surface-two-fields.md)
- [`HOME_SPACE_DEFAULTS`](endo-but-for-bots--llm-designs-chat-spaces-home--indelible-space-zero-and-numbering--home-space-defaults.md)
- [Numbering scheme — design intent vs. current source](endo-but-for-bots--llm-designs-chat-spaces-home--indelible-space-zero-and-numbering--numbering-scheme-design-intent-vs-current-source.md)
