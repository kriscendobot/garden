---
title: Loading blob content and focus-mode integration
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
---

> Abstract: Both commands load blob content by resolving the typed
> `petNamePath` to a capability and calling `text()` on the resulting
> blob. The mechanism is a three-step path walk: (1) the first
> segment resolves as a pet name in the current profile's namespace;
> (2) when the resolved value is a tree or directory, `lookup()`
> walks the remaining segments; (3) `text()` on the final blob
> returns the content as a string. `/edit`'s save is the inverse:
> for a mutable blob, `write()` on the parent directory with the
> entry name and new content; for an immutable blob, a fresh
> `readable-blob` formula via the daemon and a pet-name prompt.
> Focus-mode keyboard shortcuts extend with `v` → `/view` and `e` →
> `/edit`, both pre-filling the pet name path from the focused
> value's name. The shortcuts only appear when the focused value is a
> blob or a directory entry that resolves to a blob.

## Loading content

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

## Focus-mode integration

When a message in the transcript contains a value that resolves to a
blob, the focus mode shortcuts extend:

- `v` → `/view` (pre-fills the pet name path from the focused value's
  name)
- `e` → `/edit` (same pre-fill)

These shortcuts only appear when the focused value is a blob or a
directory entry that resolves to a blob. The visibility predicate is
the same shape as other focus-mode actions: the shortcut is offered
only when its target makes sense, and it carries forward the
focused value's identity (its name in the inventory) so the
modal opens already populated and the user does not retype the path.

The `v` and `e` shortcuts compose with the chat client's broader
focus-mode framework. Other focus actions (`r` to reply, `f` to
forward, `Enter` to expand) are already in place; `v` and `e` join
them on the blob branch of the predicate.

### Shortcut name collision

`e` is also the focus-mode shortcut for `/edit` on chat messages, the
sibling design [[endo-but-for-bots--llm-designs-chat-edit-message-ui--problem-and-authority]].
The chat-edit-message-ui design names this explicitly in its open
questions and resolves the collision via *focus target*: the
`/edit` chat command in chat-edit-message-ui acts on message
envelopes, while the `/edit` here acts on blob chips; the focused
element's kind discriminates which `/edit` and which `e` shortcut
fires. The slash command name `/edit` itself is the unresolved
open question between the two designs (see the chat-edit-message-ui
[[endo-but-for-bots--llm-designs-chat-edit-message-ui--open-questions]]
section for the three resolution options: rename one of them,
overload-and-dispatch on the field type, or ship one and rename
later).

## See also

- [[endo-but-for-bots--llm-designs-chat-components--profile-system-and-error-handling]] — the profile system that scopes the pet-name namespace the first path segment resolves into.
- [[endo-but-for-bots--llm-designs-chat-command-bar--field-types-and-autocomplete-mechanics]] — how the `petNamePath` typed input field constructs the path with `.`-drilling autocomplete.
- [[endo-but-for-bots--llm-designs-chat-components--inventory-and-messages]] — the inventory panel that displays the names and trees the path walks; the focus-mode framework that the new `v` and `e` shortcuts join.
- [[endo-but-for-bots--llm-designs-chat-edit-message-ui--open-questions]] — the named collision over the `/edit` slash command and `e` focus shortcut; the three resolution options under consideration.
- [[smallcaps-encoding]] — content-addressed encoding for marshaled values; conceptually adjacent to content-addressed blobs but at a different layer (marshal vs daemon blob).

Source: [designs/chat-view-edit-commands.md](https://github.com/endojs/endo-but-for-bots/blob/2691e7d52d061c0a10b89864e879188f2d4e11d7/designs/chat-view-edit-commands.md) at commit `2691e7d5`.
