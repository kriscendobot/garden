---
title: Trust as a hypothetical predicate; risk via MayAccess and MayAffect (the three new specification constructs that let open-world code reason about untrusted callees without a central authority)
source: "Reasoning about Risk and Trust in an Open World (Drossopoulou, Noble, Miller, Murray ~2015)"
source_kind: paper
source_authors: [Sophia Drossopoulou, James Noble, Mark S. Miller, Toby Murray]
source_year: 2015
source_venue: "Workshop draft (referenced as Drossopoulou-Noble *Swapsies on the Internet* PLAS 2015 [17] in the bibliography; the full technical report is ECSTR-15-08, VUW, 2015 [18])"
source_url: https://papers.agoric.com/papers/reasoning-about-risk-and-trust-in-an-open-world/
source_pdf_sha256: 3f4b20422cda8899380377c6d3c43c279ef2dca07f748febe79bc5a2302c2809
source_paper_pages: "1-7 (§1 Introduction; §2.2 Modelling Trust and Risk: obeys, MayAccess, and MayAffect)"
ingested: 2026-05-29
ingested_by: liaison-direct-draft
topics: [capability-security, capability-theory, spec-to-implementation]
status: current
---

## Abstract

§1 frames the paper's central question: given a method call `x.m(y)` where the receiver `x` is *unknown* — supplied from elsewhere in an open system with no central trust authority — what can the caller conclude about the call's behaviour? The traditional *closed-world* answer (assume all objects are trustworthy because they are *confined* in Lampson's sense) does not apply. The §1 answer the paper proposes is to introduce three new specification predicates that let code reason *conditionally and hypothetically* about untrusted callees. **`o obeys Spec`** is the first-class trust predicate: it means *the current object trusts `o` to adhere to specification `Spec`*. The `obeys` predicate is **hypothetical** — there is no central authority that can assign trustworthiness, and there is no trust bit on objects that can be tested at runtime. `obeys` is an assumption that may or may not be true, and the verification proceeds by *cases*: if we trust the object, we can use the object's specification to determine the call's results; if we do not trust the object, we determine the *risk* — the maximum amount of damage the call could do that turns out not to meet the specification. **`MayAccess(o, p)`** means it is *possible* that the code in object `o` could potentially gain a capability to access `p` — equivalently, `p` is in the transitive closure of the points-to relation on the heap starting from `o`, including both public and private references. **`MayAffect(o, p)`** means it is *possible* that some method invocation on `o` would affect the object or property `p`. The three predicates form a *complementary* pair: `obeys` tells us what we can rely on for trustworthy callees; `MayAccess` and `MayAffect` tell us what damage untrusted callees could inflict on the rest of the system. The §1 framing is the paper's central methodological move: it makes the trust assumption *explicit* in the specification language, rather than buried as an implicit closed-world assumption underneath conventional spec-and-prove machinery.

## Body

### §1 The open-world problem with a closed-world spec language

The §1 paper opens with the traditional-spec problem statement:

> Traditional systems designs are based on a closed world assumption: drawing a sharp border around a system where the system as a whole can be trusted because every component inside the border is known to be trustworthy, or is *confined* [25] by trustworthy mechanisms. Open systems, on the other hand, have an open world assumption: they must interact with a wide range of component objects with different levels of mutual trust (or distrust) — and whose configuration dynamically changes. Given a method request `x.m(y)`, what can we conclude about the behaviour of this request if we know nothing about the receiver `x`?

The §1 framing identifies two complementary aspects of the open-world spec problem:

- **Trust**: when we *do* trust the receiver to obey a specification, what can we conclude from that trust?
- **Risk**: when we *do not* trust the receiver, what is the maximum damage that the call could do?

Traditional specification approaches collapse the trust dimension into an implicit *all-objects-are-trustworthy* assumption underlying the spec system; consequently, traditional specs cannot express what happens when that assumption fails. The §1 paper makes this assumption *explicit and dischargeable*: trust becomes a first-class hypothesis that the verifier can assert or negate at will.

### §2.2 The three constructs: `obeys`, `MayAccess`, `MayAffect`

The §2.2 paper introduces three new specification-language constructs:

#### `o obeys Spec` — first-class hypothetical trust

The §2.2 paper defines `o obeys Spec` as:

> A special predicate of the form `o obeys Spec`, which we interpret to mean that the current object trusts `o` to adhere to the specification `Spec`. Because we generally can't be sure that an object — especially one supplied from elsewhere in an open system — can actually be trusted to obey a particular specification, our reasoning and specifications are *hypothetical*: analysing the same piece of code under different trust hypotheses — i.e. assuming that particular objects may or may not be trusted to obey particular specifications.

Three key properties of `obeys`:

1. **Hypothetical**: `obeys` is not a runtime-checkable predicate. There is no `o.trusted` field; there is no central authority that hands out `obeys`-certificates. `obeys` is an *assumption* the reasoner makes when verifying code, then *discharges* in proofs.
2. **Asymmetric**: `o obeys Spec` is the current object's trust assertion about `o`, with respect to specification `Spec`. The same object can `obey` one specification and not another; the same object can be `obey`ed by one verifier and not another.
3. **Multi-case reasoning**: a piece of code is verified under *multiple* trust hypotheses. If we trust `o` we conclude one thing; if we do not trust `o` we conclude a weaker thing. The strong specification holds *if-trust-then-functional-correctness*; the weak specification holds *unconditionally* and bounds the damage.

#### `MayAccess(o, p)` — the transitive points-to closure

The §2.2 paper defines `MayAccess`:

> `MayAccess(o, p)` means that it is possible that the code in object `o` could potentially gain a capability to access `p` — that is, a reference to `p`. In practice, `MayAccess(o, p)` means that `p` is in the transitive closure of the points-to relation on the heap starting from `o` including both public and private references.

`MayAccess` is the formalized version of the **object-capability principle**: *only connectivity begets connectivity*. To reach `p` from `o`, the heap must already have a path. The paper later (§3.3 (`METH-CALL-2`) rule) uses `MayAccess` to bound what *new* references a method call can introduce: the postcondition `MayAccess(u, z)` after `v := x.m(y)` implies *either* `u` already had access to `z` *before* the call, *or* `u` newly gained access through `x` or `y` — and the new access must be along a pre-existing transitive chain through `x` or `y`.

#### `MayAffect(o, p)` — the dual to MayAccess for mutation

The §2.2 paper defines `MayAffect`:

> `MayAffect(o, p)` means that it is possible that some method invocation on `o` would affect the object or property `p`.

`MayAffect` is the *mutation* counterpart to `MayAccess`: where `MayAccess` bounds *which* objects an untrusted callee could *see*, `MayAffect` bounds *which* objects an untrusted callee could *change*. Together they form the **risk bounds**:

- *What an untrusted `o` may read or write to* — `MayAffect(o, p)`.
- *What an untrusted `o` could gain a reference to* — `MayAccess(o, p)`.

The §2.2 paper's framing emphasizes that these are *hypothetical* like `obeys` — they are claims about what is *possible* given the current heap configuration, not facts the runtime exposes.

### The methodological payoff

The §1 paper's *Contribution* section explicitly enumerates the methodological gains:

> Our approach first makes that [trust] assumption explicit (as `obeys`), lets us reason hypothetically and conditionally about those trust assumptions, even in cases where those assumptions fail (by quantifying risk via `MayAccess` and `MayAffect`).

This is the paper's central thesis: **specifications for open systems must make trust explicit and bound the damage when trust fails**. Traditional specs handle only the trustworthy case (or assume confinement); the §2.2 constructs let the same specification language handle the untrusted case too. The body of the paper then shows that the *escrow exchange* — a worked example originally specified in Miller-Van Cutsem-Tulloh 2013 ([31] in this paper's bibliography) — has weaker guarantees than its designers originally thought, and demonstrates (via a four-case `ValidEscrow` specification) what is *actually* achievable in the open world.

