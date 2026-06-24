---
title: §Eight-Open-Questions
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

§Eight-Open-Questions enumerate §design-decisions-yet-to-make:

1. How deep avatar lineage should display before truncating.
2. Whether agent "thinking"/"loading" states should be a distinct reply type or a transient annotation.
3. Conflict resolution when two users simultaneously Move the same sibling set.
4. Governance for user-defined reply types (any participant vs admin only).
5. Whether Pro/Con should trigger special rendering (e.g., color-coded columns).
6. Maximum nesting depth for deletions-of-deletions.
7. Whether private reply tree visibility can be expanded after creation.
8. Threshold of unseen changes for Global Playback automatic-vs-on-demand.

§Eight-Open-Questions is §a-design-maturity-signal (between cycle 198 patterns-diagnostic-feedback's §one-Open-Question for §nearly-ready-implementation and cycle 196 endoclaw's §seven-Open-Questions for §reference-document). §Cycle-212-outliner has §eight-Open-Questions, suggesting §mid-stage-design.
