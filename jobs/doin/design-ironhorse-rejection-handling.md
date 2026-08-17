---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Discuss: why panic-on-reference-error matters, and how it interacts with unhandled/unwatched rejection handling

Repository: endojs/endo-but-for-bots. Target the roadmap branch `llm` (draft
PR against `llm`), sibling to and cross-linked with `design-ironhorse-panic`
(the panic-mechanism design this job's basename follows up on — read that
job's resulting design, or if not yet landed, its board entry/branch, for the
Coda it proposes: an Ironhorse option under which a reference error panics
instead of throwing, so a heap snapshot can be taken with the program counter
still at the fault site).

## Read first

- `design-ironhorse-panic`'s design document (see above).
- [`designs/ironhorse-debugger-recovery-and-uncaught.md`](../designs/ironhorse-debugger-recovery-and-uncaught.md)
  § "Ironhorse Decisions Informed by the XS Oracle", item 3: promise
  rejection tracking is explicitly out of scope for throw-time uncaught
  classification and is a separate mechanism (XS's weak list checked at
  drain/exit, `fxAddUnhandledRejection`/`fxCheckUnhandledRejections`).
- library-lookup on CapTP/promise-pipelining and eventual-send semantics
  before writing the CapTP section below, so this document uses the same
  vocabulary the library already establishes rather than inventing parallel
  terms.

## What to write

This is a rationale/analysis document, not an implementation spec. It should
end in a clear recommendation, written for a future design or build job to
act on — not just a survey.

### 1. Why panic-on-reference-error matters

Argue the case directly: unwinding through `catch` (or a promise rejection
handler) before anyone inspects the failure destroys the most useful
evidence — the exact program counter and heap state at the moment of fault.
A normal catchable `ReferenceError` lets code (deliberately or accidentally)
continue past the bug, potentially minutes or messages later, by which time
the heap has moved on. Panicking on the reference error instead freezes the
world at the fault site for a snapshot, even when a `catch` or rejection
handler exists and *would* otherwise have intercepted it. Contrast this with
`Halt::StackOverflow`/`Halt::MeterAbort`, which already get this property for
free because those two conditions are already non-recoverable by
construction — a reference error is the odd one out today, ordinarily
recoverable, and the option under discussion is what lets it be treated the
same way, on demand, for diagnosis.

### 2. Interaction with other approaches to unhandled and unwatched rejection

Lay out the landscape and where panic-on-reference-error fits in it:

- **A promise can always be handled later.** Every promise, whether it is
  *currently* rejected (or will *eventually* reject), can still be validly
  handled by a `.then`/`.catch` subscribed after the fact. "Not yet handled"
  is not "will never be handled" — any policy that treats the two as
  equivalent is making a timing guess, not observing a fact.
- **This is especially sharp over CapTP.** A promise handed off to a third
  party (returned from an eventual-send, passed as an argument, resolved
  into another vat's reference graph) is frequently never expected to be
  observed *locally* at all — the whole point of the handoff is that
  someone else now owns the obligation to handle it. A local "nobody
  subscribed yet" heuristic cannot see across that boundary and has no way
  to know the promise was legitimately handed off rather than dropped.
- **Node.js's unhandled-rejection escalation is exactly this heuristic**,
  and gets both cases wrong: it can crash a process over a rejection that
  is `await`ed or `.catch`ed slightly later, and it has no concept at all of
  "handed off to a peer, not ours to observe." State plainly that this is
  bad practice as a general default.
- **But it is defensible in the absence of panic-on-reference-error (and
  stack-overflow/allocation-failure panics).** Without a precise mechanism
  that catches a real class of bugs (reference errors, exhaustion) at their
  exact source, an unhandled-rejection timeout heuristic is the only
  available tool for surfacing *some* class of silently-dropped failures —
  a blunt instrument used because nothing sharper exists. Once
  panic-on-reference-error (and the existing stack-overflow/meter-abort
  panics) can catch that class of bug precisely, the coarse heuristic is no
  longer pulling its weight for that purpose and its false-positive cost
  (killing processes over legitimately-deferred or legitimately-handed-off
  promises) stops being worth paying.
- **Recommendation: Endo/Ironhorse should not adopt Node's
  escalate-on-unobserved-rejection behavior**, and should treat this as a
  concrete goal to move toward once the panic mechanism lands, rather than
  carrying Node's heuristic forward by default. Be explicit about what
  Ironhorse should do instead for genuinely-abandoned rejections (if
  anything) versus what it should simply stop flagging.

### Debugger note

Close with a note (for the Ironhorse worker debugger's web UI, alongside the
`ironhorse-debugger-recovery-and-uncaught.md` work) that it should carry
**reactive visualization panels** for:

- **Pending promises**, attributed to the line and column where each was
  created — a "where did this promise come from" view.
- **As-yet-unhandled ("unwatched") rejections**, live, until each is handled
  — a rejection that later gets a handler attached should visibly leave this
  panel rather than staying flagged, which is exactly the "can still be
  handled later" property § 2 argues Node's heuristic ignores. Making this
  state visible and live is the debugger-side answer to the same problem the
  reference-error panic option answers for engine-raised errors: give the
  developer precise, timely information instead of a coarse timeout guess.

## Deliverable

A design document per the designer role's usual shape, cross-linked with
`design-ironhorse-panic`'s document (update its Dependencies/related-designs
table if that document has already landed and is still open; otherwise leave
a note for whoever lands it later to add the cross-link). Where a concrete
mechanism (a rejection tracker, the visualization panels' data plumbing)
needs its own follow-on design or build job, name it explicitly in Open
Questions rather than leaving it implicit.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 1
  worker_kind: gardener
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-08-17T06:06:01Z
