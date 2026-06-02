---
section: token-threshold-trigger-with-iterative-summary-and-cumulative-file-tracking
source: endo-but-for-bots--llm-designs-endopi-iterative-compaction
topics: [agent-conventions]
status: current
---

# Token-threshold trigger with iterative summary and cumulative file tracking

> *Each compaction's summary takes the *previous* summary as input,
> not the *original* messages. This means a long session accumulates
> one summary, not N summaries.*
>
> — `designs/endopi-iterative-compaction.md` §Iterative property

`endopi-iterative-compaction.md` (152 lines, *Proposed (partially
satisfied)* status, created 2026-05-15) is the fifth endopi-* design
ingested and the *fourth spinout from cycle 121's family keystone*.
Parent: `endopi.md`. The design closes the §Compaction gap surfaced
in §Feature-by-Feature Mapping by *importing Pi's compaction
algorithm as the substrate that
[`lal-transcript-memory-management`](lal-transcript-memory-management.md)
already asks for, in algorithmic form*.

## *Partially satisfied* — the design's Status frontmatter is
load-bearing

The §Status section is the design's *most consequential paragraph*.
It opens with the bald observation:

> *`packages/genie` already ships an iterative-compaction substrate
> that implements a sibling shape to Pi's.*

Cycle 121's family keystone §What Genie's existence tells us already
made this point: *the compaction gap has a working implementation*;
*Genie's observer / reflector pair is closer to a shipped iterative
compactor than `endopi-iterative-compaction`'s design anticipated*;
*the substrate now exists; the design's role shifts from "specify
the algorithm" to "harmonise with the observer/reflector pair and
route Lal/Fae transcripts through them"*.

This design *embodies that shift*. The Status block enumerates
Genie's shipped pieces:

- **Observer subagent** (`packages/genie/src/observer/index.js`) —
  compresses chat into prioritised observations
  (`memory/observations.md`) on a *token-threshold (default 30k)
  plus idle-timer trigger*. Runs as a background `PiAgent` with a
  focused tool set.
- **Reflector subagent** (`packages/genie/src/reflector/index.js`)
  — consolidates observations into long-term knowledge
  (`memory/reflections.md`, `memory/profile.md`) on a *40k-token
  threshold plus daily heartbeat trigger*; *prunes stale low-
  priority entries; merges related observations*.
- Both subagents are gated by `tool-gate.js` to ensure they
  actually call the memory-write tools they were dispatched for.

The §This satisfies clause names what remains:

> *the projection layer (run observer/reflector over Lal
> transcripts; surface their output back into Lal's transcript
> graph rather than to disk), plus the `keepRecentTokens` /
> `reserveTokens` knobs and the structured-summary format pi-mono
> uses.*

The *partially-satisfied* status pattern is structurally important:
it's the *honest-design-correction* discipline cycle 114's
familiar-unified-weblet-server.md exhibits, applied to a different
case. Where cycle 114 corrected a prospective implementation status,
this cycle corrects an *anticipated-algorithm-vs-shipped-substrate*
mismatch.

## The trigger conditions — token threshold + idle, two axes

The §Trigger conditions are the *two-axis trigger discipline* that
both Pi and Genie use:

```
contextTokens > contextWindow - reserveTokens
```

Auto-compaction triggers when the active context approaches the
model's window minus a reserve. `reserveTokens` defaults to *16384*
(leaving room for the model's response). Both knobs are
configurable per-host in the settings store.

The §manual side: a `/compact [instructions]` slash command lets
the user trigger on demand with focused intent (*preserve the
bug-hunt thread, drop the API exploration*). The optional
instructions parameter is the *user-directed-compaction* knob.

The Genie observer's *idle-timer* trigger (not in this design's
algorithm but mentioned in the Status section) is a third axis the
implementation already supports. The design's algorithm only
specifies the threshold; the idle trigger is implicit in the
*loop-running-as-background-PiAgent* shape.

## The five-step algorithm — Pi's compaction.ts ported

The §Algorithm section ports Pi's
`packages/coding-agent/src/core/compaction/compaction.ts`:

1. **Find cut point.** Walk backwards from the newest message,
   accumulating token-count estimates until `keepRecentTokens`
   (default *20000*) is reached. *This is the boundary between
   "summarize" and "keep verbatim".*
2. **Extract.** Collect messages from the previous compaction
   boundary (or session start) up to the cut point.
3. **Generate summary.** Call the same LLM the agent is using,
   with a structured prompt asking for:
   - Goals the user expressed
   - Decisions made
   - **Files touched (cumulative, even those modified before the
     previous compaction)**
   - Open threads
   - Code patterns established
   If a prior summary exists, *pass it as iterative context so the
   new summary builds on it rather than starting fresh*.
4. **Append entry.** Write a `compaction` entry to the JSONL
   session file (per cycle 117's
   `endopi-jsonl-transcript-format`) with `firstKeptEntryId`
   pointing at the cut point.
5. **Reload.** The in-memory transcript is rebuilt with the summary
   entry in place of the elided range.

The five steps mirror Pi's algorithm exactly. The §step-3 LLM
prompt structure is the only piece that admits configuration
(`compaction.customInstructions`); steps 1, 2, 4, 5 are mechanical.

## The §Iterative property — *one summary, not N summaries*

The §Iterative property paragraph is the design's *single
structurally interesting claim*:

> *Each compaction's summary takes the *previous* summary as
> input, not the *original* messages. This means a long session
> accumulates one summary, not N summaries. Pi's structured format
> makes the summary parseable enough that the next compaction can
> merge cleanly.*

