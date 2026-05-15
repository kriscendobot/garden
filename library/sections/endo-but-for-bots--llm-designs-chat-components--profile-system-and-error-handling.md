---
title: Profile navigation system and error-display patterns
source: designs/chat-components.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 3b031592e5f97a86e317cb96f1b7c44abb4e41f9
source_date: 2026-03-02
source_authors: [Kris Kowal]
topics: [chat-ui, agent-conventions]
status: current
---

## Profile system

Users can navigate between host profiles — each profile has its own
inventory and is reachable by stepping in and stepping out:

| Affordance | Behavior |
|---|---|
| **Breadcrumb bar** | Shows the current profile path. Each crumb is clickable to navigate up. |
| **`/enter` command** | Enter a host as the current profile. |
| **`/exit` command** | Return to the parent profile. |
| Inventory | Each profile has its own inventory view; switching profiles swaps the displayed panel. |

The profile system makes **the user's current "I" addressable** —
which agent's perspective the inventory is showing, which agent's
`@keypair` will sign outgoing messages, which agent's NETS controls
the advertised connection hints. This is the surface manifestation
of the per-agent-keypair work
([[endo-but-for-bots--llm-designs-d256--per-agent-keypairs]]) and
the per-agent NETS design
([[endo-but-for-bots--llm-designs-dani--per-agent-networks-and-nets]]).

The breadcrumb + `/enter` / `/exit` discipline is the chat-UI
counterpart of the daemon's pet-name-paths-as-addressing
convention: an agent only sees what it has been granted.

## Error-handling pattern

Errors surface in a consistent visual shape across modes:

| Mode | Error placement |
|---|---|
| Command mode | Red bubble above the command row |
| Send mode | Red bubble above the input field |

Both use a **speech-pointer** indicating the source of the error,
and errors **clear on next input** — the user does not need to
dismiss them; typing the next character clears the bubble.

The speech-pointer-attached-to-source pattern is the kind of small
visual discipline that compounds: a user who has read one
red-bubble-with-speech-pointer learns the convention and applies it
across every other mode the bubble appears in. This is the visual-
feedback principle from
[[endo-but-for-bots--llm-designs-chat-invariants--principles]]
working in practice.

## What the profile system depends on

The two daemon-side affordances the profile system rests on:

1. **`@host` and `@self` special names** — populated when an agent
   is incarnated; the chat client uses them to know which agent is
   "self" relative to the current profile.
2. **Pet-name-paths as addressing** — `/enter alice.assistant`
   resolves through the directory's nested pet-store; the agent
   reached is exactly the one named at that path.

These are not negotiable interface details: removing either would
remove the profile system's substrate. The chat client is *one*
client of the daemon's identity APIs; any other client would have
the same affordances.
