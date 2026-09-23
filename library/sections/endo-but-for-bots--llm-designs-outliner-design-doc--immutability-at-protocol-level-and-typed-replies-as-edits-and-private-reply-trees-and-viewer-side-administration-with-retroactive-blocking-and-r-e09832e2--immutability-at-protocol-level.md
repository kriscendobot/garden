---
title: §Immutability-at-protocol-level
source: endo-but-for-bots designs/outliner-design-doc.md
source-slug: endo-but-for-bots--llm-designs-outliner-design-doc
ingest-cycle: 212
ingest-date: 2026-06-06
lane: designs
status: undated (no Status frontmatter; appears Proposed-or-Reference)
author: undated (no Author frontmatter)
related:
  - endo-but-for-bots--llm-designs-chat-reply-chain-visualization (cycle 158; reply-chain visualization at chat layer)
  - endo-but-for-bots--llm-designs-chat-focus-message (successor to cycle 158)
  - endo-but-for-bots--llm-designs-lal-reply-chain-transcripts (Lal's transcript representation)
  - endo-but-for-bots--llm-designs-daemon-capability-persona (delegate/epithet system referenced for participant identity)
  - endo-but-for-bots--llm-designs-inventory-cancel-and-liveness (cycle 206; UI pattern for capability-bearing items)
keywords:
  - Type-3-chat-system (distinct from Type-1-chat / Type-2-forum)
  - immutability-at-protocol-level (every action as typed reply)
  - seven-built-in-reply-types (Reply / Edit / Deletion / Move / Pro / Con / Supporting-Evidence)
  - user-defined-reply-types as string tags (no protocol changes needed)
  - last-write-wins with edit-queue-as-resolution-mechanism
  - private-reply-trees as capability-grant
  - layered-confidentiality (private subtrees within private subtrees)
  - edit-queue with deletion-of-deletions (recursive deletion targeting)
  - edited-by-pet-name attribution
  - avatar-lineage as partially-overlapping-circular-avatars ordered left-to-right by edit sequence
  - z-index-as-edit-order encoding
  - Global-Playback chronological walk-through
  - playback-with-diff-markup for seen-before nodes
  - viewer-side-administration with retroactive-blocking (slices mutations from viewer's history)
  - block-propagates-to-future-invitees (creates personalized-unique-view per viewer)
  - read-only vs read-write invitation
  - custom-attenuation-code in SES-Compartment
  - even-untrusted-attenuator-code-can-at-worst-interrupt
  - reference-scoping no-upward-traversal (file-system principle "endowing a directory does not endow upward")
  - agent-participation as first-class (any Agent holding channel capability)
  - @mention-as-wake-up-command
  - explicit-mentions-important-in-multi-user-real-time-collaboration
  - Roam-on-Endo-Petdaemon
  - replaces-Automerge-CRDTs-with-object-capability-message-passing
  - what-it-gains-vs-loses explicit trade-off
  - Meta+J keyboard shortcut for new top-level node/channel
  - eight-Open-Questions
  - cycle 212 designs-lane
  - forty-sixth consecutive designs/chat alternation cycle 166-212
parent: endo-but-for-bots--llm-designs-outliner-design-doc--immutability-at-protocol-level-and-typed-replies-as-edits-and-private-reply-trees-and-viewer-side-administration-with-retroactive-blocking-and-roam-on-endo
---

> At the protocol level, all posts are immutable. Every action — including what the user experiences as an edit or deletion — is a **typed reply** referencing an existing node. The reply's type determines how the renderer treats it.

§The-protocol-level vs §the-user-experience: §at-the-protocol-level-all-posts-are-immutable; §what-the-user-experiences-as-an-edit-is-a-reply-with-type-Edit. §The-renderer interprets the typed replies.

§Borrowable-pattern: §immutability-at-protocol-level + §typed-replies-as-rendered-mutations for §collaborative-document-systems where §the-mutation-history-is-load-bearing.

§Sibling-pattern to cycle 162 daemon-Ken-protocol's §atomic-checkpoint and cycle 194 daemon-endo-rust-sqlite's §re-prepare-instead-of-caching-Statement — §three-different-designs that §preserve-history-as-the-substrate at §different-layers.
