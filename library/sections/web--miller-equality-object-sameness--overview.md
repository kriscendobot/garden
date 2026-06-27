---
title: "Object Sameness: Selfish vs Selfless identity, Settled state, and sameness as Herbrand terms"
source_kind: web
source_url: https://erights.org/elib/equality/same-object.html
source_content_sha256: 463a4dc5aed174f5366545e46d35e9104b1a6d30dea298701c2d7a57b8bf5d1f
source_authors: [Mark S. Miller]
source_date: 2000-01-01
ingested: 2026-06-27
ingested_by: scholar
topics: [capability-theory, marshal]
status: current
---

E's taxonomy of *object* sameness identity (distinct from *reference* sameness, with which it is mutually recursive; object sameness holds the base cases and should be read first). Sameness identity is reasoned about by analogy to **ground formulas / Herbrand terms** in logic programming: a **Settled** object has a *ground* formula (no unbound variables), where unbound variables correspond to Promises (unresolved references). The two top-level kinds:

- A **Selfish** object has *creation-based* (atomic) sameness identity: each act of creation endows it with a unique atomic identity (a gensym, not otherwise calculable), corresponding to a unique atomic ground symbol. In Smalltalk/Java/Scheme all heap-allocated objects are Selfish (EQ by allocation address). In E, objects are **Selfish and PassByProxy by default**, and Selfish objects are always Settled.
- A **Selfless** object has *value-based* sameness identity: two Selfless objects are the same based on their *contents*, independent of whether they descend from the same creation. All Selfless objects are **Transparent** (reveal all state through a standard protocol) and **Frozen** (immutable). Selfless splits into **Scalars** (null, booleans, ints, float64s, chars — calculable atomic ground symbols, implicitly reachable everywhere, always Settled; E Strings are pragmatically treated as Scalars) and **Composite Selfless** objects (compared by cycle-tolerant recursive sameness of their components).

A Composite Selfless object's `__optUncall()` returns a *canonical* triple `[receiver, verb, args]` such that `E.call(receiver, verb, args)` recreates an object the same as it; canonicity (any two same objects return the same triple) is enforced by auditing. Its sameness formula is the compound term formed by replacing each component with its sameness formula; cycles conceptually produce an infinite rational tree, and two Settled Composite Selfless objects are the same iff their (possibly infinite) sameness formulas are the same.

This page picks up where *Reference Mechanics* left off (read that first). The philosophy of E's object equality is similar to Henry Baker's *Equal Rights for Functional Objects, or, The More Things Change, The More They Are the Same.* An object's possible states are organized for reasoning about equality, with one transition: from **Partial** to **Complete**.

We reason about the sameness identity of an object by analogy to formulas in logic programming (actually, Herbrand terms). A **Settled** object is one whose sameness identity is represented by a *ground* formula — one with no unbound variables. Unbound variables correspond to Promises, i.e., Unresolved references. (A problematic case: the Unconnected reference. Ground or not?)

A **Selfish** object has atomic *creation-based* sameness identity, or just *creation identity*. Each act of creating such an object endows it with a unique atomic identity. It corresponds to a formula consisting of a unique atomic ground symbol (a gensym, not a logic variable) that is not otherwise calculable. In many conventional languages including Smalltalk, Java, and Scheme, all heap-allocated objects are Selfish — they are EQ according to the address assigned to them where the act of creation allocated them. In E, objects are Selfish (and PassByProxy) by default. Selfish objects are always Settled.

A **Selfless** object has *value-based* sameness identity, or just *value identity*. Two Selfless objects are the same (have the same sameness identity) based on their contents, independently of whether they descend from the same act of creation. All Selfless objects are **Transparent** (reveal all their state in a standard way through their protocol) and **Frozen** (immutable). An important distinction is between **Scalars** and **Composite Selfless** objects:

- E primitively provides a fixed set of **Scalars**: null, booleans, ints, float64s, and chars. In conventional languages these are typically not heap-allocated; when they are not, conventional languages also treat these as in effect Selfless. As with Selfish objects, each scalar value corresponds to a unique atomic ground symbol, but all these symbols are calculable by any calculation. Another way to look at it: all scalars are implicitly reachable from anywhere, whereas Selfish objects are reachable only by capability rules. Scalars are always Settled. E Strings (bare Twine), being lists of chars, should in theory be dealt with as Composite Selfless objects, but for pragmatic reasons are actually dealt with as Scalars. Strings are always Settled.
- **Composite Selfless** objects are composed of components. Two Composite Selfless objects are the same according to a cycle-tolerant recursive sameness comparison of their respective components. A Composite Selfless object is Settled iff all its components are Settled. For any Selfless object `x`, `x.__optUncall()` returns a canonical triple `[receiver, verb, args]` such that `E.call(receiver, verb, args)` would create an object that's the same as `x`. There are many triples that would create `x`, but the triple returned by `__optUncall()` is *canonical* in that any two Composite Selfless objects that are the same must return the same triple (a constraint enforced by auditing). The sameness formula of a Composite Selfless object is the compound term resulting from replacing each component with its sameness formula; when this expansion encounters a cycle it conceptually creates an infinite rational tree, and two Settled Composite Selfless objects are the same if their possibly-infinite sameness formulas are the same.

The page's `PassByProxy Objects`, `PassByCopy Objects`, and `Infinite Rational Trees` subsections are headed but marked *"to be written"* on the source; the PassByProxy/PassByCopy/PassByConstruction passing taxonomy is covered in [Argument Passing Rules](../sections/web--miller-equality-argument-passing-rules--vat-independent-semantics.md).

Source: [Object Sameness](https://erights.org/elib/equality/same-object.html), Mark S. Miller, erights.org; ingested from the Internet Archive original-bytes capture, content SHA-256 `463a4dc5`.
