---
title: Three OCPs verified compositionally — dynamic sealing (Morris 1973 sealer-unsealer with the intervals worked client); caretaker (API caretaker + location caretaker; revocable access); membrane (recursive instantiation lifting location-transformations to value-transformations; the public membrane that wraps Caja's language-invariants pattern with shadow locations)
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
---

## Abstract

§3 *Dynamic Sealing* applies OCPL to verify the canonical Morris 1973 sealer-unsealer pattern: `makeseal()` returns a pair `(seal, unseal)` such that `seal v` produces an opaque low-integrity proxy `v'` for `v`, and `unseal v'` recovers `v` if (and only if) `v'` was produced by *seal*. The §3 worked client is the **intervals library**: `intervals = λ_. let (seal, unseal) = makeseal() in let makeint = λn₁ n₂. seal (if n₁ ≤ n₂ then (n₁, n₂) else (n₂, n₁)) in let imin = λi. fst (unseal i) in let imax = λi. snd (unseal i) in let isum = λi. λj. let x = unseal i in let y = unseal j in seal (fst x + fst y, snd x + snd y) in (makeint, imin, imax, isum)`. The §3 OCPL specification for dynamic sealing (Fig. 5) introduces six rules: `MakeSealSpec`, `SealSpec`, `UnsealSpec`, `UnsealAnySpec`, `SealedInv`, `SealedAgree` — the assertions `isseal γ s φ` (s is the seal function for sealer-unsealer pair *γ* with representation invariant φ), `isunseal γ u φ` (dual for unseal), `issealed γ v v' φ` (v' is a low-integrity proxy for v under pair γ with invariant φ). The §3 design preserves the *representation-invariant* φ: any value sealed under γ satisfies φ; any value unsealed under γ returns to a φ-satisfying value (`SealedInv`); two sealed-low-values for the same pair γ with the same proxy v' agree on the underlying value (`SealedAgree`). The §3 *intervals* client is verified robustly safe: even when untrusted code calls `imin j ≤ imax j` for arbitrary `j`, the dynamic unsealing either fails (assumption failure, the verified code's safe response) or succeeds (proving j is a valid sealed interval and thus the assertion holds). §4 *Caretaker* implements two layered patterns: **API caretaker** (`makecaretaker()` returns `(sync, enabled)` plus three operations `wrap f` / `enable` / `disable` for wrapping any function so the wrapped version *behaves like f when enabled, gets stuck when disabled*) and **location caretaker** (built on top of API caretaker; provides revocable-access to a high-integrity location). The §4 specification uses the API caretaker to *temporarily break the invariant* on a high-location, secure in the knowledge that disable-then-restore-invariant-then-enable preserves the invariant from the untrusted code's perspective. §5 *Membrane* generalizes the per-pattern approach: a *membrane* is a function `(locout, locin) → (membrane locout locin)` that lifts a *location-to-location transformation* `locout` (and its dual `locin`) to a *value-to-value transformation* via recursive instantiation. The `ismon p v Ψ₁ Ψ₂` predicate (Fig. 9) says *v is a function that transforms values satisfying Ψ₁ to values satisfying Ψ₂*. The §5 `MembraneSpec` reads: *if locout transforms locations satisfying Ψ₁ to values satisfying Ψ₂, then `membrane locout locin` transforms values satisfying lift Ψ₁ to values satisfying lift Ψ₂*. The §5 **public membrane** (Fig. 10) is the canonical worked example — a membrane that maintains a unique low-integrity *shadow location* for every high-integrity location the verified code declares as important. This is the *language-invariants* membrane in Google's Caja library (Miller et al. 2008; Google, Inc. 2015) — the pattern that lets a library export an old API while internally introducing new invariants without breaking compatibility with existing clients.

## Body

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

## Connection to the wider library

This section is the **canonical formal-verification of three OCPs at the program-logic level**. Three threads:

1. **The dynamic-sealing-with-representation-invariant pattern** generalizes beyond OCPL. The §3 spec structure (`isseal γ s φ` / `isunseal γ u φ` / `issealed γ v v' φ` / `SealedInv` / `SealedAgree`) is reusable for any sealer-unsealer-style abstraction.

2. **The caretaker-as-temporary-invariant-break pattern** is reusable for any code that wants to make non-atomic updates while exposing access to untrusted clients. *Disable → break-invariant → restore → enable* lets the verified code modify high-integrity state without exposing the intermediate state to untrusted observers.

3. **The membrane-as-value-transformation-lift pattern** is the deepest. *Any* location-to-location transformation can be lifted to a value-to-value transformation by recursive instantiation. The public-membrane variant is the *backward-compatibility-preserving* discipline that lets a library introduce internal invariants without breaking existing clients.

## Translation block (paper idiom → contemporary surface)

| 2017 paper concept | Contemporary surface |
| ------------------ | -------------------- |
| Dynamic sealing with representation invariant φ | Agoric ERTP's *Issuer*-as-Sealer + *Purse*-as-Unsealer; the brand is the γ; the *amount* type is the φ. |
| Sealer-unsealer for data abstraction | The contemporary `WeakMap`-keyed private state in `@endo/exo`; the WeakMap is the table; the key is the proxy. |
| API caretaker | The Agoric *governance* pattern of revocable capabilities. |
| Location caretaker | The `harden` + reference-counted-revoke pattern. |
| Membrane lifting | The `@endo/marshal` + `@endo/captp` *Remotable* + transparent-proxy discipline. |
| Public membrane = Caja language-invariants membrane | The contemporary `taming-membrane.js` in Google Caja. |
| Backward-compatible invariant via shadow location | The contemporary upgrade discipline: introduce new invariants behind a wrapper without breaking the old API surface. |

## See also

- [[capability-security]] (topic) — OCPL's three OCPs map directly to contemporary capability-security patterns.
- [[capability-theory]] (topic) — the formal-Hoare-style program logic for OCPs joins cycle-85's Drossopoulou Hoare-logic and cycle-91's Taly Datalog analysis.
- [[hardened-javascript]] (topic) — HLA's representation of OCPs in a generic higher-order concurrent language; HardenedJS is the contemporary realization.
- `papers--swasey-garg-dreyer-ocpl-2017--hla-language-program-logic-and-robust-safety` — the prior section: the OCPL foundation that this section's specifications build on.
- `papers--swasey-garg-dreyer-ocpl-2017--related-work-iris-foundation-and-future-firefox-membrane` — the third section: how OCPL relates to prior work + Iris foundations + Firefox same-origin-policy membrane future work.
- `papers--miller-vancutsem-tulloh-distributed-electronic-rights-2013--escrow-exchange-and-contract-host` — the cycle-82 escrow exchange uses dynamic sealing for the contract participation tokens; OCPL could verify the §6 Contract Host pattern.
- `papers--miller-morningstar-frantz-capability-based-financial-instruments-2000--pluribus-rights-taxonomy-and-covered-call-option` — the canonical Mint pattern that §3 verifies as conservation-of-currency.
- `papers--taly-automated-analysis-of-security-critical-javascript-apis-2011--applications-adsafe-vulnerability-sealer-unsealer-and-mint` — cycle-91's Taly et al verified the *same* three OCPs (Sealer-Unsealer, Mint) using ENCAP's static Datalog analysis. OCPL's program-logic approach is the program-logic complement to Taly's static-analysis approach.

## Common confusions

- **"The intervals client's robust safety is obvious."** It would be obvious *if* one could trust untrusted code to pass real interval handles. But untrusted code can pass *anything*. The robust-safety argument is that *even when arbitrary garbage is passed*, the verified code either (a) gets stuck (via assume-failure on unseal) or (b) succeeds with a verified-interval, never (c) silently corrupts. The proof relies on UnsealAnySpec's *may-get-stuck* triple semantics.
- **"The caretaker's disable is racy with the wrap call."** The `sync` lock serializes them. Even if disable and wrap-call happen concurrently, the sync lock makes them mutually exclusive: either disable wins (and the wrap-call sticks on `assume(!enabled)`) or the wrap-call wins (and disable waits for it to finish). The verified code's invariant survives either ordering.
- **"The membrane is just a wrapper."** It is a *recursive* wrapper that lifts location-transformations to value-transformations. Simple wrappers (per the readonly motivating example) handle individual references; the membrane handles *all values transitively reachable from a wrapped value*. The recursive-instantiation structure is what makes the membrane powerful.
- **"The public membrane breaks encapsulation."** It *preserves* encapsulation through the shadow-location indirection. From the client's perspective, the shadow location is *the* location; from the library's perspective, the shadow is mediated and can be re-aligned with the private location whenever the invariant should be restored. The encapsulation is *bidirectional* (writes propagate via `pubunwrap` + checks; reads propagate via `shadowread` + invariant-check).
- **"OCPL can verify Caja itself."** OCPL verifies *patterns* (sealer-unsealer, caretaker, membrane). Caja is a *language sandbox* that uses these patterns. Verifying Caja proper would require modeling Caja's broader semantics (JSLint filter, ADSafe runtime, etc.) — out of scope for the OCPL paper but tractable as future work.
- **"The intervals interval ordering is not preserved across untrusted code."** The proof shows the ordering *is* preserved as long as the unseal calls succeed. If untrusted code passes a non-interval value, the *unseal* gets stuck before any ordering check happens — the verified-code-side invariants never see the bad value.
