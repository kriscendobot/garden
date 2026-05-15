---
title: The Equivalence Myth (Properties A, B, C)
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
---

## Abstract

The Equivalence Myth rests on reading Lampson's access matrix as a *static* artefact: subjects are rows, resources are columns, cells are authorities; reading by column gives ACLs, by row gives capabilities. Read this way, the two encodings are isomorphic. The paper's reply is that "no description of any security mechanism is complete without a specification of how access relationships are allowed to evolve over time. Thus, comparing ACL and capability models in terms of the static access matrix alone is insufficient to establish logical equivalence." Three properties capture the dynamic differences: **Property A: No Designation Without Authority**, **Property B: Dynamic Subject Creation**, and **Property C: Subject-Aggregated Authority Management**. ACL systems fail A and (in practice) B and C; capability systems hold all three. This is enough to refute equivalence.

## Body

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

## Translation

| Paper idiom | Endo equivalent |
| ----------- | --------------- |
| subject | the holder of a reference; in Endo a compartment, a bundle, or an agent identity |
| resource | the target of a reference; in Endo an exo, a stored value, or a remote presence |
| C-list | the authorities a subject holds; in Endo the references in an agent's pet-store + the references held by its currently-running compartments |
| principal | a coarse equivalence class of subjects (user account); does not have a clean Endo correspondent because Endo distinguishes at the *agent* and *bundle* level |
| ACL | not a primary Endo concept; the daemon's pet-store + revocation discipline replaces ACL semantics with capability semantics |
| edit permissions | not present in Endo; the analogue is the principal's ability to *create new caretakers* or *revoke by withdrawing the constructor* — see [[revocation-by-withdrawal]] |

Endo's Properties A, B, C status:

- **Property A (No Designation Without Authority)**: yes, by construction. A formula identifier *is* both designator and authority. The `pass-invariant-handle-equality` discipline depends on this — Handles that designate the same backing identity carry the same authority.
- **Property B (Dynamic Subject Creation)**: yes — every compartment and every exo instance is a distinct subject at the formula-identifier level. New subjects come into being whenever a constructor runs.
- **Property C (Subject-Aggregated Authority Management)**: yes — an agent's authorities are managed in its pet-store + in the live formula graph rooted at its references, not in ACLs attached to the resources.

## Implications for Endo

The paper's Property A argument is the upstream justification for Endo's design choice that **a reference is both name and permission**. Endo agents do not look up references by string name in an ambient registry: they receive specific exos / Presences / Handles from specific upstream calls, and possession of the reference *is* the permission. Designs that thread power-bearing values through code paths (rather than reading them from globals) are *enforcing* Property A.

Property B is what makes Endo's per-compartment and per-formula-incarnation subject identity meaningful. Every formula a daemon constructs is a fresh subject with a fresh set of authorities. The granularity of subject creation in Endo is much finer than in classical ACL systems, which is why concepts like `cohort-destruction` and `revocation-by-withdrawal` even make sense — they are reasoning about authority changes at the per-formula level, not at the per-user level.

## See also

- [[pass-invariant-handle-equality]] — Endo's Handle equality discipline is an instance of Property A enforced at the connector level.
- [[cohort-destruction]] — partition response that depends on Property B (cohorts are creatable subjects, destroyable as units).
- [[revocation-by-withdrawal]] — the Endo-side fourth revocation mechanism; relies on the same matrix-evolution-rules framing the paper opens with.

Source: [SRL2003-02.pdf](https://srl.cs.jhu.edu/pubs/SRL2003-02.pdf) pages 2-4; SHA-256 `b6a3e04e60d7`.
