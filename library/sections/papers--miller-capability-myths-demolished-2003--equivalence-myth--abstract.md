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
parent: papers--miller-capability-myths-demolished-2003--equivalence-myth
---

The Equivalence Myth rests on reading Lampson's access matrix as a *static* artefact: subjects are rows, resources are columns, cells are authorities; reading by column gives ACLs, by row gives capabilities. Read this way, the two encodings are isomorphic. The paper's reply is that "no description of any security mechanism is complete without a specification of how access relationships are allowed to evolve over time. Thus, comparing ACL and capability models in terms of the static access matrix alone is insufficient to establish logical equivalence." Three properties capture the dynamic differences: **Property A: No Designation Without Authority**, **Property B: Dynamic Subject Creation**, and **Property C: Subject-Aggregated Authority Management**. ACL systems fail A and (in practice) B and C; capability systems hold all three. This is enough to refute equivalence.

Source: [SRL2003-02.pdf](https://srl.cs.jhu.edu/pubs/SRL2003-02.pdf) pages 2-4; SHA-256 `b6a3e04e60d7`.
