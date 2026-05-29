---
title: Focal, Chainmail, and the Hoare four-tuple logic for open-system code (invariants preserved during execution; code-agnostic inference rules that allow reasoning when the receiver's specification is unknown; only-connectivity-begets-connectivity as a formal inference rule)
source: "Reasoning about Risk and Trust in an Open World (Drossopoulou, Noble, Miller, Murray ~2015)"
source_kind: paper
source_authors: [Sophia Drossopoulou, James Noble, Mark S. Miller, Toby Murray]
source_year: 2015
source_venue: "Workshop draft, technical report ECSTR-15-08 (VUW, 2015)"
source_url: https://papers.agoric.com/papers/reasoning-about-risk-and-trust-in-an-open-world/
source_pdf_sha256: 3f4b20422cda8899380377c6d3c43c279ef2dca07f748febe79bc5a2302c2809
source_paper_pages: "11-18 (§3 A Formal Model of Trust and Risk through §3.4 Proving Mutual Trust)"
ingested: 2026-05-29
ingested_by: liaison-direct-draft
topics: [capability-security, capability-theory, spec-to-implementation]
status: current
---

## Abstract

§3 provides the formal model behind the §1-§2 informal arguments. **`Focal`** (Featherweight Object Capability Language) is the small dynamically-typed object-oriented core language in which the worked examples are expressed: it supports classes / fields / methods, is memory-safe, and is dynamically typed (similar to JavaScript, Grace, E, and Dart's unchecked mode). Modules `M` in Focal are mappings from class identifiers to class definitions and from predicate identifiers to *Chainmail* assertions; the *linking operator* `*` combines modules from different domains, performing no other checks — reflecting the open-world setting where objects of different provenance interoperate without a central authority. **`Chainmail`** is the specification language: a specification is a conjunction of named policies, each of one of three forms: (1) an invariant `A` (must hold at all visible states); (2) `A { code } B` (executing `code` in a state satisfying `A` leads to a state satisfying `B`); or (3) `A { any_code } B` (executing *any* code in a state satisfying `A` leads to a state satisfying `B`). Chainmail one-state assertions include the standard expression forms (`x > 1` etc.) plus four new assertions: `Expr obeys SpecId` (trust); `MayAccess` and `MayAffect` (risk); `Expr : ClassId` (class membership test). **§3.3 Hoare Logic** is the inference system that uses **four-tuples** rather than triples: `M ⊢ A { stmts } A' ⋈ B` is the four-tuple in which `B` is the *invariant* preserved during execution of `stmts`, and `A'` is the *post-condition* on the new state. The four-tuple is critical to modelling *risk*, because it lets us say *no temporary but unwanted effects occur on intermediate states*, not just *no permanent effect after termination*. The §3.3 paper presents seven core inference rules: `VARASG`, `FIELDASG`, `METH-CALL-1` (when the receiver `obeys` a known spec), `METH-CALL-2` (when nothing is known about the receiver — the *only-connectivity-begets-connectivity* axiom), `FRAME-METHCALL` (a method can affect a property only via objects it has access to), `CODE-INVAR-1` (reasoning under `obeys` hypothesis), `CODE-INVAR-2` (`obeys` is itself preserved across statement execution), plus several consequence and sequencing rules. The four *code-agnostic* rules — `METH-CALL-2`, `FRAME-METHCALL`, `CODE-INVAR-1`, `CODE-INVAR-2` — are the paper's central inferential payoff: they let the verifier reason about a method call *even when the call's effects on the receiver are unknown*, producing exactly the kind of conditional postcondition the §2.6 four-case specification requires. §3.4 *Proving Mutual Trust* applies the logic to the first deal-method step (`escrowMoney := sellerMoney.sprout`) and derives the Hoare four-tuple of Figure 7 — showing in detail how `Pol_sprout` is applied, how `Code-Invar-1` introduces the `obeys` hypothesis branch, and how `Meth-Call-2` plus `Frame-Methcall` produce the risk-bound clauses when `sprout` may not obey `ValidPurse`. The theorem (Theorem 3) is *soundness of the Hoare logic*: if the logic derives `M ⊢ A { stmts } B' ⋈ B`, then the corresponding semantic four-tuple holds: every reachable intermediate state preserves `B`, and the final state satisfies `B'`. The §3 paper closes with the methodological summary: four code-agnostic inference rules, plus the framing rules `FRAME-METHCALL` and `METH-CALL-2`, let us reason about risk even in open systems where the called method's source is not known.

## Body

### §3.1 `Focal` — Featherweight Object Capability Language

The §3.1 paper defines `Focal` (not to be confused with FOCAL [28], an older language). The salient properties:

- **Object-oriented core**: classes, fields, methods. (Figures 1 and 3 in §2 are effectively `Focal` examples.)
- **Memory-safe**: addresses cannot be forged; non-existent methods and fields cannot be called, read, or written.
- **Dynamically typed**: arguments to method calls and field writes are not checked for type at compile time or runtime — similar to JavaScript, Grace, E, and Dart's unchecked mode.

The §3.1 paper defines **modules** `M` as mappings from class identifiers to `Focal` class definitions and from predicate identifiers to `Chainmail` assertions. The *linking operator* `*` combines two modules provided their domains are separate, and performs no other check. The §3.1 framing notes:

> This reflects the open world setting, where objects of different provenance interoperate without a central authority. For example, taking `M_p` as a module implementing purses, and `M_e` as another module implementing the escrow, `M_p * M_e` is defined but `M_e * M_e` is not.

The linking-operator semantics reflect the central thesis: in the open world, modules combine without any external trust authority gating the composition. The verifier reasons about *what holds for `M_p * M_e`* in terms of `M_p`'s policies (which `M_e` cannot violate without breaching the memory-safety guarantee).

`Focal` enforces a *weak privacy* on fields: only the receiver may *modify* these fields, but *anybody* may *read* them. The asymmetric privacy is what the §2.3 `Pol_protect_balance` policy ensures: only an object with `MayAccess` to a purse `p` may `MayAffect` `p.balance`.

The §3.1 operational semantics of `Focal` is defined via a transition relation `M, σ ⇝ σ'` where `σ = frame × heap`. Definitions 6 and 7 in the paper define the *shape of execution* (`⇝ : Module × state × Stmts → state`) and the *arising / initial configurations* (the set of runtime configurations reachable from some initial configuration `(σ_0, stmts_0)`).

The §3.1 paper notes a key technical detail: `Reach(M, σ, stmts)` is *defined* even when execution should diverge. This is important because it allows giving meaning to capability policies *without requiring termination*. The verifier can reason about diverging code's effects.

### §3.2 `Chainmail` — the specification language

The §3.2 paper defines `Chainmail`: a specification is a conjunction of *named policies*, each one of three forms.

Recall **Definition 12 (Policies)**:

> `Policy ::= A | A { code } B | A { any_code } B`
> `PolSpec ::= specification S { Policy* }`

The three policy forms are:

1. **Invariant**: an assertion `A` that must hold at *all visible states*.
2. **Code-specific Hoare-style**: `A { code } B` — executing `code` in any state satisfying `A` will lead to a state satisfying `B`.
3. **Code-agnostic Hoare-style**: `A { any_code } B` — executing *any code* in a state satisfying `A` leads to a state satisfying `B`. This is what `Pol_can_trade_constant` uses.

The §3.2 paper introduces the new assertions:

- **`Expr obeys SpecId`** — model trust: `o obeys ValidPurse` means *we trust `o` to adhere to `ValidPurse`*.
- **`MayAccess(o, p)`** — model risk: it is possible the code in `o` could gain access to `p`.
- **`MayAffect(o, p)`** — model risk: it is possible some method invocation on `o` would affect `p`.
- **`Expr : ClassId`** — simple class-membership test.

The §3.2 paper emphasizes the *hypothetical* character of `obeys`, `MayAccess`, and `MayAffect`: they talk about the *potential* effects or behaviour of code; we cannot evaluate their truth-value when executing the program. They are verification-time predicates over the abstract heap and module structure.

The §3.2 paper makes precise the semantic interpretation of one-state assertions via the judgment `M, σ ⊨ A`. From Definition 13 (the paper paraphrases):

- `M, σ ⊨ e:C` iff `σ(⌊e⌋_{M,σ}) ↓_1 = C` — class membership.
- `M, σ ⊨ MayAffect(e, e')` iff there exist a method `m`, arguments `ā`, state `σ'`, identifier `z`, such that `M, σ[z ↦ ⌊e⌋_{M,σ}], z.m(ā) ⇝ χ', and ⌊e'⌋_{M,σ} ≠ ⌊e'⌋_{M,σ + 1 . χ'}` — a method call on `e` produces a state where the value at `e'` differs.
- `M, σ ⊨ MayAccess(e, e')` iff there exist fields `f̄` such that `⌊z.f̄⌋_{M, σ[z↦⌊e⌋_{M,σ}]} = ⌊e'⌋_{M,σ}` — there is a field path from `e` to `e'`.
- `M, σ ⊨ e obeys PolSpecId` iff for all `(σ, stmts) ∈ Arising(M)`, for all `i ∈ {1..n}`, for all `σ'`, `stmts'`, `(σ', stmts') ∈ Reach(M, σ, stmts) → M, σ'[z ↦ ⌊e⌋_σ] ⊨ Policy_i[z/this]` where `z` is a fresh variable and `PolSpecId` was defined as `specification PolSpecId { Policy_1, ..., Policy_n }`.

The §3.2 *obeys-validity* condition is the key technical move: an expression `e` `obeys` a specification `PolSpecId` iff in *every* configuration reachable from *every* arising configuration of the module, the policy is satisfied with `e` substituted for `this`. The verifier reasons under the hypothesis of `obeys` and discharges it by showing this universal property holds.

### §3.3 Hoare Logic with four-tuples

The §3.3 paper presents the central inference system. The Hoare logic uses *four-tuples* rather than the standard three-tuples, written:

> `M ⊢ A { stmts } A' ⋈ B`

The four-tuple has four parts:

- **`A`**: precondition — must hold before execution.
- **`stmts`**: the statements being verified.
- **`A'`**: post-condition — must hold after execution terminates.
- **`B`**: invariant — must hold *during* execution, at every intermediate state.

The §3.3 paper notes:

> Critically, both promise that the relation between the initial state, and *any* of the intermediate states reached by execution of `stmts`, will maintain the invariant `B`. The execution of `stmts` may call methods defined in `M`, and the predicates appearing in `A`, `A'`, `B'`, and `B`, may use predicates defined in `M`.

The four-tuple is required to **model risk**: the §3 paper's central technical claim is that risk is not just a post-condition concept (*nothing bad has happened by the end*) but a during-execution concept (*nothing bad happens during execution either*). An untrusted method call could temporarily expose a capability and then withdraw it; the trace-style invariant `B` catches that.

The validity is given by **Definition 16 (Validity of Hoare Four-Tuples)**:

> `M ⊨ A { stmts } B' ⋈ B` iff ∀M', σ.
> `(σ, _) ∈ Arising(M * M')` ∧ `M * M', σ ⊨ A` ∧ `M * M', σ, stmts ⇝ res, σ'`
> → `M * M', σ, σ' ⊨ B'` ∧ ∀σ'' ∈ Reach(M, σ, stmts). `M * M', σ, σ'' ⊨ B`

The quantification over `M'` is the open-world hook: the four-tuple must hold *for any module that could be linked to `M`*. The §3.3 paper quotes Jones [34]:

> A programmer should be able to prove that his programs have various properties and do not malfunction, solely on the basis of what he can see from his private bailiwick.

The Hoare four-tuple operationalizes this: the verifier proves the four-tuple *quantifying over any module `M'`*; the proof goes through *without seeing the source* of `M'`.

#### The inference rules — selected (Figure 6)

The §3.3 paper presents seven core inference rules in Figure 6. The key rules:

**`(METH-CALL-1)`** — the *trusted* call: when the receiver `obeys` a known specification.
```
M(S) ≡ spec S { ..., A { this.m(par) } B, ... }
─────────────────────────────────────────────────
⊢ x obeys S ∧ A[x/this, y/par]
  { v := x.m(y) }
  B[x/this, y/par, v/res]
  ⋈ true
```
*Read*: if `x` `obeys S`, and `S` says `A { this.m(par) } B`, and the precondition `A[x/this, y/par]` holds, then after `v := x.m(y)` the postcondition `B[x/this, y/par, v/res]` holds. The invariant is `true` — no constraint *during* execution beyond what `S`'s spec says.

**`(METH-CALL-2)`** — the *untrusted* call: when nothing is known about the receiver. This is the **only-connectivity-begets-connectivity axiom**, formalized.
```
B ≡ ∀ z :pre Object. MayAccess(v, z) → (MayAccess(x, z) ∨ MayAccess_pre(y, z))
B' ≡ ∀ z, u :pre Object. (MayAccess(u, z) →
        (MayAccess_pre(u, z) ∨
         ((MayAccess(x, z) ∨ MayAccess_pre(y, z)) ∧
          (MayAccess_pre(x, u) ∨ MayAccess_pre(y, u)))))
────────────────────────────────────────────────
⊢ true { v := x.m(y) } B ⋈ B'
```
*Read*: even when nothing is known about `x.m`, after the call:
- *Postcondition `B`*: the call's result `v` cannot expose access to any object `z` that wasn't reachable from `x` or `y` *before* the call.
- *Invariant `B'`*: *during* execution, accessibility does not change unless the participants (here `z` and `u`) were accessible to the receiver `x` or argument `y` *before* the call.

The §3.3 paper notes:

> Note that this latter promise is made via the invariant (fourth) rather than the postcondition (third) part of the Hoare-tuple. Note also that this rule is applicable *even if we know nothing* about the receiver of the call: this rule and the invariants are critical to reasoning about risk.

**`(FRAME-METHCALL)`** — the *POLA framing rule*: a method can affect a property only via objects it has access to.
```
⊢ A { v := x.m(y) } true ⋈ B
B ≡ ∀ z. (MayAffect(z, A') → B'(z)) ∧
    ∀ z. ((MayAccess(x, z) ∨ MayAccess_pre(y, z) ∨ New(z)) → ¬B'(z))
─────────────────────────────────────────────────
⊢ A ∧ A' { v := x.m(y) } A' ⋈ true
```
*Read*: if executing the call yields an invariant that constrains every object `z` whose property might be affected to one that *does not satisfy* `B'`, and if `B'` rules out objects accessible from `x` or `y` or newly allocated, then `A'` is preserved across the call.

The §3.3 paper notes:

> `(FRAME-METHCALL)` also expresses an axiom of object-capability languages, namely that in order to cause some visible effect, one must have access to an object able to perform the effect. Coupled with *only connectivity begets connectivity*, this implies that a method can cause some effect only if the caller has (transitive) access to some object able to cause the effect (including perhaps the callee).

**`(CODE-INVAR-1)`** — reasoning *under the* `obeys`-hypothesis.
```
M(S) ≡ spec S { ..., P, ... }
B ≡ ∀ x. (x obeys S → P[/x/this])
─────────────────────────────────
⊢ true { stmts } true ⋈ B
```
*Read*: any specification policy `P` of `S`, instantiated for `x`, holds throughout execution *under the hypothesis* that `x obeys S`. This is the formal rule that captures *if-we-trust-x-then-its-spec-holds-during-execution-too*.

**`(CODE-INVAR-2)`** — `obeys` *itself* is preserved across statement execution.
```
─────────────────────────────────
⊢ true { stmts } true ⋈ e obeys S → e_pre obeys S
```
Or actually reading from the paper:
```
⊢ true { stmts } true ⋈ e obeys S → e_pre obeys S
```
*Read*: `e obeys S` holds at the post-state iff `e_pre obeys S` held at the pre-state. Trust is invariant across statement execution. *Once trusted, always trusted — within a verification.*

### §3.4 Proving mutual trust (Figure 7)

The §3.4 paper applies the Hoare logic to derive the four-tuple for the *first* deal-method step (`escrowMoney := sellerMoney.sprout`). Figure 7 gives the derived four-tuple:

The four-tuple's structure (annotated):

- **Pre**: `true`.
- **Statement**: `escrowMoney := sellerMoney.sprout`.
- **Post (conditional on trust)**: `sellerMoney_pre obeys ValidPurse → ( escrowMoney obeys ValidPurse ∧ CanTrade(escrowMoney, sellerMoney) ∧ escrowMoney.balance = 0 ∧ ∀p ∈_pre GoodPrs. p.balance_pre = p.balance ∧ sellerMoney obeys ValidPurse )`.
- **Plus risk-bound clauses (no trust assumed)**: `∀p :pre GoodPrs. (p.balance_pre = p.balance ∨ MayAccess_pre(sellerMoney, p)) ∧ ∀ z, y :pre Object. (MayAccess(escrowMoney, z) → MayAccess_pre(sellerMoney, z)) ∧ ∀ z, y :pre Object. (MayAccess(z, y) → MayAccess_pre(z, y) ∨ MayAccess_pre(sellerMoney, y) ∧ MayAccess_pre(sellerMoney, z))`.

The §3.4 derivation walks the steps:

- **(A)** by `Pol_sprout` and `(METH-CALL-1)`: under `sellerMoney obeys ValidPurse`, the `Pol_sprout` postcondition holds for `escrowMoney`.
- **(B)** by `(CONS-2)` on the above: the postcondition is rephrased as `sellerMoney_pre obeys ValidPurse → ( escrowMoney obeys ValidPurse ∧ ...rest... )`.
- **(C)** apply `(FRAME-GENERAL)` and `(CONS-2)`: also conclude that `sellerMoney_pre obeys ValidPurse → escrowMoney obeys ValidPurse` (the assignment doesn't affect `escrowMoney`'s trust-status if any).
- **(D)-(I)** apply `(METH-CALL-2)`, `(CONS-1)`, `(CODE-INVAR-1)`, etc.: derive the *risk-bound* clauses that hold *regardless* of whether `sellerMoney` was trustworthy.

The §3.4 paper notes that the four-tuple's *invariant* clauses (the risk bounds) are derived using *only* the code-agnostic rules — they do not depend on `sellerMoney obeys ValidPurse`. This is the methodological payoff: **the risk bounds hold unconditionally**; the strong functional behaviour holds conditionally on the trust hypothesis. The §2.6 four-case `ValidEscrow` spec follows from chaining these single-step four-tuples through the rest of the `deal_version2` method.

### Theorem 3 — Soundness of the Hoare Logic

The §3.3 paper states **Theorem 3 (Soundness of the Hoare Logic)**:

> For all modules `M`, statements `stmts` and assertions `A, B` and `B'`, if `M ⊢ A { stmts } B' ⋈ B`, then `M ⊨ A { stmts } B' ⋈ B`.

The theorem is proven in the technical report [18]. The proof goes by induction on the derivation, using the operational semantics of `Focal` and the validity definitions for Chainmail policies.

The §3.3 paper closes with the *summary of code-agnostic rules*:

> In summary, we have four "code agnostic" rules — rules which are applicable regardless of the underlying code. Rules `(FRAME-METHCALL)` and `(METH-CALL-2)` express restrictions on the effects of a method call. Normally such restrictions stem from the specification of the method being called, but here we can argue in the absence of any such specifications, allowing us to reason about risk even in open systems. Rules `(CODE-INVAR-1)` and `(CODE-INVAR-2)` are applicable on *any* code, and allow us to assume that an object which obeys a specification `S`, satisfies all policies from `S`, and that the object, once trusted, will always be obeying `S`.

These four rules are the §3 paper's central inferential payoff: a verifier can derive useful conclusions about an open-system program *without* knowing the source of the called methods, leveraging the language-level capability discipline plus the `obeys` hypothesis machinery.

## Connection to the wider library

The §3 paper is the **formal underpinning for open-world reasoning over Hardened JavaScript and the @endo discipline**. Three threads:

1. **`Focal` is the formal model of Hardened JavaScript at the language level.** Memory-safety + dynamic typing + module composition without central authority — these are the features `harden` + Compartment + `@endo/static-module-record` give the contemporary developer. The §3.1 module composition operator `*` is the formal abstraction of `@endo/compartment-mapper` + `@endo/init`'s composition mechanics.

2. **`Chainmail` is the spec-language target for documenting Hardened JavaScript invariants.** Designs that need to formalize trust assumptions can use `Chainmail`-style policy structures (named policies; invariants vs Hoare-style vs `any_code` Hoare-style) as the documentation template.

3. **The four code-agnostic rules are the formal underpinning of *defensive consistency*.** Hardened JavaScript code is *defensively consistent* — it must produce correct output given *any* input from any caller, trusted or not. The `METH-CALL-2` axiom and the `FRAME-METHCALL` rule express the formal content of defensive consistency: even an untrusted callee cannot cause effects beyond its access reach.

## Translation block (paper idiom → contemporary Endo / Agoric surface)

| 2015 paper concept | Contemporary Endo / Agoric equivalent |
| ------------------ | ------------------------------------- |
| `Focal` (Featherweight Object Capability Language) | Hardened JavaScript (SES + lockdown + Compartment + harden); the language-level features are the same. |
| `Chainmail` named-policy specification | TypeScript interface contracts + JSDoc invariants + comment-block specification idioms; less formal but structurally analogous. |
| Module linking via `*` | `@endo/compartment-mapper` + `@endo/init` + endowment-passing — the composition is *additive* and *checks-domain-disjointness* but performs no other trust check. |
| `MayAccess` as transitive points-to closure | The pass-by-reference / pass-by-copy / pass-by-presence taxonomy in `@endo/marshal`; the formal model is the abstract graph, the implementation distinguishes how the reference traversal can happen. |
| Hoare four-tuple `M ⊢ A { stmts } A' ⋈ B` | An informal "code that holds an invariant during execution" discipline; design docs can adopt the four-tuple syntax to make the invariant explicit. |
| `(METH-CALL-2)` only-connectivity-begets-connectivity | The structural rule for capability passing in `@endo/marshal` + `captp`: a remote call cannot introduce references its arguments and receiver did not already imply. |
| `(FRAME-METHCALL)` POLA framing | The `harden`-induced *immutability-by-default*: an alleged-trustworthy object's mutations are restricted to what its access-graph permits. |
| `(CODE-INVAR-1)` reasoning under hypothesis | The contemporary Hardened JavaScript review style: *if* the alleged interface contract holds, *then* the call's effects are bounded by the contract; reviewers should consider the case where the contract fails to detect spec drift. |
| `(CODE-INVAR-2)` trust is preserved | The contemporary practice: once a capability is *committed* to via `harden` + endowment, the trust assumption holds for the lifetime of the program — there is no untrust-then-retrust dance. |

## Implications for Endo / Agoric

This section is the **formal foundation for open-world Hardened JavaScript verification**. The library can cite this paper whenever:

1. **A design needs to specify trust + risk simultaneously.** The `Chainmail` policy structure (named policies; conjunction of invariants + Hoare-style triples + `any_code` rules) is the template. Designs can adopt the named-policy idiom for documentation precision.
2. **A design needs to express an invariant that holds *during* execution.** The Hoare four-tuple is the formal mechanism. Less formally, designs should distinguish *terminal-state guarantees* from *during-execution guarantees* when the latter is load-bearing (e.g. when an untrusted callee could temporarily expose a capability).
3. **A design needs to reason about an unknown callee.** The `(METH-CALL-2)` axiom is the canonical rule: *only connectivity begets connectivity*. Designs should explicitly invoke this rule when arguing risk bounds against an unknown receiver.
4. **A design needs to formalize *defensive consistency*.** The four code-agnostic rules are exactly the formal content of defensive consistency. A reviewer asking *what does this code guarantee if the callee misbehaves?* is informally invoking these rules.

## See also

- [[object-capability]] — the `(METH-CALL-2)` axiom formalizes *only connectivity begets connectivity*, the foundational ocap principle. The `(FRAME-METHCALL)` rule formalizes the dual.
- [[principle-of-least-authority]] — the framing rule `(FRAME-METHCALL)` is the formal POLA: an object can affect only what it has authority to affect (transitively).
- [[four-ways-to-acquire-references]] — the `(METH-CALL-2)` postcondition is the formal model of the *introduction* arm: a method call can introduce only references already reachable from its arguments / receiver.
- [[vat-and-compartment]] — `Focal` modules and the `*` linking operator are the formal counterpart to compartments and `@endo/compartment-mapper` composition.
- [[hardened-javascript]] (topic) — the §3.1 *Focal* language is the formal counterpart to Hardened JavaScript at the dynamic-language level. *Focal* is what JavaScript-under-SES is, modulo concrete syntax.
- [[smart-contract]] — the §3.4 proof technique extends to any multi-party trust-sensitive contract; the four-tuple is the formal mechanism for *during-execution* risk bounds.
- `papers--drossopoulou-reasoning-about-risk-and-trust-2015--trust-as-hypothetical-and-risk-via-may-access-may-affect` — the §1-§2.2 introduction of `obeys`, `MayAccess`, `MayAffect` this section formalizes.
- `papers--drossopoulou-reasoning-about-risk-and-trust-2015--escrow-failure-and-four-case-valid-escrow-spec` — the §2.3-§2.6 application this section's logic proves.

## Common confusions

- **"Hoare four-tuples are just Hoare triples with the invariant tacked on."** Not quite. The four-tuple's invariant `B` quantifies over *every* intermediate state, not just the terminal state. This is the key formal device for capturing *no-temporary-bad-behaviour-during-execution* — the kind of guarantee that matters for risk in adversarial settings. Standard Hoare triples cannot express this.
- **"`(METH-CALL-2)` requires no specification at all."** The rule applies *in the absence of* a known spec for the called method, but the *language* (`Focal`) provides the memory-safety axioms that the rule depends on. The rule is sound *because* `Focal` guarantees no address-forgery, no non-existent-field-access, etc.
- **"`(CODE-INVAR-2)` makes trust permanent."** It makes trust *invariant across statement execution* — if `x obeys S` held before, it still holds after. This is what lets verification carry trust hypotheses across long sequences without re-discharging them. The hypothesis is still *hypothetical* — it can fail in the world, but within a verification, once assumed it holds throughout.
- **"`Focal` is JavaScript."** Close but stripped to essentials: classes, fields, methods, dynamic typing, memory-safety. No closures (the §3.1 paper does not model them); no eval; no this-style polymorphism complexity. Real JavaScript adds these on top, and the formal model would have to be extended to handle them precisely.
- **"The §3.3 rules let me verify any program automatically."** No — they form an inference system the verifier *uses* to construct proofs. The §3.3 paper presents the rules; the §3.4 paper shows one application; the §1 *Disclaimers* notes that aliasing, concurrency, quantification, confinement, network errors, and exceptions are deferred to follow-on work. Practical mechanization remains future work the §5 conclusion explicitly identifies.
- **"`obeys` is a circular hypothesis."** It is a *carry-able* hypothesis. The verifier *assumes* `x obeys S` and then derives consequences. The hypothesis is *discharged* in two ways: (i) by ground-truth provenance (we built `x` ourselves), or (ii) by structural argument (we received `x` through a trusted introduction chain). Within a verification, the hypothesis is consistent; across verifications, the discharge step matters.
