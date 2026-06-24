---
title: Body
source: "Capability-Based Financial Instruments (Financial Cryptography 2000, Springer LNCS 1962)"
source_kind: paper
source_authors: [Mark S. Miller, Chip Morningstar, Bill Frantz]
source_year: 2000
source_venue: "Financial Cryptography 2000, Springer LNCS 1962"
source_url: https://papers.agoric.com/papers/capability-based-financial-instruments/abstract/
source_pdf_sha256: 49c7606bbf78f3cd5e4565802dcaf2e87254ed9ab02ed955dd6963053fecfb8e
source_paper_pages: "1-15 (§1 Overview + §1.1 Introduction + §1.2 Six Perspectives; §2 From Functions To Objects; §3 From Objects to Capabilities, §3.1-§3.3 including Rights Amplification)"
ingested: 2026-05-28
ingested_by: liaison-direct-draft
topics: [capability-theory, capability-security, patterns]
status: current
parent: papers--miller-morningstar-frantz-capability-based-financial-instruments-2000--granovetter-six-perspectives-and-object-capability-model
---

### §1.1 The three-community bridge

The §1.1 framing names three intellectual traditions and their respective strengths:

- **Object computation community**: strong on *abstraction and composition*. Modular programming via encapsulated state-plus-behavior.
- **Capability-based secure operating systems community**: strong on *shared platforms where mutually-untrusted processes interact without being able to damage each other*. KeyKOS / EROS as canonical instances.
- **Financial cryptography community**: strong on *cooperative protocols allowing mutually suspicious parties to trade a diversity of rights in the absence of a mutually-trusted platform*.

Each community has been *weak* in the areas where the other two are strong. The paper's contribution is to identify a single abstraction the three share — the Granovetter Diagram — and build the engineering bridge from that. Mark Granovetter (1973) originally developed these diagrams to illustrate how the topology of interpersonal-knowledge relationships changes as people introduce people they know to each other; the paper finds the same diagram powerful for understanding relations between computational objects in a network.

### §1.2 The six perspectives on the Granovetter Operator

The same diagrammatic step — Alice sending Bob a message `bob.foo(carol)` — supports *six simultaneously-correct interpretations*:

1. **Objects.** The "message send" (Smalltalk) or "virtual member function call" (C++). Alice, Bob, Carol are three objects; the foo message includes a copy of Alice's reference to Carol as an argument.
2. **Capability Security.** Adding the constraint *Bob can only come to have a reference to Carol if a third party such as Alice already has both and voluntarily decides to share* — i.e., the Granovetter step is *the only way* Bob can acquire new authority. "Only connectivity begets connectivity"; the object becomes a capability.
3. **Cryptographic Protocol.** When Alice, Bob, and Carol live in three separate vats on three separate machines, **Pluribus** is E's cryptographic capability protocol implementing the Granovetter Operator across that network. Distributed object systems like CORBA and RMI implement the diagrammatic step over the network but as *cooperative* protocols (assume correct machines); Pluribus preserves capability semantics over *mutually suspicious* machines.
4. **Public Key Infrastructure.** SPKI [Ellison-Frantz-Lampson-Rivest-Thomas-Ylonen RFC 2693] interprets digital certificates as authorizations. Treating the foo message-arrow as a certificate signed by Alice stating "Bob has authority to perform the action represented by Carol" lets the Granovetter step be viewed as PKI — though SPKI's lack of confinement and its repudiation-by-default give it different tradeoffs than full capability semantics.
5. **Game Rules.** Board-game state constrains a player's available moves; a chosen move changes the board and thus alters subsequent available moves. The Granovetter step is exactly this: pre-step, only Alice can introduce Carol to Bob (mandatory security); whether she does so is *her* choice (discretionary security). Post-step, Bob can both message Carol and introduce her further. The paper notes that *non-zero-sum, partial-information game theory* is the natural formal framework for reasoning about secure capability-based distributed multi-agent computation; the paper does not explore this perspective further but flags it as a research direction.
6. **Financial Bearer Instruments.** If Carol provides a useful service, then the ability to send messages to Carol is a useful *right*. Any secure electronic-rights system must solve three problems: representing who has what rights, enabling rights-holders to exercise them and no more, and enabling holders to securely transfer rights. The Granovetter Operator solves all three at once: the reference graph IS the representation of who has what rights, the rule that you can only message objects you have references to enforces the exercise discipline, and the Granovetter step IS the transfer. The §6.2 four-axis taxonomy will later distinguish the *kinds* of rights this primitive expresses.

### §2 Object computation = lambda + message-dispatch + local-side-effects

§2 derives the object model from three composable extensions to lambda calculus. The composable form: **Objects == Lambda Abstraction + Message Dispatch + Local Side Effects**.

