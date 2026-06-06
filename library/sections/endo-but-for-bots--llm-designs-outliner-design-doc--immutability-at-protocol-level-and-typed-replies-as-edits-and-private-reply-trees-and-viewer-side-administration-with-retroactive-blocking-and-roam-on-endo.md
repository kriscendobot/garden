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
---

# outliner-design-doc — §Type-3-chat-system + §immutability-at-protocol-level + §typed-replies-as-edits + §private-reply-trees + §viewer-side-administration-with-retroactive-blocking + §Roam-on-Endo-Petdaemon-replaces-Automerge-CRDTs

## Source

- `endo-but-for-bots designs/outliner-design-doc.md` — 182 lines
- Status: undated (no explicit Status frontmatter; appears Proposed-or-Reference)
- Author: undated (no explicit Author frontmatter)
- Cycle 212 of `/loop resume the librarian work.` (designs-lane; alternates from cycle 211's chat-lane @endo/common; §forty-sixth consecutive designs/chat alternation cycle 166-212)

## Single most structurally interesting move

§Immutability-at-protocol-level with §every-action-as-typed-reply (Edits, Deletions, Moves are all replies referencing an existing node) + §seven-built-in-reply-types + §user-defined-reply-types-as-string-tags-no-protocol-changes-needed + §last-write-wins-with-edit-queue-as-resolution-mechanism + §private-reply-trees-as-capability-grant-with-layered-confidentiality + §viewer-side-administration-with-retroactive-blocking + §Roam-on-Endo-Petdaemon-replaces-Automerge-CRDTs-with-object-capability-message-passing.

§The-design's-load-bearing-axis: §every-mutation-is-immutable-and-attributed. §What-the-user-experiences-as-an-edit is §a-typed-reply that the renderer interprets. §The-mutation-history is §the-substrate.

## §Type-3-chat-system

> ## Endo Petdaemon — Type 3 Chat System

§Three-named-chat-types implied: Type-1-chat (real-time channel) + Type-2-forum (threaded discussion) + Type-3-outliner (collaboratively-editable structured document).

§Borrowable-pattern: §three-named-system-types as §a-taxonomy that §lets-the-design-be-named-by-its-place-in-the-family.

§Sibling-pattern to cycle 196 endoclaw's §thirteen-feature-categories with §status-matrix — both designs §enumerate-the-family at a §canonical-level. §Cycle-212 is §a-named-third-instance in the chat-system family.

## §Immutability-at-protocol-level

> At the protocol level, all posts are immutable. Every action — including what the user experiences as an edit or deletion — is a **typed reply** referencing an existing node. The reply's type determines how the renderer treats it.

§The-protocol-level vs §the-user-experience: §at-the-protocol-level-all-posts-are-immutable; §what-the-user-experiences-as-an-edit-is-a-reply-with-type-Edit. §The-renderer interprets the typed replies.

§Borrowable-pattern: §immutability-at-protocol-level + §typed-replies-as-rendered-mutations for §collaborative-document-systems where §the-mutation-history-is-load-bearing.

§Sibling-pattern to cycle 162 daemon-Ken-protocol's §atomic-checkpoint and cycle 194 daemon-endo-rust-sqlite's §re-prepare-instead-of-caching-Statement — §three-different-designs that §preserve-history-as-the-substrate at §different-layers.

## §Seven-built-in-reply-types

| Type | Renders as |
| --- | --- |
| Reply | Child node (standard conversational response) |
| Edit | Replacement text for target (latest accepted in place of original) |
| Deletion | Disregard target (often an Edit; can target Deletions) |
| Move | Reorder target to new position among siblings |
| Pro | Argument in favor (Kialo-style structured debate) |
| Con | Argument against |
| Supporting Evidence | Attaches evidence or references |

§Seven-built-in-reply-types each with §named-renderer-interpretation. §The-renderer-is-the-load-bearing-interpreter — §the-protocol-just-carries-typed-replies.

§Plus-user-defined-reply-types: §"A channel administrator can add new reply type strings at runtime [...] reply type is just a string tag on a reply message — no protocol changes needed". §Extension-via-string-tag-without-protocol-change is §the-design-axiom.

§Borrowable-pattern: §extensible-typed-replies-via-string-tags + §renderer-as-interpreter for §extensible-collaborative-documents.

## §Last-write-wins + §edit-queue-as-resolution-mechanism

> When two users submit Edit replies targeting the same node, **last write wins**. The earlier edit is not lost — it remains in the edit queue and can be reviewed, restored, or deleted like any other Edit. No locking or operational transformation is applied. The edit queue is the resolution mechanism.

§Last-write-wins is §the-rendering-default. §The-edit-queue is §the-history. §Earlier-edits are §not-lost — they remain reviewable.

§No-locking-no-OT — explicit rejection of §the-CRDT/OT-approach. §The-edit-queue-IS-the-resolution-mechanism.

§Sibling-pattern to cycle 200 retention-path-notation's §best-path-selection-rule (multi-tier preference for the §rendered choice) and cycle 209 path-compare's §three-tier-comparison. §Different-shapes-of-the-same-discipline: §pick-one-rendered-value-from-many-candidates-via-named-rule.

§Borrowable-pattern: §last-write-wins-with-queue-as-resolution for §collaborative-systems-without-CRDT/OT.

## §Private-reply-trees with §layered-confidentiality

> Any reply (of any type) can be **restricted to a subset of the channel's participants** at creation time. The restricted reply and its entire subtree are visible only to the named participants. Other channel members cannot see the subtree at all — it does not exist in their view.
>
> This is author-side access control, distinct from viewer-side blocking. It maps directly to Endo's capability model: the private subtree is a capability granted only to the specified participants.
>
> Private subtrees can themselves contain further private subtrees with narrower participant sets, enabling layered confidentiality within a single document.

§Author-side-access-control distinct from §viewer-side-blocking. §The-private-subtree is §a-capability-granted-only-to-the-specified-participants. §Maps-directly-to-Endo's-capability-model.

§Layered-confidentiality: §private-subtrees-within-private-subtrees with §narrower-participant-sets. §Composable-access-restriction.

§Sibling-pattern to cycle 161 daemon-capability-filesystem's §Bazel-style-selective-dependency-mounting — both designs §use-absence-as-structural-not-policy. §The-private-subtree-doesn't-exist-in-the-non-participant's-view.

§Borrowable-pattern: §author-side-access-control-via-capability-grant + §layered-confidentiality for §collaborative-systems-with-fine-grained-permissions.

## §Edit-queue with §deletion-of-deletions

> The edit queue shows the full chain of Edit and Deletion replies targeting a node, most recent at top. [...] A viewer can "delete" an edit from this queue. This posts a new Deletion-type reply targeting that Edit message. The renderer skips that edit when computing the current node text, falling back to the next most recent undeleted Edit (or the original content if all edits are deleted).
>
> Deletions themselves appear in the queue and can in turn be deleted, restoring the edit they targeted.

§Recursive-deletion-targeting: §deletion-of-deletions restores the edit they targeted. §The-renderer-walks-the-queue and §skips-deleted-edits-and-deleted-deletions.

§Two-named-mechanisms work together: §typed-reply (Edit / Deletion) + §queue-walk-by-renderer.

§Borrowable-pattern: §recursive-mutation-of-typed-replies + §queue-walk-by-renderer for §reversible-collaborative-edits.

## §Avatar-lineage as §overlapping-circles ordered by edit sequence

> Each node displays a **visual array of partially overlapping circular avatars** in its corner. Avatars are ordered left-to-right by edit sequence: the original poster is leftmost (lowest z-index), subsequent editors overlap progressively to the right.

§Z-index-as-edit-order encoding. §The-original-poster-is-leftmost-and-lowest-z-index. §The-most-recent-editor-is-rightmost-and-highest-z-index.

§Clicking-the-avatar-array-opens-the-edit-queue. §The-visual-is-also-the-affordance.

§Borrowable-pattern: §z-index-as-temporal-order-encoding for §visual-attribution where §the-attribution-is-also-a-link-to-the-history.

## §Global-Playback as §chronological walk-through

> When a user visits a document they haven't viewed in a while, the system offers **Global Playback**: a chronological walk-through of every reply-type message (Reply, Edit, Deletion, Move, etc.) across all nodes since the user's last visit.
>
> [...] For nodes the viewer has already seen, edits made since their last visit are displayed with diff-style markup (additions highlighted, deletions struck through). For nodes the viewer is seeing for the first time, only the current content is shown — no diff markup — with the avatar lineage and "Edited by" attribution indicating multiple contributors.

§Playback-with-asymmetric-display: §seen-before-nodes get diff-markup; §first-time-nodes get current-content-only. §The-viewer's-history determines the display.

§Two-named-affordances: §automatically-on-visit-after-absence + §on-demand-at-any-time.

§Borrowable-pattern: §playback-with-viewer-history-aware-display for §collaborative-documents-with-edit-history.

## §Viewer-side-administration with §retroactive-blocking

> Blocking a user **excludes that user's edits** from the viewer's rendered state of the document. This is applied retroactively: blocking someone slices out their mutations from the viewer's entire history of that node's content.
>
> The block propagates: anyone the viewer subsequently invites to this channel inherits the block. This creates a **personalized, unique view** of any channel — each viewer's document state reflects their own trust decisions.

§Retroactive-blocking-slices-out-mutations-from-viewer's-entire-history. §Block-propagation creates §personalized-unique-view per viewer.

§Each-viewer's-document-state-reflects-their-own-trust-decisions. §There-is-no-canonical-view — only §viewer-specific-views.

§Borrowable-pattern: §viewer-side-administration with §retroactive-blocking + §block-propagation for §collaborative-systems-with-decentralized-trust.

§Sibling-pattern to cycle 196 endoclaw's §object-capability-vs-ambient-authority — both designs §reject-centralized-authority for §per-viewer-or-per-capability decisions.

## §Custom-attenuation-code in SES Compartment

> Custom attenuation code can be pasted into an invitation's attenuator field. This code runs in a secure ECMAScript compartment (Endo's SES/Compartment). Even untrusted attenuator code can at worst interrupt invitees' participation — it cannot escalate privileges.

