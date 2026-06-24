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
parent: papers--miller-capability-myths-demolished-2003--confinement-myth
---

The paper's core argument — *capabilities can travel only along capabilities* — is the upstream justification for Endo's most distinctive design property: that **a compartment with no incoming or outgoing references is structurally unable to receive or transmit capability**. The `inert worker` lifecycle in the Endo daemon depends on this: a compartment born with only the capabilities its formula prescribes can hold no others, because there is no surface through which a new capability could arrive.

For the cross-peer GC and retention-accumulator designs the library already indexes, the paper's confinement argument is what makes it *meaningful* to reason about reference graphs as the unit of GC: if reference X is not reachable from the agent's pet-store via any chain of held references, X is confined out of that agent's authority, and the daemon may collect it.

The paper's Property F is the formal name for the discipline Endo's `@endo/marshal` enforces: a `passStyle: 'remotable'` value is not transmittable as bytes (its slot-side identity lives in the slots-table, not on the wire), so a malicious peer cannot smuggle a remote reference through a smallcaps string field.

Source: [SRL2003-02.pdf](https://srl.cs.jhu.edu/pubs/SRL2003-02.pdf) pages 4-7; SHA-256 `b6a3e04e60d7`.
