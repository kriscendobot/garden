---
title: Affected files (from the design's appendix)
source: designs/chat-pending-commands.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 60a63bc404ce8b28c11021d622c0c65ef1f73e00
source_date: 2026-03-13
source_authors: [Kris Kowal]
topics: [chat-ui]
status: current
notes: |
  The implementation move behind the pending-region UI: change `executeWithSpinner` so the command bar is released immediately after dispatch, and let each pending card own its promise's settlement. This admits multiple concurrent commands. Names the user-intent ordering concern (rename-after-adopt) and explains why the pending region makes it visible.
parent: endo-but-for-bots--llm-designs-chat-pending-commands--unlocking-and-concurrent-commands
---

| File | Change |
|---|---|
| `packages/chat/chat-bar-component.js` | Remove `setSubmitting` gating; dispatch to pending region instead |
| `packages/chat/pending-commands.js` (new) | Pending commands region component |
| `packages/chat/chat.css` | Styles for pending cards, transitions |

The change is **scoped to three files**, one of them new. No daemon
changes are required for this near-term solution; that is the design's
load-bearing scoping move, and is also what enables the *Relationship
to Commands as Messages* discussion (see sibling section).

Source: [designs/chat-pending-commands.md](https://github.com/endojs/endo-but-for-bots/blob/60a63bc404ce8b28c11021d622c0c65ef1f73e00/designs/chat-pending-commands.md) at commit `60a63bc4`.
