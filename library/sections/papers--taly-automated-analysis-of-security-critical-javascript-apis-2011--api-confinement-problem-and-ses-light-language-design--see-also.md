---
title: See also
source: "Automated Analysis of Security-Critical JavaScript APIs (Taly, Erlingsson, Mitchell, Miller, Nagra, IEEE S&P 2011)"
source_kind: paper
source_authors: [Ankur Taly, Úlfar Erlingsson, John C. Mitchell, Mark S. Miller, Jasvir Nagra]
source_year: 2011
source_venue: "IEEE Symposium on Security and Privacy 2011"
source_url: https://papers.agoric.com/papers/automated-analysis-of-security-critical-javascript-apis/
source_pdf_sha256: 4457eafac35c129dac26fdf163710a1f89b63b0d9a4ba1bc6378fa318c4bec95
source_paper_pages: "1-3 (§1 Introduction + §2 From JavaScript to ES5-strict to SES_light)"
ingested: 2026-05-29
ingested_by: liaison-direct-draft
topics: [capability-security, capability-theory, hardened-javascript]
status: current
parent: papers--taly-automated-analysis-of-security-critical-javascript-apis-2011--api-confinement-problem-and-ses-light-language-design
---

- [[hardened-javascript]] (topic) — the contemporary realization of SES_light's design.
- [[capability-security]] (topic) — the API+Sandbox approach is the canonical capability-discipline pattern at the API layer.
- [[capability-theory]] (topic) — the API Confinement Problem is the Overt Confinement Problem for Capabilities cast in API-confinement language.
- [[compartments]] (topic) — the contemporary realization of the SES_light isolation model.
- [[object-capability]] — the SES_light language enables ocap discipline at the JavaScript layer.
- `papers--miller-vancutsem-tulloh-distributed-electronic-rights-2013--dr-ses-architecture-and-q-promises` — Dr. SES = SES + Q + NodeKen; the SES this 2011 paper specifies is the foundation.
- `papers--close-acls-dont-2009--three-failures-of-acls-and-capability-application-caveat` — the §2.7 *capability-application caveat* is the same trap the §1 motivating example illustrates: a JavaScript API that re-implements ACL design on top of capabilities is vulnerable.
- `papers--miller-shapiro-paradigm-regained-2003--access-abstraction-and-confinement` — the broader capability-confinement framework.
- `endo--packages-pass-style-src-error-js--pass-style-defense-across-host-configurations` — the contemporary realization of the SES_light *transitively-immutable built-in objects* claim at the pass-style package level.
- `papers--taly-automated-analysis-of-security-critical-javascript-apis-2011--static-analysis-procedure-and-soundness-theorem` — the next section in this source: the formal semantics + Datalog encoding + soundness theorem.
- `papers--taly-automated-analysis-of-security-critical-javascript-apis-2011--applications-adsafe-vulnerability-sealer-unsealer-and-mint` — the third section: ENCAP applied to find the ADSafe vulnerability + verify Sealer-Unsealer + Mint.
