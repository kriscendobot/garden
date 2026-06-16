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
topics: [capability-security, capability-theory, patterns]
status: current
parent: papers--miller-capability-myths-demolished-2003--advantages-pola-confused-deputy
---

The paper's POLA argument (B + G are necessary) is what makes the per-compartment + per-formula incarnation model defensible: Endo deliberately structures the daemon so that every distinct authority-bearing thing is a distinct subject (Property B) and every constructed resource is a distinct, dynamically-created formula target (Property G). The cost is real (every reference is a separate target with separate retention bookkeeping); the benefit is that POLA is *feasible* — every exo, compartment, agent identity is small enough to express minimally.

The paper's confused-deputy argument is the upstream citation for the discipline that **power-bearing references in Endo arrive as parameters, not as imports or globals**. Code that writes `import { fs } from 'node:fs'` is granting itself ambient authority; code that writes `function makeService({ fs }) { ... }` is taking authority as a parameter, where the caller chooses which `fs` (which may be a heavily-attenuated caretaker pattern facet rather than the actual filesystem) gets passed. The latter is what Endo bundles compile *toward*. The paper formalizes why the latter is structurally less hazardous: Property A (the parameter `fs` is both designator and authority) plus Property D (no ambient access to a real `fs`) together remove the confused-deputy hazard.

The phrase *unconfusable deputy* does not appear directly in Endo's vocabulary, but the discipline it names is what the chat-components design's "endowments arrive as parameters, never closed-over" pattern is enforcing. Future designs that touch capability-passing surfaces can cite this paper's coinage when justifying the parameter-not-closure choice.

Source: [SRL2003-02.pdf](https://srl.cs.jhu.edu/pubs/SRL2003-02.pdf) pages 11-13; SHA-256 `b6a3e04e60d7`.