§Even-untrusted-attenuator-code-can-at-worst-interrupt — §the-confinement-property. §SES-Compartment provides §the-trust-boundary.

§Sibling-pattern to cycle 200 worker-rust-xs's §engine-level-confinement-via-XS-native-Compartment + cycle 205 evasive-transform's §SES-censorship-evasion. §Three-different-cycles-relying-on-the-same-SES-Compartment-substrate.

## §Reference-scoping no-upward-traversal — §file-system principle

> Having a reference to a message does **not** grant reference to its parent. This follows the file-system principle: endowing a directory does not endow upward. Contained content is implied; non-contained content is not. You can give the bag and know that nothing but what's in the bag is getting handed over.

§The-file-system-principle: §endowing-a-directory-does-not-endow-upward. §Contained-content-is-implied; §non-contained-content-is-not.

§"You-can-give-the-bag-and-know-that-nothing-but-what's-in-the-bag-is-getting-handed-over" — §the-canonical-OCap-metaphor.

§Sibling-pattern to cycle 161 daemon-capability-filesystem's §absence-is-structural-not-policy and cycle 166 daemon-mount's §realpath-at-operation-time-confinement. §Three-designs sharing §the-no-upward-traversal discipline at §three-layers.

§Borrowable-pattern: §reference-scoping-no-upward-traversal as §the-canonical-OCap-discipline for §hierarchical-resource-sharing.

