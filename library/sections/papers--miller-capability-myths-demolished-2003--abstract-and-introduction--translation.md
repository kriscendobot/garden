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
parent: papers--miller-capability-myths-demolished-2003--abstract-and-introduction
---

| Paper idiom | Endo equivalent |
| ----------- | --------------- |
| capability | a reference (in Endo: an exo, a Presence, a Handle, a formula identifier — capability is the umbrella term) |
| subject | a holder of a reference; in Endo a compartment, a vat-like bundle, or an agent |
| resource | a capability target; in Endo an exo, a remote object, a stored value |
| authority | the permissions a subject has by virtue of holding a reference; in Endo "the methods you can invoke on a reference" |
| access matrix | the static snapshot of authorities a system holds; Endo's `formulaGraph` is the dynamic analogue, evolving via construction and revocation |
| object | reserved by the paper for OO-language objects (state + behaviour); Endo overloads this term in `passStyle` and exo |

The paper's *capability* corresponds to what later E / Endo writing calls a **reference** (when emphasizing the wire-level value) or an **exo** (when emphasizing the state + methods at the resource end). The paper uses *object* in the OO-language sense; do not confuse with Endo's `passStyle` *object* (a record with own enumerable string-keyed properties).

Source: [SRL2003-02.pdf](https://srl.cs.jhu.edu/pubs/SRL2003-02.pdf) pages 1-2; SHA-256 `b6a3e04e60d7`.
