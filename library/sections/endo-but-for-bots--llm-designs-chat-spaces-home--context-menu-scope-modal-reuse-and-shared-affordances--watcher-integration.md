---
title: Watcher integration
source: designs/chat-spaces-home.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 7f5671c6114a0100d8cc51064f9f68acf5a00ffb
source_date: 2026-03-02
source_authors: [Kris Kowal]
topics: [chat-ui, agent-conventions, patterns]
status: current
parent: endo-but-for-bots--llm-designs-chat-spaces-home--context-menu-scope-modal-reuse-and-shared-affordances
---

The spaces-directory watcher handles space `'0'` specially:

| Event | Handler |
|---|---|
| `handleSpaceAdded('0')` | Reload home config from store, re-render |
| `handleSpaceRemoved('0')` | Reset to `HOME_SPACE_DEFAULTS`, re-render |
| Other space IDs | Normal `spacesMap` add / remove behavior |

The remove-handler's behavior is the load-bearing one: **deleting
the `spaces/0` entry doesn't delete the home space; it resets it to
defaults**. Combined with the cannot-delete invariant from the
sibling section, the home space is structurally undeleteable —
even direct pet-store manipulation (e.g. by another agent) can't
remove home; the worst it can do is wipe the user's customizations
back to defaults.
