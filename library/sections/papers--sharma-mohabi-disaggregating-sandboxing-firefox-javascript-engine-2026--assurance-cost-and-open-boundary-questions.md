---
title: Assurance cost and open boundary questions
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

Abstract: Mohabi reports 24.82% JetStream and 24.43% Speedometer overhead, versus a cited 53% Speedometer reduction when Firefox's JIT is disabled. It substantially shrinks the engine TCB but explicitly leaves full boundary-sanitization coverage unfinished. The Endor takeaway is a disciplined tradeoff: native containment can be practical, but its cost and residual boundary risk must be measured and stated instead of being hidden behind a generic "sandbox" label.

The paper attributes the largest browser cost to backward-edge control-flow checks and reports 5.9% overhead for MH-LFI's large-memory, write-only SPEC configuration. It contrasts Mohabi with V8 Ubercage: the latter has lower cost from a narrower internal heap boundary, but leaves JIT, runtime, and much GC code trusted and has accumulated boundary bypasses. Mohabi instead moves most SpiderMonkey code inside the sandbox and relies on sanitization at the browser boundary.

Its remaining open problem is comprehensive verification that every browser-to-engine exchange is checked. The existing sanitization layer covers only a limited set of wrapper types and not the full JSAPI. The authors suggest automatic sanitization in generated glue or a narrower redesigned interface.

Open questions for Endor: What untrusted-code class is intended to be contained, and does the deployment have a distinct secret domain? Which values crossing an Endor boundary are data, which are authority, and which are merely host-managed identities? Can the interface be generated from a schema and independently fuzzed or validated? If native isolation is out of scope, where is the trusted-engine assumption documented so applications can choose a process or VM boundary when it is needed?

Source: [Mohabi PDF](https://www.usenix.org/system/files/osdi26-sharma.pdf), pp. 216-220.
