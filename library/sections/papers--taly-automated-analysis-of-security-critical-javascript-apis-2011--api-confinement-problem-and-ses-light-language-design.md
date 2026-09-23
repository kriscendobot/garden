---
title: The API+Sandbox approach for embedding untrusted JavaScript in trusted hosting pages; the three properties JavaScript fails (Lexical Scoping, Safe Closure-Based Encapsulation, No Ambient Access to Global Object); how ES5-strict (ES5S) fixes those three but leaves two remaining limitations (ambient access to built-in objects + dynamic code execution); how SES_light adds *transitively-immutable built-in objects* + *variable-restricted eval* to close the remaining gaps
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
kind: index
section_count: 6
---

Sections:

- [Abstract](papers--taly-automated-analysis-of-security-critical-javascript-apis-2011--api-confinement-problem-and-ses-light-language-design--abstract.md)
- [Body](papers--taly-automated-analysis-of-security-critical-javascript-apis-2011--api-confinement-problem-and-ses-light-language-design--body.md)
- [Connection to the wider library](papers--taly-automated-analysis-of-security-critical-javascript-apis-2011--api-confinement-problem-and-ses-light-language-design--connection-to-the-wider-library.md)
- [Translation block (paper idiom → contemporary practice)](papers--taly-automated-analysis-of-security-critical-javascript-apis-2011--api-confinement-problem-and-ses-light-language-design--translation-block-paper-idiom-contemporary-practice.md)
- [See also](papers--taly-automated-analysis-of-security-critical-javascript-apis-2011--api-confinement-problem-and-ses-light-language-design--see-also.md)
- [Common confusions](papers--taly-automated-analysis-of-security-critical-javascript-apis-2011--api-confinement-problem-and-ses-light-language-design--common-confusions.md)
