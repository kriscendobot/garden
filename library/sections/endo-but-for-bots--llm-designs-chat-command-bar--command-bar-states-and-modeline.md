---
title: Nine command-bar states with per-state modeline and keyboard table
source: designs/chat-command-bar.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 3b031592e5f97a86e317cb96f1b7c44abb4e41f9
source_date: 2026-03-02
source_authors: [Kris Kowal]
topics: [chat-ui, agent-conventions]
status: current
notes: **Status: Complete** upstream. Extracted from `packages/chat/DESIGN.md`. Same upstream commit as chat-invariants and chat-components. This document is the operational unfolding of the *modeline completeness* invariant from [[endo-but-for-bots--llm-designs-chat-invariants--overview-and-six-invariants]] — every state below maps a list of available keyboard actions to a modeline string.
kind: index
section_count: 10
---

The command bar is the chat client's primary input area. It moves
through nine distinct states; each state has a modeline showing
available actions and a keyboard table giving the precise key →
action → manual-equivalent mapping. The modeline-completeness
invariant means *every keyboard action in the state must appear in
the modeline*; the keyboard-manual parity invariant means *every
keyboard action must have a manual equivalent (or be marked
explicitly as a convenience without one)*.

Sections:

- [State 1: Empty (Send Mode)](endo-but-for-bots--llm-designs-chat-command-bar--command-bar-states-and-modeline--state-1-empty-send-mode.md)
- [State 2: Token Autocomplete Visible](endo-but-for-bots--llm-designs-chat-command-bar--command-bar-states-and-modeline--state-2-token-autocomplete-visible.md)
- [State 3: Token Only (Chip present, no message)](endo-but-for-bots--llm-designs-chat-command-bar--command-bar-states-and-modeline--state-3-token-only-chip-present-no-message.md)
- [State 4: Token + Message Text](endo-but-for-bots--llm-designs-chat-command-bar--command-bar-states-and-modeline--state-4-token-message-text.md)
- [State 5: Text Only (no token)](endo-but-for-bots--llm-designs-chat-command-bar--command-bar-states-and-modeline--state-5-text-only-no-token.md)
- [State 6: Command Selecting (after `/`)](endo-but-for-bots--llm-designs-chat-command-bar--command-bar-states-and-modeline--state-6-command-selecting-after.md)
- [State 7: Inline Command Form](endo-but-for-bots--llm-designs-chat-command-bar--command-bar-states-and-modeline--state-7-inline-command-form.md)
- [State 8: Eval Command (Inline)](endo-but-for-bots--llm-designs-chat-command-bar--command-bar-states-and-modeline--state-8-eval-command-inline.md)
- [State 9: (Other inline-form variants)](endo-but-for-bots--llm-designs-chat-command-bar--command-bar-states-and-modeline--state-9-other-inline-form-variants.md)
- [The state machine, abstractly](endo-but-for-bots--llm-designs-chat-command-bar--command-bar-states-and-modeline--the-state-machine-abstractly.md)
