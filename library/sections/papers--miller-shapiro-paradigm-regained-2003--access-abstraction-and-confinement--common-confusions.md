---
title: Common confusions
source: "Paradigm Regained: Abstraction Mechanisms for Access Control (ASIAN 2003, LNCS 2896)"
source_kind: paper
source_authors: [Mark S. Miller, Jonathan S. Shapiro]
source_year: 2003
source_venue: "ASIAN 2003, Springer LNCS 2896"
source_url: https://web.archive.org/web/2018/http://erights.org/talks/asian03/paradigm-revised.pdf
source_pdf_sha256: 6053a29e323e4ff49a81645c76f66e9a8ac1ee7b85cda8ab39af1149b90d6cb5
source_paper_pages: "14-19 (§4.5 Access Abstraction, §5 Confinement, §5.1 Non-Discretionary Model, §5.2 The *-Properties)"
ingested: 2026-05-21
ingested_by: liaison-direct-draft
topics: [capability-theory, capability-security, patterns]
status: current
parent: papers--miller-shapiro-paradigm-regained-2003--access-abstraction-and-confinement
---

- **"Capability systems can't enforce *-properties."** §5.2 is the canonical refutation. The unmodified base model cannot; the base model *plus* a behavioral abstraction (Cassie's diode) can. The 30-year-old impossibility folklore relies on permission-only analysis.
- **"Confinement requires kernel-level enforcement."** No — §5's Cassie+Max example uses only Dennis-van-Horn 1966 primitives. The kernel role is filled by the *trademark* primitive and the *loader*; everything else is built from those.
- **"`:int` parameter guards are just static typing."** They are static typing *and* they are access control. Cassie's `:int` guard on `diodeWriter.write` is what blocks Boebert's attack of passing a capability through. Type-guard-as-access-control is the §5.2 lesson.
- **"Capabilities are discretionary because the creator chose who got the first reference."** §5.1 refines this: the creator chose, yes, but the creator could only authorize that handoff if the creator had authority to message the recipient. There are no *principals* with unconditional authority over what they create. Endo inherits this: parent bundle cannot reach into child bundle's compartment except via references explicitly passed.
- **"The lost paradigm is just object-orientation."** §4.5's *abstraction as a protection mechanism* is more than OO. OO gives you encapsulation; the lost paradigm gives you the recognition that **encapsulation IS access control** — that abstraction mechanisms *are* the protection mechanisms.
