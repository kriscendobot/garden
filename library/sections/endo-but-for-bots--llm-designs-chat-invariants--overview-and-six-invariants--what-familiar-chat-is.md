---
title: What Familiar Chat is
source: designs/chat-invariants.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 3b031592e5f97a86e317cb96f1b7c44abb4e41f9
source_date: 2026-03-02
source_authors: [Kris Kowal]
topics: [chat-ui, agent-conventions]
status: current
notes: **Status: Complete** upstream. Extracted from `packages/chat/DESIGN.md`. First chat-related ingest in the library; establishes the `chat-ui` topic. The six invariants here are **hard rules** — *violations indicate bugs*; the six principles in the sibling section are aesthetic guidelines.
parent: endo-but-for-bots--llm-designs-chat-invariants--overview-and-six-invariants
---

> *Familiar Chat is a web-based interface for interacting with the
> Endo daemon. It provides a command-driven UI for managing an
> inventory of named values (pet names), sending messages between
> peers, and evaluating JavaScript expressions in isolated workers.*

The interface is keyboard-first with a command-driven model — slash
commands, `@`-prefixed pet-name token chips, autocomplete dropdowns,
a modeline showing available keyboard actions, and a profile
indicator in the header.
