---
title: Profile system
source: designs/chat-components.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 3b031592e5f97a86e317cb96f1b7c44abb4e41f9
source_date: 2026-03-02
source_authors: [Kris Kowal]
topics: [chat-ui, agent-conventions]
status: current
parent: endo-but-for-bots--llm-designs-chat-components--profile-system-and-error-handling
---

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
