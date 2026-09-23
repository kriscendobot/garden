---
title: Testing
source: designs/chat-spaces-inbox.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 0ee0cbb3c7639985c971c30c2fb6f32e1944d55b
source_date: 2026-02-24
source_authors: [Kris Kowal]
topics: [chat-ui, agent-conventions]
status: current
parent: endo-but-for-bots--llm-designs-chat-spaces-inbox--badges-message-context-and-future
---

The design's test plan is five end-to-end scenarios:

1. **Add a space** pointing to a guest (e.g., `['fae']`).
2. **Click the space** — should navigate to that guest's inbox.
3. **Verify messages** — should show that guest's message history.
4. **Send a message** — should be sent to that guest.
5. **Cmd+N shortcut** — should switch to the Nth space's inbox.

Note that step 5 uses **Cmd+N**, which is consistent with the
source's `Cmd+1..9` handler (Cmd+1 = home, Cmd+2..9 = user spaces;
see cycle-58 investigation in
[[endo-but-for-bots--llm-designs-chat-spaces-gutter--interactions-keyboard-and-future]]).
This design predates the chat-spaces-home aspirational `Cmd+0`
table; the test uses the current source-of-truth numbering.
