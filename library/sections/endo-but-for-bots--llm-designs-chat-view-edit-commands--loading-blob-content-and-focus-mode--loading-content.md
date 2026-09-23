---
title: Loading content
source: designs/chat-view-edit-commands.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 2691e7d52d061c0a10b89864e879188f2d4e11d7
source_date: 2026-03-21
source_authors: [Kris Kowal]
ingested: 2026-05-28
ingested_by: scholar
topics: [chat-ui]
status: current
notes: |
  The capability flow at the daemon boundary and the keyboard-shortcut
  integration into the chat client's focus mode. Read flow uses
  `text()`; write flow uses `write()` on the parent or a new
  `readable-blob` formula. The `v` / `e` focus shortcuts compose with
  the existing focus framework; the design names them explicitly even
  though the focus framework is documented elsewhere.
parent: endo-but-for-bots--llm-designs-chat-view-edit-commands--loading-blob-content-and-focus-mode
---

Both commands load content by resolving the pet name path to a
capability and calling `text()` on the resulting blob:

1. Resolve the first path segment as a pet name in the current
   profile's namespace.
2. If the result is a tree or directory, call `lookup()` with the
   remaining path segments.
3. Call `text()` on the resolved blob to get the content as a string.

The three-step shape mirrors the chat client's existing pet-name
resolution discipline for value modals and message-target chips
(see [[endo-but-for-bots--llm-designs-chat-components--profile-system-and-error-handling]]
for the profile system; see
[[endo-but-for-bots--llm-designs-chat-command-bar--field-types-and-autocomplete-mechanics]]
for how the chat command bar already constructs `petNamePath` values).
Nothing about the resolution is new; the new piece is that the
resolved leaf is *read for its bytes* via `text()` rather than
displayed as a value or passed as a capability to another command.

For save in `/edit`, the inverse:

- **Mutable parent.** Call `write()` on the parent directory with the
  entry name and the new content. The save is in place; the entry now
  references the new bytes; the parent's directory listing is
  unchanged.

- **Immutable blob.** Create a new `readable-blob` formula via the
  daemon (the same primitive that produces any other immutable blob).
  Prompt the user to store the resulting blob under a pet name. The
  original blob's identity is preserved; the chat client's
  capability graph gains a new node and (if the user accepts the
  prompt) a new pet-name edge.

The two save flows are the chat-side mechanism for the
content-addressed-immutability discipline named in the
[[endo-but-for-bots--llm-designs-chat-view-edit-commands--commands-viewer-editor-and-panel-layout]]
section: an editor on an immutable blob does not pretend it can
mutate the blob; it produces a new capability and lets the user
decide where to bind it.

Source: [designs/chat-view-edit-commands.md](https://github.com/endojs/endo-but-for-bots/blob/2691e7d52d061c0a10b89864e879188f2d4e11d7/designs/chat-view-edit-commands.md) at commit `2691e7d5`.
