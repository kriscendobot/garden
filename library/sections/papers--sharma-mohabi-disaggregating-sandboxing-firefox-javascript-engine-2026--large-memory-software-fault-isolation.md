---
title: Large-memory software fault isolation
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

Abstract: MH-LFI is an x86-64 software-fault-isolation design that confines writes, indirect control flow, returns, and system calls while supporting a 256 GiB browser sandbox. Its requirements show why a native containment layer for a JavaScript host must be designed around real engine constraints: large ArrayBuffer and WebAssembly allocations, concurrent workers, native ABI compatibility, and upgradeable toolchains, not only an idealized small standalone interpreter.

The rewriter masks write destinations into a power-of-two sandbox region and uses guard pages around it. It masks indirect jump targets and bundles instructions into 32-byte units so a jump cannot target the middle of an instruction sequence. Returns become a pop-mask-jump sequence, preventing a concurrent actor from altering a checked return address. System calls are rewritten to trusted-runtime calls that permit only checked operations.

Mohabi uses native pointers rather than sandbox-relative offsets, which lowers retrofit cost at the browser boundary. Its runtime establishes sandbox stacks and preserves the reserved base, mask, and scratch registers across transitions. The design does not depend on optional hardware isolation, although hardware features could later reduce overhead.

For Endor this is evidence against claiming that a language-level Compartment alone protects a native embedding. If native containment becomes in scope, decide the desired security invariant first: write-only confinement may be valid only after secret segregation; read-write confinement costs more. Also make resource bounds explicit. The paper's 4 GiB limitation in prior tools came from the containment representation, not from JavaScript semantics, and an Endor design must account for large buffers and worker concurrency before choosing a substrate.

Source: [Mohabi PDF](https://www.usenix.org/system/files/osdi26-sharma.pdf), pp. 212-214.
