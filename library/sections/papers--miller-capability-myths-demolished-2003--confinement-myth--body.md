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
parent: papers--miller-capability-myths-demolished-2003--confinement-myth
---

### The 1988 KeyKOS counter-example

The myth was already empirically refuted in 1988 by Karger, who acknowledged: "KeyKOS achieves confinement by a mechanism called *factories*. Essentially, a factory is a mechanism for creating new instances of protected subsystems." The paper observes "It is unfortunate that the Confinement Myth continues to scare people away from capabilities so long after KeyKOS succeeded in confining programs."

### Delegation in object capabilities

The paper's Figure 5 shows Alice delegating a capability `foo` (which points to Carol) by sending it as a message to Bob. The send itself requires a capability from Alice to Bob — "messages may only travel along a capability." So:

> In order for Alice to authorize Bob to access Carol, Alice must herself be authorized to access *both* Bob and Carol. The requirement that capability transfer makes confinement possible, since no capability transfer can introduce a new connection between two objects that were not already connected by some path. Confinement of authorities within a set of objects can be determined simply by observing that the subgraph containing the set of objects is not connected to the rest of the object graph.

The paper continues with a concrete confinement example: "Suppose, for example, we decide not to trust Bob. To prevent Alice from delegating to Bob, we simply refrain from giving Alice access to Bob. No subgraph of co-operating objects can delegate to Bob if Bob is not reachable from that subgraph to begin with. This simple insight is the basis for many capability-based confinement systems."

### The Wallach/Balfanz/Dean/Felten objection

A widely-cited 1997 paper on Java security made a subtler version of the claim: "two programs which can communicate object references can share their capabilities without system mediation." The paper's reply: "this slightly different error... correctly acknowledges that the ability to communicate object references is *necessary* for two programs to share their capabilities. However, it appears to overlook the possibility that such an ability to communicate object references might be unavailable or restricted." That ability is precisely what an object-capability system controls.

### Boebert's 1984 *-Property attack and its limits

Boebert's 1984 argument (the strongest historical version of the myth) constructed an attack: Alice holds a Write-Low capability and writes it into a Low segment; Bob reads the Write-Low capability out of the Low segment; Bob then uses the Write-Low capability to write information from High into Low — violating the *-Property. Figures 7-9 of the paper diagram this attack against an "unmodified capability machine".

The paper's reply: "Boebert's example assumes that subjects can transmit capabilities anywhere they can transmit data, which is not the case in most capability systems." In *partitioned* or *type-enforced* capability systems — explicitly listing KeyKOS [9], W7 [19], EROS [21], and **E** [4] — "capabilities and data are distinguished by the kernel or runtime. Reading and writing capabilities are necessarily distinguishable operations from reading and writing data." Figure 10 redoes the diagram with separate capability-read / capability-write authorities and shows the *-Property is enforced.

The paper formalizes this kernel-level distinction as needed for **Property F: Access-Controlled Delegation Channels** — "is an access relationship between two subjects X and Y required in order for X to pass an authority to Y?" Object-capability systems hold Property F; password-capability systems (like Amoeba [17]) do not.

A separate misunderstanding cited by Gong — "a capability is just a bit string [and] can propagate in many ways without the detection of the kernel or the server" — applies *only* to **password capability systems** (those where capabilities are unforgeable only because they are unguessable bit strings). Object-capability systems do not store capabilities as guessable / pass-by-data bit strings, so this whole class of attack is structurally absent.

### Final reply

"Moreover, it has been formally verified [Shapiro & Weber 2000] that any capability system enforcing independent controls on data transfer and capability transfer can enforce both confinement and the *-Property."

Source: [SRL2003-02.pdf](https://srl.cs.jhu.edu/pubs/SRL2003-02.pdf) pages 4-7; SHA-256 `b6a3e04e60d7`.
