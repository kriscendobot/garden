---
source_kind: paper
source_authors: [Abhishek Sharma, Anand Balaji, Zachary Yedidia, Anthony Du, Taehyun Noh, Iain Ireland, Jan de Mooij, Matthew Gaudet, Tal Garfinkel, Deian Stefan, Hovav Shacham, Shravan Narayan]
source_title: "Mohabi: Disaggregating and Sandboxing the Firefox JavaScript Engine"
source_year: 2026
source_venue: "20th USENIX Symposium on Operating Systems Design and Implementation (OSDI 2026), pp. 207-220"
source_url: https://www.usenix.org/system/files/osdi26-sharma.pdf
source_pdf_sha256: c007115b3a5b54f70389700de0f04e3cd695ea25969be8ad609fdb0bc20825d3
source_fetched_via: direct
source_pdf_pages: 14
ingested: 2026-07-25
ingested_by: scholar
section_count: 5
status: current
notes: |
  Direct USENIX open-access PDF acquired with fetch-source.sh. This is a native
  JavaScript-engine-containment paper, not an SES implementation: its Endor
  implications distinguish language-level authority confinement from a defense
  against memory-safety compromise in the executing engine.
---

Abstract: Mohabi is a Firefox prototype that places the entire SpiderMonkey JavaScript engine behind an x86-64 software-fault-isolation boundary. It combines typed disaggregation of browser/engine interfaces, large-memory SFI, JIT-code validation, and mediated page transitions. Its central result is that full-engine containment can be achieved with roughly 24% browser-benchmark overhead, but the boundary sanitization problem remains open. For Endor, it provides a sharp threat-model distinction: SES compartments constrain JavaScript authority; native engine compromise requires a separately enforced containment boundary and a deliberately narrow, validated crossing surface.

| Section | Topics | Status |
|---------|--------|--------|
| [security-boundary-and-endor-threat-model](../sections/papers--sharma-mohabi-disaggregating-sandboxing-firefox-javascript-engine-2026--security-boundary-and-endor-threat-model.md) | hardened-javascript, capability-security | current |
| [typed-disaggregation-and-boundary-sanitization](../sections/papers--sharma-mohabi-disaggregating-sandboxing-firefox-javascript-engine-2026--typed-disaggregation-and-boundary-sanitization.md) | capability-security, hardened-javascript | current |
| [large-memory-software-fault-isolation](../sections/papers--sharma-mohabi-disaggregating-sandboxing-firefox-javascript-engine-2026--large-memory-software-fault-isolation.md) | hardened-javascript, capability-security | current |
| [jit-validation-and-writable-executable-code](../sections/papers--sharma-mohabi-disaggregating-sandboxing-firefox-javascript-engine-2026--jit-validation-and-writable-executable-code.md) | hardened-javascript, capability-security | current |
| [assurance-cost-and-open-boundary-questions](../sections/papers--sharma-mohabi-disaggregating-sandboxing-firefox-javascript-engine-2026--assurance-cost-and-open-boundary-questions.md) | hardened-javascript, capability-security | current |
