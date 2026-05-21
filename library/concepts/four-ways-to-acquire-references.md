---
id: four-ways-to-acquire-references
aliases: ["four ways", "four ways to acquire references", "Introduction", "Parenthood", "Endowment", "Initial Conditions", "only connectivity begets connectivity", "ways B can come to know about C"]
topics: [capability-theory, capability-security, patterns]
---

# four-ways-to-acquire-references

The **exhaustive enumeration** of how one object can come to hold a reference to another in an object-capability system. Structure of Authority §3.4 names the four mechanisms; any way for B to come to know about C must collapse to one of these:

1. **Introduction**. If B and C already exist, and B does not already know about C, then *the only way* B can come to know about C is if there exists an object A that already knows about both, and A *decides to share* with B her knowledge of C. In object terms: A holds references `b` and `c`; A sends the message `b.foo(c)`. B does not know or care what name A's code uses to refer to C; B simply receives a parameter that *is* C.
2. **Parenthood**. If B already exists and C does not, then if B creates C, *at that moment B is the only object that knows about C*. Other objects come to know about C only by inductive application of these four steps. Parenthood occurs by normal object instantiation: calling a constructor, evaluating a lambda expression, importing a module.
3. **Endowment**. If A and B already exist and C does not, then if A already knows about C, A can create B *such that B is born already endowed with knowledge of C*. B might be instantiated by lambda evaluation in which a free variable `c` within B is bound to C in B's creation context (as supplied by A). Or A might instantiate B by calling a constructor, passing C as an argument. The architectural rule: **the imported B module must not be able to magically come into existence with authorities not granted by its importer**.
4. **Initial Conditions**. For purposes of analysis, there is always a *first instant of time* at which B might already know about C, because the universe-of-discourse came into existence in that state. In Endo terms, this is the bootstrap moment when the daemon comes online with its initial root petname graph.

The enumeration is **exhaustive**. Any "new" way collapses to one of these four. The structural corollary is the most-quoted single sentence in the capability-theory literature: **only connectivity begets connectivity**. New knows-about relationships can only be brought about from existing knows-about relationships. Two disjoint subgraphs of the reference graph can *never become connected* — which is why garbage collection of unreachable subgraphs can be transparent. If two subgraphs are *almost disjoint*, they can only interact or become further connected according to the decisions of the objects that bridge them.

This rule gives the object-capability model its formal teeth: an object's permissions are exactly the references it holds. The object reference graph *becomes* the access graph. Together with designational integrity (Close's "y-property", 2003) and defensive correctness (Concurrency Among Strangers 2005), these *are* the rules of object-capability security.

## Sections that touch this concept

| Section | One-line summary |
|---|---|
| [papers--miller-tulloh-shapiro-structure-of-authority-2004--fractal-structure-of-authority](../sections/papers--miller-tulloh-shapiro-structure-of-authority-2004--fractal-structure-of-authority.md) | The §3.4 **canonical enumeration**: Introduction / Parenthood / Endowment / Initial Conditions as the exhaustive list. Plus Simon's hierarchy + Hayek's local-knowledge as the structural justification for why POLA can only be practiced locally. |
| [papers--miller-shapiro-paradigm-regained-2003--object-capability-model-and-redells-caretaker](../sections/papers--miller-shapiro-paradigm-regained-2003--object-capability-model-and-redells-caretaker.md) | §4 names *only connectivity begets connectivity* as the structural rule. §4.2's loader transformation (`loader.load(code, ["x" => x, "y" => y])`) is the *Endowment* mechanism in its purest formal form: all linking happens by virtue of these explicit associations. |
| [papers--miller-shapiro-paradigm-regained-2003--access-abstraction-and-confinement](../sections/papers--miller-shapiro-paradigm-regained-2003--access-abstraction-and-confinement.md) | §5's Cassie+Max factory + factoryMaker is the most-worked-out *Endowment* example in the Miller corpus: Cassie's `acceptProduct(:Factory)` instantiates Max's code under Cassie's chosen state. Confinement is achievable *because* of the four-ways constraint. |
| [papers--miller-tribble-shapiro-concurrency-among-strangers-2005--partial-failure-and-when-catch](../sections/papers--miller-tribble-shapiro-concurrency-among-strangers-2005--partial-failure-and-when-catch.md) | §9.2 *Offline capabilities* (`captp://...` URIs and `SturdyRef`) describes the *Initial Conditions* mechanism in distributed form: how a fresh reference graph can be bootstrapped from a small set of offline capabilities after partition. |
| [papers--miller-capability-myths-demolished-2003--four-models-and-seven-properties](../sections/papers--miller-capability-myths-demolished-2003--four-models-and-seven-properties.md) | The seven properties (A-G) include the design conditions the four mechanisms must satisfy: Property A (No Designation Without Authority), Property D (No Ambient Authority), Property F (Access-Controlled Delegation Channels). The four-ways enumeration is *implicit* in the Model 4 (object-capability) specification. |