## §Agent-participation as §first-class

> In Endo, the Agent interface describes both human personas and automated participants (robots/bots). Any Agent holding a channel capability can participate in the Outliner — reading nodes, posting reply-type messages, and receiving events.
>
> Users can `@mention` an Agent in a node. If the Agent has channel access and an instruction like "if mentioned, reply," the mention acts as a **wake-up command**. The Agent receives its current view of the document and decides how to act.
>
> Explicit mentions are important in multi-user real-time collaboration — users may brainstorm for a while before wanting to trigger an Agent response.

§Agent-and-human are §the-same-interface. §@mention-as-wake-up-command — §the-mention-triggers-the-agent's-current-view-and-decision.

§Explicit-mentions-important — §multi-user-real-time-collaboration needs §boundary-between-brainstorm-and-trigger.

§Borrowable-pattern: §unified-Agent-interface-for-humans-and-bots + §@mention-as-wake-up-command for §multi-participant-collaborative-systems.

§Sibling-pattern to cycle 210 lal-fae-form-provisioning's §manager-worker-split — both designs §treat-agents-as-first-class-participants. §Cycle-212's-agent-participation is §the-receiver-side; §cycle-210's-form-provisioning is §the-sender-side.

## §Roam-on-Endo-Petdaemon — §replaces-Automerge-CRDTs-with-object-capability

