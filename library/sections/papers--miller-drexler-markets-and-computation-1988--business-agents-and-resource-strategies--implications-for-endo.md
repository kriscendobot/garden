---
title: Implications for Endo
source: "Markets and Computation: Agoric Open Systems (Ecology of Computation, Elsevier 1988)"
source_kind: paper
source_authors: [Mark S. Miller, K. Eric Drexler]
source_year: 1988
source_venue: "The Ecology of Computation (Huberman, ed.), Elsevier Science Publishers B.V. (North-Holland)"
source_url: https://papers.agoric.com/papers/markets-and-computation-agoric-open-systems/abstract/
source_pdf_sha256: f058464a36bb0dc0f54514268ff9f8bbf061c94ff7cd0412c9c1fcf73603910b
source_paper_pages: "149-156 (§5 Agents and strategies — §5.1 initial market strategies; §5.2 business location decisions; §5.3 business agents including data-type agents, managers, reputations, compilation; §5.4 the scandal of idle time)"
ingested: 2026-05-28
ingested_by: liaison-direct-draft
topics: [capability-security, agent-conventions, patterns]
status: current
parent: papers--miller-drexler-markets-and-computation-1988--business-agents-and-resource-strategies
---

This section is *most useful as the unrealized-architecture map*: it names the agoric-systems primitives the Endo / Agoric stack has not yet enacted at the performance-modularity layer. The library can use §5 as the canonical reference when:

1. **A design names "business agent" or "agoric system" without further elaboration.** §5 is the canonical citation; §5.3 develops the agent vs subcontractor distinction.
2. **A design names "reputation system."** §5.3.3 is the canonical citation for the positive-vs-negative distinction. Agoric's IST and similar systems implicitly choose positive reputation; this section grounds the choice.
3. **A design proposes resource-pricing or metering.** §5.1 is the canonical historical anchor; the contemporary @endo/agoric meter-and-fuel discipline traces its lineage here.
4. **A design discusses idle-resource use or post-facto analysis.** §5.4 is the canonical citation; the "scandal of idle time" framing is the diagnostic vocabulary.
5. **A design proposes adaptive implementation selection (data structure switching at runtime).** §5.3.1 is the canonical lookup-table-agent example.

**The biggest architectural gap the section reveals**: Endo today modularizes *competence* (exo + lockdown + marshal); the *performance modularization via prices* that §4.3 named and §5 develops is largely unrealized. Agoric SwingSet's meter discipline is the closest production enactment, but the broader market-mediated resource allocation the paper envisions remains research territory.
