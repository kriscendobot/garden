---
title: Known gaps — the design's own punch list
source: designs/chat-command-bar.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 3b031592e5f97a86e317cb96f1b7c44abb4e41f9
source_date: 2026-03-02
source_authors: [Kris Kowal]
topics: [chat-ui, agent-conventions]
status: current
parent: endo-but-for-bots--llm-designs-chat-command-bar--command-categories-and-known-gaps
---

The design records three gaps under three headings:

### Modeline gaps

- Verify all inline command forms show appropriate modeline hints.
- Verify eval form modeline is complete.

These are *coverage* gaps — the modeline-completeness invariant
holds for the states documented above, but inline command forms
(State 7 in
[[endo-but-for-bots--llm-designs-chat-command-bar--command-bar-states-and-modeline]])
have per-command modelines that each need an audit. Tracked, not
yet done.

### Keyboard-manual parity gaps

- `Space` to insert last recipient has **no manual equivalent** (acceptable convenience).
- Edge name entry (`:`) has **no manual equivalent**.

Both are deliberate exceptions to the keyboard-manual parity
invariant, recorded as such. The design acknowledges them; they
are not bugs.

### Other

- Command history (up / down arrow) **not yet implemented**.
- Chip × button **not always visible for deletion** — keyboard fallback works (Backspace at chip boundary), but the manual-equivalent affordance is incomplete.
