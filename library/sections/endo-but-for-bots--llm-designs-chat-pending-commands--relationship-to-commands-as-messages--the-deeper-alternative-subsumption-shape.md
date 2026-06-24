---
title: The deeper alternative (subsumption shape)
source: designs/chat-pending-commands.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 60a63bc404ce8b28c11021d622c0c65ef1f73e00
source_date: 2026-03-13
source_authors: [Kris Kowal]
topics: [chat-ui]
status: current
notes: |
  The design's self-positioning. The pending region is a UI-only solution; a sibling design (`daemon-commands-as-messages`) proposes the deeper daemon-side fix that would model commands as self-addressed messages. The pending-region design names the relationship explicitly and frames itself as the near-term solution and as a fallback if the daemon change is deferred. Notable as a worked example of *near-term-UI vs. invasive-daemon-change* dependency framing in this design corpus.
parent: endo-but-for-bots--llm-designs-chat-pending-commands--relationship-to-commands-as-messages
---

`daemon-commands-as-messages` proposes modeling commands themselves as
**self-addressed messages** in the daemon's mail system, with results
as **reply messages**. If implemented, the pending region's role
changes: pending commands are simply self-addressed messages whose
reply messages have not yet arrived. They are rendered inline in the
transcript, exactly where the user sees inbound messages from others.

The subsumption shape:

| Today | Pending region (this design) | Commands as messages (sibling design) |
|---|---|---|
| Spinner on send button | Card in pending region | Message in transcript, awaiting reply |
| Spinner disappears | Card fades / persists per success/failure | Reply message appears (or never does) |
| No record | Card visible during flight only | Both command and reply durable in `followMessages()` |

The pending region's value persists in the subsumed world only as
*formatting hints*: a self-addressed message without a reply renders
with a spinner, a settled one renders with the reply inline. The
transcript itself becomes the pending region.

Source: [designs/chat-pending-commands.md](https://github.com/endojs/endo-but-for-bots/blob/60a63bc404ce8b28c11021d622c0c65ef1f73e00/designs/chat-pending-commands.md) at commit `60a63bc4`.