## See also

- [[object-capability]] — the substrate that lets the four-ways enumeration be exhaustive. In ACL models, the enumeration is *not* exhaustive (ambient-authority lookups, principal-as-creator-owner rules, etc.); object-capability models close those gaps.
- [[principle-of-least-authority]] — POLA is achievable *because* the four-ways constraint holds. Every authority transfer goes through one of the four mechanisms; POLA reasons about which mechanism is appropriate.
- [[caretaker-pattern]] — the canonical *Introduction* mechanism at the design-pattern level: A introduces B to a Caretaker `carol2` rather than to Carol directly, attenuating the authority B receives.
- [[formula-graph]] — the Endo enactment. The four ways a new formula identifier comes to exist in the daemon (introduction via marshal pass-style; parenthood via formula construction; endowment via initial bundle endowments; initial conditions via daemon bootstrap) match §3.4 exactly.
- [[per-agent-keypair]] — the agent identity is an *Initial Conditions* artifact at the per-agent layer: a fresh keypair is part of the bootstrap state every agent is born with.

## Common confusions

- **"There must be other ways."** §3.4 is explicit about exhaustiveness. Any "new" way collapses to one of the four by definition. Counter-examples typically involve *ambient authority* (the model in which a subject can resolve a name in a global namespace) — but ambient authority is exactly the failure mode the object-capability model rules out. Once you have ambient authority, you have an *additional* fifth way and the formal teeth dissolve.
- **"Endowment and Parenthood are the same."** Parenthood: B creates C, B holds the only reference. Endowment: A creates B *with C already in B's scope*. The distinction matters because Endowment requires A to have already had access to C, so Endowment is the mechanism by which existing authority propagates into a new subject; Parenthood is the mechanism by which a *fresh* reference comes into existence.
- **"Initial Conditions is a hack."** No — Initial Conditions is the *necessary* first step. Every system needs a first instant. The interesting design question is *what* is in initial conditions: a maximally-empowered root user (the failure mode), or a minimum-viable seed of bootstrap capabilities (the POLA-compatible design). Endo's daemon bootstrap chooses the latter.
- **"`b.foo(c)` is just argument passing."** It is argument passing *and* it is authority transfer. The §3.4 Introduction mechanism makes explicit what's happening: A is *introducing* B to C via the act of sending a message. Lexical scoping is the within-language form of the same primitive.
- **"GC reachability is just an optimization."** GC reachability is *one* consequence of only-connectivity-begets-connectivity. The deeper consequence is the security result: disjoint subgraphs cannot affect each other; near-disjoint subgraphs interact only through bridging objects. GC is a *visible* symptom of the underlying structural rule.
- **"The four ways are sufficient for POLA."** The four ways constrain *how* authority transfers; they say nothing about *what* authority transfers. POLA is the discipline of choosing what; the four-ways constraint is the substrate that lets the choice be enforceable.
