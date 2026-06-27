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
| [[brand-and-trademark]] | The rights-amplification / sealer family that lets a matcher hold and forward funds-bearing rights it cannot itself spend — the *mutually-acceptable transport* tool. |

## See also

- [[pass-invariant-handle-equality]] — the equality answer Endo enforces at the Handle layer.
- [[three-party-handoff]] — the transport answer in OCapN CapTP.
- [[granovetter-operator]] — the introduction primitive whose third rule the puzzle scrutinizes.
