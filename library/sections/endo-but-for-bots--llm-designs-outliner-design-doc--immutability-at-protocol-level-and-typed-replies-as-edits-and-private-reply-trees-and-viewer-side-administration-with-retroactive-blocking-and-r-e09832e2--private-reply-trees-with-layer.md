---
title: §Private-reply-trees with §layered-confidentiality
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

> Any reply (of any type) can be **restricted to a subset of the channel's participants** at creation time. The restricted reply and its entire subtree are visible only to the named participants. Other channel members cannot see the subtree at all — it does not exist in their view.
>
> This is author-side access control, distinct from viewer-side blocking. It maps directly to Endo's capability model: the private subtree is a capability granted only to the specified participants.
>
> Private subtrees can themselves contain further private subtrees with narrower participant sets, enabling layered confidentiality within a single document.

§Author-side-access-control distinct from §viewer-side-blocking. §The-private-subtree is §a-capability-granted-only-to-the-specified-participants. §Maps-directly-to-Endo's-capability-model.

§Layered-confidentiality: §private-subtrees-within-private-subtrees with §narrower-participant-sets. §Composable-access-restriction.

§Sibling-pattern to cycle 161 daemon-capability-filesystem's §Bazel-style-selective-dependency-mounting — both designs §use-absence-as-structural-not-policy. §The-private-subtree-doesn't-exist-in-the-non-participant's-view.

§Borrowable-pattern: §author-side-access-control-via-capability-grant + §layered-confidentiality for §collaborative-systems-with-fine-grained-permissions.
