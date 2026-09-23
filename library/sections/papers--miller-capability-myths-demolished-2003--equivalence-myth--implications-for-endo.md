---
title: Implications for Endo
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

The paper's Property A argument is the upstream justification for Endo's design choice that **a reference is both name and permission**. Endo agents do not look up references by string name in an ambient registry: they receive specific exos / Presences / Handles from specific upstream calls, and possession of the reference *is* the permission. Designs that thread power-bearing values through code paths (rather than reading them from globals) are *enforcing* Property A.

Property B is what makes Endo's per-compartment and per-formula-incarnation subject identity meaningful. Every formula a daemon constructs is a fresh subject with a fresh set of authorities. The granularity of subject creation in Endo is much finer than in classical ACL systems, which is why concepts like `cohort-destruction` and `revocation-by-withdrawal` even make sense — they are reasoning about authority changes at the per-formula level, not at the per-user level.

Source: [SRL2003-02.pdf](https://srl.cs.jhu.edu/pubs/SRL2003-02.pdf) pages 2-4; SHA-256 `b6a3e04e60d7`.
