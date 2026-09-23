---
title: Implications for Endo / Agoric
source: "Reasoning about Risk and Trust in an Open World (Drossopoulou, Noble, Miller, Murray ~2015)"
source_kind: paper
source_authors: [Sophia Drossopoulou, James Noble, Mark S. Miller, Toby Murray]
source_year: 2015
source_venue: "Workshop draft, technical report ECSTR-15-08 (VUW, 2015)"
source_url: https://papers.agoric.com/papers/reasoning-about-risk-and-trust-in-an-open-world/
source_pdf_sha256: 3f4b20422cda8899380377c6d3c43c279ef2dca07f748febe79bc5a2302c2809
source_paper_pages: "11-18 (§3 A Formal Model of Trust and Risk through §3.4 Proving Mutual Trust)"
ingested: 2026-05-29
ingested_by: liaison-direct-draft
topics: [capability-security, capability-theory, spec-to-implementation]
status: current
parent: papers--drossopoulou-reasoning-about-risk-and-trust-2015--hoare-four-tuples-and-code-agnostic-rules
---

This section is the **formal foundation for open-world Hardened JavaScript verification**. The library can cite this paper whenever:

1. **A design needs to specify trust + risk simultaneously.** The `Chainmail` policy structure (named policies; conjunction of invariants + Hoare-style triples + `any_code` rules) is the template. Designs can adopt the named-policy idiom for documentation precision.
2. **A design needs to express an invariant that holds *during* execution.** The Hoare four-tuple is the formal mechanism. Less formally, designs should distinguish *terminal-state guarantees* from *during-execution guarantees* when the latter is load-bearing (e.g. when an untrusted callee could temporarily expose a capability).
3. **A design needs to reason about an unknown callee.** The `(METH-CALL-2)` axiom is the canonical rule: *only connectivity begets connectivity*. Designs should explicitly invoke this rule when arguing risk bounds against an unknown receiver.
4. **A design needs to formalize *defensive consistency*.** The four code-agnostic rules are exactly the formal content of defensive consistency. A reviewer asking *what does this code guarantee if the callee misbehaves?* is informally invoking these rules.
