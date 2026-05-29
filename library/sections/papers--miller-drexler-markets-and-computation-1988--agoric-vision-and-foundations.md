---
title: The Agoric Vision and Foundations (encapsulation as property right; Hayek's spontaneous order; capability security as the three-mechanism rule; ownership and trade of resources)
source: "Markets and Computation: Agoric Open Systems (Ecology of Computation, Elsevier 1988)"
source_kind: paper
source_authors: [Mark S. Miller, K. Eric Drexler]
source_year: 1988
source_venue: "The Ecology of Computation (Huberman, ed.), Elsevier Science Publishers B.V. (North-Holland)"
source_url: https://papers.agoric.com/papers/markets-and-computation-agoric-open-systems/abstract/
source_pdf_sha256: f058464a36bb0dc0f54514268ff9f8bbf061c94ff7cd0412c9c1fcf73603910b
source_paper_pages: "133-148 (§1 Introduction + §1.1-§1.2; §2 Overview; §3 Computation and economic order with subsections §3.1-§3.7; §4 Foundations with subsections §4.1-§4.5)"
ingested: 2026-05-28
ingested_by: liaison-direct-draft
topics: [capability-theory, capability-security, patterns]
status: current
---

## Abstract

The 1988 Miller-Drexler paper that introduces **agoric systems** — software systems using market mechanisms, based on foundations providing for the *encapsulation* and *communication* of *information*, *access*, and *resources* among *objects*. The term *agoric* is coined from *agora* (Greek for meeting and market place); this paper is the historical and conceptual seed of the Agoric project itself, and the term-of-art most directly carried into modern Endo / Agoric work is the *agoric system* designation. §1 frames the central claim: as computation moves from centralized to increasingly decentralized models of control and action, market mechanisms become a natural extension. §3 grounds the proposal in two Hayekian arguments: prices summarize local knowledge into globally-actionable signals, and *spontaneous order* yields coherent results from local interactions that no central planner could reproduce. The §3.1 framing names two extremes (command economy / market economy) and concludes that *computational markets, like human markets, will consist of islands of central direction in a sea of trade*. §3.2 makes the deepest structural claim: **encapsulation in software serves the same crucial function as property rights in human affairs** — establishing protected spheres in which entities can plan and act free of interference from unpredictable external influences. §4 names the foundational triple: support for encapsulation and communication of (a) information, (b) access, (c) resources. §4.1's *capability security* definition is the 1988 ancestor of the four-ways-to-acquire-references enumeration — A can get access to B only by (1) being born with it (creator already had access), (2) receiving it in a message, or (3) being the creator of B. The §4.3 *competence vs performance modularity* distinction is the paper's deepest architectural contribution: object-orientation modularizes *competence* (what programs can do) via message-passing interfaces; computational markets modularize *performance* (how efficiently programs do it) via prices as abstract interface for resource costs.

## Body

### §1.1 Why focus on markets — Hayek as load-bearing economist

§1.1 frames the central proposal: this work explores essentially *pure markets* as models of economic organization for computation, supported by a minimal "legal" framework of foundational constraints. The justification is Hayek's: markets are, on the whole, remarkably effective in promoting efficient, cooperative interactions among entities with diverse knowledge, skills, and goals. Historically those entities have been human beings, but economic principles extend to decision-making agents in general — and hence to software objects as well. The §1.1 closing observation: *the distinctive rules of markets (such as suppression of force and protection of trademarks) foster the spread of cooperation*. The paper's argument is that *market ecosystems are particularly appropriate as foundations for open systems* in which evolving software spread across a distributed computer system serves different owners pursuing different goals.

### §1.2 The agoric sketch — encapsulation + communication of information, access, resources

§1.2 names the proposal: the *agoric* approach to software systems. *Agoric* (a·gó·ric) stems from *agora* (ág·o·ra), the Greek term for a meeting and market place. **An agoric system is defined as a software system using market mechanisms, based on foundations that provide for the encapsulation and communication of *information*, *access*, and *resources* among *objects*.**

The notion of "object" the paper uses is independent of scale and language and includes no notion of inheritance. An object might be small and written in an object-oriented language; equally well it might be a large, running process (such as an expert system or a database) coded internally in any manner whatsoever. Objects are assumed to communicate through message passing and to interact according to the rules of actor semantics, enforceable at either the language or operating-system level.

The three-layer framing the rest of the paper develops:

- **Encapsulation and communication of information** — corresponds to elements of traditional object-oriented practice; in large systems facilitates local reasoning about *competence* issues (what computations the system can perform).
- **Encapsulation and communication of access** — capability security; in §3.1 of the 2000 *Capability-Based Financial Instruments* paper this becomes the explicit *Granovetter Operator* framing.
- **Encapsulation and communication of resources** — extension to computational resources (memory, processor time, etc.). Facilitates local reasoning about *performance* issues (about the time and resources consumed in performing a given computation).

### §3.1-§3.2 Encapsulation as property right — Hayek and Alchian-Allen

§3.1 names the two extreme forms of organization (command economy / market economy) and frames the architectural conclusion: *computational markets, like human markets, will consist of islands of central direction in a sea of trade*. The paper invokes Hayek's *Constitution of Liberty* and Adam Smith's *Wealth of Nations* in §3.2's opening:

> The rationale of securing to each individual a known range within which he can decide on his actions is to enable him to make the fullest use of his knowledge.... The law tells him what facts he may count on and thereby extends the range within which he can predict the consequences of his actions. — F. A. Hayek, 1960

The structural translation to computation: *encapsulation in software serves the same crucial function as property rights in human affairs* — establishing protected spheres in which entities can plan and act free of interference from unpredictable external influences. **Without encapsulation, parasitic objects would proliferate, costs of inefficiency would not be confined to inefficient objects, and the incentive system needed for evolutionary improvement would fail.**

§3.2 names a more subtle observation: *central direction of data representation and processing has been replaced by decentralized mechanisms* (the rise of object-orientation), but *central direction of resource allocation remains*. The systems programmer attempts to legislate a general solution for memory allocation, scheduling, and so on; *these general solutions, however, provide no way to make tradeoffs that take account of the particular merits of particular activities at particular times*. The §3.2 closing diagnosis is the architectural justification for agoric systems: object-orientation modularized data and code via property rights; *agoric systems extend property rights to resources*.

### §3.3-§3.4 Trade and spontaneous order — Hayek as the load-bearing argument

§3.3 opens with two Hayek quotes that ground the paper's claim that prices summarize local knowledge:

> ...the chief guidance which prices offer is not so much how to act, but *what to do*. — F. A. Hayek, 1978

The architectural reading for computation: *prices for computational resources tell objects what to do — what work is worth doing now, given the current relative scarcities of memory, time, and bandwidth*. The §3.3 framework treats producers as objects that *to increase value as judged by the rest of the system as a whole, a producer need only ensure that the price of its product exceeds the prices (costs) of the inputs consumed*. **This simple, local decision rule gains its power from the ability of market prices to summarize global information about relative values.**

§3.4 generalizes to *spontaneous order* — Hayek's framing of markets as systems whose behavior cannot be reproduced by any individual planner. The §3.4 closing observation:

> Markets are a form of "evolutionary ecosystem", and such systems can be powerful generators of spontaneous order: consider the intricate, undesigned order of the rain forest or the computer industry. **The use of market mechanisms can yield orderly systems beyond the ability of any individual to plan, implement, or understand.** What is more, the shaping force of consumer choice can make computational market ecosystems serve human purposes, potentially better than anything programmers *could* plan or understand.

This is the paper's deepest claim about why agoric systems matter for computer science as a discipline: *the goal is not to make software sweat, but to guide it in making choices that serve the general interest*.

### §3.5 Coase's question — why firms? Why bundle into "computational firms"?

§3.5 invokes Coase's 1937 puzzle: if markets are efficient, why do firms exist? The economic answer is *transaction costs* — costs of advertising, negotiation, accounting, and establishing trust. The paper's translation to computation:

- **Inside a firm**, matching consumers with producers does not require advertising, instructions do not require negotiation, movement of goods does not require invoices and funds transfer, coworkers share an interest in their joint success.
- **For small enough objects and transactions**, the cost of accounting and negotiations will overwhelm any advantages from making flexible price-sensitive tradeoffs.
- **For large enough objects and transactions**, market mechanisms are worth the cost.
- **At intermediate scale**, negotiation will be too expensive but accounting will help guide planning.

The §3.5 closing prescription: *these scale effects will encourage the aggregation of small, simple objects into "firms" with low-overhead rules for division of income among their participants*. The architectural prediction: agoric systems will exhibit a *layered* structure where small objects bundle into computational "firms" at low layers and trade in markets at higher layers.

### §4 Foundations — encapsulation and communication of information, access, resources

§4.1 *Information and access* defines the substrate. The paper's three-mechanism enumeration is the 1988 ancestor of the 2004 four-ways:

> Capability security: with capability security, object A can get access to object B only by:
> 1. being born with it, when object A's creator already has that access;
> 2. receiving it in a message (from an object that already has that access); or
> 3. being the creator of object B.

(*Library cross-note: Structure of Authority 2004 §3.4 refines this enumeration to four mechanisms — Introduction / Parenthood / Endowment / Initial Conditions — and Paradigm Regained 2003 §4 develops the formal model. The 1988 enumeration combines what 2004 calls "Endowment" (born with) and 2004 calls "Initial Conditions" (was already there at creation) into the single mechanism "being born with it"; the 2004 refinement is what gives the four-way enumeration its formal teeth. See [[four-ways-to-acquire-references]] for the canonical concept page.*)

§4.1 names the security argument the §4.5 *Paradigm Regained* refines in 2003: *Turing-equivalence describes the abilities of a system, but security rests on inabilities — on the inability to violate certain rules*. The 1988 paper is the earliest published anchor for this argument.

§4.2 *Ownership and trade* introduces *resource encapsulation* — agoric systems require the encapsulation and communication of computational resources (memory, processor time). This prevents the evolution of parasitic objects, confines the costs of inefficiency to inefficient objects and their customers, and (in suitable implementations) makes performance information available locally.

The §4.2 cited foundational work is Artsy's "*The Design of Fully Open Computing Systems*" [22], which corresponds to what the paper calls **extreme separation of mechanism and policy** — the mechanism is the support of protected transfer of ownership and the verification of ownership on access; all other resource-allocation is provided as user-level policy. Schedulers and memory allocators operate via an ownership-and-trade model, completely outside the secure operating system kernel.

§4.3 *Resource ownership and performance modularity* names the paper's deepest architectural contribution: the **competence vs performance** distinction.

> The activity of a running program may be analyzed in terms of *competence* and *performance*. Competence refers to what a program can do given sufficient resources, but without explicit consideration of these resources. Competence includes issues of *safety* (what the program will not do) and *liveness* (whether the program will eventually do what it is supposed to). Performance refers to the resources the program will use, the efficiency with which it will use them, and the time it will take to produce results.

The §4.3 architectural prescription, summarized in Figure 4 of the paper:

| | Formal Analysis | Modularity |
|---|---|---|
| **Competence, Safety, Liveness** | Semantics, Correctness proofs | Object-oriented programming, Message passing |
| **Performance, Efficiency** | Complexity theory, Proofs of response time | **Computational markets, Prices** |

The paper's claim: **computational markets do for performance modularization what object-oriented programming does for competence modularization**. Prices serve as an abstract interface for resource costs the way message protocols serve as an abstract interface for competence effects.

§4.4 *Currency* notes that within a mutually trusted hardware subsystem, *capability-based security plus unforgeable unique identifiers are sufficient for establishing a public key system without resorting to encryption*. This is the 1988 framing of the 2000 paper's VatID + swiss number machinery — capability-rooted identity rather than cryptography-rooted identity. Distributed systems will then require third-party trusted machines serving as banks for transfer of currency between mutually-distrustful machines.

The §4.4 closing recommends *a variety of local currencies with exchange rates among them* rather than a single global currency — a prescient observation about heterogeneous economic substrates whose 1988 form anticipates the contemporary multi-stablecoin ecosystem.

## Translation block (paper idiom → Endo / Agoric / Hardened JavaScript surface)

| Paper concept                              | Endo / Agoric equivalent                                                                                       |
| ------------------------------------------ | -------------------------------------------------------------------------------------------------------------- |
| Agoric system                              | The Agoric project itself; the company name derives directly from this paper's coinage. *Agoric* = *agora*-style. |
| Encapsulation as property right            | The library's existing `principle-of-least-authority` and `security-as-extreme-modularity` concept pages. The 1988 framing is the *political* form ("property rights"); the 2004 *Structure of Authority* Table 1 is the *engineering* form. |
| Three-mechanism capability security        | The 1988 ancestor of the four-ways-to-acquire-references concept page. "Being born with it" is the 1988 combination of what 2004 calls Endowment + Initial Conditions; "receiving in a message" = Introduction; "being the creator" = Parenthood. |
| Competence vs performance modularity       | An architectural insight Endo has only partially exercised. Competence modularity is well-developed (exo + marshal + lockdown); performance modularity is largely unrealized — the @endo stack does not currently price resources. |
| Ownership and trade of computational resources | Agoric SwingSet's meter-and-fuel discipline is the closest production enactment; Endo daemons do not currently price the resources bundles consume. |
| "Islands of central direction in a sea of trade" | The contemporary architectural arrangement: a bundle / vat is internally centrally-directed; cross-bundle interactions are governed by capability-discipline equivalent of "trade". |
| Currency = capability + unforgeable identifiers | This 1988 framing is the conceptual ancestor of Agoric's IST stablecoin + ERTP issuer mechanics — capability-rooted rather than cryptography-rooted identity. |

## Implications for Endo

This paper is the **historical and conceptual seed of the Agoric project** and is most useful as the citation for several long-standing assumptions in the Endo / Agoric posture:

1. **The Agoric name and mission trace here.** The Agoric company name, the *agoric system* discipline, and the broader ambition to apply market mechanisms to computational resource allocation all originate in this 1988 paper. The library's `capability-theory` topic now has the entire historical arc: 1988 (agoric vision), 2000 (capability-based money), 2003 (CMD + Paradigm Regained), 2004 (Structure of Authority), 2005 (Concurrency Among Strangers).
2. **The three-mechanism capability-security definition is older than the four-way.** The library has been citing 2004 *Structure of Authority* §3.4 as the canonical four-ways-to-acquire-references reference; this 1988 paper §4.1 is the three-mechanism ancestor. The combination of *Endowment* + *Initial Conditions* into a single 1988 "being born with it" is worth noting on the concept page as the historical evolution.
3. **Competence vs performance modularity is a load-bearing architectural framing the library has been implicit about.** Endo / Agoric design reviews implicitly distinguish these concerns (exo design = competence; gas/meter discipline = performance), but the library does not yet have a concept page making the §4.3 distinction explicit. This is a strong candidate for a future concept page.
4. **"Islands of central direction in a sea of trade"** is the most-quoted architectural framing of this paper. The contemporary Endo posture matches: a bundle is internally centrally-directed (one compartment, one trust boundary); cross-bundle interactions are governed by capability discipline — the computational analog of trade. This 1988 framing anchors the architecture.

## See also

- [[four-ways-to-acquire-references]] — the concept page. The §4.1 three-mechanism definition is the 1988 ancestor of the 2004 four-mechanism enumeration; the library concept page now spans both vintages.
- [[principle-of-least-authority]] — the concept page. The §3.2 *encapsulation as property right* framing is the political-economic version of POLA; the 2004 *Structure of Authority* Table 1 is the engineering version.
- [[security-as-extreme-modularity]] — the concept page. The §4.3 *competence vs performance modularity* distinction is a structural argument that anticipates the 2004 thesis: every modularity discipline is also a security discipline.
- `papers--miller-morningstar-frantz-capability-based-financial-instruments-2000--granovetter-six-perspectives-and-object-capability-model` — the 2000 paper's three-mechanism enumeration (Introduction / Parenthood / Construction) is the direct successor of this 1988 enumeration ("being born with it" splits into Construction; "receiving in a message" = Introduction; "being the creator" = Parenthood). The 2000 paper drops "Initial Conditions" entirely; the 2004 paper restores it.
- `papers--miller-tulloh-shapiro-structure-of-authority-2004--fractal-structure-of-authority` — the 2004 paper's four-way refinement.
- `papers--miller-shapiro-paradigm-regained-2003--access-abstraction-and-confinement` — the 2003 paper's *abstraction-as-protection* thesis is the architectural elaboration of this 1988 paper's §4.1 *security rests on inabilities* observation.

## Common confusions

- **"Agoric systems are about cryptocurrency."** No — the 1988 paper predates cryptocurrencies by 21 years. *Agoric* describes any computational system using market mechanisms for resource allocation, with capability discipline as the access-control substrate. The 1988 currency framing (§4.4) is capability-rooted, not cryptography-rooted. The 2000 paper's capability-based money is the earliest worked-out form; production Agoric (the company) builds on this lineage but is broader than its monetary aspect.
- **"Three vs four mechanisms is a contradiction."** No — the 1988 enumeration combines Endowment + Initial Conditions into the single mechanism "being born with it"; the 2004 refinement splits them because the *time of creation* (Endowment) and the *universe-of-discourse origin* (Initial Conditions) are mechanically distinct. The 2004 refinement is the canonical form.
- **"Competence vs performance is just safety vs liveness."** No — competence subsumes safety and liveness (the *what* of a program). Performance is the *how efficient* dimension. The §4.3 Figure 4 explicitly maps competence to the safety/liveness pair and performance to its own dimension.
- **"This paper is about replacing programming with economics."** No — the §3.5 Coase argument explicitly anticipates *firms* in the computational market: small objects will bundle into low-overhead computational "firms" where internal accounting is not warranted. Markets are not a universal solvent; they are most appropriate at *intermediate-and-larger scales* where transaction costs are dominated by inefficient-decision costs.
- **"Spontaneous order is hand-wavy."** §3.4's spontaneous-order argument is rigorous to the extent Hayek's economic argument is rigorous: prices summarize local knowledge into globally-actionable signals, and the system as a whole exhibits coherent behavior that no individual planner could reproduce. The §3.4 claim is testable in principle and rests on the §3.2 *encapsulation = property rights* structural argument.
