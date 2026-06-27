---
id: grant-matcher-puzzle
aliases: ["grant matching", "grant matcher", "Grant Matcher Puzzle", "grant-matcher", "matching grant capability", "capability equivalence puzzle", "capability man-in-the-middle", "do two parties designate the same object", "equality primitive motivation"]
topics: [capability-security, capability-theory, marshal, captp]
status: draft
---

# grant-matcher-puzzle

> **External lineage — source not yet ingested.** The canonical statement of
> this puzzle is Mark S. Miller's *The Grant Matcher Puzzle* on erights.org
> (`https://erights.org/elib/equality/grant-matcher/index.html`, mirrored at
> `http://www.caplet.com/security/taxonomy/grant-match/grant-matcher.html`),
> part of the E *equality* taxonomy. Both hosts were **unreachable**
> (`ECONNREFUSED`) at ingest time (2026-06-27); erights.org is documented as
> intermittently down (`conventions.md` § PDF acquisition guidance). The
> framing below is drawn from a web-search summary of that page and is marked
> external until the primary source is fetched and ingested as a source page.
> A follow-on job (`scholar-ingest-grant-matcher-puzzle`) is posted to do so.

The **Grant Matcher Puzzle** is Mark Miller's motivating problem for *object
identity and equality primitives* in distributed capability systems. The
scenario: a **Grant Matcher** offers to match a grant — Alice wants to fund
some destination, and Dana (the matcher) will contribute matching funds *to the
same destination Alice chose*. This poses two questions:

1. **Equality.** Can the Grant Matcher determine whether Alice and Dana are
   designating the **same** destination? (Per the search summary: "Can the
   Grant Matcher determine if Alice and Dana are designating the same
   destination?")
2. **Transport.** "Having made a determination, can the Grant Matcher reliably
   transport the money to the destination, in a way mutually acceptable to
   Alice and Dana?"

The danger the puzzle isolates is the **capability man-in-the-middle**: in a
distributed cryptographic capability system, a naive equality test can be
spoofed so the matcher believes two parties designate the same object when they
do not (or vice versa), redirecting funds. The only protection Alice and Dana
have is the **principle of least authority**: the matcher's protocol must
require of them *only* the capabilities it genuinely needs to perform its duty
honestly, and must guarantee Alice does not lose money unless a destination
*acceptable to her* receives the matching funds (and symmetrically for Dana).
The puzzle's lasting contribution is that "the implications of different answers
to questions about object identity were not understood until the Grant Matcher
Puzzle" — it is *why* a distributed ocap system needs a carefully designed
**pass-invariant equality** primitive, and the reason a `desc:handoff` reliably
transports to *the* designated object rather than a man-in-the-middle.

## Where it interlocks (in-corpus)

> These are the library concepts the puzzle *connects to*, not its source. The
> puzzle's own source page is external and not yet ingested (see banner).

| Concept / section | Relationship |
|---|---|
| [[pass-invariant-handle-equality]] | The puzzle's **equality** question. The connector guarantee — same backing identity yields the same formula identifier — is exactly the primitive that lets a matcher decide two designations refer to one object without trusting the sender. The [equivalence-myth section](../sections/papers--miller-capability-myths-demolished-2003--equivalence-myth.md) is the in-corpus formal anchor. |
| [[three-party-handoff]] | The puzzle's **transport** question. The signed `desc:handoff-give` / `desc:handoff-receive` flow is how a capability is reliably moved to the designated destination *without* a man-in-the-middle, mutually acceptable to both parties. |
| [[principle-of-least-authority]] | The puzzle's stated protection: Alice and Dana grant the matcher *only* the authority it needs to act honestly. |
| [[brand-and-trademark]] | The rights-amplification / sealer family that lets a matcher hold and forward funds-bearing rights it cannot itself spend — the *mutually-acceptable transport* tool. |

## See also

- [[pass-invariant-handle-equality]] — the equality side; the puzzle is its canonical *why*.
- [[three-party-handoff]] — the transport side; the CapTP realization that defeats the capability man-in-the-middle.
- [[object-capability]] — the model in which "designation *is* authority," which is what makes the equality question security-critical rather than cosmetic.
- [[grant-matching]] *(alias of this page)* — the maintainer's name for the topic; the canonical literature name is "Grant Matcher Puzzle."

## Common confusions

- **"Grant matching is a petname-directory feature."** The maintainer's plan hypothesized "grant/petname material," but the canonical source is the **equality puzzle**, not a directory mechanism. Petnames are how a *human* designates; the puzzle is about whether two *programs'* designations provably refer to one object across a trust boundary.
- **"It's a payments problem."** The donor/charity framing is illustrative. The puzzle is fundamentally about **object identity** and the design of equality primitives in distributed capability systems; the money makes the man-in-the-middle stakes concrete.
- **"Two equal-looking references are the same object."** Precisely the trap the puzzle warns against. In a distributed cryptographic capability system, surface equality can be forged; a *pass-invariant* equality primitive is required, which is the puzzle's whole point.
