---
source: designs/endopi-iterative-compaction.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: d77f3277b5b63cfec07f164270b3927a37194819
source_date: 2026-05-15
source_authors: [Kris Kowal]
ingested: 2026-06-02
ingested_by: scholar
section_count: 1
status: current
notes: |
  Fifth endopi-* design ingest (after cycles 112 + 117 + 121 +
  122). The 152-line *Proposed (partially satisfied)* design
  (Parent: endopi.md) closes the §Compaction gap by importing
  Pi's compaction.ts algorithm as the substrate that
  `lal-transcript-memory-management` already asks for, in
  algorithmic form.

  Single most structurally interesting feature: the *partially
  satisfied* Status. The §Status block names Genie's already-
  shipped observer + reflector subagent pair as *implementing a
  sibling shape to Pi's*. The §This satisfies clause names what
  remains: *the projection layer (run observer/reflector over
  Lal transcripts; surface their output back into Lal's
  transcript graph rather than to disk), plus the
  keepRecentTokens / reserveTokens knobs and the structured-
  summary format pi-mono uses*. This is the *partially-satisfied*
  lifecycle pattern — the *honest-design-correction* discipline
  cycle 114's familiar-unified-weblet-server.md exhibits, applied
  to a different case (anticipated-algorithm-vs-shipped-substrate
  mismatch rather than prospective-implementation-status mismatch).

  Five-step algorithm ported from Pi's `compaction.ts`: find cut
  point (walk backwards accumulating tokens until
  `keepRecentTokens` reached) → extract messages from previous
  boundary up to cut point → generate summary via LLM with
  structured prompt (Goals / Decisions / Files touched / Open
  threads / Code patterns) → append `compaction` entry to JSONL
  (per cycle 117) → reload in-memory transcript.

  Three structurally interesting moves:
    (1) §Iterative property — *each compaction's summary takes
        the previous summary as input, not the original messages*;
        *a long session accumulates one summary, not N summaries*;
        Pi's structured format makes the summary parseable enough
        that the next compaction can merge cleanly.
    (2) §File tracking — Pi maintains a *cumulative file-operations
        record* across compactions; *even if a file was last
        touched ten compactions ago, the current summary still
        mentions it*; Endo's equivalent *observes the Dir/File
        capabilities the agent invokes* (the capability-traffic-
        as-tracking-substrate idiom that leverages cycle 105's
        capability-bank discipline).
    (3) §Compaction is lossy — *the original messages remain in the
        JSONL file (per cycle 117); compaction prunes the in-
        memory window the LLM sees, not the on-disk record*; the
        two-layer-storage architecture cycle 117 already laid down.

  Two-axis trigger discipline: `contextTokens > contextWindow -
  reserveTokens` (default `reserveTokens` = 16384) for auto-
  compaction; `/compact [instructions]` slash command for manual.
  The Genie observer adds an *idle-timer* third axis the design
  doesn't formalize but the implementation already supports.

  Four configurable knobs in the per-host settings store:
  `compaction.enabled` (true) / `compaction.reserveTokens`
  (16384) / `compaction.keepRecentTokens` (20000) /
  `compaction.customInstructions` (unset).

  Three Pi citations file-level: docs/compaction.md +
  core/compaction/compaction.ts (auto-compaction logic) +
  core/compaction/utils.ts (file tracking, serialization).

  Two §Out of scope decisions: *branch summarization on tree
  navigation* (gated on a Pi-like `/tree` UI in Lal which is not
  designed yet); *multi-agent context sharing across compactions*
  (the multi-guest-coordination problem belongs at the daemon
  layer cycle 119's capability-bus / cycle 105's capability-bank
  address).

  Cycle 124 was nominally papers-lane (cycle 123 was comments).
  Papers-lane has been blocked for 18+ consecutive cycles
  (97/100/102/104/106/108/110/112/113/114/116/117/118/119/120/
  121/122/123). Cycle 124 pivoted to designs-lane to continue
  knitting the endopi-* family arc; family now at 5/8 ingested
  (keystone + skills-markdown-format + jsonl-transcript-format +
  edit-tool + iterative-compaction). Four spinouts remain:
  extension-package-manifest / prompt-templates /
  provider-registry-and-oauth / stdio-rpc-bridge.
---

> Abstract: `endopi-iterative-compaction.md` (152 lines, *Proposed
> (partially satisfied)* status; Parent: endopi.md) imports Pi's
> `compaction.ts` algorithm as the substrate
> [`lal-transcript-memory-management`](lal-transcript-memory-management.md)
> already asks for. The *partially satisfied* lifecycle pattern
> is load-bearing: `packages/genie` already ships an observer +
> reflector subagent pair *implementing a sibling shape to Pi's*;
> the remaining work is the *projection layer* (run observer /
> reflector over Lal transcripts and surface output back into the
> transcript graph rather than to disk).
>
> Trigger: `contextTokens > contextWindow - reserveTokens`
> (`reserveTokens` defaults to 16384) for auto; `/compact
> [instructions]` for manual. Five-step algorithm: walk backwards
> for `keepRecentTokens` (20000) → extract previous boundary to
> cut point → generate summary with structured prompt (Goals /
> Decisions / Files touched / Open threads / Code patterns; *if a
> prior summary exists, pass it as iterative context*) → append
> `compaction` entry to JSONL (cycle 117) → reload in-memory
> transcript.
>
> Three structurally interesting moves: (1) §Iterative property —
> *one summary, not N* (the structured-format-as-iteration-
> substrate discipline; without it, each compaction would either
> restart fresh or accumulate N nested summaries); (2) §File
> tracking — cumulative-across-compactions list, surveying which
> `Dir`/`File` capabilities the agent has invoked (capability-
> traffic-as-tracking-substrate leveraging cycle 105's capability-
> bank); (3) §Compaction is lossy — in-memory window prunes; JSONL
> preserves; *an operator or the agent itself can recover detail
> by re-reading the JSONL*.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [token-threshold-trigger-with-iterative-summary-and-cumulative-file-tracking](../sections/endo-but-for-bots--llm-designs-endopi-iterative-compaction--token-threshold-trigger-with-iterative-summary-and-cumulative-file-tracking.md) | agent-conventions | current |

Tight 152-line design with one structural argument cluster:
*import Pi's compaction algorithm, harmonised with Genie's
already-shipped observer/reflector substrate, surfacing through
Lal's transcript graph and JSONL files*. One cohesion-honest
section.

## Provenance

- Fetched 2026-06-02 from `endojs/endo-but-for-bots@d77f3277` (the
  branch `origin/llm`) via the local bare-clone.
- Last touched 2026-05-15 by kriscendobot in commit `d77f3277`
  (same dispatch wave as cycle 121's family keystone original
  pass).
- Status: *Proposed (partially satisfied)*. Parent: `endopi.md`
  (cycle 121's family keystone).
- **Twenty-third-comment-style design ingest.** Pairs with cycles
  112 + 117 + 121 + 122 to advance the endopi-* family to 5/8
  ingested. Together with cycle 121's family keystone §Genie
  section that names this design as *partially satisfied today*
  by Genie's observer + reflector pair, this ingest completes the
  *family-keystone-acknowledges-genie-substrate-shipping* arc.
- Cycle 124 was nominally **papers-lane** (cycle 123 was
  comments). Papers-lane has been blocked for **18+ consecutive
  cycles** due to lack of PDF-fetching infrastructure. Cycle 124
  pivoted to designs-lane.
- Cohesion-honest one-section count.
