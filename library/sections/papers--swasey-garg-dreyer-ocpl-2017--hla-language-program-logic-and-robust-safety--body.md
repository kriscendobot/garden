---
title: Body
source: "Robust and Compositional Verification of Object Capability Patterns (Long Version) (Swasey, Garg, Dreyer; OOPSLA 2017)"
source_kind: paper
source_authors: [David Swasey, Deepak Garg, Derek Dreyer]
source_year: 2017
source_venue: "OOPSLA 2017 (Long Version with full appendices) — Max Planck Institute for Software Systems (MPI-SWS), Saarland Informatics Campus"
source_url: https://papers.agoric.com/papers/robust-and-compositional-verification-of-object-capability-patterns/
source_pdf_sha256: e5e252f7895f94b56c1d40d102f668fb965710c249f0b44c1c417af2022e13ef
source_paper_pages: "1-9 (§1 Introduction + §2 Robust Safety and OCPL through §2.3 Metatheory)"
ingested: 2026-05-29
ingested_by: liaison-direct-draft
topics: [capability-security, capability-theory, hardened-javascript]
status: current
parent: papers--swasey-garg-dreyer-ocpl-2017--hla-language-program-logic-and-robust-safety
---

### §1 The readonly-pattern motivating example

The §1 paper opens with a worked example:

> Suppose you have a mutable reference `ℓ` whose contents you care about, meaning that you want to impose some invariant on it (e.g., `ℓ` always points to an even number). Suppose further that you want to share access to `ℓ` with code you did not write and that you do not trust to preserve the invariant on `ℓ`. To ensure the invariant on `ℓ` is maintained, you therefore do not want to pass the untrusted code the reference `ℓ` directly. Instead, you might construct a *read-only wrapper* `w` as follows:
>
> ```
> readonly ≜ λr. λ_. !r          w ≜ readonly ℓ
> ```
>
> Here, *readonly* transforms a reference `r` into a thunk that, when applied, returns the current contents of `r`. The expression `w` applies *readonly* to our reference of interest `ℓ`, constructing a function for reading `ℓ`'s contents. You can now pass `w` to untrusted code without worrying about it corrupting your invariant on `ℓ`.

The §1 framing names the pattern explicitly:

> Wrappers like `w` are often called *object capabilities*, and the wrapper construction function *readonly* is a very simple example of an *object capability pattern* (OCP) (Miller et al. 2000).

The §1 history cites the *Although OCPs date back at least to the 1970s (Morris 1973), they have gained increased currency in recent years* — naming the field's foundational papers including *Miller et al. 2000* (the cycle-75 *Capability-Based Financial Instruments* paper), Mettler et al. 2010 (Joe-E), Spiessens-Roy 2004, and *Stiegler-Miller 2006* (the *How Emily tamed the Caml* paper that cycle 85 had sought). The §1 framing also cites *Web sandboxing systems like Yahoo!'s ADSafe (Crockford 2008; Politz et al. 2014) and Google's Caja (Miller et al. 2008)*.

The §1 paper then names the central technical problem:

> Unfortunately, despite the ubiquity of OCPs in modern web programming, remarkably little attention has been paid to the question of what exactly are the security guarantees that such OCPs are supposed to provide, and how might we prove that they actually provide them. Even in the case of the extremely basic *readonly* pattern shown above, it is not at all obvious what is the "right" formal specification for *readonly*. What, in particular, are the formal conditions on `ℓ` that are needed to guarantee that *readonly ℓ* can be "safely" shared with untrusted code? If `ℓ` merely points to an integer, no conditions may be necessary, but what if `ℓ` points to a closure or some other higher-order object? How do we know that giving readonly access to `ℓ` will not indirectly give untrusted code a way of gaining full access and violating important invariants maintained by the user of this OCP?

The §1 framing closes with the paper's claim:

> In this paper, we present **OCPL** (a *L*ogic for *OCP*s), the first formal type system for *compositionally* specifying and verifying the security guarantees provided by OCPs, in the context of a simple but representative programming language with higher-order functions, state, and concurrency. In contrast to prior work, OCPL enables one to reason modularly about both OCP implementations and user code that depends on them, and to specify a general property on user code that ensures such code can be safely shared with untrusted code without having its internal invariants violated.

### §1 The *low-integrity value* concept

The §1 paper introduces the central technical device:

> The key idea in OCPL is how it characterizes the interface between verified user code and untrusted code, via the concept of a "low-integrity value" (or *low value* for short) adapted from the literature on verification of security protocols (Abadi 1999). Roughly speaking, a low value is a value that can be safely shared with untrusted code, such as the closure wrappers returned by OCPs. More precisely, a low value is a value from which no code can possibly extract a direct reference to private state. To formalize this notion, we employ a logical relation, which is easy to define using Iris's built-in support for guarded recursive predicates.

