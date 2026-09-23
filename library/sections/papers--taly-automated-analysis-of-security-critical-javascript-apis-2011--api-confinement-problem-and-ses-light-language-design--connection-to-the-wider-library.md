---
title: Connection to the wider library
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

This section is the **canonical SES-language-foundation paper**. Three threads:

1. **The API+Sandbox structural pattern is the contemporary template** for embedding untrusted code in trusted hosts. The library can cite this section whenever a design needs to motivate the *API-as-reference-monitor* architecture. The pattern is enacted in contemporary Endo as `@endo/compartment-mapper` + `@endo/static-module-record` + endowment-passing.

2. **The three-property-trichotomy (Lexical Scoping + Safe Closure-Based Encapsulation + No Ambient Access to Global Object)** generalizes beyond JavaScript. Any host language that wants to support *capability-discipline at the API layer* needs the same three properties or equivalents.

3. **The transitively-immutable-built-in-objects + variable-restricted-eval pair** is the *minimum delta from strict-mode-JavaScript to SES*. Contemporary Hardened JavaScript realizes both: `lockdown()` freezes the intrinsics (the transitive-immutability part); `Compartment` + `static-module-record` provides the static-analyzability that variable-restricted-eval was a 2011 sketch of.
