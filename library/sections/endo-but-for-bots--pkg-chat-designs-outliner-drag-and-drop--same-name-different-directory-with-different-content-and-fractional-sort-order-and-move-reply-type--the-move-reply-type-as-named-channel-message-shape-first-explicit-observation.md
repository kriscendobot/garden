---
title: §the-move-reply-type-as-named-channel-message-shape (first-explicit-observation)
section-slug: endo-but-for-bots--pkg-chat-designs-outliner-drag-and-drop--same-name-different-directory-with-different-content-and-fractional-sort-order-and-move-reply-type
source-slug: endo-but-for-bots--pkg-chat-designs-outliner-drag-and-drop
url: https://github.com/endojs/endo-but-for-bots/blob/master/packages/chat/designs/outliner_drag_and_drop.md
authors: [Endo project (collective)]
status: (no explicit metadata table)
ingest-cycle: 289
ingest-date: 2026-06-11
lane: designs
scope: full
total-lines: 48
parent: endo-but-for-bots--pkg-chat-designs-outliner-drag-and-drop--same-name-different-directory-with-different-content-and-fractional-sort-order-and-move-reply-type
---

The design uses the **channel's existing reply-type vocabulary** to express the new "move" operation:

- `move` reply type
- `replyTo` = the node being moved
- `String(newSortOrder)` = the new sort order in the message body

**§the-named-channel-API-reuse**: the design doesn't invent a new channel-method or message-format; it extends the existing reply-type vocabulary. **§the-named-extension-IS-via-an-existing-vocabulary**.

§the-`replyTo`-IS-overloaded-as-target-node: in `move` messages, `replyTo` names *what the move targets* (which node is being moved). This is a *semantic overload* of the field that originally meant "this message is a reply to this node". §the-existing-field-IS-repurposed-for-the-new-operation.

§the-three-named-fields-encode-the-move (newSortOrder + targetNodeNumber + 'move'-replyType); §minimal-encoding-via-existing-vocabulary.
