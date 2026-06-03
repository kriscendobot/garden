---
section: streamReply-and-streamSend-with-stream-formula-and-CapTP-rides-method-calls
source: endo-but-for-bots--llm-designs-daemon-message-streaming
topics: [daemon, captp]
status: current
---

# streamReply and streamSend with stream-formula and CapTP rides method calls

> *For messages that cross CapTP peer boundaries, the stream
> events travel over the existing CapTP channel as method calls
> on the stream formula's far reference. No new transport
> primitive is needed — the existing promise pipelining and
> method dispatch handle it.*
>
> — `designs/daemon-message-streaming.md` §Cross-peer considerations

`daemon-message-streaming.md` (216 lines, *In Progress* status,
created 2026-03-26 / updated 2026-05-19) is the design by Joshua
T Corbin (jcorbin) — **the first non-Kris-Kowal daemon design
ingested**. Phase 1 (`streamReply` + `StreamWriter` +
`StreamReader`) is open as PR #287, not yet merged to `llm`.

The design adds *progressive-text-delivery* to the daemon's mail
system, motivated by the Genie agent's LLM-token streaming
needs.

## The §motivation — *thinking → tool-call → responding* phases

The §Motivation paragraph names the *Genie agent* use case:

> *The Genie agent (and similar AI-powered guests) produces
> output incrementally: reasoning tokens stream in as the LLM
> thinks, tool call notifications arrive mid-turn, and the final
> assistant response is assembled token-by-token.*

Today's workaround:

1. Send a *"Thinking …"* status message while the LLM reasons.
2. Send a *"Calling tool X …"* message on each tool invocation.
3. Buffer all response tokens and send the full text as a single
   final message.

The §choppy-UX problem: *the recipient sees several separate
messages rather than a single response that builds up in real
time*. The design's goal is *one message that builds up in real
time* rather than *N separate messages*.

The §Genie cross-reference connects to cycle 121's family
keystone §Genie section (which introduced Genie as the third
Endo-side surface that embeds Pi directly). Genie's
`makePiAgent` produces incremental output; this design gives the
daemon a way to *carry that incremental output* without forcing
the multi-message workaround.

## The §five use-case requirements

The §Use-Case Requirements section names five capabilities the
streaming facility needs:

1. **Progressive text delivery** — sender appends fragments over
   time; recipient sees each fragment as it arrives.
2. **Status phases** — metadata indicating *thinking* /
   *tool-call* / *responding* so the UI can render appropriate
   indicators.
3. **Finalisation** — *Once finalised, the message becomes an
   ordinary immutable message in the inbox/outbox.* The §static-
   message-eventually invariant.
4. **Error / abort** — sender can abort; recipient sees *partial
   content plus an error indicator*.
5. **Back-pressure (optional, future)** — sender can detect slow
   consumer and throttle.

The §back-pressure-as-future-not-now scoping: the initial design
*doesn't* include back-pressure; the recipient's pull rate is
not (yet) visible to the sender. The §Open questions section
revisits this.

## The §StreamWriter and §StreamReader interfaces

The §StreamWriter interface (sender side):

```js
/**
 * @typedef {object} StreamWriter
 * @prop {(text: string) => Promise<void>} append
 *   Append a text fragment to the stream.
 * @prop {(phase: string) => Promise<void>} setPhase
 *   Update the current phase label (e.g. "thinking" → "responding").
 * @prop {() => Promise<void>} end
 *   Finalise the stream.  The message becomes immutable.
 * @prop {(reason: string) => Promise<void>} abort
 *   Abort the stream with an error reason.
 */
```

The §StreamReader (recipient side) is an *async iterable of
StreamEvent objects*:

```js
/**
 * @typedef {object} StreamEvent
 * @prop {'append' | 'phase' | 'end' | 'abort'} type
 * @prop {string} [text]   - For 'append' events.
 * @prop {string} [phase]  - For 'phase' events.
 * @prop {string} [reason] - For 'abort' events.
 */

for await (const event of message.stream) {
  switch (event.type) {
    case 'append': process.stdout.write(event.text); break;
    case 'phase':  showStatus(event.phase);          break;
    case 'end':                                       break;
    case 'abort':  showError(event.reason);          break;
  }
}
```

