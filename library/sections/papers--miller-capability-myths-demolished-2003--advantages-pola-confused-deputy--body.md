---
title: Body
source: Capability Myths Demolished (SRL2003-02)
source_kind: paper
source_authors: [Mark S. Miller, Ka-Ping Yee, Jonathan Shapiro]
source_year: 2003
source_venue: JHU SRL Technical Report SRL2003-02
source_url: https://srl.cs.jhu.edu/pubs/SRL2003-02.pdf
source_pdf_sha256: b6a3e04e60d7ef08d32900143f8e93acbdcb62e2b63160b604591d7a021f7f42
ingested: 2026-05-15
ingested_by: scholar
topics: [capability-security, capability-theory, patterns]
status: current
parent: papers--miller-capability-myths-demolished-2003--advantages-pola-confused-deputy
---

### Least-privilege operation requires Properties B and G

The Saltzer & Schroeder 1975 principle of least privilege says "every entity should operate using the minimal set of privileges necessary to complete its task." The paper observes:

> Operating in least-privilege fashion demands that we provide access to minimal resources, and that we grant such access to minimal subjects. ... Property B: Dynamic Subject Creation is necessary for limiting authority when starting new running instances of software components. In order for subjects to be able to create instances with limited authority, each instance must have its own separate set of authorities, and must therefore be a distinct subject. ... Property G: Dynamic Resource Creation is necessary in order for the model to be able to express access restrictions on objects (such as individual files) that can be created and destroyed. No security model limited to controlling a static set of resources can possibly have sufficient expressive detail to support least-privilege operation on a dynamic system.

The two properties together are *necessary but not sufficient*: a system can hold B and G yet still leak authority through other channels. But without both, least privilege is *infeasible*: a static-subject system (Property B failing) cannot grant a fresh principal a separate authority set; a static-resource system (Property G failing) cannot meaningfully discuss authority over resources that come and go.

The paper notes: "The three capability-like models offer both of these properties, whereas the ACL model is missing Property B. The POSIX capabilities mechanism bears a weak resemblance to capability models but lacks Property G, so it cannot (on its own) support least-privilege operation."

### Confused deputies and Properties A + D

The paper introduces confused deputies via the classic Hardy 1988 example:

> A deputy is a program that must manage authorities coming from multiple sources. A confused deputy is a deputy that has been manipulated into wielding its authority inappropriately. ... The classic story of the confused deputy concerns a compiler in an ambient authority system. The compiler is granted write access to a file called BILL in order to store billing information. Upon invoking the compiler, the user can specify the name of a file to receive the debugging output. If the user specifies BILL as the name of the debugging file, the compiler is fooled into overwriting the billing information with debugging information.

The paper identifies the two property failures the example depends on:

**Property D (No Ambient Authority).** "The question of ambient authority determines whether subjects can identify the authorities they are using. If subjects cannot identify the authorities they are using, then they cannot associate with each authority the *purpose* for which it is to be used. Without such knowledge, a subject cannot safely use an authority on another party's behalf." The compiler holds the BILL-write authority and the user-supplied BILL-write authority, but cannot tell them apart because both arrive nameless from the ambient namespace.

**Property A (No Designation Without Authority).** "An authorization given by one party is used to access a resource designated by a different party, bringing about an unintended transfer of authority. In ACL systems, because designation and authorization are necessarily separated, this confusion is difficult to escape. In a system where designation and authority are inseparable, this common type of confused deputy problem — in which a malicious party designates a resource they are not supposed to access — simply cannot occur."

The paper proves: "the presence of Property A *implies* the presence of Property D" (because if every designation carries its own authority, ambient authority is structurally absent — designators cannot be authority-less).

The combined result is the paper's Figure 14: a small diagram that reads "Property A IMPLIES Property D"; "Property A means designation inseparable from authority"; "Property D means there are no ambient authorities"; "Property D IMPLIES authorities arrive in context of requests"; "Properties together CONTRIBUTE TO easier to write an unconfusable deputy."

### Unconfusable deputies

The phrase *unconfusable deputy* (the paper's coinage in this section) names a deputy that — by virtue of its host system holding Properties A and D — *cannot* be tricked into using one authority where another was intended. The argument:

> Object-capability systems possess both Property A and Property D, so they enforce the combination of designation with authority, enable the assignment of local identifiers to authorities, and encourage the presence of context when authorities are conveyed. All three of these things contribute to establishing a chain of designation, running from the original creator of a resource, through the entity that exercises the resource, and finally to the resource itself.

The paper's framing of *maintaining this unbroken chain of designation* is the upstream root of Endo's discipline around connector-vended Handles. A `Handle` carries with it both the authority to act and the identity of what it acts on; an agent receiving a Handle has a chain of designation back to the connector that vended it.

### A note on terminology

The paper's penultimate section, *A Note on the Word "Capability"*, explicitly stakes the claim that the object-capability model is the *true* capability model:

> Given these various interpretations of the capability model, the reader may wonder what one should adopt as the most legitimate meaning for the term *capability*. ... We would argue that the "true" capability model is the object-capability model, because all known major capability systems take the object-based approach (for examples, see [1, 4, 9, 11, 16, 17, 19, 21]).

The paper explicitly distances object capabilities from "POSIX capabilities", "Netscape capabilities", and "split capabilities" — three things that "have never been presented as security mechanisms that can stand on their own." This is the source of later capability-security writing's habit of marking *object-capability* as a distinct term-of-art rather than letting "capability" carry the meaning unambiguously.

### Conclusion

The paper's closing claim:

> We have described a progression of four security models from traditional ACLs to pure capabilities, while defining a set of seven properties that can be used to distinguish the models. ... The distinctions that we have drawn support our refutations of three common misconceptions concerning capability-based systems — the Equivalence Myth, the Confinement Myth, and the Irrevocability Myth. Although the myths have some truth in the intermediate security models we have often taken as interpretations of capabilities, they do not hold for the "pure capability" or "object-capability" model represented by the vast majority of capability systems. Furthermore, the properties we identified show that capability systems lack certain fatal flaws of ACL systems — namely, the susceptibility of ACLs to the confused deputy problems that are inherent in ambient authority systems, and the inability of ACLs to perform least-privilege delegation to new processes. Capability-based systems provide much stronger support for the precise, minimal, and meaningful delegation of authority, which is fundamental to secure operation.

Source: [SRL2003-02.pdf](https://srl.cs.jhu.edu/pubs/SRL2003-02.pdf) pages 11-13; SHA-256 `b6a3e04e60d7`.
