---
title: Revertible effects and local temporal composability
source: "A Programming Paradigm for Spatiotemporal Composability"
source_kind: paper
source_authors: [Yifan Shi, Wei Zhang, Tianyi Cui]
source_year: 2026
source_venue: "Preprint (cordiverse/paper on GitHub)"
source_url: https://github.com/cordiverse/paper/blob/main/paper.pdf
source_pdf_sha256: 4d48478dc0b6222d9f74d7db10ee776449b1209eb112632336544d32a49db97f
ingested: 2026-08-14
ingested_by: scholar
topics: [effect-and-coeffect-systems, dynamic-composition]
status: current
---

Abstract: This derived digest, not the original paper, captures the paper's temporal-composability mechanism: model an effect not as a bare state transformation but as a *pair* of a forward transformation with an explicit inverse, `Γ → Γ × (Γ → Γ)`; carry a runtime *accumulator* that composes those inverses; and recover the pre-composition state by applying the accumulator. Loading a component is applying such a sequence and accumulating its inverses; unloading it is applying the accumulator. An *independence* condition (pairwise commutation of one effect's transformations with another's) is what lets inverses run out of order — the case that arises when one component is withdrawn while others remain, or when several components' effects interleave.

**Effects as context transformations.** Any impure `f_impure : X → Y` is pure-ified to `f : Γ × X → Γ × Y`, where `Γ` is *the context* and every side effect is a transformation on `Γ`. Effects therefore live in the monoid of transformations `Γ → Γ` under composition, whose monoid axioms read directly as effect properties (closure = sequential composition is again an effect; associativity = bracketing-independence; identity = `id_Γ` is the no-op).

**Pairing with an inverse.** To model undoing, each transformation `f` is paired with a `g` that undoes it — a *left inverse* (`g ∘ f`, never `f ∘ g`; undoing is one-sided). Pairs compose by *twisted composition*: `(f₁,g₁) ∘ (f₂,g₂) := (f₁∘f₂, g₂∘g₁)` — forward maps compose in order, inverses accumulate in the opposite order (LIFO). This makes pairs a monoid, the *twisted composition monoid* `𝔗Γ`.

**Effect context and the accumulator.** The *effect context* is `∂Γ := Γ × (Γ → Γ)`, a pair `(γ, φ)`: `γ` the current state and `φ` the *accumulator*, the composite of the inverses of all effects performed so far — the function that recovers the initial state. The initial effect context is `(γ₀, id_Γ)`. Two operations run it:

- `track(f,g) : (γ,φ) ↦ (f(γ), φ∘g)` — apply `f` to the state and compose the inverse `g` onto the accumulator. `track` is a monoid homomorphism from `𝔗Γ` into `∂Γ → ∂Γ` (units to units, twisted composition to composition).
- `recover : (γ,φ) ↦ (φ(γ), id_Γ)` — apply the accumulated inverse and reset. After a sequence of tracked effects, `recover` carries the effect context back to `(γ₀, id_Γ)`. The paper calls `φ(γ) = γ₀` the *soundness invariant*.

**Revertible effect functions `𝔈*Γ`.** An effect function yields, at each state, a successor and an inverse witnessed to revert *at the state its own application produced*. Reverting in LIFO order (the reverse of application) needs no extra hypothesis (Theorem 16): each inverse meets exactly the state its own application produced.

**Independence — reverting out of order.** Two situations need more than LIFO: running an inverse while *later* effects are still installed (withdrawing one component from a running system), and a sequence that *interleaves* several components' effects. The paper's answer is an *independence* condition (Definition 19): every transformation of one effect commutes with every transformation of the other (forward map and yielded inverse alike), and neither disturbs the inverse the other yields. Independence is decided on the generators (Lemma 18). Under independence, an inverse run at a state later effects have moved withdraws *its own contribution and nothing else*, and the inverses may be applied in *any* permutation and still reach `γ₀` (Corollary 21). Independence is a condition on the *effects*, not a property of the construction; where it fails, order must be carried elsewhere (within a component by the LIFO accumulator, across components by a declared coeffect that orders one activation against another).

**What this delivers.** *Local temporal composability*: for every sequence of effect functions a component applies, the accumulator recovers the context it began at, and reverting hands each inverse the state its own application ran against. "Local" because the guarantee is read of one component's effects in isolation; the system-wide version is Section 4.4.2's trace theorem.

Source: [paper.pdf](https://github.com/cordiverse/paper/blob/main/paper.pdf) §3.1 (cordiverse/paper), content SHA-256 `4d48478d…`.
