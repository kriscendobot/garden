---
title: See also
source: "ACLs don't (Tyler Close, ~2009)"
source_kind: paper
source_authors: [Tyler Close]
source_year: 2009
source_venue: "Position paper (Hewlett-Packard Labs, Palo Alto; references span Hardy 1988 to Close 2008 + Hansen-Grossman 2008 — published ~2009)"
source_url: https://papers.agoric.com/papers/acls-dont/
source_pdf_sha256: d1ffe9e6e56f513dc83e8143ef7134ffb01f5f30020b10816e4798913181fc75
source_paper_pages: "1-3 (§1 Introduction + §2 Access Matrix through §2.3 Confused Deputy attack)"
ingested: 2026-05-29
ingested_by: liaison-direct-draft
topics: [capability-security, capability-theory]
status: current
parent: papers--close-acls-dont-2009--compilation-scenario-and-the-confused-deputy-attack
---

- [[object-capability]] — the §2.2 capability transfer is the implementation; this paper is the canonical introduction.
- [[four-ways-to-acquire-references]] — the User-Compiler-Filesystem capability flow is a worked example of *introduction* and *parenthood* and *endowment*.
- [[principle-of-least-authority]] — the Compiler exercising User-contributed authority for output and Vendor-contributed authority for logging is the canonical worked POLA example.
- [[smart-contract]] — the Compiler-as-mediator is a smart-contract avant-la-lettre; the worked scenario is the structural ancestor of the Vendor-User-Mediator pattern in Agoric Zoe contracts.
- `papers--miller-capability-myths-demolished-2003--{access-models-introduction, confined-subjects-and-the-confinement-myth, irrevocability-myth-and-the-caretaker-pattern}` — Miller-Yee-Shapiro 2003 makes the same point at greater length and with the Equivalence Myth as its central target; this section is the Tyler-Close-style condensed proof.
- `papers--miller-shapiro-paradigm-regained-2003--permission-vs-authority-and-cp-versus-cat` — Miller-Shapiro 2003's *permission vs authority* distinction is the formal language for what this section informally calls *ACL gets the wrong access decision*.
- `papers--miller-tulloh-shapiro-structure-of-authority-2004--excess-authority-and-designation` — Miller-Tulloh-Shapiro 2004 names the cp-vs-cat designation argument; the Compiler is a *deputy* that under cp would never have been confused.
