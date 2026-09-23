---
title: "Obtaining Elements from an InStream: the obtain/5 primitive and the input-operation taxonomy"
source_kind: web
source_url: http://erights.org/elib/concurrency/eio/obtaining.html
source_effective_url: https://erights.github.io/erights-org-website/elib/concurrency/eio/obtaining.html
source_fetched_via: mirror
source_content_sha256: 5ffca11a509780bc89cd7f5c1c8bcf0a9ca564ea28497fd1982cefa2cf128a46
source_authors: [Mark S. Miller, E. Dean Tribble]
source_date: 1998-10-03
ingested: 2026-06-28
ingested_by: scholar
topics: [e-language, eventual-send, streams]
status: current
notes: >
  Child chapter (Obtaining Elements from an InStream) of the EIO sub-hub
  (erights--elib-concurrency-eio-index), itself a child of the ELib Event Loop
  Concurrency hub (erights--elib-concurrency-index). The single `obtain/5` primitive
  and the 2*2*3*2 = 24-cell taxonomy of input operations it generates (reading /
  skipping / peeking / checking, crossed with NOW / WAIT / LATER scheduling and the
  atLeast..atMost element bounds), plus the convenience methods. The LATER scheduling
  mode returns a promise/vow — the direct ancestor of `@endo/stream`'s async-iterator
  pull. source_date is an era approximation matching the sibling concurrency chapters.
---

## Abstract

How a consumer **reads from an EIO InStream**. Though InStream has many methods, it
has only a few primitives; the one for obtaining elements is **`obtain(atLeast,
atMost, sched, proceed, report)`** (called `obtain/5`). Every other input method is
a convenient repackaging of it. The five parameters generate a **2\*2\*3\*2
taxonomy of 24 input operations** along four axes: **proceed** (ADVANCE vs QUERY),
**report** (ELEMENTS vs STATUS), **sched** (NOW vs WAIT vs LATER), and **atLeast**
(a quantity `0..ALL`, or `ALL`), with `atMost >= atLeast`. Crossing proceed and
report yields the four operation families — **reading** (advance + report elements),
**skipping** (advance, report only status), **peeking** (query + report elements),
and **checking** (query, report status). The `sched` axis is the non-blocking
hinge: **NOW** performs immediately or throws `UnavailableException`; **WAIT** may
block the vat and risk deadlock (used only when the source is known prompt);
**LATER** registers a claim and **returns a promise (vow) for the elements** to be
resolved when they become ready. LATER is the ancestor of `@endo/stream`'s
pull-based async-iterator read: the consumer asks for the next elements and gets a
promise, never blocking the agent's turn.

## The obtain/5 primitive

```
public Object obtain(int atLeast,
                     int atMost,
                     String sched,
                     String proceed,
                     String report)
    throws UnavailableException, IOException
```

Most other InStream methods are convenient repackagings of this primitive; the
primitive and all its packagings are collectively the **input operations**. Four of
the parameters (`atLeast`, `sched`, `proceed`, `report`) form a four-dimensional
2\*2\*3\*2 taxonomy.

## The proceed × report axes (the four operation families)

The main taxonomy is `proceed` × `report`, each with two values. (Miller notes he
first made these boolean but found `..,ADVANCE,STATUS)` far clearer than
`..,true,false)` in an argument list.)

- **proceed = ADVANCE** — advance the stream past the obtained elements, relieving
  backpressure and letting further elements flow downstream.
- **proceed = QUERY** — leave the stream unaffected so the elements can be
  re-obtained.
- **report = ELEMENTS** — report a list of the elements obtained (at end of stream,
  an empty list rather than null).
- **report = STATUS** — report the stream's termination status after these elements
  are obtained (the obtained elements themselves are ignored).

Crossing them gives the four families:

| | report = ELEMENTS | report = STATUS |
|---|---|---|
| **proceed = ADVANCE** | **reading** (report and consume elements) | **skipping** (consume without reporting) |
| **proceed = QUERY** | **peeking** (report next elements without consuming) | **checking** (what the termination status will be after N elements) |

(Miller notes "taking"/"take" would have been more suggestive than "reading"/"read",
but "read" is conventional.)

## The sched × atLeast axes

The remaining two dimensions are `sched` (three values) and `atLeast` (a quantity in
`0..ALL`, or exactly `ALL`), giving 3\*2 cells; showing the proceed×report 2\*2
table in each yields the full 24-operation taxonomy. Only a few cells are normally
used, and convenience methods are defined for them.

