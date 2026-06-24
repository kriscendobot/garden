---
title: Body
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
parent: papers--drossopoulou-reasoning-about-risk-and-trust-2015--trust-as-hypothetical-and-risk-via-may-access-may-affect
---

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
