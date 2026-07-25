---
title: Typed disaggregation and boundary sanitization
source: Mohabi: Disaggregating and Sandboxing the Firefox JavaScript Engine
source_kind: paper
source_authors: [Abhishek Sharma, Anand Balaji, Zachary Yedidia, Anthony Du, Taehyun Noh, Iain Ireland, Jan de Mooij, Matthew Gaudet, Tal Garfinkel, Deian Stefan, Hovav Shacham, Shravan Narayan]
source_year: 2026
source_venue: "20th USENIX Symposium on Operating Systems Design and Implementation (OSDI 2026)"
source_url: https://www.usenix.org/system/files/osdi26-sharma.pdf
source_pdf_sha256: c007115b3a5b54f70389700de0f04e3cd695ea25969be8ad609fdb0bc20825d3
ingested: 2026-07-25
ingested_by: scholar
topics: [capability-security, hardened-javascript]
status: current
---

Abstract: Mohabi makes a previously implicit engine/browser trust boundary explicit through a small family of typed bridge patterns: split allocation for shared objects, generated wrappers for the 2,250-function JSAPI, typed DOM reflectors, and virtual trampoline/springboard control transfers. The important lesson for Endor is to centralize authority crossings in generated or typed adapters, rather than allow ambient host objects, callbacks, or mutable shared structures to leak across a compartment boundary.

Firefox and SpiderMonkey were directly linked and shared deeply intertwined control flow and data structures. Mohabi separates the engine build, then uses patterns that encode where fields live and where calls may go. Split-allocation types divide an object into trusted and sandboxed parts. DOM reflector glue receives validation because values from the engine are untrusted. Stub generation turns a wide API into wrappers with a uniform security policy. Virtual trampolines and springboards constrain nested callbacks and event-queue interactions.

The authors' type system and code generation reduce the manual surface, but do not prove all boundary checks are present. This is a useful warning for Endor: TypeScript types and SES `harden()` can document or narrow an interface, yet they are not a complete validator for values produced by compromised native code. Boundary adapters should distinguish data from authority-bearing handles, validate discriminants, sizes, lifetime and ownership, and avoid using guest-controlled metadata to make privileged host decisions.

Source: [Mohabi PDF](https://www.usenix.org/system/files/osdi26-sharma.pdf), pp. 209-212, 218-219.
