---
id: selfless-and-selfish-objects
aliases: ["selfless object", "selfish object", "selfless", "selfish", "PassByCopy", "implements PassByCopy", "transparent object", "open state", "open source", "pass-by-copy between vats", "synchronous sameness", "Semantics of Same", "E sameness", "settled reference"]
topics: [e-language, pass-style]
status: draft
---

# selfless-and-selfish-objects

E's distinction (from the *Semantics of "Same"* chapter) between **selfish**
objects, which carry a unique identity (a *self*) endowed at creation so that the
synchronous-sameness operator `==` compares object identity, and **selfless**
objects, which have no identity so that `==` compares contents. Every object is
selfish by default (as in Java, Smalltalk, Python). An object expression may be
declared selfless (`implements PassByCopy`) only after three conditions hold:
**immutable** (instance variables `final`), **open state** (a method exposing the
object's scope, making it non-encapsulating), and **open source** (a method
exposing the object's source, making it non-polymorphic). An object that is open
state and open source is **transparent**. Selflessness makes an object immutable
and transparent, makes it **pass-by-copy between vats**, makes its sameness a
contents comparison, and makes its selflessness apparent. Transparency is what
*licenses* copying: an immutable, identity-less, secret-less object cannot be
distinguished from a copy, so an implementation may freely copy or collapse such
objects across machines without violating any encapsulation the program
expressed.

This is the direct conceptual ancestor of **Endo's pass-style discipline**:
selfless ↔ pass-by-copy data (`CopyRecord` / `CopyArray` / `CopyTagged`), selfish
↔ pass-by-reference remotable (`Far` / `Remotable`), transparent ↔ the marshal
requirement that copy data expose its whole structure with no hidden state.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [erights--elang-same-ref--selfish-and-selfless-objects](../sections/erights--elang-same-ref--selfish-and-selfless-objects.md) | The primary E source: selfish vs selfless, the three conditions, why transparency licenses copying, collection sameness. |
| [erights--elang-same-ref--synchronous-sameness-and-reflexivity](../sections/erights--elang-same-ref--synchronous-sameness-and-reflexivity.md) | The `==` operator selflessness is defined against: substitutability, reflexivity, scalar sameness. |
| [endo--pkg-marshal-readme--pass-by-presence-vs-copy](../sections/endo--pkg-marshal-readme--pass-by-presence-vs-copy.md) | The Endo descendant: pass-by-copy values cross the wire as data; the selfless-object idea operationalized. |
| [endo--pkg-pass-style-readme--pass-by-copy-vs-presence](../sections/endo--pkg-pass-style-readme--pass-by-copy-vs-presence.md) | The high-level pass-by-copy vs pass-by-presence distinction marshal enforces. |

## See also

- [[pass-invariant-handle-equality]] — Endo's modern treatment of sameness that survives marshal round-trips; the `==` substitutability invariant carried into the distributed setting.
- [[object-capability]] — selfish (identity-bearing) objects are the capability-bearing remotables; the selfless/selfish split is which values convey authority by reference vs travel as inert data.
- [[granovetter-operator]] — the reference-passing step transmits selfish objects by reference (capability) and selfless objects by copy.

## Common confusions

- **"Selfless means stateless."** No — a selfless object may *hold* mutable objects in its (final) instance variables; it is the *binding* that must be immutable, and the object itself must be transparent. The point is that two selfless objects with the same contents are indistinguishable, so identity is dispensable.
- **"`==` is a method the object implements."** No — E decides `==` by language rule (identity for selfish, contents for selfless), precisely so an untrustworthy object cannot lie about sameness. This is why sameness is safe for map-key comparison among mutually suspicious objects.
