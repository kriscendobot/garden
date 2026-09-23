---
title: See also
source: "Automated Analysis of Security-Critical JavaScript APIs (Taly, Erlingsson, Mitchell, Miller, Nagra, IEEE S&P 2011)"
source_kind: paper
source_authors: [Ankur Taly, Úlfar Erlingsson, John C. Mitchell, Mark S. Miller, Jasvir Nagra]
source_year: 2011
source_venue: "IEEE Symposium on Security and Privacy 2011"
source_url: https://papers.agoric.com/papers/automated-analysis-of-security-critical-javascript-apis/
source_pdf_sha256: 4457eafac35c129dac26fdf163710a1f89b63b0d9a4ba1bc6378fa318c4bec95
source_paper_pages: "3-12 (§3 The Language SES_light through §5 Analysis Procedure)"
ingested: 2026-05-29
ingested_by: liaison-direct-draft
topics: [capability-security, capability-theory, hardened-javascript]
status: current
parent: papers--taly-automated-analysis-of-security-critical-javascript-apis-2011--static-analysis-procedure-and-soundness-theorem
---

- [[capability-theory]] (topic) — the formal-Hoare-logic paper (cycle 85) is the *complementary* formal-foundation paper that grounds *trust-and-risk* in Hoare logic; this section grounds *confinement* in Datalog points-to.
- [[hardened-javascript]] (topic) — the contemporary realization of SES_light.
- `papers--taly-automated-analysis-of-security-critical-javascript-apis-2011--api-confinement-problem-and-ses-light-language-design` — the prior section: the API+Sandbox approach + SES_light's language-design rationale.
- `papers--taly-automated-analysis-of-security-critical-javascript-apis-2011--applications-adsafe-vulnerability-sealer-unsealer-and-mint` — the next section: applying ENCAP to find the ADSafe vulnerability + verify Sealer-Unsealer + Mint.
- `papers--drossopoulou-reasoning-about-risk-and-trust-2015--hoare-four-tuples-and-code-agnostic-rules` — cycle 85's complementary formal Hoare-logic framework for the *risk* dimension; this section's Datalog points-to handles the *confinement* dimension.
- `papers--miller-vancutsem-tulloh-distributed-electronic-rights-2013--dr-ses-architecture-and-q-promises` — Dr. SES + Q + NodeKen; SES_light + analysis tools form the JavaScript-language layer Dr. SES builds on.
- `papers--close-acls-dont-2009--three-failures-of-acls-and-capability-application-caveat` — Tyler Close's §2.7 *capability-applications-can-recreate-ACL-vulnerabilities* is the qualitative version of what ENCAP catches *quantitatively*.