The structural reading:

- **Low values can be shared with untrusted code** — they carry no capability to high (private) state.
- **The definition is *logical-relational***: low-value-ness is a property of *what observations a value can support*, not a property of *the value's internal structure*. This is the *extensional* perspective.
- **Iris's guarded recursive predicates** let the logical relation be defined for arbitrary higher-order types (closures, sums, products, references).

The §1 paper proves the spec for the readonly pattern in low-value terms:

> ∀ℓ. {T} !ℓ {x. lowval x} ⇒ {T} readonly ℓ {f. lowval f}

The *if dereferencing `ℓ` always produces a low value, then `readonly ℓ` is itself a low value* spec. The premise lets the wrapper be safely shared because *anything the untrusted code can read from `readonly ℓ` is low*.

### §1 Robust safety — the meta-theorem

The §1 paper introduces the connecting meta-theorem:

> Next, we appeal to a general meta-theorem — and one of the main technical results of this paper — called *robust safety*. Robust safety states that, if some user code satisfies a spec like the one given above for *usetwo* — i.e., a spec whose postcondition stipulates that the resulting value is low-integrity — then we can run that verified user code under an arbitrary adversarial context `C` (i.e., any context `C` that does not *itself* contain any assert statements), and we will be assured that the execution of the resulting program will never result in a violation of any of the user code's internal assertions.

The §1 paper cites the prior-art lineage:

> Robust safety is a well-known meta-theorem in the security literature (Bengtson et al. 2011; Gordon and Jeffrey 2001), but it has not heretofore been employed in the context of object capability programming. One of the central contributions of this paper is the observation that robust safety is exactly the property a language must satisfy in order to support OCPs.

### §2.1 HLA — Higher-order with Locations and Assertions

