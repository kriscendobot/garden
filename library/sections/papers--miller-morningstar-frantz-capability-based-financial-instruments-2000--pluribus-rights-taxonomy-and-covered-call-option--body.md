---
title: Body
source: "Capability-Based Financial Instruments (Financial Cryptography 2000, Springer LNCS 1962)"
source_kind: paper
source_authors: [Mark S. Miller, Chip Morningstar, Bill Frantz]
source_year: 2000
source_venue: "Financial Cryptography 2000, Springer LNCS 1962"
source_url: https://papers.agoric.com/papers/capability-based-financial-instruments/abstract/
source_pdf_sha256: 49c7606bbf78f3cd5e4565802dcaf2e87254ed9ab02ed955dd6963053fecfb8e
source_paper_pages: "20-32 (§4 Pluribus distributed protocol; §4.3 Subjective Aggregation; §5 PKI comparison; §6 Financial Instruments + four-axis rights taxonomy + CoveredCallOptionMaker + TitleCompanyMaker; §7 Conclusion)"
ingested: 2026-05-28
ingested_by: liaison-direct-draft
topics: [capability-theory, capability-security, captp, patterns]
status: current
parent: papers--miller-morningstar-frantz-capability-based-financial-instruments-2000--pluribus-rights-taxonomy-and-covered-call-option
---

### §4 Pluribus — the distributed capability protocol

§4 begins by aggregating objects into **vats**. Each E object exists in exactly one vat; a vat hosts many objects. A vat exists on one machine at a time, but a machine may host many vats. A vat is, to a first approximation, a process full of objects — an address space full of objects plus a thread of control. Unlike a typical OS process, **a vat persists**: its state is saved to persistent storage when its hosting process is terminated or interrupted. The paper calls a particular OS-process incarnation of a vat an *incarnation*; the vat maintains its identity and state as it passes serially through a sequence of incarnations. (*Library cross-reference: this is the 2000 framing of the vat concept later elaborated in Concurrency Among Strangers 2005 §3 — see `papers--miller-tribble-shapiro-concurrency-among-strangers-2005--vat-and-event-loop-model` for the 2005 expansion.*)

The §4 setup introduces **proxies** as the local representatives of remote objects. When an object in VatA refers to an object in VatB, the local representative in VatA is a *proxy*. A message sent to a proxy is encoded into a packet which is dispatched as a network message; the receiving vat decodes it into a message local to its address space, handshaking with remote vats as necessary to create needed proxies; the decoded message is finally delivered.

### §4.2 Cryptographic capabilities — VatID and swiss number

§4.2 names the two cryptographic primitives Pluribus relies on:

- **VatID.** On creation, each vat generates a public/private key pair. The fingerprint of the vat's public key is its **vat Identity, or VatID**. What does the VatID identify? *"The VatID can only be said to designate any vat which knows and uses the corresponding private key apparently according to the protocol."*

- **Swiss number.** When VatC first exported a capability to access Carol across the vat boundary, VatC assigned an unguessable randomly-chosen number to Carol. The paper calls this a **swiss number** since it has the *knowledge-is-authority* logic loosely attributed to Swiss bank account numbers. When VatA first received this capability, VatA thereby came to know both Carol's swiss number and VatC's VatID.

The mechanism when Alice sends Bob a reference to Carol:

1. VatA tells VatB Carol's swiss number and VatC's VatID.
2. VatB contacts an alleged VatC (using location-routing/hint information communicated with the VatID) and asks for VatC's public key.
3. VatB verifies the public key's fingerprint matches the alleged VatID.
4. Handshake proceeds along SSL-like lines: VatC proves knowledge of the corresponding private key; Diffie-Hellman key agreement yields a shared session key.
5. *Only after the authenticated secure pipe is established* does VatB reveal Carol's swiss number to VatC.
6. VatC associates messages sent inside VatB to the proxy c2 (and then encoded over the network to VatC) with Carol.

The paper closes the §4.2 mechanism with a sharp summary: *"A capability is an arrow, and an arrow has two ends. There is an impostor problem in both directions. The VatID ensures that the entity that Bob is speaking to is the one that Alice meant to introduce him to. The Swiss number ensures that the entity allowed to speak to Carol is the one that Alice chose to enable to do so."*

### §4.3 Subjective aggregation — "only trust makes distinctions"

§4.3 contains the most philosophically deep argument in the paper. Although the §4.2 mechanism is correct, *there is something peculiar* in the description. On the one hand, the analysis seems to assume *we aren't trusting VatB*, which is why Carol's swiss number isn't revealed to VatB until someone reveals it to an object such as Bob, which is hosted by VatB. On the other hand, Alice's intention is to give Bob access to Carol, *but not to give this access to any other objects, such as Joe, that might also be hosted by VatB*. However, Alice *must* trust VatB to play by these rules, since Alice, by sending it Carol's swiss number, has enabled it to do otherwise.

