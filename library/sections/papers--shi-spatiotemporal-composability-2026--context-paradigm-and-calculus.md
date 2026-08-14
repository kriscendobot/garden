---
title: The unified context paradigm and the calculus of dynamic composition
source: "A Programming Paradigm for Spatiotemporal Composability"
source_kind: paper
source_authors: [Yifan Shi, Wei Zhang, Tianyi Cui]
source_year: 2026
source_venue: "Preprint (cordiverse/paper on GitHub)"
source_url: https://github.com/cordiverse/paper/blob/main/paper.pdf
source_pdf_sha256: 4d48478dc0b6222d9f74d7db10ee776449b1209eb112632336544d32a49db97f
ingested: 2026-08-14
ingested_by: scholar
topics: [dynamic-composition, effect-and-coeffect-systems]
status: current
---

Abstract: This derived digest, not the original paper, captures how the two local mechanisms are unified into a single *context type* and then lifted from one component to a whole running system. The unification: an *observational equivalence* on the coeffects supplies the effects with the independence property, so effect-tracking and coeffect-resolution operate on one context. The calculus: a *component* instantiated as a *fiber* has a lifecycle (Inactive → Reloading → Active → Unloading) with an operational semantics; the *withdrawal guard* orders a provider's teardown after its dependents' deactivations; and the metatheory (preservation, temporal and spatial composability, progress, confluence) carries the local guarantees to a whole trace of interleaved components.

**Unified context and observational equivalence (§3.3).** The effect context (`∂Γ`, carrying an accumulator of inverses) and the coeffect context (`Σ`, a dependency table) are combined into one *context type*. Values at a coeffect key are compared only *up to* a key-supplied equivalence relation `≃` (a coeffect is a triple `(𝒱_k, ≃_k, 𝒜_k)` — value type, equivalence, and the operations the binding provides). This observational equivalence is what makes the independence condition of §3.1.3 attainable in practice: two effects need only commute *up to* observational equivalence, not on the nose. The unified context carrying both effects and coeffects is the *programming paradigm* the title names.

**Components and fibers (§4.1).** A component declares a coeffect specification `d` (what it injects), a provide set `p` (what it offers), and an effect `e` (what it does on activation). Instantiating a component on a context yields a *fiber* — the runtime instance — with a parent fiber, a derived child context it runs in, a lifecycle state, an accumulator (`dispose`), and a *committed view* `ω` (which provider each declared key currently resolves to).

**Lifecycle with transitions in progress (§4.3).** Beyond the two-state (Inactive/Active) base calculus, real transitions are not instantaneous, so two intermediate states are added: `Reloading` (activating: iterating the effect, accumulating inverses) and `Unloading` (deactivating: about to apply the accumulator). Edges: `L-Begin`/`L-Iter`/`L-Finish` drive activation; `L-Leave` records a decision to deactivate (stops the fiber providing its coeffects while leaving committed views intact); `L-Unload` applies the accumulator, discards the committed view, and returns the fiber Inactive — the *only* rule that applies an accumulator.

**The withdrawal guard (§4.3.1).** Deactivation ordering is the substantive half of spatial composability: a component being torn down because its provider is going away may still need the very coeffect being withdrawn (closing a connection pool means handing connections *back* to whatever provided them). `L-Unload` carries the premise `¬relied_n(γ)` — the *guard* — which holds a provider's withdrawal of key `k` back until every consumer that resolved `k` to it has gone. The guard does not deadlock: once `L-Leave` marks a fiber Unloading its table leaves the active union, so no target view can name it any longer and every consumer that committed to it is itself on the way out (Theorem 66: the guard always releases).

**Other in-progress concerns (§4.3.2–4.3.4).** *Iteration*: an activation may run multiple effects in sequence, modeled by an *effect iterator*, and deactivation recovers them in LIFO order. *Asynchrony*: an in-flight transition carries *inertia* (a future handle) so asynchronous teardown runs to completion before further change is acted on. *Failure*: a failed activation records an error outcome (`Inactive(ξ)`), with its target set to inactive.

**Metatheory (§4.4).** The calculus proves *preservation* (well-typed states step to well-typed states / the soundness invariant is maintained), *temporal composability* (a whole system's trace recovers its starting context — the global lift of Theorem 16 via independence), *spatial composability* (the withdrawal ordering holds system-wide — no consumer reads a withdrawn binding, Theorem 63), *progress* (a non-quiescent well-typed state can always step), and *confluence* (orchestration actions arriving one at a time reach the same quiescent state regardless of interleaving). Together these license *reasoning about a Cordis application as though it were static*, even though components arrive and depart at runtime.

Source: [paper.pdf](https://github.com/cordiverse/paper/blob/main/paper.pdf) §3.3–§4 (cordiverse/paper), content SHA-256 `4d48478d…`.