The §2.1 paper defines HLA: a *call-by-value λ-calculus with recursive functions, products, sums, references, and fork-based concurrency*. *The one new feature in HLA, not present in [Krebbers et al.'s] calculus, is **assertion expressions***. `assert e`: if `e` evaluates to true, no effect; if false, *sets a `goodness bit` g to Fail*, irreversibly. The goodness bit is part of the machine state and tracks dynamic-assertion-failure.

The §2.1 explanation for the goodness-bit design:

> The reader may wonder why we employ a goodness bit instead of just saying that assert false gets stuck or aborts the program. The reason is simple: we wish to use OCPL to reason not only about fully verified code but also about the behavior of verified code when linked with untrusted code (which itself does not contain assertions). So it is important that we have a way of verifying Hoare triples even for code that may very well get stuck (i.e., fail to make progress) thanks to dynamic type errors introduced by the untrusted code. We nevertheless want to say that assert expressions in such code always succeed, so we must differentiate assert false from other stuck states.

The §2.1 design choice: **two failure modes need to be distinguished**:
- *Stuck* — the expression cannot reduce (e.g., dynamic type error). Acceptable for untrusted code.
- *Failed assertion* — the goodness bit is `Fail`. Verified code must avoid this even when linked with stuck-causing untrusted code.

The goodness bit lets OCPL separate these: a verified expression `{T} e {T}_p` *must* be progressive (does not get stuck) *and* must not flip the goodness bit; but a verified expression with a non-progressive triple `{T} e {T}` *may* get stuck (when linked with untrusted code) *but still* must not flip the goodness bit.

### §2.2 OCPL — the program logic

The §2.2 paper presents OCPL as *a Hoare-style program logic derived from Iris*. Hoare triples come in two flavors:

- **Progressive** `{P} e {x. Q}_p` — the expression *does not get stuck* and, if it terminates, the postcondition holds.
- **Non-progressive** `{P} e {x. Q}` — the expression *may* get stuck (no progress guarantee), but if it terminates, the postcondition holds.

The §2.2 framework adds *Iris's standard structural rules* (consequence, frame, monadic bind/return) and *rules for defining and enforcing logical protocols on physical and ghost state*. The new rules for HLA are *the basic rules for reasoning about head reductions and non-progressive triples for reasoning about stuck expressions*.

#### High vs low locations

The §2.2 paper introduces the central memory-classification distinction:

> OCPL divides memory locations (i.e., mutable references) into two types: *high-integrity* and *low-integrity* (or just high and low for short). High locations are locations that are private to user code, on which it may place invariants of its choosing, and to which untrusted code should not be given direct, unfettered access. Low locations are locations that may be freely shared with — and may in fact have been allocated by — untrusted code.

The §2.2 emphasis:

> Note that there is no distinction between high and low locations in the operational semantics of HLA; rather, this distinction is merely something we track in OCPL in order to formally specify the interface between user code and untrusted code.

The §2.2 framing's structural significance: **high/low is a *verification-time* distinction, not a *runtime* distinction**. The operational semantics treats all locations uniformly; the program logic divides them by intent. This is the *separation-logic-as-meaning-not-mechanism* discipline.

For *high locations* (Fig. 2a): the standard separation-logic *points-to* assertion `ℓ ↪ v` is used. For *low locations* (Fig. 2b): the new *lowloc ℓ* assertion is introduced. *In contrast to the points-to assertion for high locations, the assertion lowloc ℓ does not denote any ownership of ℓ because as soon as a location is considered safe to be shared with untrusted code, there is no way of knowing what that code will do with it.*

The §2.2 *lowloc* discipline: lowloc-ness is a *persistent* fact — once-low-always-low. The proof rules `AllocLow`, `LoadLow`, `StoreLow` allow the standard memory operations on low locations but with the looser guarantee that the contents may have changed since the last operation.

#### The `lift Ψ` logical relation — predicate-on-locations to predicate-on-values

The §2.2 paper introduces the core technical device:

> Lifting low locations to low values. We return now to the question of what it means for a *value* `v` to be low. Intuitively, a low value is one from which the language constructs of HLA provide no way to get direct access to any high location. This is fundamentally an *extensional* property, i.e., a property about the observations that a program can make (i.e., the information it can extract) when passed the value `v`. As such, for those readers familiar with classic techniques from program semantics, it will not come as a surprise that a natural way of formally accounting for this property is via a *logical relation*.

The Fig. 3 definitions:

```
lift Ψ (rec f x. e) ≜ ▷∀v. {lift Ψ v} e[v/x, rec f x. e/f] {y. lift Ψ y}_?
lift Ψ ℓ ≜ Ψ ℓ
lift Ψ lit ≜ T
lift Ψ () ≜ T
lift Ψ (v_1, v_2) ≜ (lift Ψ v_1 ∗ lift Ψ v_2)
lift Ψ (inl v) ≜ ▷lift Ψ v
lift Ψ (inr v) ≜ ▷lift Ψ v
```

The structural reading:

- **Function values** are low if their bodies preserve low-ness: *applied to a low argument, produce a low result*. The non-progressive Hoare triple is used because *f may be applied to arguments constructed by untrusted code* — those arguments are low by assumption, but f may get stuck on them due to dynamic type errors.
- **Locations** are low if `Ψ ℓ` holds — directly defers to the location predicate.
- **Literals and unit** are unconditionally low — no location can be extracted from them.
- **Products and sums** are low if their components are low — structurally recursive.

The `lowval v ≜ lift lowloc v` definition: a value is low iff every location reachable from it is low.

The *later* (▷) modality is structurally crucial: it makes the recursive definition well-founded over guarded recursion. OCPL inherits this from Iris's step-indexed model.

### §2.3 Metatheory — AdequacySafety + RobustSafety

The §2.3 paper presents two key meta-theorems. **AdequacySafety**: an expression verified with a progressive triple `{T} e {T}_p` from a good initial state stays good through all reachable states — no failed assertion. **RobustSafety**: the central novel result.

> **Theorem RobustSafety**: Let *AdvCtx* denote the set of HLA contexts containing neither locations nor assertions. If expression `e` is closed and has been verified to return only low values, then for every adversarial context `C`, on running `C[e]` from an initial state, we can observe that every reachable state is good (no assertions fail).
>
> `C ∈ AdvCtx`   `e closed`   `{T} e {x. lowval x}_p`   `(C[e]); (∅, OK) →* T'; (h', g')`
> ─────────────────────────────────────────────────────────────────────────────────
>                                  `g' = OK`

The §2.3 framing's structural significance:

> Robust safety captures our informal distinction between "user code" and "untrusted code". Both are written in HLA, but user code must be verified in OCPL and may contain assertion statements, whereas untrusted code need not be verified and is not permitted to contain assertion statements. Untrusted code may also not contain references to memory locations `ℓ`, since those are not part of the surface syntax of the language. The theorem says that verified user code can be linked with untrusted code, while remaining safe (i.e., its internal assertion statements will never assert false).

The §2.3 *entire metatheory has been verified formally in Coq* — `OCPL 2017` at `http://plv.mpi-sws.org/iris/`.
