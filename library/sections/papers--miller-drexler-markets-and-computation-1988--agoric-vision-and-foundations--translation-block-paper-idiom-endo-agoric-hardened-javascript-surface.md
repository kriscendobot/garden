---
title: Translation block (paper idiom → Endo / Agoric / Hardened JavaScript surface)
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

| Paper concept                              | Endo / Agoric equivalent                                                                                       |
| ------------------------------------------ | -------------------------------------------------------------------------------------------------------------- |
| Agoric system                              | The Agoric project itself; the company name derives directly from this paper's coinage. *Agoric* = *agora*-style. |
| Encapsulation as property right            | The library's existing `principle-of-least-authority` and `security-as-extreme-modularity` concept pages. The 1988 framing is the *political* form ("property rights"); the 2004 *Structure of Authority* Table 1 is the *engineering* form. |
| Three-mechanism capability security        | The 1988 ancestor of the four-ways-to-acquire-references concept page. "Being born with it" is the 1988 combination of what 2004 calls Endowment + Initial Conditions; "receiving in a message" = Introduction; "being the creator" = Parenthood. |
| Competence vs performance modularity       | An architectural insight Endo has only partially exercised. Competence modularity is well-developed (exo + marshal + lockdown); performance modularity is largely unrealized — the @endo stack does not currently price resources. |
| Ownership and trade of computational resources | Agoric SwingSet's meter-and-fuel discipline is the closest production enactment; Endo daemons do not currently price the resources bundles consume. |
| "Islands of central direction in a sea of trade" | The contemporary architectural arrangement: a bundle / vat is internally centrally-directed; cross-bundle interactions are governed by capability-discipline equivalent of "trade". |
| Currency = capability + unforgeable identifiers | This 1988 framing is the conceptual ancestor of Agoric's IST stablecoin + ERTP issuer mechanics — capability-rooted rather than cryptography-rooted identity. |
