---
title: §Borrowable patterns (tier-1)
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

1. **§Type-3-chat-system** as §a-named-third-instance in a chat-system family.
2. **§Immutability-at-protocol-level + §typed-replies-as-rendered-mutations** for collaborative-document-systems where the mutation-history is load-bearing.
3. **§Seven-built-in-reply-types + §user-defined-reply-types-as-string-tags-no-protocol-changes-needed** — §extension-via-string-tag-without-protocol-change.
4. **§Last-write-wins-with-edit-queue-as-resolution-mechanism** for collaborative-systems-without-CRDT/OT.
5. **§Private-reply-trees-as-capability-grant** with §layered-confidentiality — §author-side-access-control distinct from §viewer-side-blocking.
6. **§Recursive-mutation-of-typed-replies + §queue-walk-by-renderer** for reversible-collaborative-edits.
7. **§Z-index-as-temporal-order-encoding** in avatar-lineage visualization.
8. **§Playback-with-viewer-history-aware-display** — seen-before nodes get diff-markup; first-time nodes get current-content-only.
9. **§Viewer-side-administration with §retroactive-blocking + §block-propagation** — creates personalized-unique-view per viewer; no canonical view.
10. **§Custom-attenuation-code-in-SES-Compartment** — even untrusted attenuator can at worst interrupt; cannot escalate.
11. **§Reference-scoping-no-upward-traversal** as §the-canonical-OCap-discipline ("you can give the bag and know that nothing but what's in the bag is getting handed over").
12. **§Unified-Agent-interface-for-humans-and-bots + §@mention-as-wake-up-command** for multi-participant-collaborative-systems.
13. **§What-it-gains-vs-loses-with-pragmatic-substitute** for designs that trade-off against prior art.
14. **§Eight-Open-Questions as design-maturity-signal** for mid-stage designs.
15. **§Named-keyboard-shortcut in design doc** (Meta+J for new top-level node) for UI-designs.
