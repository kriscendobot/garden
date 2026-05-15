---
title: Value modal — four value-states and the four modal actions
source: designs/chat-command-bar.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 3b031592e5f97a86e317cb96f1b7c44abb4e41f9
source_date: 2026-03-02
source_authors: [Kris Kowal]
topics: [chat-ui]
status: current
---

The value modal is what opens when a user *inspects* a value
(clicks a token chip, presses Enter on a chip-only command-bar
state, opens a message attachment, etc.). It displays the value
and lets the user save it with a pet name.

## Four value states

The title bar of the modal renders the value's *identity surface*
in one of four shapes:

| State | Title display | Description |
|---|---|---|
| **Has ID + pet names** | `@foo @bar` (blue chips) | Value retained in store, has names |
| **Has ID + no pet names** | `(unnamed)` | Value retained but not named |
| **Has message context** | `#42:attachment` (gray chip) | Value from inbox message |
| **Ephemeral (no ID)** | `Ephemeral Value` | Transient value (e.g., from `/list`) |

> *A value can show BOTH message context chip AND pet name chips if
> applicable.*

The four-state classification is the chat-UI equivalent of the
daemon's [[pass-invariant-handle-equality]] discipline applied to
the *display* layer: the same backing identity gets the same
rendering, but the rendering varies along two axes — "has the user
named it?" and "did it arrive in a message?". Both axes can apply
to one value, and both chips render side-by-side when they do.

## Modal actions

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

## Where the modal sits in the surrounding flow

The modal is reached *from* the command-bar states described in
[[endo-but-for-bots--llm-designs-chat-command-bar--command-bar-states-and-modeline]]:

- **Token-only state, Enter** → inspect via the modal.
- **Token autocomplete visible, Enter** → complete token then inspect via the modal.
- **Click a token chip** anywhere in the inbox → inspect via the modal.
- **Click an attachment** in a message → inspect via the modal.

The modal does NOT change the underlying value identity — closing
the modal returns to whatever state the command bar was in. Saving
a value names it (creates a pet-name binding) but does not change
the value's formula identifier; pass-invariant-handle-equality
holds across the save.
