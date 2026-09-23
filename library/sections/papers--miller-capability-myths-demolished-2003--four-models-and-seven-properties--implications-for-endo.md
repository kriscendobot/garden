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
parent: papers--miller-capability-myths-demolished-2003--four-models-and-seven-properties
---

Endo fits Model 4 cleanly. Every one of the seven properties holds:

- **A**: a formula identifier is both designator and authority — `pass-invariant-handle-equality` is an explicit instance.
- **B**: per-incarnation subject identity at compartment and exo granularity.
- **C**: pet-store + reference graph; never ACL-on-resource.
- **D**: SES lockdown's whole point.
- **E**: exos are both callable and callers; `defineExoClassKit` exploits this for the forwarder/revoker (caretaker) pattern.
- **F**: marshal's wire format distinguishes capability slots from data bytes; capability transmission goes only along CapTP sessions.
- **G**: formulas can construct new formulas; the formula-graph grows.

The paper's vocabulary therefore gives Endo designers a precise way to articulate what Endo *does* — by listing the property combinations the design holds, instead of waving at "we are a capability system." When a design reviewer asks "why does this approach work?" the answer can cite "Property F + Property E" instead of restating the argument.

Source: [SRL2003-02.pdf](https://srl.cs.jhu.edu/pubs/SRL2003-02.pdf) pages 8-11 (Figures 13, 15); SHA-256 `b6a3e04e60d7`.