The §four-event-type taxonomy: `append` / `phase` / `end` /
`abort`. Each event carries only the fields relevant to its
type.

## The §stream-formula implementation sketch

The §Implementation Sketch names a new formula type `stream` for
the daemon's formula graph:

```
stream:<id> = {
  phase: string,
  chunks: AsyncIterator<StreamEvent>,
  push(event): void,   // internal — called by the sender's StreamWriter
  close(): void,       // internal
}
```

The §stream-formula-shape: *promise-kit-backed async iterator*.
The formula is *created* when `streamReply` is called and its
*ID is attached to the outbound message envelope*. The discipline:
*the formula is the live thing; the envelope is the durable
thing*.

## The §single most structurally interesting move — *CapTP rides
the stream as method calls*

The §Cross-peer considerations paragraph is the design's
*structurally most interesting paragraph*:

> *For messages that cross CapTP peer boundaries, the stream
> events travel over the existing CapTP channel as method calls
> on the stream formula's far reference. No new transport
> primitive is needed — the existing promise pipelining and
> method dispatch handle it.*

The §no-new-transport-primitive observation: streaming is
*just CapTP method calls* on the stream formula's far reference.
Cycle 119's `daemon-capability-bus` envelope protocol already
carries CapTP frames; the streaming events ride that channel
without any new wire-format work.

The §promise-pipelining-handles-it claim: CapTP's promise
pipelining (the *Stage 4 milestone* OCapN cites — pipelining
calls *before the promise resolves*) is exactly what's needed to
make `append` / `setPhase` / `end` / `abort` calls efficient.
The sender pipelines all calls; the receiver processes them in
order; no round-trip per chunk.

This is the *re-use-existing-substrate* discipline. Adding
streaming to the daemon doesn't require new envelope verbs (vs
cycle 119's capability-bus envelope protocol Phase 5 syscall
migration). The §existing-CapTP-handles-it observation is the
*free lunch* of layering: streaming doesn't need its own
transport because CapTP method dispatch *is already* a
streaming transport.

## The §message-envelope-extension — *optional streamId field*

The §Message envelope extension:

> *Add an optional `streamId` field to the message envelope.
> When present the recipient's inbox entry includes a `stream`
> property that is a Far reference to the stream formula's
> async iterable.*

The §opt-in-via-extension-field discipline: messages *without* a
streamId are *unchanged*; messages *with* a streamId carry the
new behavior. No breaking changes; *Phase 1 implements alongside
existing reply/send*.

The §three-phase delivery:

1. Sender calls `streamReply(number)`.
2. Mail subsystem creates a stream formula and a message
   envelope with `streamId`.
3. The envelope is *delivered to the recipient immediately* —
   the message appears in their inbox with `stream` attached.

The §immediate-envelope-late-content shape: the recipient sees
*a placeholder message* immediately (with `stream` attached);
the actual content streams in over time. The §async-iterable-on-
the-stream-property is what the recipient consumes
progressively.

## The §persistence model — *durable-on-end, partial-on-abort*

The §Persistence section names the three storage cases:

> *- While streaming, only the stream formula's in-memory buffer
>   is authoritative.*
> *- On `end()`, the assembled text is written to the message's
>   durable record so it survives daemon restart.*
> *- On `abort()`, partial text plus the abort reason are
>   persisted.*

The §in-memory-during / §durable-on-completion split. The
§assembled-text-concatenated-on-end discipline: the in-memory
chunks get concatenated and *the message snapshot becomes the
durable record*. After `end()`, the message is *indistinguishable
from a non-streaming message* — the §static-message-eventually
invariant from §Use-Case Requirements 3.

The §abort-preserves-partial-content discipline: the abort case
*doesn't discard* what was streamed before the abort. The
partial text + the abort reason are *both* persisted, so the
recipient can see *how much got through* before the failure.

