---
id: object-sameness
aliases: ["object sameness", "reference sameness", "sameness", "sameness identity", "designational equivalence", "designationally equivalent", "Selfish object", "Selfless object", "Settled reference", "Unsettled reference", "creation identity", "value identity", "E.same", "== predicate", "EQ primitive in E", "Henry Baker equal rights for functional objects", "PowerKey", "CycleBreaker", "Disconnected reference"]
topics: [capability-theory, marshal, eventual-send]
status: current
---

# object-sameness

**Object (and reference) sameness** is Mark Miller's E-language taxonomy of
*identity* — the classification the Grant Matcher Puzzle forces a pure
object-capability system to pin down. E reasons about sameness identity by
analogy to **ground formulas / Herbrand terms**: a **Settled** reference has a
ground formula (no unbound variables), where an unbound variable is a Promise
(unresolved reference). Two top-level kinds of object:

- **Selfish** — *creation-based* identity. Each act of creation mints a unique
  atomic identity (a gensym); same contents from two creations are *not* the
  same. Conventional heap objects (Smalltalk/Java/Scheme) are Selfish by
  allocation address. In E, objects are **Selfish and PassByProxy by default**,
  and Selfish objects are always Settled.
- **Selfless** — *value-based* identity. Two Selfless objects are the same by
  their contents, independent of creation. All Selfless objects are
  **Transparent** (reveal state through a standard protocol) and **Frozen**.
  Selfless splits into **Scalars** (null/bool/int/float64/char — calculable
  atomic ground symbols, always Settled; E Strings are pragmatically Scalars)
  and **Composite Selfless** objects (cycle-tolerant recursive comparison; a
  canonical `__optUncall()` triple; possibly-infinite rational-tree formulas).

*Reference* sameness is the synchronous `==` predicate (mutually recursive with
object sameness, which holds the base cases). `x == y` returns `true`, returns
`false`, or **throws** — throwing only when an operand is Unsettled. It tests
**designational equivalence** (same sameness formula) and is **monotonic** (a
returned answer never changes); a reference goes Unsettled → Settled and never
back. Because a partition-broken **Disconnected** reference keeps the identity it
had as a Far reference, `==` tests *designational* rather than *computational*
equivalence. E's **EMap** hashtable requires **Settled keys** for this
stability; **PowerKey** / **CycleBreaker** wrappers let unsettled references key
a map by reporting a stable hashCode. The asynchronous **join** (`E.join(a, b)`)
is the eventual form, bottoming out in immediate `==` once both operands resolve
and co-locate.

This is the E-language ancestor of Endo's [[pass-invariant-handle-equality]]:
"same backing identity → same formula identifier" is the modern enforcement of
the designational-equivalence guarantee a Grant Matcher needs.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [equality/object-sameness/overview](../sections/web--miller-equality-object-sameness--overview.md) | Selfish (creation identity, PassByProxy default) vs Selfless (value identity, Transparent + Frozen); Scalar vs Composite-Selfless; Settled state; sameness as Herbrand terms. |
| [equality/reference-sameness/overview](../sections/web--miller-equality-reference-sameness--overview.md) | The `==` predicate (true/false/throws); designational equivalence; monotonicity; EMap-requires-Settled-keys; designational-vs-computational via Disconnected refs; PowerKey/CycleBreaker. |
| [equality/four-party-partial-orders/overview](../sections/web--miller-equality-four-party-partial-orders--overview.md) | The asynchronous `join` — eventual equality that bottoms out in immediate `==`; why distributed grant matching needs it. |
| [grant-matcher/how-eq-makes-a-difference](../sections/web--miller-grant-matcher-puzzle--how-eq-makes-a-difference.md) | Why an address-equality `EQ` (the `==` of reference sameness) resolves the puzzle by returning false for a transparent forwarder. |

## See also

- [[grant-matcher-puzzle]] — the canonical *motivation*: why a distributed ocap system must be able to decide whether two references designate the same object.
- [[pass-invariant-handle-equality]] — Endo's modern realization of designational equivalence at the Handle layer ("same backing identity → same formula identifier").
- [[pass-by-construction]] — the *passing* taxonomy (PassByProxy/PassByCopy/PassByConstruction) that determines, per object kind, what "the same object" means across a vat boundary.
- [[three-party-handoff]] — the transport side: reliably moving a reference to the designated destination without a man-in-the-middle.
