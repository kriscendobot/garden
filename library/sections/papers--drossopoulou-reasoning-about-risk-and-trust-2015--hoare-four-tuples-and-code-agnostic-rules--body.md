---
title: Body
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
parent: papers--drossopoulou-reasoning-about-risk-and-trust-2015--hoare-four-tuples-and-code-agnostic-rules
---

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
