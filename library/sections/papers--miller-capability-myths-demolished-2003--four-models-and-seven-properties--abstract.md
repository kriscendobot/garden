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
topics: [capability-security, capability-theory]
status: current
parent: papers--miller-capability-myths-demolished-2003--four-models-and-seven-properties
---

The paper's central organizing artefact is the property table (the paper's Figure 15) that scores eight systems and models against seven security properties. The four models — **Model 1: ACLs as Columns**, **Model 2: Capabilities as Rows**, **Model 3: Capabilities as Keys**, **Model 4: Object Capabilities** — score progressively better as the model moves from purely static (Model 1) to fully compositional (Model 4). The seven properties are **A: No Designation Without Authority**, **B: Dynamic Subject Creation**, **C: Subject-Aggregated Authority Management**, **D: No Ambient Authority**, **E: Composability of Authorities**, **F: Access-Controlled Delegation Channels**, **G: Dynamic Resource Creation**. Models 2 and 3 each hold a *subset* of these — which is why they generate the Confinement and Irrevocability Myths. Model 4 holds all seven. The paper's larger contribution is the *vocabulary*: it lets later authors describe specific systems precisely, not the rough binary of "ACL" vs "capability."

Source: [SRL2003-02.pdf](https://srl.cs.jhu.edu/pubs/SRL2003-02.pdf) pages 8-11 (Figures 13, 15); SHA-256 `b6a3e04e60d7`.
