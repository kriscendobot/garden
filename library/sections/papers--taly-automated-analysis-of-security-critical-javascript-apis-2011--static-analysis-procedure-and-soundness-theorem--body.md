---
title: Body
source: "Automated Analysis of Security-Critical JavaScript APIs (Taly, Erlingsson, Mitchell, Miller, Nagra, IEEE S&P 2011)"
source_kind: paper
source_authors: [Ankur Taly, Úlfar Erlingsson, John C. Mitchell, Mark S. Miller, Jasvir Nagra]
source_year: 2011
source_venue: "IEEE Symposium on Security and Privacy 2011"
source_url: https://papers.agoric.com/papers/automated-analysis-of-security-critical-javascript-apis/
source_pdf_sha256: 4457eafac35c129dac26fdf163710a1f89b63b0d9a4ba1bc6378fa318c4bec95
source_paper_pages: "3-12 (§3 The Language SES_light through §5 Analysis Procedure)"
ingested: 2026-05-29
ingested_by: liaison-direct-draft
topics: [capability-security, capability-theory, hardened-javascript]
status: current
parent: papers--taly-automated-analysis-of-security-critical-javascript-apis-2011--static-analysis-procedure-and-soundness-theorem
---

### §3 SES_light's formal operational semantics — *standard store, no prototype on scope objects*

The §3 paper presents SES_light as a clean small-step operational semantics. The syntax (Figure 2):

```
Variables and Values:
  (Loc)   l   ::=  l_g | l_obj | l_oProt | ... | null | l_1 | ...
  (PVal)  pv  ::=  num | str | bool | undef       primitives
  (Val)   v   ::=  l | pv | TypeError | RefError  values
  (FVal)  fv  ::=  function x(y){s}               function values
  (A)     a   ::=  $All | $Num | ...              annotations
  (Vars)  x,y ::=  this | foo | bar | ...         user-variables

Expressions:
  (Exps)  e   ::=  x | v

Statements:
  (Stmts) s ::= y = e
              | y = e_1 binop e_2
              | y = unop e
              | y = e_1[e_2, a]                  load
              | e_1[e_2, a] = e_3                store
              | y = {x : e}                       object literal
              | y = [e_i]                          array literal
              | y = e(e_i)                        call
              | y = e[e_1, a](e_i)                invoke
              | y = new e(e_i)                    new
              | y = function x(z̄){s}              function expression
              | function x(z̄){s}                  function declaration
              | eval(e, str)                       eval
              | return e | var x | throw e
              | s; t | if (e) then s [else t]
              | while (e) s | for (x in e) s
              | try {s_1} catch (x) {s_2} finally {s_3}
              | N | Th(v) | Ret(v)                end
```

Notable design choices:

- **A-normal form**: every value is a primitive or a variable; complex expressions use temporary variables. This makes the operational rules per-statement-kind tractable.
- **Property annotations** like `$Num` and `$Native` are *optional* hints attached to property lookups; they indicate a bound on the set of string values the expression `e_2` can evaluate to. Used for analysis precision.
- **Eval has a second argument** `str` — the explicit set of free variables (per the §2.B variable-restricted-eval discipline).

The §3 paper defines **heaps and stacks** (Figure 3):

```
Closure := FVal × Stacks
RVal := (Val) × 2^Attr ∪ {⊥}
Records R := Vars → RVal
Objects o := Records ∪ (Records × Closure)
Stacks A, B := [Records]
Heaps H, K := Loc → Objects
```

