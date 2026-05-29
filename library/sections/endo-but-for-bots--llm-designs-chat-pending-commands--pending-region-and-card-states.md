---
title: The pending-commands region, per-card progress, and card-state transitions
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
---

## Abstract

The design adds a visually distinct *pending region* anchored to the
bottom of the transcript, above the command bar and below the message
list. Each in-flight command appears as a compact card showing the
command name, its arguments, a per-card indeterminate progress
indicator, and the time elapsed since submission. When a command
settles, the card transitions to a success or failure state with
distinct affordances: success cards fade out (with a "show result"
button if the command produced a value); failure cards persist until
explicitly dismissed. The region collapses to zero height when empty.

## Per-card content

Each card shows:

- The command name and its arguments (e.g., `dismiss #5`,
  `adopt #3:edge → myname`, `eval …`).
- An indeterminate progress indicator *per card* (not on the send
  button as today).
- The time elapsed since submission.

The progress indicator's *location* is the load-bearing change. Today's
spinner is on the send button, which is part of the command bar; the
new spinner is on the pending card, which is below the bar. Moving the
spinner moves the gate: the user is gated on cards (which can be many)
rather than on the bar (which is one).

## Settled-card state transitions

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

## Visual sketch (from the design)

```
┌─ transcript ──────────────────────────────────────┐
│                                                    │
│  (messages)                                        │
│                                                    │
├─ pending ─────────────────────────────────────────┤
│  ◐ dismiss #5                              2s ago  │
│  ◐ eval (source…)                          0s ago  │
│  ✓ adopt #3:VALUE → myval                  done    │
├────────────────────────────────────────────────────┤
│  [command bar]                                     │
└────────────────────────────────────────────────────┘
```

Two in-flight cards (`◐`) and one settled-success card (`✓`) coexist
in the pending region. The transcript scrolls above; the command bar
sits below; the pending region grows and shrinks between them.

## Empty-state collapse

The pending region collapses to zero height when empty. The user does
not see a permanent empty band between transcript and command bar; the
region appears only when there is something in it. This keeps the
transcript-to-command-bar transition visually unchanged for the common
case where no commands are pending.

## Affordance for produced values

A successful evaluate or request produces a value the user often wants
to inspect. The success-state card carries a "show result" affordance
that opens the existing value modal (the same modal opened by clicking
a token chip in the inbox). This makes the pending region a *peripheral
read of the command stream*: the user sees the card, decides whether
the result is worth looking at, and either lets the card fade or opens
the modal.

## See also

- [[endo-but-for-bots--llm-designs-chat-pending-commands--motivation-and-problems]] — the three problems this region targets.
- [[endo-but-for-bots--llm-designs-chat-pending-commands--unlocking-and-concurrent-commands]] — the implementation change behind the cards: dispatch then release the bar; each card holds its own promise.
- [[endo-but-for-bots--llm-designs-chat-command-bar--value-modal-and-states]] — the value modal the "show result" affordance opens.
- [[endo-but-for-bots--llm-designs-chat-command-bar--command-bar-states-and-modeline]] — the command-bar state machine the pending region composes with.

Source: [designs/chat-pending-commands.md](https://github.com/endojs/endo-but-for-bots/blob/60a63bc404ce8b28c11021d622c0c65ef1f73e00/designs/chat-pending-commands.md) at commit `60a63bc4`.
