---
title: Excess Authority and the Logic of Designation (cp vs cat; functionality vs security; object-capability as designation + authority aligned)
source: "The Structure of Authority: Why Security Is Not a Separable Concern (MOZ 2004, LNAI 3389)"
source_kind: paper
source_authors: [Mark S. Miller, Bill Tulloh, Jonathan S. Shapiro]
source_year: 2005
source_paper_year: 2004
source_venue: "MOZ 2004 (Multiparadigm Programming in Mozart/Oz), Springer LNAI 3389"
source_url: https://papers.agoric.com/papers/the-structure-of-authority-why-security-is-not-a-separable-concern/abstract/
source_pdf_sha256: f92e409045cee73bea534c58e196994564e1a6e80f31a0f854cdea9cdfc3385d
source_paper_pages: "1-6 (§1 Excess Authority, §1.1 How Much Authority Is Adequate, §2 Composing Complex Systems, §2.1 Object-Capability Model)"
ingested: 2026-05-17
ingested_by: liaison-direct-draft
topics: [capability-theory, capability-security]
status: current
---

## Abstract

§1 names the problem the paper sets out to solve: **excess authority is the gateway to abuse**. Every program a typical user launches inherits the user's full authority — Solitaire can read your email, install backdoors, and delete arbitrary files, regardless of whether Solitaire is itself malicious or merely buggy and exploitable. Conventional approaches to this — running programs as applets (no authority, unusable), or static sandboxing via policy files — fall short because *the right amount of authority changes dynamically as a program executes*; only the act of designation itself reveals what authority is actually needed. §1.1 sharpens this with the canonical cp-versus-cat comparison: `cp foo.txt bar.txt` passes filenames as strings, forcing cp to need authority over *the entire filesystem* before it can open the files it was asked to copy; `cat < foo.txt > bar.txt` passes pre-opened file descriptors, so cat needs authority *only over the specific files passed in*. Both perform the same task; their least-authority differs by orders of magnitude. This is not a security accident — it is a *logical consequence* of which entity does the designation. §2 generalizes the lesson: in a programming language, *designation* (which references an object holds) and *authority* (what an object can affect) can be the same act — an object's permissions just are the references it holds. The object-capability model is the natural alignment: a reference indivisibly combines the designation of a particular object, the means to access it, and the right to access it. §2.1 closes by claiming that the object-capability model does *not* treat access control as a separable concern; rather it is **a model of modular computation with no separate access control mechanisms**. POLA (the Principle of Least Authority) is the *discipline* of taking advantage of this alignment to grant authority on a need-to-do basis, just as good modular practice grants information on a need-to-know basis.

## Body

### §1 The gateway-to-abuse framing

Software systems today are highly vulnerable. The paper traces this widespread vulnerability to a single architectural decision: programs routinely inherit far more authority than they need to do their jobs. Solitaire is the case study. The least authority Solitaire actually needs is the ability to draw in its window, receive UI events targeted at it, and write a score file the user specifies. The least authority Solitaire actually receives — as a program launched on Windows, UNIX, macOS, or PalmOS — is the *full authority of the user who launched it*: read any file, write any file, scan email for tidbits, install backdoors, forward spam. A corrupted Solitaire (whether due to malicious origin or an exploitable bug enabling attacker control) becomes a vehicle for everything the user could have done.

The paper presents this as a *forced choice* in conventional systems. Figure 1's two-axis diagram (Cooperative vs Isolated on the vertical; Dangerous vs Safe on the horizontal) names the conventional positions: applications run with the *user's full authority* (cooperative-and-dangerous), applets run with *no authority* (isolated-and-safe-but-useless), and static sandboxing offers a middle ground at the cost of either configuration complexity or constant user-facing security dialogs. The diagonal *Static Sandboxing* arrow on Figure 1 captures the conventional sense that security and functionality must be traded off against each other.

The paper's contribution is to refute this forced choice. The diagram's upper-right corner — *cooperative AND safe* — is labeled "E, CapDesk, Polaris: Dynamic Least Authority", and the rest of the paper explains how that corner is reached. The mechanism is *dynamic allocation of authority*: provide the right amount of authority *just-in-time* (when designation reveals what is needed) rather than *just-in-case* (anticipating every operation a program might be asked to perform).

