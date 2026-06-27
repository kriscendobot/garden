---
id: grant-matcher-puzzle
aliases: ["grant matching", "grant matcher", "Grant Matcher Puzzle", "grant-matcher", "matching grant capability", "capability equivalence puzzle", "capability man-in-the-middle", "do two parties designate the same object", "equality primitive motivation", "EQ primitive", "transparent forwarder", "KEQD", "Alice gets greedy"]
topics: [capability-security, capability-theory, marshal, captp]
status: current
---

# grant-matcher-puzzle

The **Grant Matcher Puzzle** is Mark S. Miller's foundational motivating
problem for *object-identity and equality primitives* in pure object-capability
systems, and the root page of the E *equality* taxonomy
([erights.org](https://erights.org/elib/equality/grant-matcher/index.html),
mirrored at
[caplet.com](http://www.caplet.com/security/taxonomy/grant-match/grant-matcher.html)
as *Identity Untangled: The Grant Matcher Puzzle*, credited to Mark Miller with
thanks to Norm Hardy and E. Dean Tribble). It is now ingested in-corpus as the
source page [`web--miller-grant-matcher-puzzle`](../sources/web--miller-grant-matcher-puzzle.md).

The scenario: a **Grant Matcher** is a mutually trusted third party that matches
two donors' grants to a common destination. **Alice** wants to give $10 to a
charity, **KEQD**, *only if* $10 also goes to KEQD from a second donor, **Dana**;
Dana has the symmetric desire involving Alice. Alice and Dana trust the Grant
Matcher but **do not trust each other**. The Grant Matcher escrows both
donations, and only if both designate the **same destination** (and the same
amount) does it hand the sum to that destination; otherwise it refunds both. In
the underlying capability diagram the Grant Matcher plays *Bob*, KEQD plays
*Carol* (the destination), and Dana is symmetric to Alice. This poses two
coupled questions:

1. **Equality.** Can the Grant Matcher determine whether Alice and Dana are
   designating the **same** destination — without consulting the objects
   themselves (an `EQ` primitive)?
2. **Transport.** Having so determined, can the Grant Matcher *reliably
   transport* the money to that destination in a way mutually acceptable to
   Alice and Dana — ensuring Alice does not lose $10 unless a destination
   acceptable to her receives $20, and symmetrically for Dana?

The danger the puzzle isolates is the **capability man-in-the-middle**. In the
"Alice Gets Greedy" attack, Alice hands the Grant Matcher a *transparent
forwarder* to KEQD that forwards every message — including the equality-protocol
messages — *except* one carrying $20, which it diverts to Alice's own account. A
message-only equality protocol (a system with truly transparent forwarders, as
in Actor systems or Joule) cannot distinguish this from the honest case except
at the price of the very $20 at stake, so Dana can lose his $10 with no
destination acceptable to Dana receiving $20. The protection Alice and Dana have
is the **principle of least authority**: the protocol must require of them only
the capabilities the Grant Matcher genuinely needs to act honestly. The
resolution Miller draws is that an **`EQ` (address-equality) primitive** would
return *false* for the forwarder — refunding both donors, a safe outcome — at
the cost of precluding truly transparent forwarders, *especially in the
distributed case*. The puzzle is thus *why* a distributed ocap system needs a
carefully designed **pass-invariant equality** primitive and a
man-in-the-middle-resistant **handoff transport**: "the implications of
different answers to questions about object identity were not understood until
the Grant Matcher Puzzle."

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [grant-matcher/overview](../sections/web--miller-grant-matcher-puzzle--overview.md) | Why object identity must be resolved to design equality primitives; the `EQ` framing and the cost of each answer. |
| [grant-matcher/capability-foundations](../sections/web--miller-grant-matcher-puzzle--capability-foundations.md) | The three rules of capability computation; the third — "the Carol that Bob gets must be the Carol that Alice meant" — is the heart of the puzzle. |
| [grant-matcher/setting-up-the-puzzle](../sections/web--miller-grant-matcher-puzzle--setting-up-the-puzzle.md) | Roles (Grant Matcher = Bob, KEQD = Carol, Dana symmetric to Alice); least-authority as the donors' only protection; mutual distrust. |
| [grant-matcher/when-it-works](../sections/web--miller-grant-matcher-puzzle--when-it-works.md) | The two questions stated — equality and transport — and the no-`EQ` message-only protocol attempt. |
| [grant-matcher/alice-gets-greedy](../sections/web--miller-grant-matcher-puzzle--alice-gets-greedy.md) | The transparent-forwarder attack that defeats a message-only equality protocol; the asymmetry that costs Dana his $10. |
| [grant-matcher/how-eq-makes-a-difference](../sections/web--miller-grant-matcher-puzzle--how-eq-makes-a-difference.md) | Address-equality `EQ` returns false for the forwarder and refunds both; the abstract Java `GrantMatcher` reference implementation and `MalletCharity`. |
| [papers/capmyths/equivalence-myth](../sections/papers--miller-capability-myths-demolished-2003--equivalence-myth.md) | Property A (No Designation Without Authority) — the in-corpus formal anchor for the equality question. |

## Where it interlocks (in-corpus)

| Concept / section | Relationship |
|---|---|
| [[pass-invariant-handle-equality]] | The puzzle's **equality** question. The connector guarantee — same backing identity yields the same formula identifier — is the primitive that lets a matcher decide two designations refer to one object without trusting the sender. The [equivalence-myth section](../sections/papers--miller-capability-myths-demolished-2003--equivalence-myth.md) is the in-corpus formal anchor. |
| [[three-party-handoff]] | The puzzle's **transport** question. The signed `desc:handoff-give` / `desc:handoff-receive` flow is how a capability is reliably moved to the designated destination *without* a man-in-the-middle, mutually acceptable to both parties (the modern OCapN CapTP answer to the transport half). |
| [[principle-of-least-authority]] | The puzzle's stated protection: Alice and Dana grant the matcher *only* the authority it needs to act honestly. |
| [[brand-and-trademark]] | The rights-amplification / sealer family that lets a matcher hold and forward funds-bearing rights it cannot itself spend — the *mutually-acceptable transport* tool. The [History of the Grant Matcher](../sections/web--miller-grant-matcher-history--sealer-unsealer-equivalence.md) records that an `EQ` adequate for grant matching and Sealer/Unsealer pairs are *mutually constructible*. |
| [[object-sameness]] | The puzzle's **equality** question stated as a taxonomy: when two objects/references are the *same* (Selfish creation-identity vs Selfless value-identity; the `==`/designational-equivalence predicate; the asynchronous `join`). The E-language definitions behind the `EQ` the puzzle needs. |
| [[pass-by-construction]] | The puzzle's **transport** half stated as the object-passing taxonomy (PassByProxy / PassByCopy / PassByConstruction; the three-vat "travelling" case the [[three-party-handoff]] resolves). |

## The adjacent E equality-taxonomy pages (in-corpus)

The puzzle is the root page of erights.org's `elib/equality/` tree; its sibling and successor pages are now ingested alongside it:

| Source | What it adds |
|---|---|
| [History of the Grant Matcher](../sources/web--miller-grant-matcher-history.md) | The EQ-history essay the overview's "not understood until…" link points at: Lisp EQ → Smalltalk/Actors/KeyKOS → Joule → the Escrow Exchange Agent → the puzzle; plus the EQ ⇄ Sealer/Unsealer equivalence. |
| [Four Party Partial Orders](../sources/web--miller-equality-four-party-partial-orders.md) | The puzzle's "On to:" successor: the *concurrency* problem (distributed equality must add a join to the message-delivery order); the E `join` implementation. |
| [Object Sameness](../sources/web--miller-equality-object-sameness.md) / [Reference Sameness](../sources/web--miller-equality-reference-sameness.md) | The sameness classification ([[object-sameness]]). |
| [Argument Passing Rules](../sources/web--miller-equality-argument-passing-rules.md) | The object-passing classification ([[pass-by-construction]]). |

## See also

- [[pass-invariant-handle-equality]] — the equality answer Endo enforces at the Handle layer.
- [[object-sameness]] — the E-language identity taxonomy (`==`, designational equivalence, Selfish/Selfless) the `EQ` rests on.
- [[pass-by-construction]] — the E-language object-passing taxonomy (PassByProxy/Copy/Construction) the transport half rests on.
- [[three-party-handoff]] — the transport answer in OCapN CapTP.
- [[granovetter-operator]] — the introduction primitive whose third rule the puzzle scrutinizes.
