---
title: §Borrowable patterns (tier-1)
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

1. **§Five-numbered-goals named in Motivation** — checklist-of-what-the-design-must-achieve.
2. **§Linked-chain-of-transcript-nodes-with-shared-prefix-stored-once** for branching-data-structures-where-memory-matters.
3. **§Branching-is-free** — two replies to same parent create new nodes pointing to same parent.
4. **§ASCII-tree-diagram of branching** as §visual-explanation-in-design-doc.
5. **§Assembly-via-walk-from-leaf-to-root + concatenate root-to-leaf** for §traversal-shape-walking-linked-chain.
6. **§Two-Phase Node Lifecycle** (Phase 1 inbound + Phase 2 own-outbound-alias) for §asymmetric-state-update with §alias-mapping.
7. **§Honest-design-evolution-visible-in-the-prose** ("This is getting complex. Let's simplify:") — §self-correcting-prose as §a-new-rhetorical-shape for §designs-where-the-iteration-is-pedagogically-useful.
8. **§Pet-store-as-source-of-truth-with-in-memory-cache** for §large-data with §lazy-load-on-cache-miss.
9. **§Text-prefix-as-out-of-band-metadata** (`[depth:N]`) when §schema-changes-are-expensive.
10. **§No-daemon-changes-required** — §leverage-existing-API.
11. **§Three-Alternatives-Considered each rejected with named reason** (full-copy-wasteful / single-with-tags-fragile / structured-field-schema-changes-deferred).
12. **§Four-Phases-all-Complete + Phase-5-extracted-to-separate-design** for §substantive-phase-extraction.
13. **§Decisions-Made-vs-Tentative-Decisions two-table-shape** for §some-decisions-still-pending-implementation-verification.
14. **§Four-out-of-scope items with named-reason-or-pointer-to-sibling** for §explicit-scope-refusal.
15. **§Phases-Complete-status-with-honest-design-evolution-visible** for §record-of-what-was-built.
