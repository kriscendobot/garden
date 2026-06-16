---
title: Where this design sits relative to its siblings
source: designs/chat-command-bar.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 3b031592e5f97a86e317cb96f1b7c44abb4e41f9
source_date: 2026-03-02
source_authors: [Kris Kowal]
topics: [chat-ui, agent-conventions]
status: current
parent: endo-but-for-bots--llm-designs-chat-command-bar--command-categories-and-known-gaps
---

Among the cycle-54-57 chat ingests, this design is the most
**operationally specified** — it converts the chat-invariants'
abstract *"modeline completeness"* + *"keyboard-manual parity"*
invariants into a concrete state-by-state, key-by-key spec. The
chat-components design covers package-level structure; chat-spaces-
gutter and chat-spaces-home cover the spaces affordance specifically;
this design covers *what happens when the user types*.

If a future builder dispatch implements a new command or refactors
the autocomplete machinery, this section is the load-bearing
specification — every state needs its modeline; every keyboard
action needs its manual equivalent (or an explicit acknowledged
exception).
