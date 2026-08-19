---
gate: deferred
priority: low
role: designer
posted_by: producer
posted_at: 2026-08-19T17:47:08Z
---

---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Explore: promise resolution chain shortening in Ironhorse

Repository: endojs/endo-but-for-bots, branch `llm`. Exploratory design —
survey feasibility and tradeoffs; do not commit to implementation.

## What this is

When a promise is resolved with another thenable/promise, and that one is
resolved with yet another, naive implementations build an ever-growing
internal chain of reaction jobs to walk before the final value settles —
real engines (V8's "fast async" work is the well-known precedent) implement
**chain shortening**: collapsing/flattening these resolution chains so
settling doesn't cost O(chain length) work or risk unbounded internal state
growth on a long or cyclic-looking chain. This matters doubly for Ironhorse
given the metering doctrine (`designs/ironhorse-engine.md` — every
observable step should cost a deterministic, bounded computron amount; an
unshortened chain risks either a metering blind spot or a pathological
worst case) and for Endo's own CapTP/eventual-send usage, where **promise
pipelining routinely chains resolutions across vats** — exactly the shape
this optimization targets, not just a synthetic worst case.

## Read first

- `designs/ironhorse-engine.md` § Metering — the determinism/accuracy
  doctrine any promise-resolution accounting must fit inside.
- The two promise/rejection designs already in flight from this same
  session — read both, this exploration should be consistent with them,
  not sibling-blind:
  - `design-ironhorse-panic` (uncatchable termination, message-embargo,
    snapshot/transcript-replay retry).
  - `design-ironhorse-rejection-handling` (why panic-on-reference-error
    matters, unhandled/unwatched rejection semantics, CapTP promise-handoff
    to third parties, the debugger's pending-promise/unhandled-rejection
    visualization panels).
  Chain shortening is adjacent to both: a long resolution chain is exactly
  the kind of thing the debugger's "pending promises attributed to
  creation line/column" panel needs to represent sensibly (a shortened
  chain is one entry, not N), and chain-shortening bugs are themselves a
  plausible source of the "reference error panics with heap frozen at the
  fault site" scenario the panic design targets.
- Note from earlier research this session:
  `ironhorse-debugger-recovery-and-uncaught.md` records that "Ironhorse's
  promise-reaction throw path is not implemented yet (self-named
  `Halt::Unsupported("promise:handler-throw")")" — confirm current status
  before assuming the promise implementation is further along than it is.

## What the exploration should cover

- **Current state**: how far Ironhorse's promise implementation actually
  is today (survey the VM source directly, don't assume from designs) —
  whether naive chains are even reachable yet, or this is groundwork ahead
  of promise-reaction-throw landing.
- **The actual mechanism**: what "shortening" looks like against
  Ironhorse's arena/index-based heap model specifically (not just cite
  V8's approach abstractly) — how a chain gets detected and collapsed, and
  what the metering cost of the collapse operation itself should be.
- **CapTP interaction**: does cross-vat promise pipelining change what
  "the chain" even means (a chain that crosses a vat boundary can't be
  collapsed purely locally) — flag this explicitly rather than silently
  scoping to single-vat chains.
- **Test coverage**: how to construct a test that actually exercises deep
  chains (a synthetic worst-case generator, or real CapTP pipelining
  fixtures) and what a passing bar looks like under the metering doctrine.
- **Recommendation**: worth building now, worth building once
  promise-reaction-throw lands, or not a real problem at Ironhorse's
  current scale — with reasoning.

## Deliverable

A design document (or a shorter written finding if the survey concludes
it's premature). No code. Deliberately parked/deferred — no urgency,
promote when there's room.
