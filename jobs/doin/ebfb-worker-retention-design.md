---
tier: minion
model-burned: mentor
fallback-tier: 
dispatch: automatic
---
handler-timeout: 7200

# Design research brief: worker retention, revocation, and the batch-flush idea

**Repo:** `endojs/endo-but-for-bots` (roadmap branch `llm`)
**Project slug:** `endo-but-for-bots`
**Origin:** captured from a maintainer design conversation, 2026-08-16. Not tied to a PR or issue.

## Ask

Research the threads below (library-lookup on the named terms/prior art first) and produce a design document under `designs/` in the consuming project. The document should either propose a concrete direction, or — where the conversation left a genuine open question — lay out the alternatives with their trade-offs precisely enough for the maintainer to decide. This is exploratory; it is fine for the design to conclude "not yet, because X" on any individual thread, as long as the reasoning is explicit.

## Starting premise (the recorded stance under reassessment)

The daemon's current invariant: a value incarnated from a formula lives only as long as some name (a pet-store entry, or transitively reachable through other named formulas) keeps it reachable. Every daemon invocation sweeps everything not reachable by name, and the sweep is enforced as *actual* revocation, not just bookkeeping deletion — if a worker process still holds a live in-memory reference to a swept value, the sweep kills the worker, because otherwise deleting the formula record would be cosmetic (the worker could keep servicing calls on that capability regardless of what the daemon's graph says). This was originally defended as: (a) the only way to get real revocation given a second, uncontrolled source of liveness truth (the worker's own heap), and (b) something a transcript-replay persistence model can't give you at all, since replay resurrects whatever the history contains rather than tracking present reachability.

The conversation below reassesses this stance against several adjacent designs and proposes one specific extension (the batch-flush retention root) that the design should evaluate on its merits.

## Thread 1 — Kill-the-worker vs. surgical partition (ocap-kernel / SwingSet comparison)

ocap-kernel and SwingSet retain heap references across vats and get timely revocation by manipulating slot/c-list tables directly — dooming a promise, or partitioning a single presence (severing one importer's edge to an object while the exporter and other importers are unaffected). The problem: partitioning obligates every program holding *any* reference to defend against that specific reference going bad at any time, independent of whether its holder (the worker/vat) is otherwise alive and healthy. That is a materially different failure class from "my counterparty died" (ordinary partial failure, which every eventual-send already has to tolerate) — it's "my counterparty is fine but this one previously-working reference just stopped," which nothing in ordinary distributed-object programming prepares you for, and which in practice nobody defends against consistently.

The daemon's coarser choice — kill the whole worker rather than partition one presence — collapses the failure surface back down to ordinary partial failure, at the cost of collateral damage to whatever else that worker legitimately held. Working hypothesis from the conversation: this is the right trade, because it avoids a pervasive-defensiveness tax that isn't practical to actually uphold across a real program population. The design should confirm or challenge this with the actual literature/precedent (E's promise/partition semantics, SwingSet's c-list drop/retire protocol) rather than taking the conversation's framing on faith.

## Thread 2 — Ergonomic value-passing vs. hidden formula identifiers (Distributed Confinement)

Today, using a value as a dependency of a new formula requires first binding it to a pet name, even when the name is only needed transiently to satisfy the by-name construction API. It would be more ergonomic to pass the live value directly and let it stand for the formula identifier behind it (or a sturdy ref).

Hard constraint: guests must never see the daemon's cryptographic formula identifiers, per Distributed Confinement (Mark Miller, erights.org) — an identifier that could be observed/serialized by a guest is a channel for smuggling capability-equivalent information out of band, defeating the introduction discipline ocaps depend on.

Working hypothesis: these are not in conflict *if* the value→formula-ID resolution is done entirely on the daemon's trusted side (an identity-keyed map the daemon builds when it hands out a presence, never anything the guest's representation of the value can serialize or print). The design should determine whether Endo's current marshalling/presence machinery actually supports this cleanly — is there a stable object identity on the daemon side for a live presence that daemon-internal code can key off, across the eventual-send boundary — and should flag any code path where the naive implementation would leak the identifier.

## Thread 3 — Heap-pressure heterogeneity as an argument against local-GC-timing signals

A host's local garbage collector timing (heap size, generational behavior, when a major GC actually runs) is a property of that host, not of the object graph. Using local GC/`FinalizationRegistry` timing as a distributed liveness signal means the laziest collector in the network effectively sets retention policy for everyone downstream — a large-heap host can obligate a small-heap host to keep something alive it would otherwise have collected. This is the standard argument for explicit refcounted import/export protocols (SwingSet's `dropImports`/`retireExports`) over local-GC-driven distributed GC, and it's the same underlying reason the daemon's sweep-by-name-reachability (deterministic, host-independent) is preferable to any scheme keyed on when a particular process's GC happens to run. `FinalizationRegistry` at most belongs as a local optimization *hint* to send a release message promptly, never as the authoritative signal. The design should state this principle explicitly and check every proposed mechanism (including Thread 5's batch-flush idea) against it: is the liveness signal a protocol-level fact, or a local-timing artifact wearing a protocol-level costume?

## Thread 4 — Mathieu Hofman's no-orthogonal-persistence worker model

A worker discipline that retains no heap or stack between message deliveries; all durable state must be explicitly captured into durable storage between deliveries (no reliance on orthogonal persistence for anything meant to survive). Zygotic snapshots remain usable, but only as a cold-start/performance optimization at an arbitrary checkpoint, not as the definition of durable truth. Motivation cited: on-chain vat upgrade needs new code to operate over old durable state without depending on heap/bytecode-layout compatibility across code versions, which orthogonal persistence (heap snapshot as ground truth) does not give you.