**`sched` — how the operation is scheduled:**

- **NOW** — performed immediately whether or not enough elements are ready. If a
  sufficient number cannot be obtained immediately, an `UnavailableException` (or
  other `IOException`) is thrown; on `UnavailableException` nothing was consumed and
  no side effects happened (on another `IOException` up to `atMost` may have been
  consumed).
- **WAIT** — *warning: may block the vat and cause deadlock.* If it can succeed
  immediately it does; otherwise, if the InStream supports waiting, the calling
  vat/runner/thread blocks until the operation can complete. The wrappers of
  `java.io` streams support waiting. Use only when the programmer knows the source is
  prompt though the underlying stream does not say so, or when this vat exists
  precisely to build one virtual device from a non-prompt stream (a
  one-expression-at-a-time parser over a character InStream).
- **LATER** — registers a claim for the next `atLeast..atMost` elements and
  **returns a promise for them**; when the elements become ready the claim is
  satisfied and the promise resolves.

**`atLeast` / `atMost` — how many elements are sufficient:** both may be `ALL`
(`Integer.MAX_VALUE`) or any non-negative quantity. When `atLeast` is `ALL`, a
sufficient number means *all* remaining elements until termination (and `atMost`
must also be `ALL`); when `atLeast` is a quantity, sufficient means at least that
many or all remaining, whichever comes first. `atMost` must be `>= atLeast` and a
sufficient number never exceeds it.

## Convenience methods (expansions of obtain/5)

| Convenience | Expansion | Meaning |
|---|---|---|
| `read(atLeast,atMost)` | `obtain(atLeast,atMost,NOW,ADVANCE,ELEMENTS)` | if enough are ready NOW, consume `atLeast..atMost` and return them; else complain and read nothing |
| `readReady(num)` | `read(0,num)` | read as many as are ready NOW, up to `num` |
| `readReady()` | `read(0,ALL)` | read as many as are ready NOW |
| `readOptOne()` | `switch (read(1,1)) { match [] { null } match [x] { x } }` | return the next element, or null if terminated (ambiguous for streams that may contain null); complain if not terminated and the next element is not ready |
| `readAll()` | `read(ALL,ALL)` | read ALL remaining elements NOW (all must be ready now) |
| `peek(num)` | `obtain(num,num,NOW,QUERY,ELEMENTS)` | obtain up to `num` elements NOW without advancing, and return them |
| `readLater(atLeast,atMost)` | `obtain(atLeast,atMost,LATER,ADVANCE,ELEMENTS)` | claim the next sufficient elements to be obtained LATER, advance past the claim, return a vow for the element list |
| `skip(num)` | `obtain(num,num,LATER,ADVANCE,STATUS)` | advance past the next `num` elements (or to termination), return a vow for the termination status |
| `readAllLater()` | `readLater(ALL,ALL)` | claim ALL remaining elements, return a vow for them; further input applies at termination |
| `becomesReady(num)` | `obtain(num,num,LATER,QUERY,STATUS)` | a QUERY returning a vow that resolves LATER when `num` (or all remaining) elements are ready, to the stream's expected termination status |

## Translation to Endo

| E (EIO obtaining) | Endo / Hardened JavaScript |
|---|---|
| `obtain/5` primitive | the single pull operation an async-iterator stream exposes, parameterized by mode |
| reading (ADVANCE + ELEMENTS) | `for await (const x of reader)` / `reader.next()` consuming an element |
| peeking (QUERY + ELEMENTS) | a non-consuming lookahead over a buffered reader |
| skipping (ADVANCE + STATUS) | draining elements without reading their values |
| checking (QUERY + STATUS) | inspecting whether/where the stream terminates |
| `sched = NOW` (throws if not ready) | a synchronous/non-awaiting read that fails when nothing is buffered |
| `sched = WAIT` (may block) | (no Endo analog by design — the agent turn never blocks) |
| `sched = LATER` (returns a vow) | `await reader.next()` — the pull returns a promise resolved in a later turn |
| vow for the next elements | the promise an async-iterator `next()` returns |

Source: [elib/concurrency/eio/obtaining.html](https://erights.github.io/erights-org-website/elib/concurrency/eio/obtaining.html) (canonical `http://erights.org/elib/concurrency/eio/obtaining.html`), content SHA-256 `5ffca11a509780bc89cd7f5c1c8bcf0a9ca564ea28497fd1982cefa2cf128a46`, fetched via the erights.org GitHub Pages mirror.
