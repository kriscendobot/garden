---
title: Body
source: "Robust and Compositional Verification of Object Capability Patterns (Long Version) (Swasey, Garg, Dreyer; OOPSLA 2017)"
source_kind: paper
source_authors: [David Swasey, Deepak Garg, Derek Dreyer]
source_year: 2017
source_venue: "OOPSLA 2017"
source_url: https://papers.agoric.com/papers/robust-and-compositional-verification-of-object-capability-patterns/
source_pdf_sha256: e5e252f7895f94b56c1d40d102f668fb965710c249f0b44c1c417af2022e13ef
source_paper_pages: "9-22 (§3 Dynamic Sealing + §4 Caretaker + §5 Membrane)"
ingested: 2026-05-29
ingested_by: liaison-direct-draft
topics: [capability-security, capability-theory, hardened-javascript]
status: current
parent: papers--swasey-garg-dreyer-ocpl-2017--three-ocps-verified-dynamic-sealing-caretaker-membrane
---

### §3 Dynamic Sealing — sealer-unsealer pattern

The §3 paper opens with the Morris 1973 motivation:

> We now consider one of the oldest and most influential OCPs: *dynamic sealing*, also called the sealer-unsealer pattern. Originally proposed by Morris (1973), dynamic sealing makes it possible to support data abstraction in the absence of static typing.

The §3 *functionality of dynamic sealing*:

> Morris (1973) introduced dynamic sealing to enforce data abstraction while interoperating with untrusted, potentially ill-typed code. He stipulated a function *makeseal* for generating pairs of functions (*seal*, *unseal*), such that (i) for every value v, *seal v* returns a value v' serving as an *opaque, low-integrity proxy* for v; and (ii) for every value v', *unseal v'* returns v, if v' was produced by *seal v*, and otherwise gets stuck.

#### The intervals worked client

The §3 paper uses the **intervals library** to make dynamic sealing concrete. Let `[n₁, n₂]` denote the set `{n₁, n₁+1, …, n₂-1, n₂}`. The intervals library represents an interval `[n₁, n₂]` as the *sealed* pair `(n₁, n₂)` — internal representation kept private even when interval handles flow to untrusted code.

```
intervals = λ_. let (seal, unseal) = makeseal() in
              let makeint = λn₁ n₂. seal (if n₁ ≤ n₂ then (n₁, n₂) else (n₂, n₁)) in
              let imin = λi. fst (unseal i) in
              let imax = λi. snd (unseal i) in
              let isum = λi. λj. let x = unseal i in let y = unseal j in
                                  seal (fst x + fst y, snd x + snd y)
              in (makeint, imin, imax, isum)
```

The §3 design's structural insight:

> Notice that *seal* and *unseal* are kept private to the *intervals* implementation, which means it can enforce that the only values sealed with *seal* are pairs (n₁, n₂) representing intervals (i.e., where n₁ ≤ n₂). Consequently, the *imin* (resp. *imax*) function can simply return the first (resp. second) component of its argument after unsealing it, because it *knows* that, even if the argument comes from untrusted code, *so long as the unsealing succeeds*, the resulting value will be a pair where the first (resp. second) component represents the lower (resp. upper) bound of that input interval.

The §3 *data abstraction* claim: dynamic sealing provides *data abstraction even when interfacing with untrusted code, at the cost of some simple dynamic checks at the boundaries of the abstraction*.

#### Implementation of dynamic sealing in HLA

```
makeseal ≜ λ_. let tbl = ref mapempty in
              let sync = makesync() in
              let seal = λx. let k = ref () in
                              sync(λ_. tbl ← mapinsertnew (!tbl) k x); k in
              let unseal = λk. assume (isloc k);
                                sync(λ_. maplookup (!tbl) k) in
              (seal, unseal)
```

The §3 implementation uses:
- A *fresh* low-integrity location `k` per sealed value, serving as the *proxy*.
- A *private* high-integrity table `tbl` mapping each proxy back to its underlying value.
- A lock `sync` to serialize concurrent `seal` and `unseal` calls.
- An `assume` (C-style assertion that *gets stuck* if false, vs `assert` that flips the goodness bit) to validate the proxy is a location before lookup.

The §3 framing of `assume`:

> The expression `assume e` resembles a C- or Java-style assertion: it returns unit if e evaluates to true; otherwise, it gets stuck.

#### §3 The OCPL specification (Fig. 5)

The §3 specification introduces six rules:

