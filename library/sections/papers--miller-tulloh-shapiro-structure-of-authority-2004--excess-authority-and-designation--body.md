---
title: Body
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
parent: papers--miller-tulloh-shapiro-structure-of-authority-2004--excess-authority-and-designation
---

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