The implication: a session that has been compacted ten times has
*one* summary at the head of the in-memory window, not ten nested
summaries. The structured-summary format (*Goals / Decisions /
Files touched / Open threads / Code patterns established*) is
*parseable enough that the next compaction can merge cleanly* —
the structure is what makes the iterative merge tractable.

This is the *structured-summary-as-iteration-substrate* discipline.
Without the structure, each compaction would either restart fresh
(losing earlier context) or accumulate N summaries (consuming all
the tokens the compaction was meant to save).

## §File tracking — *the cumulative record survives compactions*

The §File tracking paragraph is the most operationally interesting
move:

> *Pi maintains a cumulative file-operations record across
> compactions: even if a file was last touched ten compactions ago,
> the current summary still mentions it. The Endo equivalent
> observes the `Dir`/`File` capabilities the agent invokes and
> tracks which paths it touched. The list survives compactions
> because each summary carries it forward.*

The §carries-forward discipline is the structured-summary's
specific use: the *Files touched* field of one summary becomes the
seed of the next summary's *Files touched* field. The list grows
monotonically across compactions; an agent can know *every file
it has ever touched in this session* without reading the full
JSONL.

The Endo-specific extension — *observes the `Dir`/`File`
capabilities the agent invokes* — leverages the capability-bank
discipline cycle 105 ingested: the agent's authority is bounded by
the capability handles it holds, so the *Files touched* set is
exactly the set of paths the agent's `Dir`/`File` caps have been
asked to operate on. The compaction tool doesn't need to grep the
JSONL for paths — the capability traffic already names them.

## §Compaction is lossy — *the JSONL preserves what the in-memory
window prunes*

The §Compaction is lossy paragraph names the *two-layer-storage*
discipline:

> *The original messages remain in the JSONL file (per
> [endopi-jsonl-transcript-format](endopi-jsonl-transcript-format.md)).
> Compaction prunes the in-memory window the LLM sees, not the
> on-disk record. An operator or the agent itself can recover
> detail by re-reading the JSONL.*

This is the §architecture-of-two-readers cycle 117's
`endopi-jsonl-transcript-format` already laid down: *the agent
itself* (resumes a session by reading its own JSONL) + *the
operator* (`endo session list/show` CLI). Compaction *operates on
the agent's in-memory view*, leaving the operator's view (the
JSONL on disk) untouched.

The trade-off is explicit: in-memory window can be small and
fast-to-process; on-disk record can be long and full-fidelity.
*The compaction summary is what bridges them.*

## Settings — four configurable knobs in the per-host store

The §Settings table specifies four configurable values:

| Setting | Default | Description |
|---------|---------|-------------|
| `compaction.enabled` | `true` | Auto-compaction on context overflow |
| `compaction.reserveTokens` | `16384` | Reserved for model response |
| `compaction.keepRecentTokens` | `20000` | Recent window kept verbatim |
| `compaction.customInstructions` | unset | Optional global instructions appended to the summary prompt |

The defaults are conservative: 16k reserved + 20k recent =
~36k-token in-memory window after compaction. For 200k-context
models this leaves ~164k for summaries and tool results.

## §Out of scope — *branch summarization*; *cross-guest sharing*

The §Out of scope section names two paths the design declines:

- **Branch summarization on tree navigation.** Pi has this for
  `/tree`; Endo's reply-chain UI is different. Revisit if
  `/tree`-style navigation lands.
- **Multi-agent context sharing across compactions.** Compaction
  is per transcript; cross-guest context coordination is a
  separate problem.

Both declines are *honest scope decisions* — neither is a *we
shouldn't do this* judgment; both are *not this design*. The first
is gated on a different design (a Pi-like `/tree` UI in Lal); the
second is the *multi-guest-coordination problem* that the daemon
substrate (cycle 119's capability-bus, cycle 105's capability-bank)
addresses at a different layer.

## Three Pi citations, file-level

The §Citation section names three pi-mono files:

- `packages/coding-agent/docs/compaction.md` (documentation)
- `packages/coding-agent/src/core/compaction/compaction.ts`
  (auto-compaction logic)
- `packages/coding-agent/src/core/compaction/utils.ts` (file
  tracking, serialization)

The §file-level citation discipline visible in cycle 121's family
keystone (33 file-level citations) is repeated here at smaller
scale (three citations).

## Related sections

- cycle 121 family keystone
  [[endo-but-for-bots--llm-designs-endopi--genie-pi-inside-endo-and-the-four-architectural-contrasts]]
  — the §What Genie's existence tells us paragraph that says
  *the compaction gap has a working implementation*; *the
  design's role shifts from "specify the algorithm" to "harmonise
  with the observer/reflector pair"*.
- cycle 117
  [[endo-but-for-bots--llm-designs-endopi-jsonl-transcript-format--pi-compatible-jsonl-with-custom-entries-for-endo-extensions]]
  — the JSONL transcript format that holds the `compaction`
  entry with `firstKeptEntryId`; cycle 117's §five entry types
  includes `compaction` as one of the five.
- cycle 122
  [[endo-but-for-bots--llm-designs-endopi-edit-tool--llm-friendly-edit-by-replacement-with-unique-match-and-line-ending-preservation]]
  — sibling endopi-* spinout from cycle 121's keystone.
- cycle 112
  [[endo-but-for-bots--llm-designs-endopi-skills-markdown-format--agentskills-io-on-disk-skill-shape-with-progressive-disclosure]]
  — first endopi-* spinout (skills format).
- cycle 105
  [[endo-but-for-bots--llm-designs-daemon-capability-bank--shared-capabilities-as-a-meta-design-with-six-design-principles]]
  — the *Dir / File capabilities the agent invokes* that the
  §File tracking discipline tracks; capability-bank is the
  framework that makes those caps tracking-substrate.
