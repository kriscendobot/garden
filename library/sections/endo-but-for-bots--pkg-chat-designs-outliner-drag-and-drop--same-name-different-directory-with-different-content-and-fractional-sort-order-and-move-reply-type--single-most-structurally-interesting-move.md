---
title: Single most structurally interesting move
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

**§two-cycles-with-the-same-design-file-name-in-different-directories** — the repository contains two files named `outliner_drag_and_drop.md`: a 1020-line cluster-wide UI pattern guide at `designs/` (cycle 277) and a 48-line chat-package implementation-detail-fragment at `packages/chat/designs/` (cycle 289). **Same name, different audiences, different scope, distinct purposes**.

This IS the natural shape of layered designs in a monorepo: the cluster-wide design names the pattern; the package-level design names the implementation. The shared name IS NOT a mistake — it's a *deliberate cross-directory naming convention* that links the cluster-spec to its package-implementation by filename alone. **§the-cross-directory-shared-name-IS-the-named-link-mechanism**.

The pattern generalizes to any layered architecture: a top-level *what* document at the cluster level, and a per-package *how* document with the *same filename* at the package level. The reader looking at `outliner_drag_and_drop.md` in the chat package KNOWS to look up the same filename at the top level for the pattern guide. §the-filename-IS-the-cross-document-anchor.

§the-naming-IS-the-navigation: in a repository with this convention, file-name-based search across directories yields the related-documents-at-different-scales.
