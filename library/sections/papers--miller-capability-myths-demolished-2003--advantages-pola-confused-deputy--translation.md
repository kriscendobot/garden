---
title: Translation
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

| Paper idiom | Endo equivalent |
| ----------- | --------------- |
| principle of least privilege (POLA) | "no globals, all power injected via parameter" — the SES + exo discipline |
| confused deputy | the canonical hazard SES, exo, and the daemon discipline collectively defend against |
| unconfusable deputy | an exo whose powers all arrive bound to designators (the request shape, the Handle, the formula identifier) so it cannot be tricked into using one for another |
| chain of designation | the formula graph rooted at an agent's pet-store, traceable back through every reference an agent holds to the formula that constructed it |
| ambient authority | what lockdown removes from the JS realm; what SES audits remove from a compartment-bound shim |

Source: [SRL2003-02.pdf](https://srl.cs.jhu.edu/pubs/SRL2003-02.pdf) pages 11-13; SHA-256 `b6a3e04e60d7`.
