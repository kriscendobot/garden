---
title: 2. Visibility of edit history to other participants
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

The daemon retains revision history per message and surfaces it through
`messageHistory`, but it is unclear whether the *recipient's* chat UI
should also display the "edited" annotation and offer the revision
panel.

Arguments for: transparency. Recipients deserve to know that the text
they see has changed.

Arguments against: an agent may make many small "thinking..."
revisions during a streaming response, and exposing all of them as a
clickable history clutters the inbox.

A middle ground noted in the source: *always show "edited" but only
expose the revision panel for messages that were ever settled (`done:
true`) and then re-edited*. The middle ground captures the cost of
each path: hiding edits entirely loses transparency; exposing every
streaming-tick edit floods the inbox; exposing only post-settle edits
discloses the user-visible writes (the ones a recipient might have
acted on) without surfacing every internal streaming tick.

The middle-ground proposal aligns with the design's own *not-done
messages are not editable from the UI* gate (decision 2 in the
sibling section): both rules treat *settled-then-edited* as the
recipient-significant event class, distinct from *still streaming* or
*never edited*.

Source: [designs/chat-edit-message-ui.md](https://github.com/endojs/endo-but-for-bots/blob/1d1a0bc78f0ed1b7cbabdbb4551c795276af21fe/designs/chat-edit-message-ui.md) at commit `1d1a0bc7`.
