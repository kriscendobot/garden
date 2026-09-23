---
title: Connection to the wider library
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

This section is the **canonical formal-foundation paper for SES + JavaScript-API confinement analysis**. Three threads:

1. **SES_light's formal operational semantics** is the foundation contemporary Hardened JavaScript implementations build on. The library can cite this section whenever a design needs to ground a JavaScript-language-level claim in a formal semantics.

2. **The labeled-semantics + Confinement-Property definition + soundness theorem** is the canonical worked example of *static-analysis-with-formal-soundness-guarantee* for capability-confinement. Generalizes to any analysis problem that can be cast as *over-approximate the points-to of a test variable*.

3. **The Datalog encoding** is the *practical tool* the §5 procedure builds. Reusable for any flow-insensitive context-insensitive points-to analysis. The contemporary `eslint-plugin-no-undefined-globals` and similar tools occupy a similar analysis-strength space without the SES_light language base.
