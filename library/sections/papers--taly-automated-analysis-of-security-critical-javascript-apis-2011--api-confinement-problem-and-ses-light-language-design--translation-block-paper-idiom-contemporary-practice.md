---
title: Translation block (paper idiom → contemporary practice)
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

| 2011 paper concept | Contemporary surface |
| ------------------ | -------------------- |
| API+Sandbox approach | The contemporary Hardened JavaScript pattern: trusted code exposes a Compartment's API (via endowments) to a guest bundle; the Compartment is the sandbox. |
| Reference monitor as the API itself | The contemporary practice: there is no separate reference-monitor process; the API checks are *in the API methods*. |
| ES5S restrictions (no `with`, no `delete`-on-variable, no `.caller`, etc.) | Contemporary strict-mode JavaScript inherits these. SES + Compartment additionally enforce them. |
| Transitively-immutable built-in objects | `lockdown()` from `@endo/lockdown` — freezes the intrinsics. Deep freeze of `Object.prototype`, `Array.prototype`, etc. |
| Variable-restricted eval | The contemporary `Compartment.evaluate(src, options)` with explicit endowments. The endowments enumerate the free variables; the source is evaluated only with those endowments in scope. |
| No ambient access to the global object | Compartment's `globalThis` is the *compartment's* globalThis, not the realm's. The host's globalThis is unreachable from inside the Compartment. |
| `ECMAScript 5th edition` standard reference | Now ES2024+; contemporary practice operates on a much larger standard. |
