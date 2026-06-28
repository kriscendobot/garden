---
title: "EIO Design Goals: Requirements and Preferences"
source_kind: web
source_url: http://erights.org/elib/concurrency/eio/goals.html
source_effective_url: https://erights.github.io/erights-org-website/elib/concurrency/eio/goals.html
source_fetched_via: mirror
source_content_sha256: b8492e10dce45a0bbb4c4c25bd56d85a7d7e80ef11b5cce46cb98f872bd90919
source_authors: [Mark S. Miller, E. Dean Tribble]
source_date: 1998-10-03
ingested: 2026-06-28
ingested_by: scholar
topics: [e-language, eventual-send, streams]
status: current
notes: >
  Child chapter (Design Goals) of the EIO sub-hub
  (erights--elib-concurrency-eio-index), itself a child of the ELib Event Loop
  Concurrency hub (erights--elib-concurrency-index). The requirements-and-preferences
  charter for EIO, E's non-blocking I/O library: the InStream/OutStream model, the
  fail-stop stream contract, and the composability goals (pipes, filters,
  backpressure). Direct ancestor of `@endo/stream`'s reader/writer async-iterator
  streams and the no-blocking-reads discipline. source_date is an era approximation
  matching the sibling concurrency chapters.
---

## Abstract

The **design goals** chapter for **EIO**, E's non-blocking I/O library — the
answer to "you mean I can't block on a read?" Because a vat turn runs to completion
and an object cannot stop executing even on I/O, blocking reads are impossible, so
EIO requests I/O by sending and delivers results by notification over a stream
abstraction. This chapter states EIO's requirements and preferences: the
**general requirements** (non-blocking even in the face of buggy E code; efficiently
implementable later over Java NIO; possible now over plain Java 1.3), the
**InStream / OutStream** model (a stream is an ongoing sequence of typed elements
with a terminator, flowing from a producer through an OutStream to an InStream and a
consumer), the **goals for EIO streams** (wraps and tames legacy `java.io` streams,
carries objects not just bytes/chars, fail-stop delivery), and the
**composability** goals (pipes, filters, opto-isolation via no-unchecked-preconditions,
failure and close propagation upstream and downstream, bounded-buffer backpressure
for flow control, flush pressure, and preserved immediacy). This is the direct
ancestor of `@endo/stream`'s async-iterator reader/writer streams, its
backpressure model, and Endo's no-blocking-reads discipline.

## General EIO requirements

- **Non-blocking.** Normal use of EIO must not cause a vat to block indefinitely on
  external I/O, or block at all on any non-prompt I/O, **even when the E code using
  EIO has bugs**. (Requiring that *malicious* use cannot block is pointless: a
  malicious entity can already wedge its hosting vat with an infinite loop.) When
  wrapping legacy libraries, this relies on those libraries reporting accurately
  what may proceed promptly (a wrapper over a Java `InputStream`/`Reader` is prompt
  only to the extent `available()`/`ready()` says what can be read now).
- **Efficient later.** EIO must be implementable over Java 1.4 NIO without
  introducing unnecessary threads.
- **Possible now.** EIO must be implementable in pure Java 1.3 (E itself requires
  only 1.3). This cannot be met *efficiently* now: a 1.3 implementation needs a
  separate thread to block on each separately blockable device with a posted I/O
  operation.

## The InStream / OutStream model

