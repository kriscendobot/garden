---
title: Why the invariants exist
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

The shape of these invariants — *every keyboard action is also
manual; every mode and action is visible; escape is always safe;
simple tasks stay simple* — is a deliberate **lift of the keyboard-
manual symmetry and the safe-escape discipline from Emacs and
modal-editor culture into a web UI**. The autocomplete list-navigation
invariant in particular is a worked solution to the common keyboard-
UI bug where Page Down jumps so far the user loses spatial
orientation in the list.

See
[[endo-but-for-bots--llm-designs-chat-invariants--principles]] for the
companion *should*-rules (the design principles that motivate but do
not bind).
