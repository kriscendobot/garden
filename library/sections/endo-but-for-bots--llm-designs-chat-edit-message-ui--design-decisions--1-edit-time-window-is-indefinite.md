---
title: 1. Edit time-window is indefinite
source: designs/chat-edit-message-ui.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 1d1a0bc78f0ed1b7cbabdbb4551c795276af21fe
source_date: 2026-05-06
source_authors: [Kris Kowal, Kriscendo Bot]
topics: [chat-ui]
status: current
notes: |
  Four decisions the design names explicitly. Decision 4 (the chip
  carries the locator, not the stale pet name) surfaces an existing
  CLI/chat parity gap captured in the source's *Related: Chat parity
  gap for proposed names* section and folded into this section's
  *Implications for Endo*.
parent: endo-but-for-bots--llm-designs-chat-edit-message-ui--design-decisions
---

`/edit` is available whenever the daemon accepts the call. The
daemon imposes no window, and the UI imposes none either. A UI-only
window (for example, "edit only the most recent message" or "within 5
minutes") would simplify the affordance but limits correction of
long-tail typos, and the maintainer chose unbounded editability.

The trade-off: unbounded editability means the *latest body* of a
message may diverge arbitrarily from what the recipient first saw, and
recipients who acted on the original body bear the cost of re-checking
the latest. The revision-history surface (see the sibling section)
exists precisely so a recipient can audit what they read against what
the sender now claims to have written.

Source: [designs/chat-edit-message-ui.md](https://github.com/endojs/endo-but-for-bots/blob/1d1a0bc78f0ed1b7cbabdbb4551c795276af21fe/designs/chat-edit-message-ui.md) at commit `1d1a0bc7`.