### §1.1 The cp-vs-cat lesson — designation determines least authority

The two Unix shell commands `cp foo.txt bar.txt` and `cat < foo.txt > bar.txt` perform the same task: copy `foo.txt` to `bar.txt`. But they follow very different *logics of designation* — and their least-authority requirements differ accordingly.

**cp:** The shell passes the two strings `"foo.txt"` and `"bar.txt"` to cp. By these strings, the user means particular files *in the user's namespace*. For cp to open the files it has been asked to operate on, cp must already have *the authority to use the user's namespace* and *the authority to read and write any file the user might name*. Given this way of using names, cp's least authority still includes all of the user's authority to the filesystem. This is so broad as to make practical least-authority hopeless.

**cat:** The shell uses `"foo.txt"` and `"bar.txt"` to determine which files the user means to designate. Once this is resolved, the shell passes cat *direct access to the files*, as open file descriptors. cat performs the copy by reading and writing through those file descriptors. cat's least authority is precisely what one would expect — the right to read this particular `foo.txt` and the right to write this particular `bar.txt`. cat needs no further access to the user's filesystem.

The architectural lesson is sharp: **today's widely deployed systems support both styles of access control**, but typically *grant authority to open a file on a per-user basis (creating dangerous pools of excess authority)* while also *dynamically granting access to a file descriptor on a per-process basis (a form of capability discipline)*. Ironically, only the first style is officially explained as providing access control. The capability discipline that cat embodies is doing the real work, but it is left unnamed and unsystematic.

### §2 The architectural payoff — designation and authority as one act

§2 generalizes the cp/cat lesson from process-launching to in-language object composition. To build systems that are both functional and secure, the paper argues, programmers need *tools, practices, and design patterns that enable them to combine designation with authority*. Designation occurs in two main places:

1. **User-interface designation** — users designate actions through the user interface (drag-and-drop, file-open dialog boxes, selection).
2. **Object-to-object designation** — objects designate actions by sending requests to other objects (via the references they hold).

In both places, developers already have rich experience with supporting designation. The user-interface community has Yee's "User Interaction Design for Secure Systems" framing (cited as [Yee04]) and a rich tradition of widget design. The programming-language community has the tools of modularity and abstraction. The architectural insight is that *security is not a separable concern* because the same tools that decompose-and-then-recompose systems for modularity and abstraction *also* decompose-and-recompose authority — *if* the language aligns designation with authority.

### §2.1 The object-capability model — references as the access graph

In the object model, programmers decompose a system into objects and compose those objects to get complex functionality. References create the paths of communication. Objects send messages along these references to request services on their behalf.

In the **object-capability model**, references indivisibly combine three things:

1. The **designation** of a particular object (which object this reference points to).
2. The **means to access** the object (the ability to invoke it by sending messages).
3. The **right to access** the object (the authority to do so).

By requiring that objects interact *only* by sending messages on references, the reference graph *becomes* the access graph. The object-capability model does not treat access control as a separable concern; rather it is **a model of modular computation with no separate access-control mechanisms**.

The §2.1 closing positions this against Dijkstra's "separation of concerns": Dijkstra's modest 1974 suggestion that we temporarily separate concerns as a *conceptual aid* for reasoning about complex systems is *applicable* to security as it is to correctness and modularity. What the paper calls into question is the conventional practice of treating access-control concerns — the allocation of access rights within a system — *separately from* the practice of designing and building systems. One cannot make a system more modular by adding a modularity module; security must be treated as part of the process of de-composing and composing systems. Access control in the object-capability model derives from the pursuit of abstraction and modularity. Parnas's principle of *information hiding* says abstractions should hand out information only on a *need to know* basis. **POLA simply adds that authority should be handed out only on a *need to do* basis.** Modularity and security each require both.

## Translation block (E idiom → Endo / JavaScript surface)