| Rule | Statement | Role |
|---|---|---|
| `MakeSealSpec` | `{T} makeseal() {v₁ v₂ γ. ret (v₁, v₂). isseal γ v₁ φ ∗ isunseal γ v₂ φ}` | Allocate fresh sealer-unsealer pair γ with representation invariant φ. |
| `SealSpec` | `{isseal γ s φ ∗ φ v} s v {x'. issealed γ v x' φ}` | Sealing requires φ holds on v; produces a sealed-low-value. |
| `UnsealSpec` | `{isunseal γ u φ ∗ issealed γ v v' φ} u v' {ret v. T}` | Unsealing a known-sealed-value returns the underlying. |
| `UnsealAnySpec` | `{isunseal γ u φ} u v {x. issealed γ x v φ}_?` | Unsealing arbitrary value: may get stuck, or returns the underlying value satisfying φ. |
| `SealedInv` | `issealed γ v v' φ ⊢ φ v` | Sealed values satisfy the representation invariant. |
| `SealedAgree` | `issealed γ v₁ v' φ ∗ issealed γ v₂ v' φ ⊢ v₁ = v₂` | The seal is functional: two underlying values agreeing on the proxy must be equal. |

Plus three *low values* rules:

| Rule | Statement |
|---|---|
| `SealedLow` | `issealed γ v v' φ ⊢ lowval v'` |
| `SealLow` | `(∀v. lowval v ⊢ φ v) ⊢ isseal γ s φ ⊢ lowval s` |
| `UnsealLow` | `(∀v. φ v ⊢ lowval v) ⊢ isunseal γ u φ ⊢ lowval u` |

The structural insight: **sealed values are *always* low** (`SealedLow`); the seal and unseal functions are *conditionally* low — they are low *if* the representation invariant φ is *both* a low-value-implication direction. Specifically, *seal* is low when *every low value satisfies φ* (so untrusted code can't construct a non-φ-satisfying value to seal); *unseal* is low when *every φ-satisfying value is low* (so untrusted code can't unseal to obtain a high value).

The §3 framing emphasizes:

> Crucial to the soundness of these rules is the fact that the seal function used internally by *intervals* is *not* shared with untrusted code (i.e., not low): according to rule `SealLow`, in order for seal to be treated as low, the representation invariant φ would have to be satisfied by all low values, which it clearly is not.

#### §3 Robust safety of the intervals client

The §3 paper closes with the robust-safety proof for the intervals client:

```
client ≜ let cap = intervals() in
         let (makeint, imin, imax, isum) = cap in
         let check = λj. assert (imin j ≤ imax j) in
         (check, cap)
```

The §3 framing: *intuitively, even if `client` is shared with untrusted code, this assertion must always succeed, because if the applications of imin and imax do not get stuck, it means that j is a proper interval value, whose lower bound is ≤ its upper bound*.

The §3 proof outline:

1. Use the intervals spec to prove `{T} client {x. lowval x}` (the client returns a low value).
2. The proof's key step shows that the assertion in `check` succeeds for arbitrary j via `MinAnySpec`, `MaxAnySpec`, `IntervalAgree`, and `IntervalInv`.
3. Appeal to **RobustSafety** from §2.3 — *which implies that the assertion in check will not fail, even when client is linked with untrusted code*.

### §4 Caretaker — revocable access

The §4 paper opens with the caretaker pattern:

> Next, we consider another well-known OCP, the *caretaker* pattern (Miller and Shapiro 2003; Miller 2006). This OCP allows verified (trustworthy) code to grant untrusted code access to a high-integrity resource (a high-integrity location or an API that modifies high-integrity locations), and subsequently disable or enable the access at any time.

The §4 design's two layers:

1. **API caretaker** — wraps any set of functions so they can be uniformly enabled or disabled.
2. **Location caretaker** — built on top of API caretaker; provides revocable access to a high-integrity location.

#### §4 API caretaker

```
makecaretaker ≜ λ_. let enabled = ref false in
                    let sync = makesync() in
                    (sync, enabled)
wrap ≜ λ(sync, enabled) f x. sync(λ_. assume (!enabled); f x)
enable ≜ λ(sync, enabled). sync(λ_. enabled ← true)
disable ≜ λ(sync, enabled). sync(λ_. enabled ← false)
```

The §4 framing's structural insight:

> The caretaker pattern is useful when the verified code wants to ensure that the untrusted code can access the resource only while some invariant holds. Disabling the caretaker allows the verified code to temporarily break the invariant, secure in the knowledge that untrusted code won't be able to access the resource until the caretaker is re-enabled.

This is the **temporary-invariant-break pattern**: a verified function that wants to make a non-atomic update to a high-integrity location can `disable` access from untrusted clients, perform the update (during which the invariant may temporarily not hold), then `enable` access. From the untrusted client's perspective, *the invariant always holds* because *the client cannot observe any state during which it does not*.

#### §4 Location caretaker

The §4 paper builds the location caretaker on top of the API caretaker:

> To use this interface, verified code creates a caretaker ct and holds it privately. It can then wrap any number of API functions using *wrap* and disclose the wrapped functions to untrusted code. The untrusted code's access to all those functions can be simultaneously disabled and enabled by calling *disable ct* and *enable ct*, respectively.

The §4 worked client establishes robust safety: the verified code holds the caretaker; the wrapped-read and wrapped-write functions are exposed to untrusted code; the verified code's invariant `the location always points to an even number` is maintained because the caretaker is disabled whenever the location is temporarily odd.

### §5 Membrane — recursive value-transformation

