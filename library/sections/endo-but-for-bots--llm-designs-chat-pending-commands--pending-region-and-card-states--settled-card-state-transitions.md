---
title: Settled-card state transitions
source: designs/chat-pending-commands.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 60a63bc404ce8b28c11021d622c0c65ef1f73e00
source_date: 2026-03-13
source_authors: [Kris Kowal]
topics: [chat-ui]
status: current
notes: |
  The near-term UI solution to the three problems named in the *motivation-and-problems* section: a dedicated region between transcript and command bar holds one card per in-flight command, with success/failure transitions and a value-modal escape hatch.
parent: endo-but-for-bots--llm-designs-chat-pending-commands--pending-region-and-card-states
---

When a command settles:

| Settles as | Card transitions to | Persistence |
|---|---|---|
| **Success** | A success state (checkmark, muted style) | Remains visible briefly before fading out |
| **Success with value** | A success state with a "show result" affordance opening the value modal | Same fade-out timing |
| **Failure** | An error state with the error message | Remains visible until the user explicitly dismisses it |

The asymmetric persistence (success fades, failure persists) is the UI
expression of *errors deserve attention, successes do not need
acknowledgement*. The failure card is the analog of the brief
error-flash the current bar shows, but it stays put rather than
disappearing.

Source: [designs/chat-pending-commands.md](https://github.com/endojs/endo-but-for-bots/blob/60a63bc404ce8b28c11021d622c0c65ef1f73e00/designs/chat-pending-commands.md) at commit `60a63bc4`.
