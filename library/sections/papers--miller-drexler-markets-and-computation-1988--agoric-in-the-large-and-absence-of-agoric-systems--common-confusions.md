---
title: Common confusions
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

- **"§7 is a defensive argument, not a real one."** The §7 *consistent-with-being-a-good-idea* framing is a careful *due-process-reasoning* move — it identifies the major category of possible negative evidence (the idea has been tested and found wanting) and shows that *category does not apply* in 1988. The argument is not "agoric systems are good"; it is *"the absence of agoric systems is not evidence against agoric systems"*. The 38 years since 1988 have produced partial validation of the agoric vision (cloud markets, Agoric the company, ERTP), suggesting the §7 argument was correct.
- **"The marketplace of mind is mysticism."** §6.2 is explicit: the §6.2 *intelligence-as-emergent-property* claim is not mystical. The argument is structural: human society as a whole is more intelligent than any individual; that intelligence is an emergent property of market-coordinated specialized agents; agoric systems propose the same dynamic for software. Intelligence ≠ consciousness ≠ will, and the §6.2 framing makes this explicit.
- **"The opaque box is a niche concern."** No — Intel SGX, AMD SEV, ARM TrustZone, Apple Secure Enclave, AWS Nitro Enclaves, and Microsoft Pluton are *all* contemporary enactments of the §6.1.2 opaque-box prediction. The §6.1.2 architectural claim has been almost completely realized in production hardware in the 38 years since.
- **"Charge-per-use is just SaaS."** No — SaaS is *subscription-based* (which is closer to charge-per-time); the §6.1 paper specifically describes *charge-per-invocation* with royalty-payment composability. Cloud-functions billing (Lambda's per-invocation pricing, Cloud Run's per-second-of-execution) is the contemporary partial enactment; the *composability-across-component-creators* aspect remains under-realized.
- **"The Appendix I matrix is a hand-wavy table."** Appendix I makes a structural claim: *each issue exhibits hard-edged formal counterparts at low levels and soft-edged informal counterparts at high levels*. The architectural prescription is to use the right tool at each level — not to try to use logic where due-process is appropriate, or to try to use reputation where encapsulation is appropriate. The library can adopt this discipline directly.
