---
title: Abstract
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

The Confinement Myth claims "capability systems cannot limit the propagation of authority." The paper's reply rests on a single observation about Model 4 (Object Capabilities): **a capability can travel from Alice to Bob only along a capability Alice already holds for Bob**. If Alice has no capability to Bob, no capability Alice holds can be delegated to him, because there is no channel. Confinement of a set of objects is therefore decidable by graph connectivity: "the subgraph containing the set of objects is not connected to the rest of the object graph." The paper also examines Boebert's 1984 argument (the strongest historical version of the myth) and shows that in *partitioned* or *type-enforced* capability systems (KeyKOS, W7, EROS, E), Boebert's *-Property attack fails because capabilities and data are distinguished — Alice cannot smuggle a capability through a data channel.

Source: [SRL2003-02.pdf](https://srl.cs.jhu.edu/pubs/SRL2003-02.pdf) pages 4-7; SHA-256 `b6a3e04e60d7`.