The center of any I/O library is the pair often called `InputStream` /
`OutputStream`; in EIO these are **InStream** and **OutStream** (jointly, **EIO
Streams**). EIO both defines the InStream/OutStream types (for itself and others to
implement) and provides built-in implementations. Conformance ("a conforming Foo
MUST ...") is conventional and not enforced; built-in primitive streams are required
to conform, and built-in layered streams must be **conformance-preserving** (if the
layers they build on conform, so do they; a wrapper over a conforming `java.io`
stream conforms).

The model: a **stream** is an ongoing sequence of elements of some type, some known
now and some expected to become known later. The stream may continue forever, close
successfully, or fail with a terminal problem (an `IOException` explaining the
failure). Whether it closes or fails it ends with a **terminator** (either `true`
for a clean close or a reference broken by the terminal problem) that sits
conceptually after the last element but is not itself an element. Elements enter
through an **OutStream** and exit through an **InStream**. When Alice writes a stream
Bob reads, Alice is **upstream** of Bob (and the OutStream is upstream of the
InStream); a client of an OutStream (Alice) is a **producer**, a client of an
InStream (Bob) is a **consumer**.

## Goals for EIO streams

- **Wraps legacy.** EIO Streams must wrap the common `java.io` byte and character
  stream classes well enough to replace them in the portable E API without loss.
- **Tames legacy.** The wrapping must eventually let legacy blocking operations be
  tamed out of existence from the E programmer's perspective, or at least made
  unnecessary for normal use.
- **Objects can play too.** Besides bytes and chars, the API must carry streams of
  any element type, bringing stream-oriented programming to objects. When the type
  is a scalar, a packed list-of-scalar representation should be used; within a vat,
  an object stream passes references to the objects themselves without
  serialization.
- **Simple model.** The stream model above is the kind of model required (simple,
  with a clear terminator).
- **Synchronous use is instantly familiar / asynchronous use is easily learned.**
  Synchronous reads/writes must be understandable to anyone who knows `java.io`'s
  `InputStream`/`Reader` and `OutputStream`/`Writer`; the asynchronous operations
  must be easily learned by someone who knows the synchronous ones and the basic E
  concurrency model.
- **Simple things simple, complex things possible.** The design is explicitly
  willing to accept APIs that cannot do some complex things, judged case by case.
- **Fail-stop.** The streams must be fail-stop: deliver elements reliably and in
  order until they close or fail; failure must be distinguishable from normal
  termination and must be permanent (a done stream stays done and releases its
  buffers).

## Composability

- **Pipes.** EIO must provide a pipe with an InStream facet and an OutStream facet;
  everything written to the OutStream facet is immediately available from the
  InStream facet.
- **Filters.** Streams must compose easily, Unix-shell style: a filter reads from an
  InStream and writes to an OutStream, and placing filters between pipes makes
  longer or transducing pipes. EIO must provide basic filters including an
  **inter-vat copying filter** (so pipes can span vats).
- **Pipes as "opto-isolators".** As in capability style, InStreams and OutStreams
  must have **no unchecked preconditions**: when Alice writes a pipe's OutStream and
  Bob reads its InStream, Alice sees good behavior even if Bob misbehaves, and Bob
  sees good behavior even if Alice misbehaves.
- **Failure propagation.** Pipes and filters may spontaneously fail (unless their
  contract forbids it) or be told to fail by a client; built-in ones must report
  failure both upstream and downstream, and a not-yet-done pipe/filter that receives
  a failure report must itself fail with and propagate the same terminal problem.
- **Close propagation.** Built-in pipes and filters must not spontaneously close (a
  close is an intentional client decision: Alice closing her OutStream tells Bob she
  is done writing; Bob closing his InStream tells Alice he is no longer interested).
  A middle party Carol closing or failing an InStream/OutStream in the chain revokes
  Alice's ability to talk to Bob, so built-ins must propagate closes both ways
  (failing rather than closing is recommended, so the terminal problem can explain
  the revocation).
- **Backpressure (flow control).** There must be built-in pipes/filters needing only
  bounded buffers; as those fill, they propagate **backpressure** upstream (stop
  draining upstream elements), up to the EIO client at the endpoint who can postpone
  production. Flow control cannot be masked and must be visible to application code.
- **Error control, not.** Unlike comm protocols, EIO does **not** require error
  control (retransmission): such errors can and (given fail-stop) must be masked at a
  lower level. Flow control is the part that must remain visible.
- **Flush pressure.** With an OutStream it must be possible to obligate the stream to
  eventually deliver all already-entered elements; built-ins honor this up to the
  limits of termination and backpressure.
- **Preserve immediacy.** Built-in legacy wrappers must expose all the immediate
  read/write power of the underlying stream (if 37 bytes are available underneath,
  37 bytes must be readable now), though immediacy may be limited by intermediaries
  and is entirely lost over an inter-vat pipe.

## Translation to Endo

| E (EIO design goals) | Endo / Hardened JavaScript |
|---|---|
| non-blocking I/O (no blocking reads) | async I/O surfaced as promises / async iterators; the agent turn never blocks |
| InStream / OutStream | `@endo/stream` reader / writer async-iterator streams |
| producer upstream of consumer | the writer end feeding the reader end of a stream |
| terminator (clean close vs broken) | async-iterator `return` (done) vs a thrown/rejected terminal error |
| fail-stop streams | a stream that delivers in order then permanently ends on close or error |
| pipe with two facets | a connected reader/writer pair (a stream pipe) |
| filter (read InStream, write OutStream) | an async-iterator transform between a reader and a writer |
| no unchecked preconditions ("opto-isolator") | each end is robust to the other end misbehaving (object-capability robustness) |
| bounded-buffer backpressure | async-iterator pull-based backpressure (`@endo/stream`) |
| inter-vat copying filter | a stream that bridges two agents / processes over CapTP |

Source: [elib/concurrency/eio/goals.html](https://erights.github.io/erights-org-website/elib/concurrency/eio/goals.html) (canonical `http://erights.org/elib/concurrency/eio/goals.html`), content SHA-256 `b8492e10dce45a0bbb4c4c25bd56d85a7d7e80ef11b5cce46cb98f872bd90919`, fetched via the erights.org GitHub Pages mirror.