| Paper concept                              | Endo / Hardened JavaScript equivalent                                                                  |
| ------------------------------------------ | ------------------------------------------------------------------------------------------------------ |
| cp's "authority over the user's namespace" | A bundle granted broad endowment access. Avoided by Endo's "endow only what's named" discipline.       |
| cat's pre-opened file descriptor model     | Endo's pattern of passing pre-resolved capability handles into bundles instead of name strings.        |
| Reference as designation + authority       | An Endo formula handle or `E()`-able proxy. Holding the reference *is* the right to invoke.            |
| Static sandboxing                          | Compartment-with-static-endowments. Useful but cannot adapt to dynamic designation.                    |
| Dynamic least authority                    | Endo's preferred posture — each bundle gets the smallest endowment object adequate to the task at the moment it is granted, computed from the user's designation. |
| Object-capability model                    | The model Endo's compartment + lockdown + marshal stack enacts in JavaScript. The reference graph between exos and bundles is the access graph. |
| POLA (need-to-do)                          | The discipline scholar's [[principle-of-least-authority]] concept page (deferred) will anchor.         |

## Implications for Endo

This section is the *philosophical anchor* for Endo's whole posture on bundle endowment. The cp-vs-cat distinction is the operational principle behind decisions like:

1. **Endow bundles with capability handles, not paths.** When a bundle needs to read a specific document, the user designates that document through the petname graph and the daemon hands the bundle a capability to read *that* document — never the authority to read arbitrary documents in the user's home.
2. **Avoid the "TCB = anything launched by the user" antipattern.** Endo's bundle-launching is closer to CapDesk than to conventional shell launching: a bundle's authority is determined by what was *designated to it* at start, not by what the launching user could have done.
3. **The reference graph IS the access graph.** Endo's formula graph and petname graph together form the same kind of access graph the paper names. Forwarding restrictions, sealing, and marshal's pass-style classifications are all about preserving the access-graph invariant across bundle / vat / network boundaries.
4. **POLA is a discipline, not a feature.** Endo provides the *substrate* (compartment + lockdown + capability-aligned references) but the discipline of granting need-to-do authority is a *design pattern* each Endo application enforces for itself. The paper's framing makes this explicit: POLA can only be practiced where designation is well-aligned with authority.

## See also

- [[principle-of-least-authority]] — *placeholder concept page*. The paper's §1.1 cp/cat example and §2.1 closing paragraph are the canonical exposition; this section is the citation when a future Endo design needs to ground POLA in the literature.
- [[object-capability]] — the existing concept page (anchored to Capability Myths Demolished's Model 4 framing) gains another citation here. The four-models taxonomy and the designation-aligned-with-authority framing are complementary perspectives on the same model.
- `papers--miller-capability-myths-demolished-2003--abstract-and-introduction` — the companion paper that names the four capability models; this paper *uses* Model 4 and shows it scales across abstraction layers.
- `papers--miller-tribble-shapiro-concurrency-among-strangers-2005--defensive-correctness-and-pola` — the same authors' concurrency-control framing of POLA; the statusGetter/statusSetter facet-split example there is a worked instance of the cp/cat lesson at the object-method granularity.

## Common confusions

- **"POLA is about denying capabilities."** No. POLA is about *granting capabilities precisely matched to need*. The §1 framing makes clear that withholding authority (the applet stance) is just the failure mode of denying functionality; POLA aims to be cooperative AND safe simultaneously, which requires *granting* the right authority at the right moment.
- **"Capabilities and ACLs are interchangeable access-control mechanisms."** No. The §2.1 architectural claim is that the object-capability model *eliminates* access control as a separable concern; capability discipline is *not* an access-control mechanism layered over a modular system — it is a *property* of how the modular decomposition is done. ACL systems treat access control as a separate concern; capability systems don't.
- **"cat is more secure than cp because cat is shorter."** No. The §1.1 lesson is that cat is more secure because *the shell* performs the designation in the user's namespace before invoking cat, so cat receives a *narrow capability* (a file descriptor) instead of a *broad credential* (the user's filesystem authority). The architectural property is in the shell-cat composition, not in cat itself.
