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
topics: [capability-security, capability-theory, patterns]
status: current
parent: papers--miller-capability-myths-demolished-2003--advantages-pola-confused-deputy
---

After dispelling the three myths and naming the property vocabulary, the paper closes with two advantages object-capability systems hold over ACL systems: **least-privilege operation** (the principle of least privilege, POLA, Saltzer & Schroeder 1975) and **avoiding confused deputy problems** (Hardy 1988). Each advantage is reduced to a small property combination. Least-privilege operation requires Properties B (dynamic subject creation) and G (dynamic resource creation) together. Avoiding confused-deputy problems requires Properties A (no designation without authority) and D (no ambient authority) together, which between them produce **unconfusable deputies** — deputies whose authority arrives in context, bound to a designator, with the purpose for each authority discoverable from the request shape. The paper closes with a short note on terminology: "we would argue that the 'true' capability model is the object-capability model, because all known major capability systems take the object-based approach."

Source: [SRL2003-02.pdf](https://srl.cs.jhu.edu/pubs/SRL2003-02.pdf) pages 11-13; SHA-256 `b6a3e04e60d7`.
