---
title: "lal-transcript-memory-management — Phase 5 extracted from lal-reply-chain-transcripts; durable persistence for the conversation tree"
source-slug: endo-but-for-bots--llm-designs-lal-transcript-memory-management
url: https://github.com/endojs/endo-but-for-bots/blob/master/designs/lal-transcript-memory-management.md
authors: [Kris Kowal (prompted)]
repo: endojs/endo-but-for-bots
path: designs/lal-transcript-memory-management.md
total-lines: 135
status: Not Started (2026-03-05 created; 2026-03-05 updated)
ingest-cycle: 216
ingest-date: 2026-06-07
lane: designs
---

# lal-transcript-memory-management.md

A 135-line **Not Started** design extracted from Phase 5 of [lal-reply-chain-transcripts.md](endo-but-for-bots--llm-designs-lal-reply-chain-transcripts.md) (cycle 214's ingest). Implements §durable-persistence-for-the-conversation-tree so that every Endo message the Lal agent processes is mapped to a durable transcript node, persisting independently of the inbox.

## Key design moves

- **§Predecessor-extraction** with §explicit-Predecessor-section linking to parent design (cycle 214's lal-reply-chain-transcripts).
- **§Existing-Infrastructure-named-with-bullet-list** — five enumerated pieces (TranscriptNode / nodeCache / getNode / putNode / assembleTranscript) + alias-entries item.
- **§Every-message-maps-to-a-durable-node** — inbound creates new node; outbound creates alias.
- **§Durability-beyond-message-lifecycle** — transcript store independent of inbox; dismissing inbox does not affect transcripts.
- **§Accumulation-is-intentional** — agent's memory of past conversations grows over lifetime.
- **§Error-not-silent-truncation** — missing node in chain is a reported error, not a silent partial transcript.
- **§User-initiated-cleanup** — discard agent or export via another agent; §two-named-cleanup-paths.
- **§Single-Decisions-table** (four rows) — different shape from cycle 214's two-table-Decisions-Made-vs-Tentative.
- **§Four-Out-of-Scope items** with named reason — token budget / auto-summarization / GC / export tooling.
- **§Sixteenth-honest-design-evolution-record member** with §a-new-shape: §design-evolution-visible-across-two-documents (vs cycle 214's §within-one-document self-correcting prose).

## Section files

- [§Predecessor-extraction + §Every-message-maps-to-durable-node + §Error-not-silent-truncation + §User-initiated-cleanup](../sections/endo-but-for-bots--llm-designs-lal-transcript-memory-management--predecessor-extraction-and-every-message-maps-to-durable-node-and-error-not-silent-truncation-and-user-initiated-cleanup.md) — full design ingest.

## Ingest scope

Cycle 216 (designs-lane): full ingest of the 135-line design as one section. §Five-completed-Lal/Fae-cluster-designs in library after this cycle (cycles 208 + 210 + 214 + 216, with cycles 208/210/214 shipped and cycle 216 Not Started).
