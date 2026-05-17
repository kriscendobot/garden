---
source_kind: paper
source_authors: [Mark S. Miller, Bill Tulloh, Jonathan S. Shapiro]
source_title: "The Structure of Authority: Why Security Is Not a Separable Concern"
source_year: 2005
source_paper_year: 2004
source_venue: "MOZ 2004 (Multiparadigm Programming in Mozart/Oz), Springer LNAI 3389, pp. 2-20"
source_url: https://papers.agoric.com/papers/the-structure-of-authority-why-security-is-not-a-separable-concern/abstract/
source_pdf_sha256: f92e409045cee73bea534c58e196994564e1a6e80f31a0f854cdea9cdfc3385d
source_pdf_pages: 19
source_mirror_url: https://papers.agoric.com/assets/pdf/papers/the-structure-of-authority-why-security-is-not-a-separable-concern.pdf
ingested: 2026-05-17
ingested_by: liaison-direct-draft
section_count: 3
status: current
---

The 2004/2005 paper by Mark S. Miller, Bill Tulloh, and Jonathan S. Shapiro that argues **security is not a separable concern** — that access control in well-designed systems is *not* a layer bolted onto a modular decomposition but a *property* of the decomposition itself. The paper grounds this claim in three structural arguments and one practical synthesis.

**The structural arguments:**

1. **Designation determines least authority.** §1.1's cp-vs-cat example shows that the *logic of designation* determines what authority a program needs to do its job. Strings-as-arguments (cp) require broad ambient authority; pre-resolved capability references (cat) require narrow specific authority. Today's deployed systems support both styles but officially explain only the broad one as access control; the capability discipline does the real work but is left unsystematic.

2. **Authority has fractal structure.** §2.2 combines Simon's hierarchy argument (complex systems have nested-subsystem structure) with Hayek's local-knowledge argument (the knowledge to allocate resources is necessarily local) to show that POLA can only be practiced *where the local knowledge of need lives*. §3 then enumerates four levels of composition (people, applications, modules, language-level objects) at which POLA logic recurs.

3. **Only connectivity begets connectivity.** §3.4 enumerates the *four ways* one object can come to know about another: **Introduction**, **Parenthood**, **Endowment**, **Initial Conditions**. The enumeration is exhaustive — any "new" way collapses to one of these four. The corollary is that the reference graph IS the access graph; disjoint subgraphs cannot affect each other; near-disjoint subgraphs interact only through their bridging objects. This is the formal teeth of object-capability security.

**The practical synthesis:**

§3.5-§3.8 show how POLA composes across layers: nested TCBs follow the spawning tree (§3.5); subcontracting forms dynamic authority networks (§3.6); legacy boundaries limit POLA but are managed incrementally (§3.7); the multiplicative reduction in attack surface from recursive POLA across layers makes the architectural payoff (§3.8). Table 1's "Security as Extreme Modularity" maps ten software-engineering practices to their strict capability-discipline readings — *information hiding ↔ POLA*, *avoid global variables ↔ forbid mutable static state*, *say what you mean ↔ mean only what you say*. The architectural claim: good software-engineering practice is already most of the way toward capability discipline; the gap is cultural (accepting the strict reading) more than technical.

§4's conclusion: to build systems that are simultaneously *safer, more functional, more modular, and more usable* than is normally thought possible, "we need merely make a natural change to our foundations [object-capability languages] and a corresponding natural change to our software-engineering discipline [strict capability discipline]." The paper presents the *E + CapDesk + Polaris* triple as proof-of-concept.

## For the Endo / Agoric library

This paper is the **canonical citation for the design discipline** Endo asks of its bundle authors. When a future Endo design names "POLA" or "least authority" without further citation, this paper (and its companion *Concurrency Among Strangers* defensive-correctness framing) is what's being invoked. Specifically, the paper grounds:

- The discipline of endowing bundles with *capability handles* (cat-style) instead of paths or names (cp-style).
- The architectural choice that the **formula graph IS the access graph** — the four ways a new formula comes to exist (Introduction via marshal pass-style, Parenthood via formula construction, Endowment via initial bundle endowments, Initial Conditions via daemon bootstrap) match §3.4 exactly.
- The case for *nesting* (daemon → bundle → compartment → exo): nesting depth is what makes the multiplicative attack-surface reduction (§3.8) load-bearing rather than rhetorical.
- The Table 1 checklist as the *practical* anchor: each row is a concrete discipline a bundle author can audit themselves against.

The paper has no direct concurrency-control content (unlike *Concurrency Among Strangers*); it focuses purely on the access-control side. The two papers are complementary readings — *Concurrency Among Strangers* explains how eventual-send + vats give defensive consistency under shared-state concurrency; *Structure of Authority* explains how the same object-capability foundation gives least-authority POLA under spatial composition. Together they cover the two main architectural commitments Endo inherits from the E lineage.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [excess-authority-and-designation](../sections/papers--miller-tulloh-shapiro-structure-of-authority-2004--excess-authority-and-designation.md) | capability-theory, capability-security | current |
| [fractal-structure-of-authority](../sections/papers--miller-tulloh-shapiro-structure-of-authority-2004--fractal-structure-of-authority.md) | capability-theory, capability-security, patterns | current |
| [multiplicative-pola-and-security-as-modularity](../sections/papers--miller-tulloh-shapiro-structure-of-authority-2004--multiplicative-pola-and-security-as-modularity.md) | capability-theory, capability-security, patterns | current |

The paper's structure (§1 + §1.1 + §2 + §2.1 // §2.2 + §3 intro + §3.4 // §3.5-§3.8 + §4) is reflected in three argument-cluster sections rather than the paper's eight subsections, because §3.1-§3.3 (Human/Application/Module granularity walk-throughs of CapDesk) and §3.6-§3.7 (subcontracting and legacy) are illustrative rather than load-bearing — they support the arguments in the three retained sections without contributing distinct theoretical content the library would cite independently.

## Provenance

- Drafted by the liaison via orchestrator-direct-draft on 2026-05-17, per the maintainer-authorized disposition established earlier the same day (`entries/2026/05/17/223038Z-result-liaison-bdf459.md`).
- Maintainer context: capability theory is foundational defensive-security research; Mark Miller is the maintainer's longtime mentor; the work is publicly available and explicitly aimed at defending against the harms three decades of capability-security research have been working to forestall.
- Source PDF SHA-256 `f92e409045cee73bea534c58e196994564e1a6e80f31a0f854cdea9cdfc3385d`, 19 pages, fetched from `papers.agoric.com/assets/pdf/papers/the-structure-of-authority-why-security-is-not-a-separable-concern.pdf` on 2026-05-17.
