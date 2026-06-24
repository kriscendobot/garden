---
title: Body
source: "Concurrency Among Strangers (TGC 2005, LNCS 3705)"
source_kind: paper
source_authors: [Mark S. Miller, E. Dean Tribble, Jonathan Shapiro]
source_year: 2005
source_venue: "Trustworthy Global Computing (TGC 2005), Springer LNCS 3705"
source_url: https://papers.agoric.com/assets/pdf/papers/concurrency-among-strangers.pdf
source_pdf_sha256: 4ff0c5bd07e1262f8b2541194214b8a62a05d05fb5b443c44dc8f65cabc85ba5
ingested: 2026-05-15
ingested_by: scholar
topics: [capability-theory, capability-security, patterns]
status: current
parent: papers--miller-tribble-shapiro-concurrency-among-strangers-2005--defensive-correctness-and-pola
---

### Defensive correctness

The paper opens §7.1 with a definition:

> If a user browsing a webserver were able to cause incorrect pages to be displayed to other users, we would likely consider it a bug in the webserver — we expect it to remain correct regardless of the client's behavior. We call this property *defensive correctness*: a program P is defensively correct if it remains correct despite arbitrary behavior on the part of its clients.

Pinning "arbitrary":

> When we say that a program P is correct, this normally means that we have a specification in mind, and that P behaves according to that specification. There are some implicit caveats in that assertion. For example, P cannot behave at all unless it is run on a machine; if the machine operates incorrectly, P on that machine may behave in ways that deviate from its specification. We do not consider this to be a bug in P, because P's correctness implicitly depends on the machine's correctness. If P's correctness depends on another component R's correctness, we will say that *P relies upon R*. ... We will refer to the set of all elements on which P relies as P's *reliance set*.

Footnote 6 names the reliance set's familiar cousin:

> The set of all things that P relies on is similar in concept to P's "Trusted Computing Base" or TCB. "Rely" articulates the objective situation (P is vulnerable to R), and so avoids confusions engendered by the word "trust".

### Defensive consistency vs defensive correctness

The Internet-scale claim:

> Correctness can be divided into consistency (safety) and progress (liveness). An object that is vulnerable to denial-of-service by its clients may nevertheless be *defensively consistent*. Given that all the objects it relies on themselves remain consistent, a defensively consistent object will never give incorrect service to well-behaved clients, but it may be prevented from giving them any service. While a defensively correct object is invulnerable to its clients, a defensively consistent object is merely incorruptible by its clients.

The internet-scale tradeoff:

> Among machines distributed over today's Internet, cryptographic protocols help support defensive consistency, but defensive correctness remains infeasible.

The conclusion of §7.1:

> Among objects in the same vat, E supports defensive consistency: Any object may go into an infinite loop, thereby preventing the progress of all other objects within their vat. Therefore, within E's architecture, defensive correctness *within* a vat is impossible. With respect to progress, all objects within the same vat are mutually reliant. In many situations, defensive consistency is adequate — a potential adversary often has more to gain from corruption than denial of service. This is especially so in iterated relationships, since corruption may misdirect plans but go undetected, while loss of progress is quite noticeable.

This is the **per-vat granularity** of E's threat model: same-vat objects are mutually reliant (one can DoS the others by going into an infinite loop), but across vats E's machinery (turn isolation + cryptographic integrity) is enough to support defensive consistency. The granularity decision drives most of the rest of E's design.

### POLA and the statusGetter/statusSetter split

Section 7.2 introduces POLA via a refinement of the statusHolder:

> Our statusHolder itself is now defensively consistent, but is it a good abstraction for the account manager to rely on to build its own defensively consistent plans? In our example scenario, we have been assuming that the account manager acts only as a publisher and that the finance application and spreadsheet act only as subscribers. However either subscriber *could* invoke the setStatus method. If the finance application calls setStatus with a bogus balance, the spreadsheet will dutifully render it.

The fix: split the authority.

```
def makeStatusPair(var myStatus) {
    def myListeners := [].diverge()
    def statusGetter {
        to addListener(newListener) {
            myListeners.push(newListener)
            newListener <- statusChanged(myStatus)
        }
        to getStatus() { return myStatus }
    }
    def statusSetter {
        to setStatus(newStatus) {
            myStatus := newStatus
            for listener in myListeners {
                listener <- statusChanged(newStatus)
            }
        }
    }
    return [statusGetter, statusSetter]
}
```

The closure-over-shared-state idiom is the paper's E expression of the same construction *Capability Myths Demolished* (Section: [irrevocability-myth](papers--miller-capability-myths-demolished-2003--irrevocability-myth.md)) formalizes as the forwarder/revoker pattern (Endo's [[caretaker-pattern]]). Here, both facets are first-class capabilities; the account manager:

> The account manager can now keep the new statusSetter for itself and give the spreadsheet and the finance application access only to the new statusGetter. More generally, we may now describe publishers as those with access to statusSetter and subscribers as those with access to statusGetter. The account manager can now provide consistent balance reports to its clients because it has denied them the possibility of corrupting this service.

The principle named:

> As with concurrency control, the key to access control is to allow the possibilities needed for cooperation, while limiting the possibilities that would allow for plan interference. We wish to provide objects the authority needed to carry out their proper duties — publishers gotta publish — but little more. This is known as *POLA*, the *Principle of Least Authority* (See [MS03] for the relationship between POLA and the Principle of Least Privilege [SS75]).

The cited [SS75] is Saltzer-Schroeder's 1975 *The Protection of Information in Computer Systems* — the upstream of *least privilege* as a security principle. POLA refines least-privilege to be about *authority* (what effects one can cause), not just *privilege* (what one can access).

### A taste of E across a network: Pluribus

Section 7.3 introduces E's network protocol:

> E's computational model extends across the network. An eventual reference in a vat can refer to an object in a vat on another machine; eventual-sends to that reference are sent across an encrypted, authenticated link and posted as pending deliveries for the target object on the remote vat. ... E's network protocol, Pluribus, actually runs between vats, not between machines.

The key claim — Pluribus enforces E's reference-integrity properties even in mixed-language settings:

> Pluribus enforces characteristics of the E computational model, such as reference integrity, so that E programs can rely on those properties between vats and therefore between machines. Even if a remote vat runs its objects in an unsafe language like C++, other vats could still view it from a correctness point of view as a set of (possibly incorrect) objects written in E. From the perspective of other vats, the objects in the remote vat could collude and act arbitrarily within the union of the authorities granted to any of them, but they cannot feasibly manufacture new authorities. Thus, if an object relies on another object in a remote vat, then it also relies on that remote vat (because the remote object relies on that vat).

Footnote 8: "Pluribus relies on the standard cryptographic assumptions that large random numbers are not feasibly guessable, and that well-accepted algorithms are immune to feasible cryptanalysis." This is the standard ocap-network assumption that **unguessability of large random numbers = unforgeability of capabilities across the network**.

Source: [Concurrency Among Strangers (LNCS 3705)](https://papers.agoric.com/assets/pdf/papers/concurrency-among-strangers.pdf) pages 207-211 (§7 Protection from Misbehavior, §7.1 Defensive Correctness, §7.2 POLA, §7.3 A Taste of E Across a Network); SHA-256 `4ff0c5bd07e1`.
