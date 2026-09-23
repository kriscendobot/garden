---
source: designs/daemon-message-streaming.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 81a22f0064a1754d36453193d93be5a00dfb0734
source_date: 2026-05-20
source_authors: [Joshua T Corbin]
ingested: 2026-06-03
ingested_by: scholar
section_count: 1
status: current
notes: |
  Thirtieth-comment-style design ingest. **First non-Kris-Kowal
  daemon design ingest** — authored by Joshua T Corbin
  (jcorbin) with *(evoked)* attribution (vs Kris's *(prompted)*).
  216-line *In Progress* design (created 2026-03-26, updated
  2026-05-19, last bot-revised 2026-05-20). Phase 1 (`streamReply`
  + `StreamWriter` + `StreamReader`) open as PR #287, not yet
  merged to `llm`.

  Adds *progressive-text-delivery* to the daemon's mail system,
  motivated by Genie's LLM-token streaming. Current Genie
  workaround (separate "Thinking" / "Calling tool X" / final
  buffered response messages) produces a *choppy UX*; this
  design lets the recipient see *one message that builds up in
  real time*.

  §StreamWriter (sender): append(text) + setPhase(phase) +
  end() + abort(reason). §StreamReader (recipient): async
  iterable of StreamEvent objects with type ∈ {append, phase,
  end, abort}.

  §Stream-formula implementation: new formula type `stream` —
  *promise-kit-backed async iterator*. Stream formula is
  *created* when `streamReply` is called; ID attached to the
  outbound message envelope.

  Single most structurally interesting move: §The cross-peer-
  streams-ride-CapTP observation — *the stream events travel
  over the existing CapTP channel as method calls on the stream
  formula's far reference. No new transport primitive is needed
  — the existing promise pipelining and method dispatch handle
  it*. The §re-use-existing-substrate discipline: streaming
  doesn't need its own transport because CapTP method dispatch
  *is already* a streaming transport (cycle 119's
  capability-bus envelope protocol carries the CapTP frames).

  §Message envelope extension via *optional `streamId` field* —
  the §opt-in-via-extension-field discipline; messages without
  streamId are unchanged.

  §Three-phase delivery: (1) sender calls streamReply; (2) mail
  subsystem creates stream formula + envelope with streamId;
  (3) envelope delivered *immediately* to recipient (message
  appears with `stream` attached). §Immediate-envelope-late-
  content shape.

  §Persistence model: *while streaming, only the stream
  formula's in-memory buffer is authoritative*; *on end(), the
  assembled text is written to the message's durable record so
  it survives daemon restart*; *on abort(), partial text plus
  the abort reason are persisted*. The §static-message-eventually
  invariant + §abort-preserves-partial-content discipline.

  §Three-phase non-breaking migration: implement alongside
  reply/send (no breaking changes) → guests opt in → Familiar
  chat UI checks for `stream` property and renders live-updating
  bubble. §Fallback-to-static-strings unifies streaming + non-
  streaming rendering.

  §Four open questions deliberately deferred: chunk granularity
  (§debounce-as-perceived-latency-trade-off); back-pressure
  (§promise-as-back-pressure-signal-vs-fire-and-forget); multiple
  streams per message (§start-with-one-stream-extend-later);
  stream cancellation by recipient (§cancel-from-the-other-side).
  The §honest-deferral discipline: design acknowledges trade-offs
  without pre-committing.

  Cycle 137 was nominally papers-lane (cycle 136 was comments).
  Papers-lane has been blocked for 31+ consecutive cycles. Cycle
  137 pivoted to designs-lane. Third daemon-* design after
  endopi-* closure (cycles 133 guest-eval-simplification + 135
  locator-reference + this cycle's message-streaming).
---

> Abstract: `daemon-message-streaming.md` (216 lines, *In
> Progress* status, PR #287 open) is the first non-Kris-Kowal
> daemon design ingest (author: Joshua T Corbin / jcorbin, with
> *(evoked)* attribution). Adds *progressive-text-delivery* to
> the daemon's mail system, motivated by Genie's LLM-token
> streaming needs (replaces today's choppy *Thinking → Calling
> tool X → final buffered* multi-message workaround).
>
> §StreamWriter (sender) interface: append / setPhase / end /
> abort. §StreamReader (recipient) is an async iterable of
> StreamEvent objects.
>
> **The single most structurally interesting move**: the §cross-
> peer-streams-ride-CapTP observation — *the stream events
> travel over the existing CapTP channel as method calls on the
> stream formula's far reference. No new transport primitive is
> needed*. The §re-use-existing-substrate discipline: streaming
> rides cycle 119's envelope-protocol-carrying-CapTP without
> any new wire-format work.
>
> §Stream-formula implementation: new formula type `stream`
> (promise-kit-backed async iterator). §Message envelope
> extension via *optional `streamId` field* — §opt-in-via-
> extension-field; non-streaming messages unchanged.
>
> §Persistence model: in-memory while streaming; durable on
> end(); partial-content-plus-abort-reason on abort(). The
> §static-message-eventually invariant lets finalised streams
> be indistinguishable from non-streaming messages.
>
> §Three-phase non-breaking migration with §fallback-to-static-
> strings UI unifying the rendering path. §Four open questions
> deferred (chunk granularity / back-pressure / multiple
> streams / cancellation).

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [streamReply-and-streamSend-with-stream-formula-and-CapTP-rides-method-calls](../sections/endo-but-for-bots--llm-designs-daemon-message-streaming--streamReply-and-streamSend-with-stream-formula-and-CapTP-rides-method-calls.md) | daemon, captp | current |

Tight 216-line *In Progress* design. The whole argument hangs
off one structural insight (*CapTP method dispatch is already a
streaming transport*) and one mechanism (stream-formula with
async-iterable far-reference). One cohesion-honest section.

## Provenance

- Fetched 2026-06-03 from `endojs/endo-but-for-bots@81a22f00` (the
  branch `origin/llm`) via the local bare-clone.
- Created 2026-03-26 by Joshua T Corbin (jcorbin) in commit
  `116f5f06d` (*Mostly bot-written design for daemon message
  streaming*). Last bot-revised 2026-05-20 by endolinbot.
- Status: *In Progress*. Phase 1 open as PR #287 on
  `feat/daemon-message-streaming-phase-1` (commit `4af9cd0ea`).
- **Thirtieth-comment-style design ingest** + **first non-Kris-
  Kowal daemon design ingest**. Pairs with cycle 121's §Genie
  section (Genie agent use case), cycle 119's capability-bus
  (envelope-protocol-carries-CapTP substrate), cycle 130's
  endopi-stdio-rpc-bridge (sibling streaming surface at RPC
  layer), and cycle 103's daemon-value-message (sibling
  reply-to-prior-message shape).
- Cycle 137 was nominally **papers-lane** (cycle 136 was
  comments). Papers-lane has been blocked for **31+ consecutive
  cycles** due to lack of PDF-fetching infrastructure. Cycle 137
  pivoted to designs-lane.
- One cohesion-honest section.
