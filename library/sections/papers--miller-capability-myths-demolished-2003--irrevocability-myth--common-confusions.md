---
title: Common confusions
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
parent: papers--miller-capability-myths-demolished-2003--irrevocability-myth
---

- **"Capability tokens are not revocable."** Literally true; capability *access* is revocable, by replacing the reachable resource with one that no longer forwards. The Endo-lineage primary terminology emphasizes the latter (we speak of revoking *access* or *the delegate's ability to act through this handle*), not the former.
- **"Caretakers must remain alive to enforce revocation."** Holds for the paper's basic forwarder/revoker construction. Endo's `revocation-by-withdrawal` is a *structurally distinct* mechanism that does *not* require the principal to remain alive — see [[revocation-by-withdrawal]].

Source: [SRL2003-02.pdf](https://srl.cs.jhu.edu/pubs/SRL2003-02.pdf) pages 6-7; SHA-256 `b6a3e04e60d7`.
