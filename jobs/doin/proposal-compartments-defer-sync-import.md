---
tier: mentor
fallback-tier: minion
dispatch: automatic
---
Record a maintainer design decision and plan the follow-on proposal work.

DECISION (kriskowal, 2026-08-17, in a liaison session), on the open charter item
"Both TLA and non-TLA evaluation paths" in
`journal/projects/proposal-compartments/README.md`, whose recorded shortfall was:
"spec `d23d7de`: `Compartment.prototype.import` is deliberately asynchronous; no
synchronous evaluation entry point is included. Maintainer decision requested on a
host-only synchronous evaluation operation."

Verbatim decision:

    Defer synchronous import. That will likely take the shape of
    compartment.importNow and import.now (syntax). We should plan to create a
    separate proposal based on the compartment core proposal, or a pair of
    proposals that introduce synchronous import and then later reconcile with
    compartment synchronous import.

Tasks:
1. Update the charter item to record the decision: synchronous evaluation is
   DEFERRED out of the minimal Compartments surface, with the anticipated future
   shape being `compartment.importNow` (method) and `import.now` (syntax). The
   item stops being an open question awaiting a maintainer and becomes a recorded
   deferral with a named successor.
2. Confirm the spec at `spec.emu` needs no change for this (the decision affirms
   the current state, in which `Compartment.prototype.import` is asynchronous and
   no synchronous entry point exists). If it DOES imply an editorial change, make
   the smallest one and say why.
3. Draft the follow-on proposal plan the decision calls for, and present the
   choice rather than silently picking: EITHER one separate proposal built on the
   compartment core proposal, OR a pair, one introducing synchronous import
   generally and a later one reconciling it with compartment synchronous import.
   Give the tradeoff between the two shapes (staging, committee sequencing,
   whether synchronous import is independently motivated outside Compartments).
   This is a design deliverable, not a decision to make alone.

DO NOT touch the other open charter item ("Error separation" / synchronous
infrastructure errors). It is still under discussion with the maintainer and its
meaning was actively being clarified when this job was posted.

Standing constraint worth recording somewhere durable, from the same maintainer
message: dynamic loader registration is considered UNSOUND, because there is a
race between registration and loading that may corrupt cache keys already
permanently committed. This does not bear on the deferral above, but it is a real
constraint on any future design that proposes registering loaders dynamically.
Record it where a future designer will find it.

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 2
  worker_kind: gardener
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-08-17T04:34:29Z
