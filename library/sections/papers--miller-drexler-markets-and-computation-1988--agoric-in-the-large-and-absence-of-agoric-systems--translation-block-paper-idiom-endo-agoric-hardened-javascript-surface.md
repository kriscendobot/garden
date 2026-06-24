---
title: Translation block (paper idiom → Endo / Agoric / Hardened JavaScript surface)
source: "Markets and Computation: Agoric Open Systems (Ecology of Computation, Elsevier 1988)"
source_kind: paper
source_authors: [Mark S. Miller, K. Eric Drexler]
source_year: 1988
source_venue: "The Ecology of Computation (Huberman, ed.), Elsevier Science Publishers B.V. (North-Holland)"
source_url: https://papers.agoric.com/papers/markets-and-computation-agoric-open-systems/abstract/
source_pdf_sha256: f058464a36bb0dc0f54514268ff9f8bbf061c94ff7cd0412c9c1fcf73603910b
source_paper_pages: "156-176 (§6 Agoric systems in the large; §6.1 software distribution markets; §6.2 marketplace of mind; §7 The absence of agoric systems; §8 Conclusions; Appendix I summary)"
ingested: 2026-05-28
ingested_by: liaison-direct-draft
topics: [capability-theory, capability-security, agent-conventions, patterns]
status: current
parent: papers--miller-drexler-markets-and-computation-1988--agoric-in-the-large-and-absence-of-agoric-systems
---

| Paper concept                              | Endo / Agoric equivalent                                                                                       |
| ------------------------------------------ | -------------------------------------------------------------------------------------------------------------- |
| Charge-per-use market                      | Agoric's metered execution; Zoe's per-invocation contract execution. The contemporary cloud-functions model (Lambda, Cloud Run) is the partial enactment at a coarser granularity. |
| Opaque box (hardware encapsulation)        | Secure enclaves (Intel SGX, AMD SEV, Apple Secure Enclave) and TPMs are the contemporary realization of this 1988 prediction. |
| CD-ROM full of encrypted software          | Contemporary content streaming (Netflix, Spotify, npm-as-a-service); the 1988 paper anticipates the architecture by ~30 years. |
| Inhibition of theft by composition         | The contemporary microservices / serverless posture exhibits this property; each service holds only its slice of capability. |
| Marketplace of mind                        | The contemporary AI-services ecosystem (model APIs, LangChain, agents-as-services) is a partial enactment; the §6.2 vision of *intelligence as emergent property of market interactions* matches contemporary multi-agent-LLM systems. |
| The absence-of-agoric-systems argument     | Now partially refuted: contemporary cloud infrastructure exhibits some agoric properties (pay-per-use, marketplaces); but the *full* agoric vision (per-object resource pricing, distributed business agents) remains research territory. |
| Issues × levels matrix                     | A diagnostic vocabulary the library can apply to Endo design reviews: at what *level* does a given design concern operate, and what is the appropriate technique at that level? |
