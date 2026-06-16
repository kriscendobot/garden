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
parent: papers--miller-capability-myths-demolished-2003--four-models-and-seven-properties
---

| Paper idiom | Endo equivalent |
| ----------- | --------------- |
| Property A (No Designation Without Authority) | reference *is* both name and permission — the pattern Endo enforces by passing power-bearing values explicitly rather than reading them from a sandbox global |
| Property B (Dynamic Subject Creation) | every compartment and exo instance is a fresh subject; new subjects come into being on every constructor invocation |
| Property C (Subject-Aggregated Authority Management) | authorities live in the agent's pet-store and the held-reference graph, not in resource-side ACLs |
| Property D (No Ambient Authority) | the core SES discipline + the "no globals, all power injected" pattern |
| Property E (Composability of Authorities) | exos are simultaneously subjects (they call others) and resources (they can be called) — Endo's `defineExoClassKit` directly leverages this |
| Property F (Access-Controlled Delegation Channels) | marshal's `passStyle: 'remotable'` design: a remote reference is not transmittable as bytes, only as a slot reference along a CapTP session |
| Property G (Dynamic Resource Creation) | the daemon's formula-graph: new formulas (and the resources they construct) appear on demand |
| ambient authority | the SES design goal that lockdown eliminates — Endo agents are written with no implicit access to globals |
| POSIX capabilities | a separate, unrelated thing; do not confuse with object capabilities |

Source: [SRL2003-02.pdf](https://srl.cs.jhu.edu/pubs/SRL2003-02.pdf) pages 8-11 (Figures 13, 15); SHA-256 `b6a3e04e60d7`.
