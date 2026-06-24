---
title: §the-`moveOverrides`-Map-as-named-sort-order-override-mechanism (first-explicit-observation)
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

> "A `moveOverrides` map tracks `nodeKey → sortOrder` from the latest move message for each node. `getSortedVisibleChildren` uses `moveOverrides` values instead of message numbers when available."

**§the-named-override-Map as-named-sort-state shape** (first-explicit-observation): a Map that *overrides* a default sort key with a per-node fractional value. **§the-default-IS-message-number + the-override-IS-the-fractional-value**.

§the-fallback-chain-IS-named-explicitly: `moveOverrides[nodeKey] ?? messageNumber[nodeKey]`. **§the-`??`-or-the-named-fallback**.
