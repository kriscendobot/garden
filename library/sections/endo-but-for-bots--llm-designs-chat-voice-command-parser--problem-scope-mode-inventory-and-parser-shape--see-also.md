---
title: See also
source: designs/chat-voice-command-parser.md
source_repo: endojs/endo-but-for-bots
source_branch: design/chat-voice-command-parser
source_commit: e2134329191713132f5ecb5f1c7954a42b8ad4d4
source_date: 2026-05-10
source_authors: [Kris Kowal]
topics: [chat-ui]
status: current
notes: |
  **Status: Not Started** upstream. The architectural framing of the
  voice-parser design: voice should drive the *same* nine modes the
  keyboard already drives, via an asynchronous parse-monad state
  machine producing inert passable effects that the chat-bar
  interprets. Per-mode wake-word tables live next to the command
  registry so a new command picks up voice support automatically; the
  modeline shows the wake words for the current mode under the
  keyboard hints.
parent: endo-but-for-bots--llm-designs-chat-voice-command-parser--problem-scope-mode-inventory-and-parser-shape
---

- [[chat-ui]] (topic) — the broader chat-UI surface.
- `endo-but-for-bots--llm-designs-chat-command-bar` — the keyboard pipeline this parser mirrors; the nine modes are documented there.
- `endo-but-for-bots--llm-designs-chat-pending-commands` — voice-issued commands queue through the same pending-command UI as keyboard-issued ones.
- `endo-but-for-bots--llm-designs-chat-slot-slash-commands` — the slot-input consolidation that voice extends through the same registry pathway.
- `endo-but-for-bots--llm-designs-chat-voice-command-parser--interaction-patterns-and-asynchrony` — the next section in this source: the five concrete interaction patterns + race-condition handling + the Escape/Enter dual-mechanism.
- `endo-but-for-bots--llm-designs-chat-voice-command-parser--design-decisions-test-plan-and-open-questions` — the third section: design decisions + test plan + open questions + §Prompt.
- `endo-but-for-bots--llm-designs-chat-edit-message-ui--*` — the chat-edit affordances that voice should also drive; the same registry-driven vocabulary discipline.
