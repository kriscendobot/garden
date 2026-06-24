---
title: §Linked-chain-of-transcript-nodes with §branching-is-free
source: endo-but-for-bots designs/lal-reply-chain-transcripts.md
source-slug: endo-but-for-bots--llm-designs-lal-reply-chain-transcripts
ingest-cycle: 214
ingest-date: 2026-06-06
lane: designs
status: Complete (2026-02-26 created; 2026-03-05 updated; Phases 1-4 shipped; Phase 5 extracted to separate design)
author: Kris Kowal (prompted)
related:
  - endo-but-for-bots--llm-designs-lal-fae-form-provisioning (cycle 210; named in cycle 210 as "Lal: reply-chain transcripts + static tools"; sibling design at agent-loop layer)
  - endo-but-for-bots--llm-designs-familiar-bundled-agents (cycle 208; delivery side of the same agent feature)
  - endo-but-for-bots--llm-designs-lal-transcript-memory-management (Phase 5 extracted; not yet ingested)
  - endo-but-for-bots--llm-designs-chat-reply-chain-visualization (cycle 158; sibling design at UI layer)
  - endo-but-for-bots--llm-designs-daemon-form-request (daemon API leveraged)
keywords:
  - linked-chain-of-transcript-nodes
  - shared-prefix-stored-once
  - branching-is-free (two replies to same parent create new nodes)
  - ASCII-tree-diagram of branching
  - assembly-via-walk-from-leaf-to-root + concatenate root-to-leaf
  - durable-storage-in-pet-store (transcript-<messageId> pet names)
  - lazy-load-on-cache-miss (in-memory Map as cache, pet store as source of truth)
  - avoids-unbounded-heap-growth
  - depth-as-text-prefix [depth:N] (no daemon schema changes)
  - honest-design-evolution-visible-in-document ("This is getting complex. Let's simplify:")
  - two-phase-node-lifecycle (Phase 1 inbound + Phase 2 own-outbound-alias)
  - alias-mapping-outboundId-to-same-node-as-replyTo
  - three-Alternatives-Considered each rejected with named reason
  - four-Phases-all-Complete + Phase 5 extracted-to-separate-design
  - Decisions-Made-vs-Tentative-Decisions two-named-decision-categories
  - tentative-may-adjust-during-implementation
  - no-daemon-changes-required (leverages existing API)
  - five-goals named in Motivation
  - four-out-of-scope items
  - depth-counts-user-plus-assistant-turns-excluding-system-prompt-and-tool-results
  - cycle 214 designs-lane
  - forty-eighth consecutive designs/chat alternation cycle 166-214
  - fifteenth-honest-design-evolution-record family member with new shape (design-evolution-visible-in-the-prose)
parent: endo-but-for-bots--llm-designs-lal-reply-chain-transcripts--linked-chain-of-transcript-nodes-with-shared-prefix-stored-once-and-two-phase-node-lifecycle-and-honest-design-evolution-visible-in-document
---

```js
/**
 * @typedef {object} TranscriptNode
 * @property {string} messageId
 * @property {string | null} parentMessageId
 * @property {ChatMessage[]} messages - LLM messages appended at this step only
 * @property {bigint} [lastInboxNumber]
 */
```

§Each-node-stores-only-the-messages-appended-at-that-step + §a-pointer-to-the-parent-node. §The-full-message-array-is-assembled-by-walking-the-chain when presenting it to the LLM.

§Branching-is-free: §when-two-replies-target-the-same-parent-messageId, §each-creates-a-new-node-pointing-to-the-same-parent. §The-shared-prefix-is-stored-once.

§ASCII-tree-diagram of root → node M1 → branches M3 + M4. §Sibling-pattern to cycle 200 worker-rust-xs's §ASCII-architecture-diagram and cycle 206 inventory-cancel-and-liveness's §ASCII-visual-layout-diagram + cycle 210 lal-fae's §ASCII-diagram-of-fan-out-pattern.

§Borrowable-pattern: §linked-chain-with-shared-prefix-stored-once for §branching-data-structures-where-memory-matters.

§Sibling-pattern to cycle 161 daemon-capability-filesystem's §three-layer-architecture and cycle 156 finalize.js's §weak-value-map — but at §a-different-layer (LLM-transcript-data-structure).
