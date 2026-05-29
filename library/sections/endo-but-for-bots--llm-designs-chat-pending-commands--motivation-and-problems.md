---
title: Motivation, problems, and the asymmetric command record
source: designs/chat-pending-commands.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 60a63bc404ce8b28c11021d622c0c65ef1f73e00
source_date: 2026-03-13
source_authors: [Kris Kowal]
topics: [chat-ui]
status: current
notes: |
  **Status: Not Started** upstream. Names two concrete chat-UX problems
  the indeterminate spinner causes (blocked input, no command history)
  and a third deeper *asymmetric record* problem (the inbox transcript
  shows inbound messages only; outbound commands are invisible).
---

## Abstract

When the user issues a chat command (`/dismiss 5`, `/adopt 3 edge name`,
`/eval`, or a plain message send), the current chat client replaces the
send button with an indeterminate spinner and locks the entire command
bar (`contentEditable = false`, `pointer-events: none`, `opacity: 0.5`)
until the daemon promise settles. This creates two surface UX problems
(*blocked input* and *no command history*) and surfaces a deeper
*asymmetric record* problem: the inbox transcript shows what others said
to you, not what you did. This section catalogs the three problems the
`chat-pending-commands` design is targeted at.

## Problem 1: Blocked input

The user is locked out of the command bar for the duration of the
operation. Fast operations (`dismiss`, `adopt`) resolve quickly. Slower
operations (evaluate, request, send) can take seconds or longer. While
the spinner is up:

- The user cannot type, issue a second command, or correct a mistake.
- The user cannot read back what they just submitted.

## Problem 2: No command history

Once a command completes, the spinner disappears and the command bar
resets. There is no visible record of what the user did or when:

- The only trace is the side effect in the inbox (a dismissed message
  disappears, an adopted value appears in the pet store).
- If the command fails, an error flash appears briefly and is gone.

The user has no way to scroll back through their own command stream.

## Problem 3: The asymmetric command record

The inbox transcript shows inbound messages, things sent *to* the
user. It does not show outbound commands the user issued. The result
is an asymmetric record: you see what others said to you but not what
you did. This asymmetry is the root cause of Problem 2 and motivates
both the near-term *pending region* fix and the deeper
`daemon-commands-as-messages` alternative (covered separately in this
source's *relationship-to-commands-as-messages* section).

## Examples drawn from the design

- `/dismiss 5` — dismiss inbox message 5.
- `/adopt 3 edge name` — adopt edge `edge` from message 3, binding it
  to pet name `name`.
- `/eval` — evaluate an expression in an isolated worker.
- A plain message send — the implicit "send" command from typing in the
  command bar and pressing Enter.

These four shapes have different latency profiles. Dismiss and adopt
are fast (low-millisecond round-trips). Evaluate, request, and send can
take seconds. The same indeterminate-spinner treatment for all of them
amplifies the blocked-input problem for the slow shapes.

## See also

- [[endo-but-for-bots--llm-designs-chat-pending-commands--pending-region-and-card-states]] — the design's near-term solution: a dedicated pending-region UI between transcript and command bar.
- [[endo-but-for-bots--llm-designs-chat-pending-commands--unlocking-and-concurrent-commands]] — the implementation change that releases the command bar immediately and admits multiple concurrent commands.
- [[endo-but-for-bots--llm-designs-chat-pending-commands--relationship-to-commands-as-messages]] — the deeper daemon-side alternative (modeling commands as self-addressed messages) that would subsume this UI-only fix.
- [[endo-but-for-bots--llm-designs-chat-command-bar--command-bar-states-and-modeline]] — the command-bar state machine; `executeWithSpinner` is the gate this design opens.

Source: [designs/chat-pending-commands.md](https://github.com/endojs/endo-but-for-bots/blob/60a63bc404ce8b28c11021d622c0c65ef1f73e00/designs/chat-pending-commands.md) at commit `60a63bc4`.
