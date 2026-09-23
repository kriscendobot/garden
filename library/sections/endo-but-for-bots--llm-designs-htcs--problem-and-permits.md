---
title: Problem and permits — TextEncoder/TextDecoder on universalPropertyNames
source: designs/hardened-text-codecs-shim.md
source_repo: endojs/endo-but-for-bots
source_branch: llm
source_commit: 6d2f3a03a0648edda82a0444898f1d1ff0c25806
source_date: 2026-05-04
source_authors: [Kris Kowal]
topics: [hardened-javascript, compartments]
status: current
notes: **Status: Not Started** upstream. Sibling of [[endo-but-for-bots--llm-designs-hardened-url-shim]] (split out per PR #84 review on the URL shim). Unlike URL, these codecs have **no ambient-authority static methods and no exposed iterator prototype** — the taming story is straightforward and lands on `universalPropertyNames` directly.
kind: index
section_count: 2
---

Endo's hardened-JavaScript model rests on the premise that **every
intrinsic shared between fearlessly coöperating compartments is
either a powerless data constructor or has been carefully tamed.**
The host's `TextEncoder` and `TextDecoder` are broadly useful — UTF-8
round-tripping for byte-oriented work, the canonical portable
alternative to Node's `Buffer` — and would be welcome additions to
the permitted intrinsics. Unlike `URL`, the text codecs have:

- **No ambient-authority static methods** (URL has `URL.createObjectURL`).
- **No exposed iterator prototype** (URLSearchParams has its own iterator that requires throwaway-instance sampling).

The taming story is therefore the simplest of the three placements
in the permits-bucket framework (see [[permits-buckets]]).

Sections:

- [Three-bucket framework (recap)](endo-but-for-bots--llm-designs-htcs--problem-and-permits--three-bucket-framework-recap.md)
- [Permits table](endo-but-for-bots--llm-designs-htcs--problem-and-permits--permits-table.md)
