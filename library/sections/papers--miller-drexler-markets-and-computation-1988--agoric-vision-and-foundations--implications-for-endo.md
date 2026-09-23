---
title: Implications for Endo
source: "Markets and Computation: Agoric Open Systems (Ecology of Computation, Elsevier 1988)"
source_kind: paper
source_authors: [Mark S. Miller, K. Eric Drexler]
source_year: 1988
source_venue: "The Ecology of Computation (Huberman, ed.), Elsevier Science Publishers B.V. (North-Holland)"
source_url: https://papers.agoric.com/papers/markets-and-computation-agoric-open-systems/abstract/
source_pdf_sha256: f058464a36bb0dc0f54514268ff9f8bbf061c94ff7cd0412c9c1fcf73603910b
source_paper_pages: "133-148 (§1 Introduction + §1.1-§1.2; §2 Overview; §3 Computation and economic order with subsections §3.1-§3.7; §4 Foundations with subsections §4.1-§4.5)"
ingested: 2026-05-28
ingested_by: liaison-direct-draft
topics: [capability-theory, capability-security, patterns]
status: current
parent: papers--miller-drexler-markets-and-computation-1988--agoric-vision-and-foundations
---

This paper is the **historical and conceptual seed of the Agoric project** and is most useful as the citation for several long-standing assumptions in the Endo / Agoric posture:

1. **The Agoric name and mission trace here.** The Agoric company name, the *agoric system* discipline, and the broader ambition to apply market mechanisms to computational resource allocation all originate in this 1988 paper. The library's `capability-theory` topic now has the entire historical arc: 1988 (agoric vision), 2000 (capability-based money), 2003 (CMD + Paradigm Regained), 2004 (Structure of Authority), 2005 (Concurrency Among Strangers).
2. **The three-mechanism capability-security definition is older than the four-way.** The library has been citing 2004 *Structure of Authority* §3.4 as the canonical four-ways-to-acquire-references reference; this 1988 paper §4.1 is the three-mechanism ancestor. The combination of *Endowment* + *Initial Conditions* into a single 1988 "being born with it" is worth noting on the concept page as the historical evolution.
3. **Competence vs performance modularity is a load-bearing architectural framing the library has been implicit about.** Endo / Agoric design reviews implicitly distinguish these concerns (exo design = competence; gas/meter discipline = performance), but the library does not yet have a concept page making the §4.3 distinction explicit. This is a strong candidate for a future concept page.
4. **"Islands of central direction in a sea of trade"** is the most-quoted architectural framing of this paper. The contemporary Endo posture matches: a bundle is internally centrally-directed (one compartment, one trust boundary); cross-bundle interactions are governed by capability discipline — the computational analog of trade. This 1988 framing anchors the architecture.
