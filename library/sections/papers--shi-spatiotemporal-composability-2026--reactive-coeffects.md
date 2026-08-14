---
title: Reactive coeffects, notification, isolation, and interception
source: "A Programming Paradigm for Spatiotemporal Composability"
source_kind: paper
source_authors: [Yifan Shi, Wei Zhang, Tianyi Cui]
source_year: 2026
source_venue: "Preprint (cordiverse/paper on GitHub)"
source_url: https://github.com/cordiverse/paper/blob/main/paper.pdf
source_pdf_sha256: 4d48478dc0b6222d9f74d7db10ee776449b1209eb112632336544d32a49db97f
ingested: 2026-08-14
ingested_by: scholar
topics: [effect-and-coeffect-systems, change-propagation]
status: current
---

Abstract: This derived digest, not the original paper, captures the spatial-composability mechanism: model a component's dependencies as a *coeffect specification* — a set of keys it requires from a shared dependency table — and classify every change to that table, against the specification, as *activating*, *deactivating*, or *neutral*. A component activates only once all declared dependencies are present (so it never reads an absent binding), and loses satisfaction reactively when one is withdrawn. Provision (`set`) is itself a revertible effect, so the effect machinery and the coeffect machinery are the same machinery — the paper's central synergy. Two refinements — *isolation* (the same key resolves to different bindings in different contexts) and *interception* (cross-cutting metadata on access) — extend the model to multi-tenancy, sandboxes, and access-control policy.

**Coeffect context as a dependency table.** The paper formalizes inversion-of-control (IoC) / dependency injection as a coeffect context `Σ := (k : K) ⇀ 𝒱_k`, a finite typed partial function from dependency keys to values (each key `k` associated with a specific value type `𝒱_k`). `get(k)` reads (defined when `k ∈ dom(σ)`); `set(k,v)` binds (requires `k ∉ dom(σ)`) and returns an inverse `σ' ↦ σ' ∖ k`. Crucially `set(k,v)` has the type of a *revertible effect function* on `Σ`, so it inherits automatic tracking and recovery from §3.1 — *coeffect operations are effects, and effects are revertible.*

**Specification, satisfaction, notification.** A coeffect specification is a set `d ⊆ K` of declared dependencies. The satisfaction predicate `σ ⊧ d := ∀k∈d. k∈dom(σ)` is decidable. Because every mutation of `σ` passes through an effect function (whose inverse recovers the previous domain), satisfaction changes are detectable at each effect boundary — the algebraic basis of reactivity. A transition `σ → σ'` is classified against `d`:

- *activating* if `σ ⊭ d ∧ σ' ⊧ d` — triggers execution of the component's effects (with full tracking);
- *deactivating* if `σ ⊧ d ∧ σ' ⊭ d` — triggers recovery by applying the accumulator;
- *neutral* otherwise.

This delivers *local spatial composability*: a component activates only at a satisfying state, so it never reads an absent binding, and every context change is classified so a loss of satisfaction is detected where it happens. One ordering direction is immediate (a dependent activates only after its provider has provided the key); the converse — holding a provider's withdrawal back until dependents have finished their own teardown — is a global condition handled by the calculus (§4.3.1 withdrawal guard).

**Isolation — same key, different binding.** `Σ_iso := (K ⇀ R) × ((r : R) ⇀ 𝒱_r)`: a *realm table* `ρ` maps each isolated key to a realm identifier, and the value table is keyed by realm. Access resolves `k → ρ(k) → σ(ρ(k))`. `isolate(k,r)` *derives* a child context assigning realm `r` to `k`, leaving the shared table untouched — essentially a runtime ad-hoc-polymorphism system in which the same dependency key resolves to entirely different values in different contexts. Applications: multi-tenant systems, testing environments, component sandboxes.

**Interception — cross-cutting metadata on access.** `Σ_inter` maps each key to a *provider function* `ℳ_k → 𝒱_k` and carries context-installed metadata `ι`; a specification carries component-declared metadata. `get(k,μ)` applies the provider to the merged metadata `μ ⊕ ι(k)`. `intercept(k,ν)` merges metadata `ν` into the context. Interception adjusts *how* a binding is used without changing *whether* it is satisfied, so it can be installed or removed at runtime without triggering a reload or perturbing the dependency graph — the hook §6.3 uses for fine-grained access-control policy.

**Two realizations of an effect.** The paper distinguishes *in-place* realization (mutate the context, return a nontrivial inverse) from *derived* realization (leave the input intact, return a fresh derived context, identity inverse; recovery discards the derived context). Isolation and interception are given derived realization outright — nothing in the shared table changes, so there is no inverse to track.

Source: [paper.pdf](https://github.com/cordiverse/paper/blob/main/paper.pdf) §3.2 (cordiverse/paper), content SHA-256 `4d48478d…`.
