---
title: In-flight visual state
source: designs/chat-edit-message-ui.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 1d1a0bc78f0ed1b7cbabdbb4551c795276af21fe
source_date: 2026-05-06
source_authors: [Kris Kowal, Kriscendo Bot]
topics: [chat-ui]
status: current
notes: |
  Covers two coupled surfaces: the in-flight visual state for an edit
  the daemon has not yet acknowledged, and the read-only revision panel
  that renders the array returned by `E(profile).messageHistory(number)`.
parent: endo-but-for-bots--llm-designs-chat-edit-message-ui--in-flight-and-revision-history
---

While an edit is in flight, the message envelope renders with a faint
"saving" affordance, reusing the same indeterminate-progress style used
for not-done messages per
[[endo-but-for-bots--llm-designs-daemon-message-streaming]]. The
affordance clears when the edit settles. The choice to share the
not-done style is deliberate: a not-done streaming send and a not-yet-
acknowledged edit are the *same kind of state* from the recipient's
point of view — content is in motion, the envelope has not settled —
and reusing the visual idiom keeps the chat's affordance vocabulary
small.

Source: [designs/chat-edit-message-ui.md](https://github.com/endojs/endo-but-for-bots/blob/1d1a0bc78f0ed1b7cbabdbb4551c795276af21fe/designs/chat-edit-message-ui.md) at commit `1d1a0bc7`.
