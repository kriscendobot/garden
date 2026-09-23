---
title: Security boundary and Endor threat model
source: Mohabi: Disaggregating and Sandboxing the Firefox JavaScript Engine
source_kind: paper
source_authors: [Abhishek Sharma, Anand Balaji, Zachary Yedidia, Anthony Du, Taehyun Noh, Iain Ireland, Jan de Mooij, Matthew Gaudet, Tal Garfinkel, Deian Stefan, Hovav Shacham, Shravan Narayan]
source_year: 2026
source_venue: "20th USENIX Symposium on Operating Systems Design and Implementation (OSDI 2026)"
source_url: https://www.usenix.org/system/files/osdi26-sharma.pdf
source_pdf_sha256: c007115b3a5b54f70389700de0f04e3cd695ea25969be8ad609fdb0bc20825d3
ingested: 2026-07-25
ingested_by: scholar
topics: [hardened-javascript, capability-security]
status: current
---

Abstract: Mohabi separates JavaScript-language authority confinement from native-engine compromise containment. SES-style hardening can constrain what correctly executing guest JavaScript receives; it does not contain a memory-safety exploit in the engine executing it. Mohabi puts the whole SpiderMonkey engine behind an SFI boundary, reducing an engine compromise to boundary-check and trusted-runtime failures. For Endor, the concrete design question is therefore whether its threat model stops at hostile JavaScript or also includes a compromised host engine, native extension, or JIT. The latter needs an independently enforced boundary and an explicit inventory of cross-boundary data, callbacks, and privileged operations.

The paper argues that modern JavaScript engines remain a high-value native attack surface because tiered interpreters and JITs perform speculative optimization and emit runtime code. Disabling JITs reduces but does not eliminate the attack surface and forfeits substantial performance. Mohabi instead confines the engine so corruption cannot write outside its sandbox or issue disallowed system calls.

Mohabi relies on Firefox site isolation for a deliberate write-only policy: a site process contains no other site's secrets, so restricting writes is enough to prevent privilege escalation. That assumption is not automatic for Endor. If Endor uses a similar write-only boundary, it must first establish that the surrounding process does not hold secrets that a compromised guest engine may read. Otherwise it needs read isolation as well, or a process boundary that segregates secrets.

The residual risk is not zero. Any unsanitized output, callback, pointer-like handle, or shared object can make the host a confused deputy. The authors identify complete coverage of the browser-to-engine boundary as future work. Endor should treat that as a checklist item, not an implementation detail: enumerate each crossing, define its representation and authority, and make missing validation fail closed.

Source: [Mohabi PDF](https://www.usenix.org/system/files/osdi26-sharma.pdf), pp. 207-209, 218-219.