> The Outliner is effectively **Roam implemented on Endo Petdaemon**. It replaces Automerge CRDTs with Endo's object-capability message-passing model.
>
> It gains: fine-grained permissions beyond read/write, edit provenance, viewer-side administration, private reply trees, programmable attenuation, global playback, and the Endo invitation system.
>
> It loses: real-time collaborative text editing within a single block (Automerge/NextGraph's CRDT strength). This is a known tradeoff. The concurrent edit policy (last write wins, review via edit queue) is the pragmatic substitute.

§Honest-trade-off-named: §what-it-gains (seven items) + §what-it-loses (real-time CRDT collaborative editing) + §pragmatic-substitute (last-write-wins + edit-queue).

§Borrowable-pattern: §what-it-gains-vs-loses-with-pragmatic-substitute for §designs-that-trade-off-against-prior-art.

§Sibling-pattern to cycle 196 endoclaw's §seven-Endo-specific-advantages and cycle 200 worker-rust-xs's §engine-level-confinement-vs-SES-shim-source-rewriting. §All-three-designs §name-the-trade-off-against-an-existing-system explicitly.

## §Eight-Open-Questions

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

## §Meta+J keyboard shortcut

> Keyboard shortcut: `Meta+J` creates a new top-level node/channel.

§Tiny-detail but §named-explicitly. §The-keyboard-shortcut is part of §the-design-axiom (not deferred to implementation).

§Borrowable-pattern: §name-the-keyboard-shortcut for §UI-designs-that-care-about-affordance-density.

## §Borrowable patterns (tier-1)

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

## §Synthesis-target

Slot machine library §collaborative-game-design-document:

- §Immutability-at-protocol-level + §typed-replies borrowable for §game-modification-history (every game-rule edit is a typed-reply with attribution).
- §Last-write-wins + §edit-queue borrowable for §concurrent-rule-changes-by-multiple-designers.
- §Private-reply-trees borrowable for §unreleased-game-variants-shared-with-subset-of-players.
- §Viewer-side-administration-with-retroactive-blocking borrowable for §player-trust-decisions (a player can choose to ignore another player's contributions to a shared game design).
- §Reference-scoping borrowable for §game-component-references that don't grant access to parent game.
- §@mention-as-wake-up-command borrowable for §triggering-game-bots in design discussions.
- §What-it-gains-vs-loses-with-pragmatic-substitute borrowable for §game-design-trade-offs against existing game engines.

## §Cycle 212 meta-observations

§The-forty-sixth-consecutive-designs/chat-alternation-cycle 166-212.

§Papers-lane-blocked 106+ consecutive cycles (since cycle ~106).

§Library-reaches-717-sections at cycle 212.

§Type-3-chat-system as §a-named-third-instance is §a-new-pattern not previously named in the library. §Sibling-pattern to cycle 196 endoclaw's §thirteen-feature-categories which §enumerated-features-but-not-system-types.

§Three-cycles-sharing-the-no-upward-traversal-discipline now in library: cycle 161 daemon-capability-filesystem (§Bazel-style-selective-dependency-mounting), cycle 166 daemon-mount (§realpath-at-operation-time-confinement), cycle 212 outliner (§reference-scoping with the §file-system-principle). §Different-layers, same-discipline.

§Three-cycles-relying-on-the-same-SES-Compartment-substrate now in library: cycle 200 worker-rust-xs (§engine-level-confinement-via-XS-native-Compartment), cycle 205 evasive-transform (§SES-censorship-evasion), cycle 212 outliner (§custom-attenuation-code-in-SES-Compartment for §even-untrusted-attenuator-can-at-worst-interrupt).
