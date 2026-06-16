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
topics: [capability-security, capability-theory]
status: current
parent: papers--miller-capability-myths-demolished-2003--confinement-myth
---

- **"Capability systems can't confine because Bob can read the capability bytes."** Holds only for *password capability* systems (Amoeba-style, where unforgeability is bit-string-entropy). Object-capability systems (KeyKOS, EROS, E, Endo's marshal) do not represent a held capability as readable data bytes; the bit pattern in the C-list is private to the kernel / VM / runtime. This is Property F: kernel-enforced distinction between capability and data transmission.
- **"Boebert proved confinement is impossible."** Boebert's 1984 argument proved confinement is impossible *in an unmodified capability machine where subjects can transmit capabilities anywhere they can transmit data*. The premise has not held in actual practice since at least KeyKOS, and never holds in any object-capability system.

Source: [SRL2003-02.pdf](https://srl.cs.jhu.edu/pubs/SRL2003-02.pdf) pages 4-7; SHA-256 `b6a3e04e60d7`.
