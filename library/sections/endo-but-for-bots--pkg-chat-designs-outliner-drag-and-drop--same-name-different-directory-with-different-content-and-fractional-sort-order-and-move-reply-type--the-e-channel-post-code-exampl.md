---
title: §the-`E(channel).post(...)`-code-example-with-named-comment-aligned-arguments (first-explicit-observation)
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

```javascript
E(channel).post(
  [String(newSortOrder)],  // fractional sort order
  [],                       // no names
  [],                       // no petNames
  String(targetNodeNumber), // replyTo = node being moved
  [],                       // no ids
  'move'                    // replyType
)
```

**§the-comment-aligned-arguments shape** (first-explicit-observation): each argument has a trailing `//`-comment naming what role it plays in this specific call. **§the-call-site-IS-self-documenting-via-trailing-comments**.

§the-empty-arrays-IS-named-explicitly-by-comment: `[]` arguments have comments saying "no names" + "no petNames" + "no ids" — making the *intentional emptiness* visible. §the-empty-IS-not-the-missing-empty-IS-the-deliberate-empty.

§the-six-positional-parameters-with-trailing-comments IS sibling-pattern to keyword-arguments in languages that lack them; the comments *simulate* named parameters at the call site.