The architectural framing: **there are two forms of mutual suspicion simultaneously supported by this Pluribus protocol** — inter-vat (or inter-machine) mutual suspicion, and inter-object mutual suspicion. *"It would be a mistake for anyone to trust Bob any more than they trust VatB. To the objects within a vat, their hosting vat is their Trusted Computing Base (TCB). Their own operation is completely at the mercy of their TCB, with no escape. Bob's behavior can be seen as an aspect of VatB's behavior."*

The §4.3 closing logic is what gives the paper its title-perspective: *"Only if Alice trusts VatB to behave properly — that is, as if it is actually hosting separate objects interacting with each other by capability rules — does it make sense for Alice to even reason about Bob as being in any way separately trusted from Joe."* If Alice does not trust VatB, Alice should reason about VatB as **a single conspiring group of objects pretending to be several separately trustable objects**.

The architectural payoff:

> Put another way, **mistrust of a vat is equivalent to ignorance of the internal relationships among the objects hosted by that vat**. A malicious vat hosting one set of objects can only cause external effects equivalent to a correct vat hosting some different (maliciously coded) set of objects. This is the main economy of the distributed capability model: **we can, without loss of generality, reason as if we are only suspicious of objects.**

The paper's strongest distributed-systems claim follows: *"The capability model, by limiting authority within the transitive connectivity of graphs, allows a participant to subjectively aggregate arbitrary sets of objects into composites. Given the same graph of objects, different participants will employ different aggregations according to their own subjective ignorance or suspicions, as we have seen, or merely their own lack of interest in making finer distinctions. **Capabilities are the only security model that simultaneously supports the economy of aggregation and the necessary subjectivity in deciding how to aggregate.**"*

The §4.3 closing aphorism: *"A fully paranoid actor should indeed assume the entire world is a monolithic conspiracy against them. Only with some trust that parts of the world are independent can we gain evidence of any other hypothesis."* This is the formal capability-security reading of *only trust makes distinctions*.

### §5 PKI comparison — Subject, Issuer, Certificate, Resource

§5 compares capabilities with SPKI (RFC 2693). The Granovetter Diagram for PKI has four distinct nodes: **Subject** (the would-be authorized party), **Issuer** (the certificate signer), **Certificate** (the authorization itself, signed by Issuer), **Resource** (the protected object). In SPKI, *there is no direct link between Issuer and Subject* — the SPKI authorization could be anonymously posted, sent through an anonymous remailer, etc. The Subject identifies itself by possessing the matching private key; the Issuer signs and publishes; the entire process can be offline. There is no way to confine the Issuer.

The paper enumerates structural differences between capability-based and SPKI-based authorization:

- **Auditing**. In SPKI, auditing who performed an action and who authorized it falls naturally out of the public-key structure (the auditor records the public keys of Issuer and Subject). In Pluribus, auditing requires introducing intermediary objects to track the authorization path.
- **Designation**. An SPKI authorization does not include a direct designation of the resource being authorized; this introduces the possibility of a *confused deputy* (Hardy 1988). The confused deputy uses an authorization given to it by one party to access a resource designated by a different party; the deputy thereby performs an unintended rights transfer.
- **Cost**. Authorization in SPKI is expensive: each authorization decision requires at minimum two signature verifications. Pluribus's public-key operations are limited to connection establishment.
- **Confinement**. SPKI cannot confine the Issuer — the Issuer can authorize anyone, anywhere, offline. Pluribus can confine, since the only way to issue a capability is to message-pass it through an existing reference graph.

The §5 paper labels the structural contrast: SPKI's enforceable subset is "an off-line, auditable, heavyweight, non-confinable, semi-capability system" versus E's "on-line, repudiatable-by-default, lightweight, confinable, full-capability system."

### §6.2 The four-axis rights taxonomy

§6 introduces a taxonomy of electronic rights along four orthogonal axes:

| Axis | Capabilities | SPKI | Example Purse-Money |
|------|--------------|------|---------------------|
| **Shareable vs Exclusive** | Alice *shares* with Bob her right to access Carol (Bob's possession doesn't preclude Alice's continued possession). | Issuer *shares* with Subject the authorization to the Resource. | When Bob deposits the payment from Alice, he knows he has *excluded* anyone else from using that money. |
| **Specific vs Fungible** | A capability designates a *specific* object. | Authorization can be for specific objects, or for some number of units. | Money is *fungible*, since we care only about quantity, not individual bills. |
| **Opaque vs Assayable** | A capability is *opaque*: from the capability alone all you can determine is what the designated object alleges about itself. | An authorization can be *read as well as used*; reading may suffice to *assay* what value it would provide. | Bob can reliably assay the amount in an alleged purse only by transferring into a purse he trusts. |
| **Exercisable vs Symbolic** | A capability has value only because it can be *exercised* (by sending a message). | An authorization may be for either or both. | As with fiat money, our example money is *purely symbolic* — one can't do anything with it other than transfer it further. |

The §6.2 closing observation about *Shareable vs Exclusive* exposes the architectural challenge: in the real world, information is sharable and physical objects are exclusive. In the capability case, if Alice drops the capability after passing it to Bob, Bob *happens to* have exclusive access — but this isn't quite an exclusive right since Bob is unable to *know* he is the only one who has it. The §6.4 `TitleCompanyMaker` will fix this by composition.

### §6.4 The CoveredCallOption smart contract

§6.4 walks through a smart-contract implementation of a covered call option. *Call* means the option holder may buy the stock. *Covered* means the option seller puts aside stock to cover the possible exercise of the option as long as it is outstanding. The contract is written as a composition of: an `escrowedStock` purse (reserves stock while offer is OPEN), an `escrowedMoney` purse (intermediate money-transfer purse), and a `timer` capability (access to real-world time).

```
define CoveredCallOptionMaker(
    timer,                  # access to a real-world time service
    escrowedStock,          # reserves stock while offer is OPEN
    escrowedMoney,          # intermediate money-transfer purse
    # The 3 args above are from broker. The 4 below from options-writer
    stockSrc,               # provides the stock offered for sale
    deadline : integer,     # time until which the offer is OPEN
    moneyDest,              # where the seller receives payment
    exercisePrice : integer # price that must be paid for the stock
) : any {
    define numShares : integer := stockSrc getBalance
    escrowedStock deposit(numShares, stockSrc)  # escrow all shares

    define state := "OPEN"
    define cancel() {
        if (state == "OPEN") {
            stockSrc deposit(numShares, escrowedStock)  # return stock
            state := "CANCELLED"
        }
    }
    timer after(deadline - timer now, cancel)

    define CoveredCallOption {
        to exercise(moneySrc, stockDest) {
            require(state == "OPEN", "not open")
            require(timer now < deadline, "too late")
            escrowedMoney deposit(exercisePrice, moneySrc)
            state := "CLOSED"
            try {
                moneyDest deposit(exercisePrice, escrowedMoney)
            } finally {
                stockDest deposit(numShares, escrowedStock)
            }
        }
    }
}
```

The structural reading: the contract is a *composite* (§2.4 terminology) whose facets are `CoveredCallOption` and the `cancel` function held only by the timer. The option contract is *atomic*: the `exercise` method first attempts to deposit the exercise price from the holder's `moneySrc` into the broker's `escrowedMoney`; *only if this succeeds* does the option then transfer the money and stock to writer and holder respectively. If escrowedMoney's deposit fails, the option remains open. The `try { ... } finally { ... }` block ensures that if the moneyDest deposit succeeds, the stockDest deposit also runs — the property that makes this a *covered* call.

The §6.4 closing question: *what kind of right have we created?* It is **specific** (refers to particular shares of particular stock), but fungible options can be created. It isn't quite **assayable** — the holder cannot reliably tell which stock is being offered or which currency is demanded without inspecting the broker. It is **exercisable**. It also introduces a new dimension — **perishable rather than durable**: the right to exercise spoils after a time.

However, unlike a real-world option, **it is sharable rather than exclusive**. If Alice (the initial options holder) wishes to give Bob the option, Bob must assume Alice still holds it. As with the purse, they are sharing rights to manipulate exclusive rights. To make an *exclusive* option, the §6.5 `TitleCompanyMaker` adds exclusivity by *composition*:

```
define TitleCompanyMaker(precious, name) : any {
    require(precious != null, "must provide an object")
    define [sealer, unsealer] := BrandMaker pair(name)
    define PurseMaker(myPrecious) : any {
        define extract() : any {
            require(myPrecious != null, "empty")
            define result := myPrecious
            myPrecious := null
            result
        }
        define purse {
            to printOn(out) { out print(`<holds $myPrecious>`) }
            to isFull   : any { myPrecious != null }
            to sprout   : any { PurseMaker(null) }
            to getExtract : any { sealer seal(extract) }
            to deposit(src) {
                require(myPrecious == null, "full")
                myPrecious := unsealer unseal(src getExtract)()
            }
            to exercise(verb, args) : any {
                E call(myPrecious, verb, args)
            }
        }
    }
    PurseMaker(precious)
}
```

The structural pattern: `TitleCompanyMaker` adapts the §3.4 money pattern to make a *single specific exercisable object* exclusive rather than fungible. Among such sibling purses, *only one holds the object at a time* — to move the object from one purse to another, one must have both purses. The result: a purse-shaped wrapper that makes any wrapped object behave as an *exclusive* right. The broker uses this to make the option exclusive: the broker holds the original purse-for-option indexed by description; when Bob wants to buy from Alice, Bob acquires an empty purse from the broker, Alice deposits her option-holding into Bob's empty purse, and at the moment of deposit Bob knows he holds the exclusive option.

### §7 Composable security, readable contracts — the conclusion

§7 names the paper's contribution: *"The kind of composition of abstractions demonstrated above is familiar in the object programming world, but without the security shown. The creation of cryptographic protocols for securely trading a variety of financial instruments is familiar in the financial cryptography world, but without the separation of concerns and easy composability shown. The best capability operating system work [KeyKOS] does combine abstraction and security in this way, but without a notation to make the issues clear, and only when all parties fully trust one common platform."*

The paper's closing claim: by using the Granovetter Operator as a bridge, the three worlds — object computation, capability-based secure OS, financial cryptography — can be applied synergistically to the engineering of a single integrated system.