The §5 paper generalizes the per-pattern approach to a *value-transformation* operation: a membrane `membrane locout locin` lifts location-to-location transformations to value-to-value transformations via recursive instantiation. The structural setup:

```
membrane ≜ λ_. λlocout. λlocin. ...
unwrap ≜ memb locin locout  // recursive instantiation in untrusted-to-verified direction
```

The §5 *membrane specification* (Fig. 9):

```
ismon p v Ψ₁ Ψ₂ ≜ ∀a. {Ψ₁ a} v a {a'. ret a'. Ψ₂ a'}_p

MembraneSpec:
{ismon p locout Ψ₁ Ψ₂ ∗ ismon p' locin Ψ₂ Ψ₁}
  membrane locout locin
{w. ismon p w (lift Ψ₁) (lift Ψ₂)}
```

The §5 *ismon* predicate reads *v is a function (with progress bit p) that transforms values satisfying Ψ₁ to values satisfying Ψ₂*. The MembraneSpec lifts this *at the location level* to the *value level* via `lift Ψ`.

The §5 framing's structural significance:

> The specification of *membrane* says that if locout transforms locations satisfying Ψ₁ to values satisfying Ψ₂ and locin does the reverse, then *membrane locout locin* transforms values satisfying lift Ψ₁ to values satisfying lift Ψ₂, where lift is the predicate transformer defined in Fig. 3. Hence, *membrane* really "lifts" the transformation on locations to a transformation on values in a precise technical sense.

The §5 generality:

> This specification of *membrane* is very general, since it holds for any predicates Ψ₁ and Ψ₂. In any use of *membrane*, these predicates can be instantiated to match what the arguments locout and locin do.

#### §5 Public membrane — Caja's language-invariants pattern

The §5 paper specializes the membrane to the **public membrane** — *similar to the membrane used in Google's Caja library (Miller et al. 2008; Google, Inc. 2015)*. The public membrane *maintains a unique low-integrity shadow location for every high-integrity location that the verified code declares as important*.

The §5 worked use-case is the *backward-compatible library invariant* problem:

> Consider a library that allocates an integer reference `ℓ`, and shares it with (untrusted) clients as an I/O buffer. Clients are expected to write only positive integers to `ℓ`, although the library does not strictly require this and the library's algorithms can execute safely even if the integer is not positive. Over time, many clients of this library have been written. Now, suppose the library is updated to use different algorithms that *really require ℓ to always be positive* (else they crash). The obvious way to do this would be to rewrite the library to hold `ℓ` private, and to export two closures that read and write `ℓ`, the latter only after checking that the value being written is positive. However, this change *breaks compatibility with all existing clients*, since they must now be rewritten to invoke the new closures to access `ℓ`.

The §5 *public membrane solution*:

> The public membrane offers a general solution to this problem. Rather than export closures, the library can deploy a public membrane and declare `ℓ` as high-integrity. The membrane consistently replaces `ℓ` with a low-integrity shadow, say `ℓ'`, for the library's clients. *Importantly, the library's clients don't have to change.* After a client updates `ℓ'` (believing that it updated `ℓ`), the library can access `ℓ'` using *shadowread* and copy it to `ℓ` if the updated value is a positive integer. Additionally, whenever the library updates `ℓ` internally, it can also copy the update to `ℓ'` using *shadowwrite*. This way, the library can maintain its new invariant *and* retain complete compatibility with existing clients.

The §5 public membrane API (Fig. 11):

| Rule | Statement | Role |
|---|---|---|
| `MakePubSpec` | `{T} makepub() {m γ. ret m. ismembrane γ m}` | Allocate a fresh public membrane. |
| `PubAllocSpec` | `{ismembrane γ m ∗ isprivval γ v} pubref m v {ℓ. ret ℓ. isprivloc γ ℓ ∗ ℓ ↪ v}` | Allocate a fresh private location with a shadow. |
| `PubWrapSpec` | `{ismembrane γ m ∗ isprivval γ v₁} pubwrap m v₁ {x₂. lowval x₂}` | Wrap a private value for untrusted exposure. |
| `PubUnwrapSpec` | `{ismembrane γ m ∗ lowval v₂} pubunwrap m v₂ {x₁. isprivval γ x₁}_?` | Unwrap an untrusted value back to private (may get stuck). |
| `ShadowReadSpec` | `{ismembrane γ m ∗ isprivloc γ ℓ} shadowread m ℓ {x. isprivval γ x}_?` | Read the shadow location's current low-integrity contents. |
| `ShadowWriteSpec` | `{ismembrane γ m ∗ isprivloc γ ℓ ∗ isprivval γ v} shadowwrite m ℓ v {ret (). T}` | Write to the shadow location, low-integrity. |

The §5 *public membrane* is the *generalized solution* to the *backward-compatible-invariant* problem: *the library can deploy a public membrane and declare `ℓ` as high-integrity; the membrane consistently replaces `ℓ` with a low-integrity shadow `ℓ'` for the library's clients*.
