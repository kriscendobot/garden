---
title: "Distributed Queuing: the L-shaped stack-plus-queue and the eventually operator"
source_kind: web
source_url: http://erights.org/elib/concurrency/queuing.html
source_effective_url: https://erights.github.io/erights-org-website/elib/concurrency/queuing.html
source_fetched_via: mirror
source_content_sha256: 6eda18a04216a130d8dafaf5befe4fc0db7f95db36b103e65dde02c0087d74ab
source_authors: [Mark S. Miller]
source_date: 1998-10-03
ingested: 2026-06-28
ingested_by: scholar
topics: [e-language, eventual-send]
status: current
notes: >
  Reference-level child chapter of the ELib Event Loop Concurrency hub
  (erights--elib-concurrency-index). The mechanics of communicating event loops:
  each vat holds an L-shaped data structure (a LIFO stack of green call frames
  plus a FIFO queue of purple pending deliveries); immediate call `.` pushes a
  frame, eventual send `<-` enqueues a delivery on the receiver's vat. The
  FIFO-queue picture is a deliberate over-specification (E specifies only partial
  order). source_date is an era approximation matching the sibling concurrency
  chapters.
---

## Abstract

The chapter that draws the concrete data structure behind communicating event
loops. Returning to the human world: scheduling time uses two patterns. "Blocked
on subtask Y, set X aside, finish Y, resume X" is **synchronous call-return** ("do
it immediately"). "Realize I need to do Y but not now, jot it on a to-do list,
continue" is **asynchronous eventual send** ("do it eventually"), written like a
call but with `<-` (the **eventually operator**) instead of `.`. Each vat holds an
**L-shaped** structure: a vertical LIFO **stack** of green call frames and a
horizontal FIFO **queue** of purple pending deliveries (the event queue). An
immediate call `.` (only valid on a NEAR intra-vat reference) pushes a green frame
onto the calling vat's stack; an eventual send `<-` enqueues a purple block onto
the back of the event queue of the vat hosting the receiver. The FIFO full-order
shown is a simplified over-specification: E specifies only **partial order on
references**, so correct E programs must not rely on stronger ordering. This is the
operational ancestor of the JavaScript call stack plus microtask queue that
`@endo/eventual-send` builds on.

## Two scheduling patterns

As I schedule my time, I mainly use two patterns:

- If in performing task X I find I am blocked on subtask Y, I put X aside, work on
  Y until done, then continue X. This is **synchronous, do-it-immediately,
  call-return** scheduling.
- If, while performing X, I realize another task Y I need to perform but not now,
  I jot a note on a to-do list and continue with my present task. This is
  **asynchronous, do-it-eventually** scheduling, supported by the **eventual
  send**. A send is written like a synchronous call but with a `<-`, the
  **eventually operator**, rather than a `.`, between recipient and message: a
  record that this message must be delivered to this recipient is duly noted, but
  the original turn continues unaffected.

## The L-shaped data structure

Each vat has an L-shaped data structure recording what remaining computation still
needs doing:

- The **green blocks** are stack frames; the vertical tower of green blocks is the
  **stack**. As is traditional, the stack is drawn upside-down, top-of-stack at the
  bottom.
- The **purple blocks** are **pending deliveries** (a record of the need to deliver
  a given message to a given receiver); the horizontal row of purple blocks is the
  **pending-delivery queue**, the event queue.

Computation in each vat proceeds only at its current top-of-stack.

- An **immediate call** (`.`) pushes a new green block to the top of stack. Since
  `.` can only be performed on a NEAR (intra-vat) reference, the green block is
  added to the calling vat's stack.
- An **eventual send** (`<-`) enqueues a new purple block to the back of the event
  queue of the vat hosting the receiver.

Worked example: Alice is executing in VatA (VatA's top-of-stack points at her as
receiver). In step (1) Alice executes `bob <- foo(carol)`. In step (2), a record of
the need to deliver `foo(carol)` to Bob is enqueued on VatB's queue, since Bob
resides in VatB. Unshown step (3): computation in VatB advances until this record
reaches the front of the queue, whereupon it becomes the initial stack frame of a
new stack and Bob actually receives the message. (How return values come back is
covered in Message Passing.)

## Partial order, not FIFO

While the vertical stack really is as fully ordered as the LIFO order shown, **the
FIFO full-order of the horizontal queue is a simplified over-specification.** E
specifies only **partial order on references**. A FIFO queue does satisfy that
specification, and the current E implementation uses it, but correct E programs
must not rely on any stronger ordering than the partial order specified.

## Why this matters for Endo

This is the picture under JavaScript's own runtime. The green LIFO stack is the
synchronous call stack; the purple FIFO queue is the microtask / job queue. An
ordinary `.` call pushes a stack frame; `E(target).method(args)` (the descendant of
`<-`) enqueues a job onto the queue serving the target's agent, and that job becomes
a fresh stack only when it reaches the front. "Computation proceeds only at the
current top-of-stack, one delivery at a time" is the run-to-completion guarantee
Endo relies on. The partial-order caveat is the ancestor of the discipline that an
Endo program must not assume cross-agent message arrival order beyond what causal
order guarantees, the same property OCapN preserves rather than tightening to a
global FIFO.

## Translation (E to Endo)

| E concurrency term | Endo / Hardened JavaScript equivalent |
|---|---|
| immediate call (`.`) | a synchronous method call (pushes a stack frame) |
| eventual send (`<-`) | `E(target).method(args)` (enqueues a job) |
| green stack frame | a JavaScript call-stack frame |
| purple pending delivery | a queued job / microtask |
| event queue (per vat) | the per-agent job / microtask queue |
| partial order on references | causal message order; no assumed global FIFO |

## Cross-references

- Parent hub: [erights--elib-concurrency-index--event-loop-reference-map](erights--elib-concurrency-index--event-loop-reference-map.md).
- The vat that owns this L-shaped structure: [erights--elib-concurrency-vat--the-vat-heap-thread-queue](erights--elib-concurrency-vat--the-vat-heap-thread-queue.md).
- The partial-order specification gets its own chapter (`partial-order.html`),
  queued for ingest in scholar-ingest-erights-9.
- Formalized in the [Concurrency Among Strangers](papers--miller-tribble-shapiro-concurrency-among-strangers-2005--vat-and-event-loop-model.md) paper section.

## Source

Source: [elib/concurrency/queuing.html](https://erights.github.io/erights-org-website/elib/concurrency/queuing.html) (mirror of `http://erights.org/elib/concurrency/queuing.html`), last modified 1998-10-03 (era approximation), content SHA-256 `6eda18a04216a130d8dafaf5befe4fc0db7f95db36b103e65dde02c0087d74ab`, fetched via the erights.org GitHub Pages mirror.
