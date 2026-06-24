---
title: Why this works
source: designs/chat-spaces-gutter.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 3b031592e5f97a86e317cb96f1b7c44abb4e41f9
source_date: 2026-02-26
source_authors: [Kris Kowal]
topics: [chat-ui, agent-conventions]
status: current
parent: endo-but-for-bots--llm-designs-chat-spaces-gutter--space-model-and-persistence
---

The design's *"No new formula types, no new daemon APIs"* claim
rests on three properties of the existing daemon surface:

1. **`pet-store.write(path, value)`** accepts arbitrary path arrays — a `spaces` directory is one such path.
2. **`pet-store.list(dirPath)`** enumerates a directory's children — any directory, not a privileged one.
3. **`host.storeValue(string)`** is the daemon's primitive for *here is a value, persist it and give me a reference* — used internally for many things, now used for `JSON.stringify(spaceConfig)`.

Together these are sufficient to encode a *typed namespace* (the
`spaces` directory of `SpaceConfig` JSON values) on top of the
daemon's untyped name-resolution primitives. The design is in this
sense a worked example of the **client-side convention over a
complete daemon API** discipline.

The same shape recurs in other client-side conventions over the
existing pet-store — message storage, message-number bindings, and
host directory hierarchies all use the same write / list / lookup /
remove vocabulary.