- **§2.1 Lambda Abstraction.** Nested function definition with lexical scoping; closures inherit their creating context's free variables. The `adderCreator` / `adder` example. The paper uses "instance variable" for what Church called the value of a free variable.
- **§2.2 Message Dispatch.** The most visible difference between a function and an object: a function's behavior satisfies just one kind of request; an object's behavior bundles methods. A request (a *message*) names which method is being invoked. `PointMaker(x, y)` returns a Point object with `printOn`, `getX`, `getY`, `add` methods.
- **§2.3 Local Side Effects.** Variables become primitive variable-objects; user-defined objects contain bindings mapping names to these variable-objects. Assignment is a `setValue` message; reading is a `getValue` message. The `getterSetterPair(value)` example shows the most basic composite — a triple of `[getter, setter, value]` where getter and setter share access to the value variable.
- **§2.4 Composites and Facets.** A *composite* is a network of objects exposed via a subset that are *facets* — externally-reachable members. The `[getter, setter]` pair are facets of a composite whose internal `value` is not a facet because no reference to it can escape. The §2.4 mechanical insight: *the rules of interaction among composites are the same as the rules of interaction among individual objects* — composition is **compositional**.
- **§2.5 The Dynamic Reference Graph.** The fabric of an object system is the *dynamic reference graph*. Objects are nodes; references are arcs. Only computation within the graph brings about changes to the graph's topology, and only changes the topology currently permits. The Granovetter Diagram is the operative view: the dynamic reference graph is primary, objects themselves secondary.

### §3.1 Capability operating systems

The §3.1 historical thread: capabilities were first invented by secure-OS designers as a protected ability to invoke arbitrary services provided by other processes. Each process holds a c-list (capability list) of (process-id, numeric-tag) pairs; the numeric tag selects a method, the process-id designates the provider. The equivalence with objects is direct: the *behavior* looked up by capability is paired with *process-state*, same state-and-behavior structure that defines an object. When different capabilities make different behaviors available from the same process via different numeric tags, the process is a *composite* and each capability is a *facet*.

### §3.2 Patterns of cooperation without vulnerability

§3.2 contains one of the paper's most-quoted observations: *required trust is a form of dependency*. Object programmers seek modularity (decrease in dependencies between separately-thought-out units); capability programmers seek security, recognizing the same thing — required trust IS a dependency on the trusted party's good behavior. **If B is designed to be invulnerable to A's malice, it is likely also invulnerable to A's bugs.** Object programmers guard against bugs; capability programmers guard against malice; the disciplines converge because the *substrate* (modularity) is shared. The paper names the goal: a growing taxonomy of *patterns of cooperation without vulnerability* — stereotyped arrangements in which mutually suspicious, separately interested agents may work together safely.

### §3 From objects to capabilities — the three connectivity-acquisition mechanisms

To get from objects to capabilities, the paper prohibits certain deviations from pure object computation. The structural constraint is *Only Connectivity Begets Connectivity*: there are exactly three ways Bob can obtain access to Carol.

1. **Connectivity by Introduction.** Somebody sends Bob a reference to Carol (the Granovetter Diagram). If Bob and Carol already exist, this is the only way Bob can obtain access — via a third party such as Alice under the three conditions of §1.2.
2. **Connectivity by Parenthood.** Bob creates Carol. Any object system must have an object-creation primitive. When Bob uses this primitive to create Carol, Bob has the *only* reference to Carol unless and until he sends it to someone else.
3. **Connectivity by Construction.** If Bob's creator has access to Carol at the time of Bob's creation, Bob may be created *sharing* this access. The PointMaker example: the PointMaker has access to `x` as a parameter; the new Point is created with `x` as part of its initial endowment.

(*Library cross-note: Structure of Authority 2004 §3.4 later names these as **Introduction / Parenthood / Endowment** with a fourth — **Initial Conditions** — added. This 2000 paper's "Connectivity by Construction" is the 2004 paper's "Endowment"; the 2004 paper adds Initial Conditions as the bootstrap-time mechanism the 2000 paper implicitly assumes. The two enumerations are structurally compatible; see [[four-ways-to-acquire-references]] for the canonical concept page.*)

Languages satisfying this constraint are sometimes called *memory-safe languages*. Object systems with garbage collection depend on this property to enable GC to be *semantically transparent* — disjoint subgraphs cannot become reconnected, so unreachable storage may be silently recycled. The §3 enumeration also names **Absolute Encapsulation** (no access to an object's internals from outside without the object's consent) and **All Authority Accessed Only by References** (anything globally accessible must be transitively immutable, otherwise it would constitute an unconditional authority source outside the reference-passing rules).

### §3.3 Rights amplification — sealer/unsealer pairs and BrandMaker

§3.3 introduces a primitive most capability systems provide that is NOT motivated solely by pure object programming: **rights amplification**. The classic example is the can and the can-opener — only by bringing the two together do we obtain the food in the can. Two common forms exist: sibling-communication [Hardy] and **sealer/unsealer pairs** [Morris73, Miller87, Tribble95, Appendix D of Rees96]. E primitively provides sealer/unsealer pairs.

Sealer/unsealer pairs are conceptually like public/private key pairs:

- The **sealer** is like an encryption key.
- The **unsealer** is like a decryption key.

The provided primitive `BrandMaker` returns such a pair when its `pair` method is called:

```
? define [sealer, unsealer] := BrandMaker pair("MarkM")
# value: [<MarkM sealer>, <MarkM unsealer>]

? define envelope := sealer seal("Tuna")
# value: <sealed by MarkM>

? unsealer unseal(envelope)
# value: Tuna
```

When the sealer is asked to seal an object, it returns an *envelope* that can only be unsealed by the corresponding unsealer. **If the envelope is the can and the unsealer is the can-opener (specific to this brand of cans), then `"Tuna"` is the food.**

The name-string argument to `pair` ("MarkM") is *purely for documentation and debugging*; it has no security role. The security comes from the pair's unguessable identity: only the holder of the unsealer can extract what's inside, and the unsealer is reachable only by being explicitly handed out (the four-ways-to-acquire constraint).

The §3.4 mint/purse money example will build the most-cited capability example in the literature on top of this primitive.