Points raised in conversation, to be verified/extended by the design:

- This is the *same* defend-pervasively-vs-fail-cleanly axis as Thread 1, recurring one layer down (within-worker instead of across-worker). Missing durable state fails immediately and reproducibly at the point of omission; insufficient partition-defense fails intermittently, dependent on timing/load, and can stay latent a long time. That's presented as an argument *for* the coherence of this direction relative to the daemon's existing kill-on-sweep choice, not a competing philosophy — the design should check whether this framing actually holds up, or whether there are failure modes in the no-orthogonal-persistence model that are just as silent (e.g., a durable write that's present but subtly wrong/stale, vs. a durable write that's simply missing).
- **Worker-type-as-constraint.** Proposal: rather than settling on one persistence discipline daemon-wide, let a worker's persistence/upgrade discipline be a constraint expressed at request time (what upgrade/continuity guarantee does this workload actually need), analogous to SwingSet already shipping more than one vat manager. The design should work out what the constraint vocabulary looks like and where it's expressed (a formula field? a worker-request argument?).
- **Durable promises are the sharp edge.** A promise's pending continuation is a closure over arbitrary reachable state plus a position in the engine's own microtask machinery — there is no obvious durable-data representation for "resume this `.then` chain" without either restricting what a continuation may close over (an explicit continuation-passing vocabulary) or accepting that unsettled promises are simply lost across a checkpoint (today's on-chain vat-upgrade status quo). The design should treat this as likely *not* fully solvable in general, and instead scope what a durable pending-promise is allowed to represent, being explicit that this relocates rather than removes the defensiveness tax (now: "handle your promise not surviving upgrade," same shape as Thread 1's partition-defense tax).

## Thread 5 — The batch-flush retention root (the most concrete proposal — priority thread)

Proposal: when a batch of pipelined messages between two peers is in flight (embargoed — held pending resolution before further delivery, as in three-party-handoff-style promise pipelining), the daemon could treat the batch's existence as a temporary GC root. Anonymous, unnamed intermediate formulas minted to shepherd values through that pipeline stay alive for exactly the batch's lifetime and become collectible the moment the batch fully flushes (delivered and settled, no outstanding continuations), unless something durable claimed a name for one of them along the way.

This is presented as resolving the Thread 2 mechanism cleanly: it gives "implicit unnamed formula" a real, protocol-defined interval to exist in — long enough to be useful as sugar for value-passing, short enough not to require eager naming — and its liveness clock is a fact about message delivery (protocol-visible, deterministic, host-independent), which is exactly the property Thread 3 says a good liveness signal needs to have.

Open questions the design must resolve or explicitly defer, in priority order:

1. **What exactly delimits "the batch."** Pipelining can fan out or chain arbitrarily (a reply triggers further pipelined sends, possibly introducing a third party). Too narrow a scope risks collecting something a later hop of the same logical operation still needs; too broad (the full causal cone of a top-level request) risks a root that never closes under sustained or recursive traffic.
2. **The stuck-batch / non-flushing case.** A peer that disappears mid-pipeline, or a message that's permanently embargoed, leaves the root open indefinitely absent an explicit abort/timeout — reintroducing, at the batch layer, exactly the unbounded-retention hazard the kill-the-worker policy exists to foreclose at the worker layer. This is also a resource-exhaustion vector: a counterparty could force retention by keeping a pipeline artificially open. The design needs a concrete answer here, not a hand-wave.
3. **Two-party vs. multi-party scope.** The cases motivating this (a live value standing in for a formula dependency) plausibly arise as often from three-party introductions as direct exchanges, and embargo semantics are already the hardest part of three-party handoff. A root scoped to a single peer pair may not cover the motivating cases.
4. **Portability across CapTP implementations, and whether it motivates an OCapN change.** The load-bearing question: is "batch flushed" *locally derivable* by each peer from resolve/settle traffic that already exists on the wire (in which case this is purely an implementation detail inside one daemon's bookkeeping, and needs nothing from OCapN), or does it require an explicit new boundary signal ("nothing further is forthcoming on this pipeline") that isn't recoverable from existing messages (in which case it is a genuine protocol addition)? Also worth checking: is this better understood as a specialization of the refcounted import/export drop protocol SwingSet's kernel already runs at the c-list level, rather than a new primitive — i.e., should the move be to generalize an existing mechanism rather than invent an embargo-specific one? If it's Endo-formula-specific machinery, it likely should *not* go into OCapN itself (which aims to stay a minimal, general interop layer across CapTP implementations that may have no notion of "formulas" at all, or may already have an equivalent).

## What the design document should contain

- A recommendation (or explicit non-recommendation with reasons) on whether the batch-flush retention root is worth building, addressing the four numbered questions in Thread 5 concretely.
- A position on worker-type-as-constraint (Thread 4): is this the right shape for letting different workloads pick different persistence disciplines, and if so, roughly where does the constraint live in the formula/worker-request surface?
- Explicit treatment of the Distributed Confinement constraint from Thread 2 wherever the design touches value-passing ergonomics — no path in the proposed design may make a formula identifier guest-observable.
- Citations to prior art: E's promise/partition semantics, SwingSet's c-list and refcounted drop/retire protocol, any existing OCapN spec language on resolve/settle and message ordering, and Mark Miller's Distributed Confinement material (erights.org) grounding the guest-visibility constraint.
- Open questions section for anything the design surfaces but can't resolve — this is a reassessment of a stated principled stance, not a mandate to force a conclusion.

<!-- garden-reaped: 0 -->

---
claim:
  host: endolin-garden2-5bcdff64
  gardener: 2
  worker_kind: gardener
  tier: 
  provider: anthropic
  model: 
  claimed_at: 2026-08-16T07:33:22Z
