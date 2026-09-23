---
id: representational-vs-behavioral
aliases: ["representational vs behavioral", "descriptive vs imperative", "behavioral protocols", "data protocols vs behavioral protocols", "representational mode", "imperative mode", "descriptive mode", "anti-REST", "nouns and verbs REST", "resource vs object", "behavior not data", "knowledge-based compression protocol"]
topics: [distributed-objects, networking]
---

# representational-vs-behavioral

The **representational-vs-behavioral** distinction is the fault line separating two ways to
model a distributed system's interface. In the **representational (descriptive) mode** — the
REST stance — every important abstraction is a **resource** manipulated by passing around
**representations** of it; the world is mainly **data objects whose primary characteristic is
their current state**, and the protocol is about synchronizing that state. In the **behavioral
(imperative) mode**, the world is mainly **functional objects whose primary characteristic is
their behavior**, and the protocol is about invoking *what an object does*. Chip Morningstar
draws the distinction from both sides. From the REST side ("A Slightly Skeptical Perspective on
REST") he notes REST is a good fit where entities really are state-centric data objects, but
"where the important entities you are dealing with really do exhibit a complex behavioral
repertoire at a fundamental level, a RESTful interpretation is much more strained," and names
a **profound asymmetry**: REST fixes a small set of verbs while leaving nouns open, whereas
imperative frameworks leave both open — so it is easy to reframe RESTful designs in imperative
terms but hard to go the other way. From the distributed-object side (the unum pattern) he
argues **unum message interfaces are about behavior, not data**, and that a behavioral protocol
is a form of **knowledge-based compression** — if you already know the operations that can
transform a thing's state, a parameterized *operation* is often far more compact than
transmitting all the resulting state (Habitat ran over 300/1200-baud links) — hence "the unum
pattern is about as anti-REST as you can be." The two essays are the two halves of one argument.
This is the same lineage as the E-vat / [eventual-send](../topics/eventual-send.md) model, whose
message-send-to-a-behavioral-object primitive is the behavioral pole made concrete.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [habitat-chronicles--skeptical-perspective-on-rest--representational-vs-imperative-descriptive-vs-behavioral](../sections/habitat-chronicles--skeptical-perspective-on-rest--representational-vs-imperative-descriptive-vs-behavioral.md) | **The REST-side statement.** Representational/descriptive vs imperative/behavioral mode; the small-fixed-verbs / open-nouns asymmetry; why nominally-RESTful systems drift back to imperative. |
| [habitat-chronicles--unum-pattern--behavioral-protocols-anti-rest](../sections/habitat-chronicles--unum-pattern--behavioral-protocols-anti-rest.md) | **The distributed-object-side statement.** Unum interfaces are about behavior not data; behavioral protocols as knowledge-based compression; "about as anti-REST as you can be." |
| [habitat-chronicles--skeptical-perspective-on-rest--state-statelessness-and-polling](../sections/habitat-chronicles--skeptical-perspective-on-rest--state-statelessness-and-polling.md) | The consequence for interactive systems: a stateless representational server cannot speak first, so clients must poll — the behavioral model's server-initiated notification is what REST lacks. |

## See also

- [[habitat-unum]] — Chip Morningstar's distributed-object pattern whose "behavioral, not data" protocols are the behavioral pole of this distinction.
- [[object-capability]] — the ocap model is behavioral by nature (you hold a reference and invoke behavior), the security lineage that grew from the same E-vat tradition.

## Common confusions

- **"Behavioral just means RPC, and REST is the modern replacement for RPC."** No — the distinction is about *what the interface is about* (state to synchronize vs behavior to invoke), not about a wire format or a fashion cycle. A behavioral protocol can compress far better than a data-replication one precisely because it ships *operations* rather than *resulting state*.
- **"Anti-REST means REST is bad."** No — Morningstar credits REST as a good fit for genuinely state-centric, data-object worlds; "anti-REST" names the *behavioral* pole for the systems (interactive, behavior-rich) where the representational stance strains.
