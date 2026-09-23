---
id: pass-by-construction
aliases: ["pass-by-construction", "PassByConstruction", "PBC", "pass-by-proxy", "PassByProxy", "pass-by-copy in E", "PassByCopy", "argument passing rules", "object-passing taxonomy", "Presence", "leaving home going home travelling", "Near reference", "Far reference", "Lost Resolution bug"]
topics: [marshal, capability-theory, pass-style]
status: current
---

# pass-by-construction

The **object-passing taxonomy** of Mark Miller's E *equality* chapter — how an
object crosses a vat (process) boundary — and the direct E-language ancestor of
Endo's marshal **pass-style**. Three kinds:

- **PassByProxy** — the Selfish default. The object stays in its home vat; a
  remote vat receives a **Far** reference (a proxy) that forwards messages home.
  Endo equivalent: **pass-by-presence** (`Far` / remotable).
- **PassByCopy** — the object is *copied* into the receiving vat by delivery
  time; the receiver gets a Near reference to an identical object. Endo
  equivalent: **pass-by-copy** (copyArray / copyRecord / tagged / primitives /
  errors).
- **PassByConstruction (PBC)** — a **Presence** of the same object is
  *constructed* in the receiving vat by delivery time. PassByCopy is the special
  case where the constructed presence is a plain copy.

The vat-independent **pass-invariance** rules guarantee that transmitted Settled
arguments stay Settled and PassByCopy/PBC args stay Near to an
identical-or-presence object — the property that lets a PassByCopy hashtable
survive the trip (its keys are Settled, so they arrive Settled and designating
the same objects). The vat-*relative* rules describe how a PassByProxy
reference transforms by which vats share it: **leaving home** (Near → Far),
**going home** (Far → Near), and **travelling** (Far → Far across three vats) —
the three-vat "travelling" case being exactly what OCapN CapTP's
[[three-party-handoff]] realizes. The page also records the historical *Lost
Resolution* bug, where a travelling Far reference arrived as an unsettled Promise
and broke hashtable keys.

## Translation (E ↔ Endo)

| E (erights `elib/equality`) | Endo (marshal / pass-style) |
|---|---|
| PassByProxy (Selfish default) | pass-by-presence — `Far` / remotable |
| PassByCopy | pass-by-copy — copyArray, copyRecord, tagged, primitives, error |
| PassByConstruction (PBC) — construct a Presence | the general rule of which pass-by-copy is the special case; in Endo, marshal reconstructs the value in the receiving realm |
| Near / Far / Disconnected reference | local / remote / partition-broken presence |
| "travelling" (three-vat Far → Far) | CapTP [[three-party-handoff]] (Gifter / Receiver / Exporter) |

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [equality/argument-passing-rules/vat-independent-semantics](../sections/web--miller-equality-argument-passing-rules--vat-independent-semantics.md) | The pass-invariance rules and the PassByCopy / PassByConstruction / PassByProxy taxonomy. |
| [equality/argument-passing-rules/vat-based-rules](../sections/web--miller-equality-argument-passing-rules--vat-based-rules.md) | leaving-home / going-home / travelling transforms of a PassByProxy reference, plus the Lost Resolution bug. |
| [equality/object-sameness/overview](../sections/web--miller-equality-object-sameness--overview.md) | Why E objects are PassByProxy (Selfish) by default and what Selfless/PassByCopy identity means. |
| [endo/pkg-marshal-readme/pass-by-presence-vs-copy](../sections/endo--pkg-marshal-readme--pass-by-presence-vs-copy.md) | The Endo realization: pass-by-copy values cross as data; pass-by-presence values cross as capability references. |
| [endo/pkg-pass-style-readme/pass-by-copy-vs-presence](../sections/endo--pkg-pass-style-readme--pass-by-copy-vs-presence.md) | The high-level pass-by-copy vs pass-by-presence distinction marshal enforces. |

## See also

- [[grant-matcher-puzzle]] — the motivating problem; the passing taxonomy is half of *transport* (the other half is equality).
- [[object-sameness]] — the identity taxonomy that pairs with this passing taxonomy (what "the same object" means across a boundary).
- [[three-party-handoff]] — the CapTP realization of the "travelling" three-vat passing case.
- [[pass-invariant-handle-equality]] — the equality invariant Endo enforces so a passed-and-returned reference stays comparable.
