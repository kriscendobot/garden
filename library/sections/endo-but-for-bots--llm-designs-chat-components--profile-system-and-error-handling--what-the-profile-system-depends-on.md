---
title: What the profile system depends on
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
