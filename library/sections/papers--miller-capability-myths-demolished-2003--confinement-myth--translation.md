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
topics: [capability-security, capability-theory]
status: current
parent: papers--miller-capability-myths-demolished-2003--confinement-myth
---

| Paper idiom | Endo equivalent |
| ----------- | --------------- |
| capability transfer | passing a Presence / exo by reference via `E()` (eventual-send) or by structured-clone in marshal |
| pass capability anywhere data goes | not how Endo works: marshal distinguishes pass-style at the wire; a `passStyle: 'remotable'` value crosses as a remote slot, not as the bytes of its identifier |
| factory (KeyKOS) | Endo's compartment-bound constructor pattern: a confined factory exo with no ambient authority that vends instances downstream |
| partitioned capability system | Endo's marshal layer: data goes via `passStyle` enumerated transit (copyRecord, copyArray, smallcaps strings); capability goes via `passStyle: 'remotable'` with an *out-of-band* slot table the wire format references symbolically |
| *-Property | Bell-LaPadula multi-level security write-up restriction; not a primary Endo concept, but relevant when reasoning about cross-trust-level delegation in agent / connector / persona designs |

Source: [SRL2003-02.pdf](https://srl.cs.jhu.edu/pubs/SRL2003-02.pdf) pages 4-7; SHA-256 `b6a3e04e60d7`.