## The §three-phase migration path

The §Migration Path section names the *non-breaking-three-step*
discipline:

1. **Implement `streamReply` / `streamSend` alongside the
   existing `reply` / `send` methods** — *no breaking changes*.
2. **Guests that want streaming opt in**; guests that don't
   continue to use discrete messages.
3. **The Familiar chat UI checks for the `stream` property on
   inbox messages and renders a live-updating bubble when
   present**, falling back to the static `strings` content for
   finalised or non-streaming messages.

The §opt-in-no-breaking-changes discipline. The §fallback-to-
static-strings discipline lets the UI handle *both* streaming
and non-streaming messages uniformly — *one rendering path with
two input shapes*.

## The §four-open-question scoping discipline

The §Open Questions section deliberately *defers* four
decisions:

1. **Chunk granularity** — *Should `append` send individual
   tokens or should the sender batch into larger chunks? A
   minimum interval (e.g. 50ms debounce) could reduce CapTP
   overhead without noticeably hurting perceived latency.* The
   §debounce-as-perceived-latency-trade-off question.

2. **Back-pressure** — *Should `append` return a promise that
   resolves when the recipient has consumed the chunk, or should
   it be fire-and-forget with an internal buffer?* The
   §promise-as-back-pressure-signal-vs-fire-and-forget question.

3. **Multiple streams per message** — *Is there a use case for a
   single message carrying multiple parallel streams (e.g.
   stdout + stderr)? For now a single stream per message seems
   sufficient.* The §start-with-one-stream-extend-later
   discipline.

4. **Stream cancellation by recipient** — *Should the recipient
   be able to signal the sender to stop streaming (e.g. user
   clicks "Stop generating")?* The §cancel-from-the-other-side
   question.

The §honest-deferral discipline: the design *acknowledges* the
trade-offs without pre-committing. Phase 1 ships *without*
answers to these; subsequent phases can address each.

## The §design-by-author observation

Joshua T Corbin (jcorbin) authored this design — the first
*non-Kris-Kowal daemon design* ingested. The §Author field uses
the *(evoked)* attribution rather than *(prompted)* — Kris Kowal's
designs use *(prompted)*, indicating the bot-assisted-by-Kris
workflow; jcorbin's *(evoked)* indicates a different attribution
shape (evoked-by-jcorbin / bot-assisted).

The §design-from-2026-03-26 + §Phase-1-implementation-on-PR-#287
+ §bot-revision-on-2026-05-20 timeline shows the design-
implement-document-update cycle visible across many cycle 121-
130 designs.

## Related sections

- cycle 119
  [[endo-but-for-bots--llm-designs-daemon-capability-bus--daemon-as-message-router-with-envelope-protocol-and-handle-rewriting]]
  — the daemon-as-message-router envelope protocol that carries
  the CapTP frames the §Cross-peer considerations leverages.
- cycle 121 §Genie section
  [[endo-but-for-bots--llm-designs-endopi--genie-pi-inside-endo-and-the-four-architectural-contrasts]]
  — the Genie agent use case that motivates this design (Pi's
  LLM-token streaming meets the daemon mail system).
- cycle 103
  [[endo-but-for-bots--llm-designs-daemon-value-message--value-as-reply-primitive-for-ai-agent-form-request-flows]]
  — the value-message design that uses `replyTo` similarly; this
  cycle's `streamReply(messageNumber)` echoes the
  `sendValue(messageNumber, ...)` shape (both reply-to-a-prior-
  message patterns).
- cycle 130
  [[endo-but-for-bots--llm-designs-endopi-stdio-rpc-bridge--stdio-jsonl-rpc-as-short-term-bridge-before-endor-bus-tui]]
  — `stdio-rpc-bridge` defines `message_update` / `message_end`
  events at the *RPC* layer; this cycle defines `append` /
  `phase` / `end` / `abort` events at the *mail* layer. The
  two designs cover the same *streaming-tokens-from-LLM* concern
  at different layers.
