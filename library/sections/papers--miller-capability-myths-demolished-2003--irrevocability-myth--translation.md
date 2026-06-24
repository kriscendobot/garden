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
parent: papers--miller-capability-myths-demolished-2003--irrevocability-myth
---

| Paper idiom | Endo equivalent |
| ----------- | --------------- |
| forwarder F + revoker R | the [[caretaker-pattern]]: Handle (action facet, action-side) + HandleControl (control facet, principal-side) |
| forwarding facet | "action facet" in Endo's [[delegates-and-epithets]] vocabulary |
| revoking facet | "control facet" in Endo's vocabulary; held by the principal not the delegate |
| forwarder caches the result of indirection | the daemon's GC + retention-accumulator design implicitly does this for live references; on cohort-destruction the cache resets |
| invoke R to stop forwarding | call `revoke()` on the HandleControl; daemon stops vending the underlying capability |

Source: [SRL2003-02.pdf](https://srl.cs.jhu.edu/pubs/SRL2003-02.pdf) pages 6-7; SHA-256 `b6a3e04e60d7`.
