---
title: JIT validation and writable executable code
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

Abstract: Mohabi's key assurance is independent validation of every executable byte, including JIT output. It modifies SpiderMonkey's shared MacroAssembler backend to emit SFI-compliant code, but treats that generator as fallible: a binary validator checks instrumentation before code becomes executable. Dual mapping lets a trusted runtime validate only newly written code without opening a concurrent write-then-execute race. For Endor, any future JIT, WebAssembly, native plugin, or generated-code substrate needs the same separation between generating code and authorizing its execution.

The JIT backend reserves SFI registers, masks memory and control-flow operations, aligns valid targets, and prevents constants or relocation data in executable pages from becoming useful gadgets. The validator found missed low-level indirect jumps, unsafe zero-filled page tails, and WebAssembly trap handling that could restore a reserved register. These were not failures of the stated design; they were omissions in complex implementation paths that the independent checker made visible.

During code updates, the runtime maps a writable alias outside the sandbox, makes the in-sandbox page non-executable, writes and validates the new region, then restores execute permission. This avoids a time-of-check/time-of-use gap while avoiding whole-page revalidation on every update.

Endor implication: do not accept "the compiler/JIT emits safe code" as a boundary claim. The security decision should name the small validator and page-transition protocol in the trusted computing base, make validation mandatory before executable permission, and test unusual emission paths such as padding, constants, bailout/deoptimization and concurrent workers. A narrower current scope is also legitimate: state that Endor does not provide native-code containment and requires a trusted engine, rather than implying that SES hardening covers it.

Source: [Mohabi PDF](https://www.usenix.org/system/files/osdi26-sharma.pdf), pp. 214-216.
