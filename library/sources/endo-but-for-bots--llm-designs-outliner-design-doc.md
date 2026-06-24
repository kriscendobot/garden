---
title: "outliner-design-doc — Type 3 Chat System: collaboratively-editable structured document (Roam on Endo Petdaemon)"
source-slug: endo-but-for-bots--llm-designs-outliner-design-doc
url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/outliner-design-doc.md
authors: [undated (no Author frontmatter)]
repo: endojs/endo-but-for-bots
path: designs/outliner-design-doc.md
total-lines: 182
status: undated (no explicit Status frontmatter; appears Proposed-or-Reference)
ingest-cycle: 212
ingest-date: 2026-06-06
lane: designs
---

# outliner-design-doc.md

A 182-line design (no Status/Author frontmatter) defining the §Outliner: a §collaboratively-editable, structured document — closest in spirit to Google Wave, built on the Endo Petdaemon's object-capability infrastructure. §Type-3-chat-system (Type 1 = chat, Type 2 = forum, Type 3 = outliner).

## Key design moves

- **§Type-3-chat-system** — §a-named-third-instance in a chat-system family.
- **§Immutability-at-protocol-level** — all posts are immutable; every action (edit/deletion/move) is a §typed-reply referencing an existing node; the renderer interprets typed replies.
- **§Seven-built-in-reply-types** (Reply / Edit / Deletion / Move / Pro / Con / Supporting-Evidence) + §user-defined-reply-types-as-string-tags (channel admin can add new strings at runtime; no protocol changes needed).
- **§Last-write-wins + §edit-queue-as-resolution-mechanism** — no locking, no OT, no CRDT; the edit queue is the history; earlier edits remain reviewable.
- **§Private-reply-trees-as-capability-grant** — any reply (of any type) can be restricted to a subset of participants at creation time; the restricted reply and its entire subtree are visible only to named participants; §maps-directly-to-Endo's-capability-model.
- **§Layered-confidentiality** — private subtrees within private subtrees with narrower participant sets.
- **§Edit-queue with deletion-of-deletions** — recursive deletion targeting; deletions can target other deletions, restoring the edit they targeted.
- **§Edited-by-pet-name attribution** below node text; clicking opens edit queue.
- **§Avatar-lineage** as §partially-overlapping-circular-avatars-ordered-left-to-right-by-edit-sequence; §z-index-as-edit-order encoding (original poster leftmost + lowest z-index; most recent editor rightmost + highest z-index).
- **§Global-Playback** — chronological walk-through of every reply-type message since last visit; §playback-with-viewer-history-aware-display (seen-before nodes get diff-markup; first-time nodes get current-content-only with avatar-lineage attribution).
- **§Viewer-side-administration with §retroactive-blocking** — blocking a user excludes their edits from the viewer's rendered state; §applied-retroactively (slices out mutations from viewer's entire history); §block-propagates-to-future-invitees; creates §personalized-unique-view per viewer.
- **§Permissions Model** — initial invitation read-only or read-write; channel admin can adjust outstanding invitation; §custom-attenuation-code in SES-Compartment for invitations.
- **§Even-untrusted-attenuator-code-can-at-worst-interrupt** — cannot escalate privileges (SES confinement property).
- **§Reference-scoping no-upward-traversal** — file-system principle: "endowing a directory does not endow upward"; §"you can give the bag and know that nothing but what's in the bag is getting handed over".
- **§Agent-participation as first-class** — any Agent holding a channel capability can participate; humans and bots use the same interface; @mention-as-wake-up-command.
- **§Explicit-mentions-important** in multi-user real-time collaboration — boundary between brainstorm and trigger.
- **§Roam-on-Endo-Petdaemon** — replaces Automerge CRDTs with Endo's object-capability message-passing.
- **§What-it-gains-vs-loses** explicit trade-off: gains (fine-grained permissions, edit provenance, viewer-side administration, private reply trees, programmable attenuation, global playback, Endo invitation system); loses (real-time collaborative text editing within a single block — Automerge/NextGraph's CRDT strength); §pragmatic-substitute (last-write-wins + edit-queue).
- **§Meta+J keyboard shortcut** for new top-level node/channel.
- **§Eight-Open-Questions** — mid-stage design maturity signal.

## Ingest scope

Cycle 212 (designs-lane): full ingest of the 182-line design as one section. Cohesion-honest single-section because §the-document-is-structurally-one-system-design.

## Related material in the library

- **cycle 158 chat-reply-chain-visualization** (deprecated; superseded by chat-focus-message): sibling reply-chain visualization at chat layer.
- **`chat-focus-message.md`** (not yet ingested): successor to cycle 158.
- **`lal-reply-chain-transcripts.md`** (not yet ingested): Lal's transcript representation.
- **cycle 161 daemon-capability-filesystem**: §absence-is-structural-not-policy sibling — both designs use absence as the security boundary.
- **cycle 166 daemon-mount**: §realpath-at-operation-time-confinement sibling — three designs sharing §no-upward-traversal discipline at three layers.
- **cycle 200 worker-rust-xs**: §engine-level-confinement-via-XS-native-Compartment sibling — both rely on SES-Compartment substrate.
- **cycle 205 evasive-transform**: §SES-censorship-evasion sibling — SES-Compartment as trust boundary.
- **cycle 210 lal-fae-form-provisioning**: §manager-worker-split sibling — both designs treat agents as first-class participants.
- **cycle 196 endoclaw**: §thirteen-feature-categories sibling — both designs enumerate the family at canonical level.
- **cycle 206 inventory-cancel-and-liveness**: §coalesced-watcher-protocol sibling — UI patterns for capability-bearing items.
