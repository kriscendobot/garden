---
title: Common confusions
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

- **"The API+Sandbox approach is just iframes-without-iframes."** Structurally similar but operationally different: iframes provide *process-level* isolation with *no* shared memory; API+Sandbox provides *language-level* isolation with *explicit* shared API surface. The trade-off: API+Sandbox is more performant + more interactive, but harder to prove confined.
- **"The §1 store-method attack is a bug in the API design."** It is — but the §1 paper's point is that *spotting this bug requires understanding the language idiosyncrasies* (full JavaScript's `Array.prototype.push` can be overridden via direct property assignment). A defender who didn't know that would write the same buggy API. Static analysis catches it without the defender needing to know.
- **"ES5S is enough."** §2.B explicitly says no: *ES5S has two remaining limitations for confinement and static analysis — ambient access to built-in objects + eval*. SES_light adds *transitive immutability* + *variable-restricted eval* to close the gaps.
- **"`with` is just a convenience feature."** It is — and it makes static analysis impossible. The `with` statement injects an object's properties as bindings in a scope, and the property set can change at runtime via prototype manipulation. ES5S forbids `with` for static-analysis tractability.
- **"`arguments.caller` is rarely used."** Rare in well-written code; *uniquely powerful for an attacker* who *does* use it. ES5S forbids it to close the closure-encapsulation gap regardless of how rare legitimate use is.
- **"SES_light is just a static-analysis-friendly subset."** Also — *and* a deployment target. The §2.B paper presents an *initialization script* approach: run a startup script on a compliant ES5S browser that makes the runtime SES_light-compliant. The contemporary `@endo/lockdown` is the direct descendent.
