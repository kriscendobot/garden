---
title: Modal actions
source: designs/chat-command-bar.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 3b031592e5f97a86e317cb96f1b7c44abb4e41f9
source_date: 2026-03-02
source_authors: [Kris Kowal]
topics: [chat-ui]
status: current
parent: endo-but-for-bots--llm-designs-chat-command-bar--value-modal-and-states
---

| Action | Keyboard | Manual |
|---|---|---|
| Close | `Escape` | Click × or backdrop |
| Save | `Enter` (in name field) | Click Save button |
| Enter Profile | N/A | Click "Enter Profile" (for host types) |

Two things to notice:

1. **`Enter Profile` has no keyboard equivalent.** The design records
   this as a known parity gap; the action is reachable only by
   mouse / touch. Future work may add a keyboard equivalent (likely
   `⌘E` or similar; not committed).
2. **`Save` is in-context** — pressing Enter while focus is in the
   name field saves; Enter outside the name field does *not* save
   (it would do whatever the focused element's default action is).
   The keyboard-manual parity invariant is satisfied because the
   Save button is also available.