Where `Attr := writable | configurable | enumerable` are the standard ES5 property attributes. Function objects are *pairs of property-records and closures* (the closure carries the function's syntax + its lexical-scope chain); non-function objects are just property-records.

The §3 paper notes the semantics is *similar to* the Maffeis-Mitchell-Taly 2008 semantics [22] *but* differs in one key respect:

> The main technical difference in the structure of our semantics and the one by Maffeis et al is that we model scope objects using the standard store data structure and not as first class objects. This simplification was possible due to the more standard scoping semantics of ES5S.

The *standard-store-no-first-class-scope-objects* simplification is what ES5S's *no-prototype-on-scope-objects* restriction enables. The semantics is correspondingly simpler and statically analyzable.

The §3 paper closes with **prototype-property-lookup and variable-resolution rules**:

```
                Lookup(H, [R, A], x) = v
        ──────────────────────────────────────  (when x ∈ R)
                Lookup(H, [R, A], x) = v

                ¬HasProp(H, l_g, x)
        ──────────────────────────────────────  (when x ∉ R)
                Lookup(H, [], x) = RefError

                x ∉ dom(R)
        ──────────────────────────────────────
                Lookup(H, [R, A], x) = Lookup(H, A, x)

                HasProp(H, l_g, x)
        ──────────────────────────────────────
                Lookup(H, [], x) = Proto(H, l_g, x)
```

The first three rules walk the activation-record chain looking for the variable; the fourth rule falls back to global-scope lookup via the prototype chain on the global object. The structure is *standard lexical-chain lookup with global fallback*.

### §4 The API Confinement Problem — labeled semantics + Confinement Property

#### §4 Labeled semantics

The §4 paper *labels* all nodes of the SES_light syntax tree with *unique labels* (allocation-site labels):

> Labels are also attached to heap locations and stack frames, based on the term whose evaluation created them. All rules `H, A, t → K, B, s` are augmented so that any allocated location or activation record carries the label of term `t` and also any dynamically generated sub-term of `s` carries the label of term `t`. Finally, unique labels are attached to all locations on the initial heap H_0.

The *propagating-labels-through-execution* discipline is the *track-the-allocation-site* property: each object in the heap carries the syntactic-allocation-site label that produced it. Two objects allocated by the same source-code expression in different calls carry the *same* label; objects allocated by different source-code expressions carry *different* labels.

**Theorem 1 (Renaming preserves bisimilarity)**:

> For all wellformed states `S`, `Rn(Tr(S)) = Tr(Rn(S))`.

Proof sketch: induction on trace length; the inductive case uses case analysis on the set of reduction rules.

The theorem is the *static-bound-variable-renaming is semantically faithful* property — α-renaming the source code produces an executable that traces through *bisimilar* states. This justifies the assumption that the analyzer can freely rename bound variables for clarity without changing the program's confinement behavior.

#### §4.B Problem Definition — Confine(t, P)

The §4.B paper sets up the formal Confinement Property:

> In accordance with the API+Sandbox mechanism, the hosting page code runs first and creates an API object, which is then handed over to the untrusted code that runs next. The hosting page code is called the *trusted API service*. We assume for simplicity that the hosting page code stores the API object in some shared global variable `api`. In order for this mechanism to be secure, untrusted code must be appropriately restricted so that the only trusted code global variable it has access to is `api`. Using the variable-restricted SES_light eval, it is straightforward to restrict any term s to that using temporary variables, all complex statements from ES5S, except setters/getters and eval, can be re-written into semantics-preserving normalized statements.

The test setup:

> In order to set up the confinement problem we also provide untrusted code access to a global variable `un`, which is used as a *test variable* in our analysis and is initially set to *undefined*. The objective of untrusted code is to store a reference to a forbidden object in it. Without loss of generality, we assume that the API service t is suitably-α-renamed according to the procedure in definition 2 so that it does not use the variable `un`.
>
> In summary, if t is the trusted API service and s is the untrusted code then the overall program that executes in the system is t; var un; eval(s, "api", "un"). Informally, the API confinement property can be stated as: for all terms s, the execution of `t; var un; eval(s, "api", "un")` with respect to the initial heap-stack `H_0, A_0` never stores a forbidden object in the variable `un`.

The structural framing is *the attacker tries to store a forbidden object in `un`; the API safely confines the resources iff no attacker can ever succeed*.

**Definition 4 (Confinement Property)**:

> A trusted service `t` *safely encapsulates* a set of property-allocation-site labels `P` iff `PtsTo(un, Reach(S_0(t))) ∩ P = ∅`. We denote this property by `Confine(t, P)`.

The property reads: *the points-to set of `un` over all reachable states from the initial states starting at trusted service `t` does not intersect the forbidden-labels set `P`*. The labels in `P` are the allocation sites of the *security-critical* objects; the property says *the attacker cannot reach any of them*.

### §5 Analysis Procedure — Datalog-based points-to with soundness

The §5 paper adopts a *flow-insensitive context-insensitive Datalog-based points-to analysis*:

> The main technique used in our verification procedure is a conventional context-insensitive and flow-insensitive points-to analysis. We analyze the API implementation and generate a conservative Datalog model of all API methods. We encode an attacker as a set of Datalog rules and facts, whose consequence set is an abstraction of the set of all possible invocations of all the API methods.

The Datalog relations (Figure 4):

```
Relations for encoding programs:
  Assign : 2^{V×V}
  Load : 2^{V×V×V}
  Store : 2^{V×V×V}
  FormalArg : 2^{L×I×V}
  FormalRet : 2^{L×V}
  Instance : 2^{V×V}
  ArrayType : 2^L
  Actual : 2^{V×V×I×V×L}
  Throw : 2^{L×V}
  Catch : 2^{L×V}
  Global : 2^V
  Annotation : 2^{V×V}
  ObjType : 2^L
  FuncType : 2^L
  NotBuiltin : 2^L

Relations for encoding the heap-stack:
  Heap : 2^{L×V×L}
  Prototype : 2^{L×L}
  Stack : 2^{V×L}
```

The encoding `Enc_T(s, l̂)` of statement `s` at scope `l̂` translates SES_light statements into Datalog facts. Notable rules:

- **Function declaration / call** produces `FormalArg` facts mapping argument positions to variables, and `Actual` facts mapping call-site argument positions to actual variables.
- **Property load / store** produces `Load` and `Store` facts.
- **Built-in objects + DOM**: encoded as Datalog facts about the initial heap with allocation-site labels; rules over `Actual` facts capture method semantics.

The inference rules (Figure 6) define the *consequence closure* of the Datalog database:

```
[ASSIGN]
  Stack(x, l) ← Stack(y, l), Assign(x, y)

[LOAD]
  Stack(x, n) ← Load(x, y, f), Prototype(l, m), Heap(m, f, n), Stack(y, l)

[STORE1]
  Heap(l, f, m) ← Store(x, f, y), Stack(x, l), NotBuiltin(l), Stack(y, m)

[STORE2]
  Store(x, a, y) ← Store(x, f, y), Annotation(f, a)

[STORE3]
  Store(x, f, y) ← Store(x, a, y), Annotation(f, a)

[ANNOTATION]
  Annotation(f, $All)

[TP1]   Actual(n, "t", x, $dump, k) ← TP(x, k), Stack(x, l), Prototype(l, m), Heap(m, "toString", n), FuncType(n)
[TP2]   Actual(n, "t", x, $dump, k) ← TP(x, k), Stack(x, l), Prototype(l, m), Heap(m, "valueOf", n), FuncType(n)

[ACTUAL1]
  Assign(f, i, z, x, k) ← Actual(f, i, z, x, k), Stack(f, l), FormalArg(l, i, y)

[ACTUAL2]
  Assign(x, y) ← Actual(f, l, z, x, k), Stack(f, l), FormalRet(l, y)

[ACTUAL3]
  Throw(k, x) ← Actual(f, l, y, z, k), Stack(f, l), Throw(l, x)

[PROTOTYPE1]
  Prototype(l, l)

[PROTOTYPE2]
  Prototype(l, n) ← Prototype(l, m), Prototype(m, n)

[PROTOTYPE3]
  Prototype(l, q) ← Instance(l, y), Stack(y, m), Prototype(m, n), Heap(n, "prototype", q)

[GLOBAL1]
  Heap(l_g, f, l) ← Stack(f, l), Global(f)

[GLOBAL2]
  Stack(f, l) ← Heap(l_g, f, l)

[THROW]
  Assign(x, y) ← Catch(k, x), Throw(k, y)
```

The §5 paper notes:

> Function calls are handled by rules [ACTUAL1], [ACTUAL2] and [ACTUAL3]. Since functions are modelled as objects in JavaScript, call targets are also resolved via the heap and stack. The rule [ACTUAL1] flows actual parameters to formal parameters, [ACTUAL2] flows formal return values to actual return values and [ACTUAL3] propagates "throws" across the call chain.

The structural insight: *every JavaScript construct that can move data between variables and properties is encoded as a Datalog relation*; the Datalog consequence-closure is the *transitive over-approximation* of all possible data flows.

#### §5.C Procedure D(t, P)

The §5.C procedure is straightforward given the encoding:

> 1. Pick any term s ∈ SES_light and compute `F_0(t) = Enc_T(t; var un; eval(s, "api", "un"), l_g) ∪ I_0`.
> 2. Compute `F = Cons(F_0(t), R)`.
> 3. Show that `PtsTo_D("un", F) ∩ P = ∅`.

The procedure picks *any* term `s` because the encoding makes the analysis *independent of the actual term* — it depends only on the bound on the free variables. So the procedure works for *any* untrusted code restricted to the API.

#### §5.D Soundness (Theorem 2)

**Theorem 2 (Soundness)**:

> For all terms t and forbidden allocation-site labels P, `D(t, P) ⟹ Confine(t, P)`.

Proof goes by three lemmas:

- **Lemma 1**: *Encoding of states over-approximates encoding of reachable states*: `Enc(Reach(S)) ⊆ Cons(Enc(S), R)`. Proof by induction on trace length.
- **Lemma 2**: *Initial facts over-approximate initial states*: `Enc(S_0(t)) ⊆ F_0(t)`.
- **Lemma 3**: *Abstract points-to over-approximates concrete points-to*: `PtsTo(v, S) ⊆ PtsTo_D(v, Enc(S))`.

The soundness theorem follows by composing the three: if the abstract analysis returns *empty intersection*, the concrete confinement holds.

The §5 paper closes with the *procedure is decidable* observation: `Enc_T`, `Cons`, and `PtsTo_D` are all computable; Datalog with a finite set of facts and rules has a finite least-fixed-point under the Herbrand semantics.
