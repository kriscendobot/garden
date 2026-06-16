---
title: Introduction
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
parent: papers--miller-capability-myths-demolished-2003--abstract-and-introduction
---

The paper situates its work as a corrective to a chain of papers over the preceding 20 years (citations [2], [3], [7], [24] in the original) that propagated the second and third myths "despite formal results [22] and practical systems [1, 9, 18, 21] demonstrating that they can do these supposedly impossible things." The authors identify the root cause as terminological: "the term *capability* has come to be portrayed as referring to several very different security models." The paper distinguishes them by name:

- **Model 1: ACLs as Columns** — the column-wise reading of Lampson's access matrix.
- **Model 2: Capabilities as Rows** — the row-wise reading of the same matrix.
- **Model 3: Capabilities as Keys** — the "unforgeable copyable keys" analogy.
- **Model 4: Object Capabilities** — the model most actual capability systems implement (KeyKOS, EROS, E, etc.).

The Equivalence Myth is refuted by showing Models 1 and 2 are distinguishable along *dynamic* properties of authority (the access matrix is a static snapshot; the rules that update it are where the model lives). The Confinement and Irrevocability Myths are refuted by reasoning in the context of Model 4 (the object-capability model), where the standard counter-arguments succeed.

The paper closes by tracing both myths' advantages back to two practical operating concerns: the **principle of least privilege** (citation [20] is Saltzer & Schroeder, 1975) and the **confused deputy problem** (citation [10] is Hardy, 1988). The body of the paper organizes around demonstrating that object-capability systems satisfy the property combinations needed to address these concerns, while ACL systems do not.

Source: [SRL2003-02.pdf](https://srl.cs.jhu.edu/pubs/SRL2003-02.pdf) pages 1-2; SHA-256 `b6a3e04e60d7`.
