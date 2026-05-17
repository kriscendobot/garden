---
title: The Fractal Structure of Authority (Simon's hierarchy + Hayek's local knowledge; four layers; four ways B can come to know about C)
source: "The Structure of Authority: Why Security Is Not a Separable Concern (MOZ 2004, LNAI 3389)"
source_kind: paper
source_authors: [Mark S. Miller, Bill Tulloh, Jonathan S. Shapiro]
source_year: 2005
source_paper_year: 2004
source_venue: "MOZ 2004 (Multiparadigm Programming in Mozart/Oz), Springer LNAI 3389"
source_url: https://papers.agoric.com/papers/the-structure-of-authority-why-security-is-not-a-separable-concern/abstract/
source_pdf_sha256: f92e409045cee73bea534c58e196994564e1a6e80f31a0f854cdea9cdfc3385d
source_paper_pages: "6-15 (§2.2 Fractal Locality of Knowledge, §3 Fractal Nature of Authority, §3.4 Object-Granularity POLA)"
ingested: 2026-05-17
ingested_by: liaison-direct-draft
topics: [capability-theory, capability-security, patterns]
status: current
---

## Abstract

§2.2 names the structural pattern that makes the paper's argument work: knowledge in well-engineered systems exhibits **fractal locality**. Complex systems are hierarchical and recursive (Simon's hierarchy argument) AND within each layer, dynamic subcontracting networks of clients and providers form (Hayek's local-knowledge argument). The static-and-dynamic combination means "least authority" can only be determined *locally*: no central planner has the knowledge to compute what authority every level needs, just as Hayek argued no central planner has the knowledge to allocate economic resources. The implication for POLA is structural: authority-allocation must be *as local as the design knowledge it serves*. §3 names this as the **fractal nature of authority** and surveys four levels of composition (people in an organization, applications launched from a desktop, modules within an application, language-level objects) at which the same POLA logic applies. The paper's deepest contribution is §3.4's **four ways one object can come to know about another**: by *Introduction* (an existing third object shares the reference), by *Parenthood* (an existing object creates the new one), by *Endowment* (an existing object creates a new object pre-bound to a known reference), and by *Initial Conditions* (the universe started this way). These four are *exhaustive* — there is no other way for two previously disconnected subgraphs to come to know about each other. The rule that **only connectivity begets connectivity** falls out as a corollary, and from it the further claim that the reference graph *is* the access graph in any system where these are the only ways objects come to know about each other.

## Body

### §2.2 The fractal locality of knowledge

What the object model and object-capability model have in common is a *logic of designation* that explains how computational decisions dynamically shape the *topology of the "knows-about" relationship*. The division of knowledge into separate objects that cooperate through sending requests creates a **natural sparseness of knowledge** within a system. The object-capability model harnesses that sparseness to protect objects from one another: objects that do not know about one another, and consequently have no way to interact, cannot cause each other harm. By combining designation with authority, the object-capability model explains how computational decisions dynamically determine the *structure of the "access-to" relationship* — the topology of authority.

The paper draws on two distinct strands of complex-systems theory to ground this:

**Simon's hierarchy argument.** Herbert Simon argued in his 1962 paper "The Architecture of Complexity" that complex systems frequently take the form of hierarchies — "one of the central structural schemes that the architecture of complexity uses". Subsystems are nested within subsystems, with interactions much denser within levels than across them. In biology: cells make up tissues that make up organs that make up organisms; cells in different organs interact via chemical signaling because direct interaction is unavailable to them. In software: organizations contain applications contain modules contain objects, with the same pattern of dense-within-level and sparse-across-level interaction. Hierarchy is the *static* skeleton of complex systems.

**Hayek's local-knowledge argument.** Within layers of abstraction, the paper observes a much more *dynamic* process. Computation is largely organized as a dynamic *subcontracting network*: components requesting services from other components, with the topology changing as services come online and as clients change their requirements. Friedrich Hayek's "Use of Knowledge in Society" (1945) argued that the division of labor in an economy is *best understood as a division of knowledge* — diverse plans can be coordinated only based on local knowledge; no central entity possesses the knowledge needed to coordinate every agent's plan. Hayek argued that prices function as a mechanism for *summarizing* local knowledge into globally-tradeable signals; the paper transposes this argument to authority: *no central entity has the knowledge to allocate authority within a computer system according to POLA*. The entity would need to understand the duties of every abstraction in the system, at every level of composition, at every moment. "Least" and "duties" can only be understood **locally**.

This is *not* a defeatist conclusion — it is an *architectural* one. POLA is achievable, but only when *the entity that performs the designation also performs the authority allocation* (because that entity has the local knowledge of what the request requires). The cp/cat lesson is the simplest worked example: the *shell* has local knowledge of what `cat < foo.txt > bar.txt` means in this moment, and so the shell is the right place to allocate authority over those specific files to cat. No central policy file could have predicted this allocation in advance.

### §3 The fractal nature of authority — four major levels

§3 inherits the access matrix model (Lampson 1974, Graham 1972) as a durable abstraction for reasoning about access control: an access matrix snapshots the protection state, with active entities (rows) holding rights (filled cells) over protected resources (columns). The paper extends the access matrix to depict **authority** rather than merely permissions: authority includes both direct permissions and *indirect causal access* via the permitted actions of intermediary objects. Saltzer and Schroeder's "principle of least privilege" (1975) is reinterpreted as **least authority** to capture this distinction; the term "access graph" is reserved for the structure of direct permissions specifically.

The paper then claims a structural result: when complex systems are organized as nested layers of abstractions (Simon's hierarchy), applying POLA *at each level* recursively reduces the system's attack surface. Howard, Pincus, and Wing's notion of an "attack surface" (2003) — the sum of a system's exploitable vulnerabilities weighted by their exposed area in the access matrix — is the metric the paper uses to make this claim quantitative in principle (though the paper concedes that *quantifying* attack surface in practice is largely inaccessible due to limited knowledge of vulnerability distributions).

Four major levels are surveyed:

1. **Human-Granularity POLA** — among the people in an organization (Alan, Barb, Doug; their respective `~alan`, `~barb`, `~doug` accounts; collaboration via OS-level permissions). The TCB at this level is the OS kernel and `root`; everything is necessarily vulnerable to that TCB.
2. **Application-Granularity POLA** — among the applications launched by a person from their desktop (e.g., Doug's CapDesk + Polaris-managed Mozilla, Excel, Eudora). The TCB at this level is CapDesk + the base OS account; the *programs launched by CapDesk* are *not* part of the user's TCB.
3. **Module-Granularity POLA** — among the modules within an application (e.g., CapMail's main module granting its address book module access to the address book, granting its SMTP module access to outbound mail, but *not* granting the crypto library access to the address book or outbound mail). The TCB at this level is the application's main() / startup module.
4. **Object-Granularity POLA** — among the individual language-level objects (where the *finest* application of POLA happens, with B and C being individual objects and A being an existing third object).

The paper's strongest claim is that these levels *compose multiplicatively*: a fraction of the attack surface removed at each level multiplies into a recursive reduction in total exposure. The cross-hatching in the figures depicting the four levels — the un-zoomed-into non-legacy boxes — represents this multiplicative claim: exposure within each "alan" box is further reduced by POLA practiced within that box, and so on recursively.

### §3.4 Object-Granularity POLA — the four ways B can come to know about C

The deepest section of the paper is §3.4's enumeration of how two previously-disconnected objects in a running system *can come* to know about each other. The paper claims this enumeration is exhaustive — there are exactly *four* ways:

**1. By Introduction.** If B and C already exist, and B does not already know about C, then the only way B can come to know about C is if there exists an object A that:
- already knows about C
- already knows about B
- decides to share with B her knowledge of C

In object terms: A holds references `b` and `c`. A sends `b.foo(c)` — a message to B with C passed as an argument. B does not know or care what name A's code uses to refer to C; B simply receives a parameter that is C. (Unlike the cp example, which passes a string `"c"`, and like the cat example, which passes a direct access.)

**2. By Parenthood.** If B already exists and C does not, then if B creates C, at that moment B is the only object that knows about C. Other objects come to know about C only by inductive application of these four steps. Parenthood occurs by normal object instantiation: calling a constructor, evaluating a lambda expression, importing a module.

**3. By Endowment.** If A and B already exist and C does not, then if there exists an object A that already knows about C, A can create B such that B is *born already endowed with knowledge of C*. B might be instantiated by lambda evaluation in which a free variable `c` within B is bound to C in B's creation context (as supplied by A). Or A might instantiate B by calling a constructor, passing C as an argument. If A creates module B by importing data describing B's behavior, A's importing context must explicitly provide bindings for all the free variables in this module file — and these values must already be accessible to A. **The imported B module must not be able to magically come into existence with authorities not granted by its importer.**

**4. By Initial Conditions.** For purposes of analysis, there is always a *first instant* of time at which B might already know about C, because the universe-of-discourse came into existence in that state. In Endo terms, this is the bootstrap moment when the daemon comes online with its initial root petname graph.

The paper's structural result: **only connectivity begets connectivity**. New knows-about relationships can only be brought about from existing knows-about relationships. Two disjoint subgraphs of the reference graph can *never become connected* (which is why garbage collection of unreachable subgraphs can be transparent). If two subgraphs are *almost disjoint*, they can only interact or become further connected according to the decisions of those objects that bridge the two subgraphs. The bridging objects are the *only* points of authority transfer.

This rule gives the object-capability model its formal teeth. An object can only affect the world outside itself by sending messages on references it holds. An object can only be affected by the world outside itself by receiving messages from objects that hold a reference to it. If objects have no possibility of causal access by other means (no global variables, no ambient authority), then **an object's permissions are exactly the references it holds**. The object reference graph becomes the access graph. Together with designational integrity (Close's "y-property", 2003) and support for defensive correctness (explained in Spiessens-VanRoy 2005), these *are* the rules of object-capability security.

The §3.4 closing observation: knowing the rules of chess is distinct from knowing how to play chess. The practice of using these rules well — *capability discipline* — is mostly just an extreme form of good modular software engineering practice. Several people who learned capability discipline have independently noticed that they find themselves following capability discipline even when writing programs for which security is of no concern. **It consistently leads to more modular, more maintainable code.**

## Translation block (E idiom → Endo / JavaScript surface)

| Paper concept                              | Endo / Hardened JavaScript equivalent                                                                  |
| ------------------------------------------ | ------------------------------------------------------------------------------------------------------ |
| Introduction (A sends `b.foo(c)`)          | `E(b).foo(c)` — passing a capability through eventual-send. Pre-resolved or unresolved; the receiver gets a usable reference regardless. |
| Parenthood (B creates C)                   | A bundle instantiating a new exo via `makeExo()` or a constructor. The parent holds the only reference to the child initially. |
| Endowment (B is born with c)               | A bundle endowed with specific capability handles at compartment-construction time. The endowment is fixed at the moment of creation. |
| Initial Conditions                         | Endo daemon startup — the initial petname graph + root host object are the "initial conditions" everything else descends from. |
| "Only connectivity begets connectivity"    | The Endo invariant that the formula graph is the access graph. Marshal preserves this across pass-style boundaries by refusing to fabricate references the sender doesn't already hold. |
| "Imported B module must not magically come into existence with authorities not granted by its importer" | Endo's compartment endowment discipline: a compartment is hard-isolated by default; every authority it exercises must trace back to something the parent compartment / bundle explicitly granted at construction time. |

## Implications for Endo

This section is the structural justification for several Endo invariants that might otherwise look like implementation choices:

1. **The formula graph IS the access graph.** Endo persists the formula graph because *the formula graph is the persistent record of who-can-access-whom*. The four ways a new formula can come to exist (introduction by passing through marshal; parenthood via new-formula construction; endowment via initial-formula bindings; initial conditions = the daemon's bootstrap petname graph) are the same four enumerated in §3.4. Endo's persistence model — *persistence by traversal from petname roots* — directly enforces "only connectivity begets connectivity."
2. **Marshal's pass-style discipline preserves connectivity.** When values cross a marshal boundary (out-of-process, on the wire, into a fresh bundle), marshal preserves the invariant that the receiver cannot acquire references the sender doesn't already hold. The smallcaps tagged-record syntax, the `@qclass` annotations, and the brand/sealing primitives all serve this invariant.
3. **Endowments are explicit.** Endo bundles do not silently gain authority from the surrounding host; everything in their compartment-construction endowment object is what they will ever have unless future *introductions* (eventual-send passing of new capabilities) extend their access graph. This is the operational form of "imported B module must not magically come into existence with authorities not granted by its importer."
4. **The fractal locality argument justifies bundle composition.** Endo's nested-bundle / nested-compartment posture (a bundle can spawn a sub-bundle with a subset of its own authority) is the operational form of nested POLA. The §3.5 framing (nested TCBs follow the spawning tree) is the architectural blueprint Endo's daemon-bundle-compartment hierarchy enacts.

## See also

- [[object-capability]] — the existing concept page. This section is the *structural-theorem* citation; the existing page's *taxonomy* (four models from Capability Myths Demolished) is the access-control-as-distinct-from-other-models citation. Both ground the same model.
- [[four-tables-coordinated-retention]] — the four ways a formula identifier comes to exist in the daemon (introduction via marshal, parenthood via formula construction, endowment via initial petname graph, initial conditions = daemon bootstrap) match the four ways enumerated here. The Endo concept is the implementation enactment.
- `papers--miller-tribble-shapiro-concurrency-among-strangers-2005--vat-and-event-loop-model` — the vat model is the unit of *temporal* separation; this paper's nested-POLA framing is the unit of *spatial* / authority separation. Together they cover the full decomposition.
- `endo--designs-daemon-persistence--persistence-by-petname-traversal` — the Endo design that enacts "only connectivity begets connectivity" as a persistence invariant.

## Common confusions

- **"The four ways are pluralistic — there might be others."** No. §3.4 makes the exhaustiveness claim explicit and proves it by exclusion: any way for B to come to know about C must either be a fact of the universe-of-discourse's initial state (Initial Conditions), or involve a third object A connecting B to C (Introduction), or involve B coming into existence already-connected (Endowment), or involve C coming into existence in B's hands (Parenthood). These are the only possibilities; any "new" way collapses to one of these four.
- **"Endowment is just constructor injection."** Endowment is structurally identical to constructor parameter injection *when the parameter is a capability reference rather than a value*. The §3.4 framing reveals why constructor injection is the discipline it is: it enacts Endowment, which is one of the only four authority-transfer mechanisms.
- **"Hierarchy and subcontracting are competing models."** No. The §2.2 framing combines them: hierarchy is the *static* skeleton (Simon), subcontracting is the *dynamic* topology (Hayek), and POLA is enforceable only because both hold. A purely flat system would lack the locality that makes least-authority computable; a purely static system would lack the dynamic responsiveness that makes least-authority appropriate.
- **"Only connectivity begets connectivity is just GC reachability."** GC reachability is *one* consequence — disjoint subgraphs can be collected because they cannot affect anything reachable. But the rule is stronger than GC: it also gives the *security* result that disjoint subgraphs cannot affect each other, and the *composition* result that two-near-disjoint subgraphs interact only through their bridging objects. These three results share the same structural cause.
