---
ts: 2026-06-02T20:37:38Z
host: endolin
role: liaison
kind: result
dispatch_id: liaison--d9604a
cycle: 124
---

# Cycle 124 — endopi-iterative-compaction.md (Kris Kowal, endo-but-for-bots) — fifth endopi-* spinout

Ingested `designs/endopi-iterative-compaction.md` (152 lines,
*Proposed (partially satisfied)* status, Parent: endopi.md) from
`endojs/endo-but-for-bots@d77f3277` (branch `origin/llm`).
**Twenty-third-comment-style design ingest.** One cohesion-honest
section:

- **token-threshold-trigger-with-iterative-summary-and-cumulative-
  file-tracking** — imports Pi's compaction.ts algorithm as the
  substrate `lal-transcript-memory-management` asks for. Five-step
  algorithm: find cut point (walk backwards until
  `keepRecentTokens` 20000 reached) → extract previous boundary
  to cut → generate summary via LLM with structured prompt (Goals
  / Decisions / Files touched / Open threads / Code patterns) →
  append `compaction` entry to JSONL (cycle 117) → reload
  in-memory transcript.

## The *partially-satisfied* lifecycle pattern

The single most structurally interesting feature is the
*partially-satisfied* Status. The §Status block names Genie's
already-shipped observer + reflector subagent pair (cycle 121
described it in detail) as *implementing a sibling shape to Pi's*.
Cycle 121's §Genie section said *the substrate now exists; the
design's role shifts from "specify the algorithm" to "harmonise
with the observer/reflector pair and route Lal/Fae transcripts
through them"* — this design embodies that shift.

The *partially-satisfied* lifecycle pattern is the *honest-design-
correction* discipline cycle 114's familiar-unified-weblet-server
exhibits, applied to a different case (anticipated-algorithm-vs-
shipped-substrate mismatch rather than prospective-implementation-
status mismatch).

## Three structurally interesting moves

1. **§Iterative property** — *a long session accumulates one
   summary, not N summaries*; the structured-summary-format-as-
   iteration-substrate discipline. Without the structure, each
   compaction would either restart fresh or accumulate N nested
   summaries.

2. **§File tracking** — *cumulative file-operations record across
   compactions; even if a file was last touched ten compactions
   ago, the current summary still mentions it*. Endo's equivalent
   *observes the Dir/File capabilities the agent invokes* — the
   capability-traffic-as-tracking-substrate idiom that leverages
   cycle 105's capability-bank.

3. **§Compaction is lossy** — *the original messages remain in the
   JSONL file; compaction prunes the in-memory window the LLM
   sees, not the on-disk record*. The two-layer-storage
   architecture cycle 117's `endopi-jsonl-transcript-format`
   already laid down.

## Endopi-* family arc progress

The endopi-* family is now at **5/8 ingested**:

- cycle 112 — `endopi-skills-markdown-format.md`
- cycle 117 — `endopi-jsonl-transcript-format.md`
- cycle 121 — `endopi.md` (family keystone)
- cycle 122 — `endopi-edit-tool.md`
- **cycle 124 (this cycle)** — `endopi-iterative-compaction.md`

Three spinouts remain: `endopi-extension-package-manifest` /
`endopi-prompt-templates` /
`endopi-provider-registry-and-oauth` /
`endopi-stdio-rpc-bridge` (four named; family keystone listed five
in its Gaps Worth Closing table; the count seems off by one — to
verify next cycle).

## Rotation note

Cycle 124 was nominally **papers-lane** (cycle 123 was comments).
Papers-lane has been blocked for **18+ consecutive cycles**
(97/100/102/104/106/108/110/112/113/114/116/117/118/119/120/121/
122/123) due to lack of PDF-fetching infrastructure. Cycle 124
pivoted to designs-lane.

## Counts

- 627 → **628** sections (+1).
- 168 → **169** source documents (+1).
- Topic pages updated: `agent-conventions.md` (+1 row — fifth
  endopi-* row in this topic).
- Keywords index extended with ~35 compaction-specific keywords.
- Sources/README.md updated (+1 row).
- Sections/README.md updated (+1 group; total adjusted).

## Next cycle

Cycle 125 wakes in 1500s. Rotation lands on **chat-lane** nominally
(still exhausted at 20/20). Expect a pivot.
