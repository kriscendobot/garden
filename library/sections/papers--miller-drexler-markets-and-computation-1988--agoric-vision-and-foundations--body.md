---
title: Body
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
parent: papers--miller-drexler-markets-and-computation-1988--agoric-vision-and-foundations
---

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
