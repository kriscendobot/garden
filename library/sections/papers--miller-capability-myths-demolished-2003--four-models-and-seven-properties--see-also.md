---
title: See also
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
parent: papers--miller-capability-myths-demolished-2003--four-models-and-seven-properties
---

- [[caretaker-pattern]] — the construction this property table credentials.
- [[cohort-destruction]] — depends on Property B (cohorts are dynamically-created subject sets).
- [[revocation-by-withdrawal]] — Endo's structurally-distinct fourth revocation mechanism; the paper does not name it but the property vocabulary it builds applies (revocation-by-withdrawal exploits Property G — the *constructor* is itself a dynamically-creatable resource that can be removed from the formula graph).
- [[security-as-extreme-modularity]] — Property B (Each Process is a Subject) plus Property G (Dynamic Subject Creation) are the substrate that makes Table 1's "forbid mutable static state" row *achievable*: without per-process subjects and dynamic subject creation, mutable static state is unavoidable. This 2003 property vocabulary is what the 2004 paper builds the modularity-side discipline on.

Source: [SRL2003-02.pdf](https://srl.cs.jhu.edu/pubs/SRL2003-02.pdf) pages 8-11 (Figures 13, 15); SHA-256 `b6a3e04e60d7`.