## Connection to the wider library

The §2.2 paper is the **specification-language groundwork** for everything that follows in this paper and for a body of follow-on work ([15], [16], [17], [18] in this paper's bibliography). Three threads to highlight:

1. **The `obeys`-as-hypothesis discipline echoes the §2 *paradigm regained* methodological turn**: capability security as *reasoning under uncertainty*. The paper does not ask *is `o` trustworthy?* (which is unanswerable); it asks *what holds if we hypothesise `o` is trustworthy?* and *what holds if we do not?*. Both branches contribute to the overall correctness proof.

2. **`MayAccess` is the formal version of the four-ways-to-acquire-references principle**: a reference to `p` from `o` arises only via the four-ways graph (parenthood, endowment, introduction, fabrication). The paper's §3.3 (`METH-CALL-2`) rule captures exactly this: after `v := x.m(y)`, any new reachability into `z` must be along a chain that was already reachable *before* the call from `x` or `y`. This is the *introduction* arm of the four-ways taxonomy made precise.

3. **`MayAffect` is the boundary that POLA enforces**: an object can affect only what it has authority to affect. The §3.3 (`FRAME-METHCALL`) rule shows the dual: if an effect happens at `z` (i.e. `MayAffect(z, A')`), then either `z` is the receiver / argument of the call, or `z` is in the *new* objects allocated by the call. This is the formal version of *only connectivity begets connectivity*.

## Translation block (paper idiom → contemporary Endo / Agoric surface)

| 2015 paper concept | Contemporary Endo / Agoric equivalent |
| ------------------ | ------------------------------------- |
| `obeys` as hypothetical trust predicate | The `harden`-and-Compartment discipline: a hardened object *may or may not* meet its informal contract; the consumer-side proof discharges the hypothesis by ground-truth-checking provenance (e.g. `assertCanonicalShape`) or by deferring to documented invariants. |
| `MayAccess` as transitive points-to closure | The pass-by-copy / pass-by-reference discipline in `@endo/marshal`: a reference reaches a remote vat *only* if it traverses a pre-existing introduction chain; capabilities cannot be forged or spontaneously generated. |
| `MayAffect` as bounded mutation | Harden's *immutability-by-default* combined with `WeakMap`-keyed private state: mutation channels are explicit and gateway-mediated; an alleged-trustworthy object cannot mutate arbitrary heap nodes. |
| Hypothetical multi-case verification | The Hardened JavaScript reasoning style: assume nothing about untrusted callees; bound the damage they could do; verify the local invariants hold *regardless* of callee behaviour. |
| Open world | The Endo formula graph: any vat can introduce any other vat at any time; trust is per-introduction, not per-deployment. |

## Implications for Endo / Agoric

This section is the **formal underpinning for the Hardened JavaScript trust discipline**. The library can cite this paper whenever:

1. **A design needs to formalize trust assumptions.** The `obeys` predicate is the canonical way to make a trust assumption *explicit* and *dischargeable* in a specification. Hardened JavaScript code makes the same assumption implicitly via *defensive consistency*; the §2.2 framing exposes the structure.
2. **A design needs to bound damage in the untrusted case.** `MayAccess` and `MayAffect` are the formal bounds: an untrusted callee can read what it can reach, mutate what it has affect-authority over. Both bounds are *static* properties of the pre-state, not runtime checks.
3. **A design discusses the open-world / closed-world distinction.** The §1 paper is the canonical statement of the open-world specification problem. The contemporary Endo / OCapN ecosystem is *paradigmatically* open-world: any vat may meet any other vat, no central authority assigns trust.
4. **A design needs to verify code *under* trust hypotheses.** The §2.2 multi-case discipline (one case per trust hypothesis, each contributing to the overall correctness proof) is the canonical reasoning style. Hardened-JavaScript review practice follows this discipline implicitly; making it explicit can sharpen review.

## See also

- [[object-capability]] — the §2.2 constructs are the spec-language formalization of the ocap model. *Only connectivity begets connectivity* (Miller PhD 2006 [30]) is the rule that justifies `MayAccess` as the transitive points-to closure.
- [[principle-of-least-authority]] — `MayAffect` is the POLA bound: an object can affect only what it has authority to affect.
- [[four-ways-to-acquire-references]] — `MayAccess` formalizes the *introduction* arm: a reference to `p` from `o` arises only along a chain that was already reachable before the call.
- [[smart-contract]] — the §1 paper motivates the methodology by pointing to smart-contract specification (specifically the escrow exchange). The §2.2 constructs are the spec-language groundwork; the §2.5-§2.6 application is the worked example.
- [[mint-purse-money]] — the §2.3 *ValidPurse* specification (the next section in this source) is the §2.2 constructs *applied* to formalize the Miller-Drexler mint-purse pattern.
- `papers--miller-vancutsem-tulloh-distributed-electronic-rights-2013--escrow-exchange-and-contract-host` — the escrow exchange this paper formalizes. The §2.2 constructs let us verify that the §5 escrow exchange of the 2013 paper is *not as strong* as originally thought; the §2.5 *deal_version2* is the revision.

## Common confusions

- **"`obeys` is a runtime check."** No. `obeys` is *hypothetical*. There is no runtime predicate `o.obeys(Spec)` that returns true or false. `obeys` is a verification-time assumption that the proof either discharges (by ground-truth provenance) or carries as a remaining hypothesis. An object that is *not* trusted by us is *not* `obey`ed in our reasoning; we still must bound the damage it could do.
- **"`MayAccess` requires reachability analysis."** It requires the *abstract* points-to relation, which is decidable in the formal model (the heap is a finite graph). In a real implementation, `MayAccess` is over-approximated by *what could conceivably happen* under the worst-case adversarial callee. The paper's §1 *Disclaimers* explicitly notes that quantification over the entire heap is part of the abstraction.
- **"`MayAffect` only covers writes."** It covers *any* observable effect a method call could have on a property — writes are the dominant case but throws, invalidations, and other observable mutations are also `MayAffect`-able. The paper's §1 Disclaimers notes that objects are assumed not to throw or breach encapsulation, which keeps `MayAffect` tractable; the realistic generalization requires additional cases.
- **"Hypothetical reasoning is just informal pondering."** No. The hypothesis is *formal* — it enters the proof as an antecedent of an implication. *If* `o obeys Spec` *then* the strong postcondition holds; *if not* then only the weak postcondition (the risk bounds) holds. Both branches are part of the overall theorem, not a hand-wave.
- **"This subsumes traditional specification languages."** Partially. Traditional specs are a *special case* of this paper's specs where every object's `obeys`-predicate is assumed true (closed world). The §2.2 framing is *strictly more expressive* than the traditional approach but requires more from the verifier: every untrusted-callee case must be handled.
- **"The paper claims to eliminate trust."** No. The paper makes trust *explicit*. The reduction is from *implicit-blanket-trust* (every object is trustworthy) to *case-by-case-explicit-trust* (each `obeys` hypothesis is discharged or carried). This is a *qualitative* improvement in the precision of specifications, not an elimination.
