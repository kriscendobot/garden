---
title: Abstract
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

The 1988 Miller-Drexler paper that introduces **agoric systems** — software systems using market mechanisms, based on foundations providing for the *encapsulation* and *communication* of *information*, *access*, and *resources* among *objects*. The term *agoric* is coined from *agora* (Greek for meeting and market place); this paper is the historical and conceptual seed of the Agoric project itself, and the term-of-art most directly carried into modern Endo / Agoric work is the *agoric system* designation. §1 frames the central claim: as computation moves from centralized to increasingly decentralized models of control and action, market mechanisms become a natural extension. §3 grounds the proposal in two Hayekian arguments: prices summarize local knowledge into globally-actionable signals, and *spontaneous order* yields coherent results from local interactions that no central planner could reproduce. The §3.1 framing names two extremes (command economy / market economy) and concludes that *computational markets, like human markets, will consist of islands of central direction in a sea of trade*. §3.2 makes the deepest structural claim: **encapsulation in software serves the same crucial function as property rights in human affairs** — establishing protected spheres in which entities can plan and act free of interference from unpredictable external influences. §4 names the foundational triple: support for encapsulation and communication of (a) information, (b) access, (c) resources. §4.1's *capability security* definition is the 1988 ancestor of the four-ways-to-acquire-references enumeration — A can get access to B only by (1) being born with it (creator already had access), (2) receiving it in a message, or (3) being the creator of B. The §4.3 *competence vs performance modularity* distinction is the paper's deepest architectural contribution: object-orientation modularizes *competence* (what programs can do) via message-passing interfaces; computational markets modularize *performance* (how efficiently programs do it) via prices as abstract interface for resource costs.
