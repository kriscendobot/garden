---
ts: 2026-06-03T03:19:44Z
host: endolin
role: liaison
kind: result
dispatch_id: liaison--16ebf2
cycle: 137
---

# Cycle 137 — daemon-message-streaming.md (Joshua T Corbin, endo-but-for-bots) — first non-Kris daemon design

Ingested `designs/daemon-message-streaming.md` (216 lines, *In
Progress* status, PR #287 open) from
`endojs/endo-but-for-bots@81a22f00` (branch `origin/llm`).
**Thirtieth-comment-style design ingest** + **first non-Kris-
Kowal daemon design ingest** (author Joshua T Corbin / jcorbin
with *(evoked)* attribution vs Kris's *(prompted)*). One
cohesion-honest section:

- **streamReply-and-streamSend-with-stream-formula-and-CapTP-
  rides-method-calls** — adds *progressive-text-delivery* to
  the daemon's mail system motivated by Genie's LLM-token
  streaming needs. §StreamWriter (append/setPhase/end/abort) +
  §StreamReader async iterable of StreamEvent objects + new
  `stream` formula type (promise-kit-backed async iterator).

## The single most structurally interesting move

The §cross-peer-streams-ride-CapTP observation:

> *For messages that cross CapTP peer boundaries, the stream
> events travel over the existing CapTP channel as method calls
> on the stream formula's far reference. No new transport
> primitive is needed — the existing promise pipelining and
> method dispatch handle it.*

The §re-use-existing-substrate discipline: cycle 119's envelope
protocol already carries CapTP frames; promise pipelining
handles `append`/`setPhase`/`end`/`abort` calls without per-
chunk round-trips. *CapTP method dispatch is already a
streaming transport*.

## §First non-Kris-Kowal daemon design ingest

Author: Joshua T Corbin (jcorbin) — *(evoked)* attribution
shape (vs Kris's *(prompted)*).

## §Persistence model

- In-memory during streaming (buffer authoritative)
- On end(): assembled text persisted to durable record (survives
  daemon restart)
- On abort(): partial text + abort reason persisted

The §static-message-eventually invariant: finalised streams are
*indistinguishable from non-streaming messages*.

## §Four open questions deferred (honest-deferral discipline)

- **Chunk granularity** — debounce-as-perceived-latency-trade-off
- **Back-pressure** — promise vs fire-and-forget
- **Multiple streams per message** — start-with-one-extend-later
- **Stream cancellation by recipient** — cancel-from-the-other-
  side

## Rotation note

Cycle 137 was nominally **papers-lane** (cycle 136 was
comments). Papers-lane has been blocked for **31+ consecutive
cycles**. Cycle 137 pivoted to designs-lane. **Third daemon-*
design after endopi-* family closure** (cycles 133's
guest-eval-simplification + 135's locator-reference + this
cycle's message-streaming).

## Counts

- 640 → **641** sections (+1).
- 181 → **182** source documents (+1).
- Topic pages updated: `daemon.md` (+1 row), `captp.md` (+1 row
  — the *streaming-rides-CapTP* observation belongs here too).
- Keywords index extended with ~29 message-streaming-specific
  keywords.
- Sources/README.md updated (+1 row).
- Sections/README.md updated (+1 group; total adjusted).

## Next cycle

Cycle 138 wakes in 1500s. Rotation lands on **chat-lane**
nominally (exhausted at 20/20). Expect another pivot. The
daemon-* family still has 21+ unexplored designs.
