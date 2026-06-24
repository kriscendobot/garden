---
title: Implications for Endo
source: designs/chat-edit-message-ui.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 1d1a0bc78f0ed1b7cbabdbb4551c795276af21fe
source_date: 2026-05-06
source_authors: [Kris Kowal, Kriscendo Bot]
topics: [chat-ui]
status: current
notes: |
  Two open questions, both flagged as maintainer-decisions in the
  source. The first is a name collision with a sibling chat design;
  the second is a UX trade-off about whether to expose edits to
  recipients.
parent: endo-but-for-bots--llm-designs-chat-edit-message-ui--open-questions
---

The two open questions illustrate two different *un-shipped* kinds.
The first (slash-command collision) is a vocabulary collision the
chat-client's command bar would have to negotiate as more designs
land; it points at the absence of a chat-client design that enumerates
the *current* command vocabulary as a single inventory. The second
(recipient-side visibility) is a UX trade-off between transparency and
inbox noise that depends on operational data the chat client does not
yet have (how often does an agent edit during streaming, how often
post-settle, what does the typical recipient want to see). Both kinds
are common: a design lands its load-bearing decisions and surfaces the
remaining trade-offs as named open questions for the maintainer to
resolve when operational signal accumulates.

Source: [designs/chat-edit-message-ui.md](https://github.com/endojs/endo-but-for-bots/blob/1d1a0bc78f0ed1b7cbabdbb4551c795276af21fe/designs/chat-edit-message-ui.md) at commit `1d1a0bc7`.
