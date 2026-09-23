---
title: §Type-3-chat-system distinguished from Type-1-chat + Type-2-forum + §immutability-at-protocol-level with §every-action-as-typed-reply + §seven-built-in-reply-types + §user-defined-reply-types-as-string-tags-no-protocol-changes-needed + §last-write-wins-with-edit-queue-as-resolution-mechanism + §private-reply-trees-as-capability-grant-with-layered-confidentiality + §avatar-lineage-as-overlapping-circles-ordered-left-to-right-by-edit-sequence + §global-playback-as-chronological-walk-through + §viewer-side-administration-with-retroactive-blocking + §block-propagates-to-future-invitees + §custom-attenuation-code-in-SES-Compartment + §reference-scoping-no-upward-traversal (file-system principle) + §agent-participation-as-first-class + §@mention-as-wake-up-command + §Roam-on-Endo-Petdaemon-replaces-Automerge-CRDTs-with-object-capability — endo-but-for-bots designs/outliner-design-doc.md
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
kind: index
section_count: 20
---

Sections:

- [Source](endo-but-for-bots--llm-designs-outliner-design-doc--immutability-at-protocol-level-and-typed-replies-as-edits-and-private-reply-trees-and-viewer-side-administration-with-retroactive-blocking-and-roam-on-endo--source.md)
- [Single most structurally interesting move](endo-but-for-bots--llm-designs-outliner-design-doc--immutability-at-protocol-level-and-typed-replies-as-edits-and-private-reply-trees-and-viewer-side-administration-with-retroactive-blocking-and-r-e09832e2--single-most-structurally-inter.md)
- [§Type-3-chat-system](endo-but-for-bots--llm-designs-outliner-design-doc--immutability-at-protocol-level-and-typed-replies-as-edits-and-private-reply-trees-and-viewer-side-administration-with-retroactive-blocking-and-roam-on-endo--type-3-chat-system.md)
- [§Immutability-at-protocol-level](endo-but-for-bots--llm-designs-outliner-design-doc--immutability-at-protocol-level-and-typed-replies-as-edits-and-private-reply-trees-and-viewer-side-administration-with-retroactive-blocking-and-r-e09832e2--immutability-at-protocol-level.md)
- [§Seven-built-in-reply-types](endo-but-for-bots--llm-designs-outliner-design-doc--immutability-at-protocol-level-and-typed-replies-as-edits-and-private-reply-trees-and-viewer-side-administration-with-retroactive-blocking-and-roam-on-endo--seven-built-in-reply-types.md)
- [§Last-write-wins + §edit-queue-as-resolution-mechanism](endo-but-for-bots--llm-designs-outliner-design-doc--immutability-at-protocol-level-and-typed-replies-as-edits-and-private-reply-trees-and-viewer-side-administration-with-retroactive-blocking-and-ro-e09832e2--last-write-wins-edit-queue-as.md)
- [§Private-reply-trees with §layered-confidentiality](endo-but-for-bots--llm-designs-outliner-design-doc--immutability-at-protocol-level-and-typed-replies-as-edits-and-private-reply-trees-and-viewer-side-administration-with-retroactive-blocking-and-r-e09832e2--private-reply-trees-with-layer.md)
- [§Edit-queue with §deletion-of-deletions](endo-but-for-bots--llm-designs-outliner-design-doc--immutability-at-protocol-level-and-typed-replies-as-edits-and-private-reply-trees-and-viewer-side-administration-with-retroactive-blocking-and-r-e09832e2--edit-queue-with-deletion-of-de.md)
- [§Avatar-lineage as §overlapping-circles ordered by edit sequence](endo-but-for-bots--llm-designs-outliner-design-doc--immutability-at-protocol-level-and-typed-replies-as-edits-and-private-reply-trees-and-viewer-side-administration-with-retroactive-blocking-and-ro-e09832e2--avatar-lineage-as-overlapping.md)
- [§Global-Playback as §chronological walk-through](endo-but-for-bots--llm-designs-outliner-design-doc--immutability-at-protocol-level-and-typed-replies-as-edits-and-private-reply-trees-and-viewer-side-administration-with-retroactive-blocking-and-r-e09832e2--global-playback-as-chronologic.md)
- [§Viewer-side-administration with §retroactive-blocking](endo-but-for-bots--llm-designs-outliner-design-doc--immutability-at-protocol-level-and-typed-replies-as-edits-and-private-reply-trees-and-viewer-side-administration-with-retroactive-blocking-and-r-e09832e2--viewer-side-administration-wit.md)
- [§Custom-attenuation-code in SES Compartment](endo-but-for-bots--llm-designs-outliner-design-doc--immutability-at-protocol-level-and-typed-replies-as-edits-and-private-reply-trees-and-viewer-side-administration-with-retroactive-blocking-and-r-e09832e2--custom-attenuation-code-in-ses.md)
- [§Reference-scoping no-upward-traversal — §file-system principle](endo-but-for-bots--llm-designs-outliner-design-doc--immutability-at-protocol-level-and-typed-replies-as-edits-and-private-reply-trees-and-viewer-side-administration-with-retroactive-blocking-and-r-e09832e2--reference-scoping-no-upward-tr.md)
- [§Agent-participation as §first-class](endo-but-for-bots--llm-designs-outliner-design-doc--immutability-at-protocol-level-and-typed-replies-as-edits-and-private-reply-trees-and-viewer-side-administration-with-retroactive-blocking-and-r-e09832e2--agent-participation-as-first-c.md)
- [§Roam-on-Endo-Petdaemon — §replaces-Automerge-CRDTs-with-object-capability](endo-but-for-bots--llm-designs-outliner-design-doc--immutability-at-protocol-level-and-typed-replies-as-edits-and-private-reply-trees-and-viewer-side-administration-with-retroactive-blocking-and-r-e09832e2--roam-on-endo-petdaemon-replace.md)
- [§Eight-Open-Questions](endo-but-for-bots--llm-designs-outliner-design-doc--immutability-at-protocol-level-and-typed-replies-as-edits-and-private-reply-trees-and-viewer-side-administration-with-retroactive-blocking-and-roam-on-endo--eight-open-questions.md)
- [§Meta+J keyboard shortcut](endo-but-for-bots--llm-designs-outliner-design-doc--immutability-at-protocol-level-and-typed-replies-as-edits-and-private-reply-trees-and-viewer-side-administration-with-retroactive-blocking-and-roam-on-endo--meta-j-keyboard-shortcut.md)
- [§Borrowable patterns (tier-1)](endo-but-for-bots--llm-designs-outliner-design-doc--immutability-at-protocol-level-and-typed-replies-as-edits-and-private-reply-trees-and-viewer-side-administration-with-retroactive-blocking-and-roam-on-endo--borrowable-patterns-tier-1.md)
- [§Synthesis-target](endo-but-for-bots--llm-designs-outliner-design-doc--immutability-at-protocol-level-and-typed-replies-as-edits-and-private-reply-trees-and-viewer-side-administration-with-retroactive-blocking-and-roam-on-endo--synthesis-target.md)
- [§Cycle 212 meta-observations](endo-but-for-bots--llm-designs-outliner-design-doc--immutability-at-protocol-level-and-typed-replies-as-edits-and-private-reply-trees-and-viewer-side-administration-with-retroactive-blocking-and-roam-on-endo--cycle-212-meta-observations.md)
