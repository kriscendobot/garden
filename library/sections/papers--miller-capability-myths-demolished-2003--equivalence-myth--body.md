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
topics: [capability-security, capability-theory]
status: current
parent: papers--miller-capability-myths-demolished-2003--equivalence-myth
---

### The static-matrix framing

The paper's Figure 2 introduces an example access matrix with three subjects (Alice, Bob, Carol), three resources (`/etc/passwd`, `/u/markm/foo`, `/etc/motd`), and cells like `{read}`, `{write}`, `{read, write}`. Reading the matrix column-by-column produces an ACL system (each resource's column lists every subject's authority for it). Reading row-by-row produces a capabilities-as-rows system (each subject's row lists every authority it holds, called a "C-list"). The two organizations carry the same information, so the static models are equivalent — but only because the matrix says nothing about *how the cells change*.

### Property A: No Designation Without Authority

Drawing the references as **arrows** in both diagrams (Figure 3 vs Figure 4) reveals the **direction** of the relationships. In the ACL model, arrows point from resource to subject (the ACL is stored with the resource and names subjects). In the capability model, arrows point from subject to resource (the capability is held by the subject and references the resource). The capability arrow's source serves *both* as the designator of the resource *and* as the authority to access it. The ACL arrow's source designates only; authority lives separately in the cell.

The paper formalizes this as **Property A: No Designation Without Authority** — "does designating a resource always convey its corresponding authority?" An ACL system cannot have Property A because designation (the name `/etc/passwd`) is decoupled from authority (the ACL row). A capability system *has* Property A, by construction: a held capability *is* both name and authority.

The corollary the paper draws here is that **ACL systems require a separate namespace** for subjects (`Alice`, `Bob`) and a separate one for resources (`/etc/passwd`). The capability model can avoid the shared namespace entirely, "avoid[ing] introducing a shared namespace into the foundations of the model, and thereby avoid[ing] the complex issues involved in managing a shared namespace — issues rarely acknowledged as a cost of non-capability models."

### Property B: Dynamic Subject Creation

In ACL systems, the subject names appearing in ACLs need to be stable enough that the resource holding the ACL can know them. In practice, this forces ACL systems to "map processes to *principals* (broad equivalence classes of processes), such as user accounts, where the set of principals does not change in the course of normal operation." Subjects in an ACL system "do not generally have the ability to create an unbounded number of new subjects."

Capability systems "distinguish subjects at the instance level — indeed, at finer granularity than users are normally even aware of." Each invocation of an executable program is a separate capability-system subject; each instance of a software component is a separate subject. "Because authorities are aggregated by subject, it is no problem for subjects to be defined at a fine granularity, even when that means subjects are creating new subjects all the time."

The paper formalizes this as **Property B: Dynamic Subject Creation**. "Strictly speaking, neither view of the access matrix imposes or prohibits this property, but we know of no ACL implementation that allows individual processes to be separate subjects, whereas all capability-based systems distinguish subjects at the instance level."

### Property C: Subject-Aggregated Authority Management

ACL systems "define an `owner` or `edit permissions` attribute, which is set on a resource to give a subject the power to edit that resource's ACL." Because the ACL is stored at the resource, "the power to edit authorities is aggregated by resource: the ability to change one permission generally comes together with the ability to edit an entire ACL." Capability systems "manipulate authorities in their own C-lists" — so the power to edit authorities is aggregated by subject.

The paper formalizes this as **Property C: Subject-Aggregated Authority Management**. "As with Property B, the access matrix model does not force the presence or absence of this property, but in all cases of which we are aware, capability systems have this property and ACL systems do not."

### Intermission

The paper concludes the Equivalence Myth section with: "All of these differences between the capabilities-as-rows model and the ACLs-as-columns model should put to rest the Equivalence Myth. Object-capability systems are different from ACL systems in yet more ways, which will surface as we address the other myths."

Source: [SRL2003-02.pdf](https://srl.cs.jhu.edu/pubs/SRL2003-02.pdf) pages 2-4; SHA-256 `b6a3e04e60d7`.
