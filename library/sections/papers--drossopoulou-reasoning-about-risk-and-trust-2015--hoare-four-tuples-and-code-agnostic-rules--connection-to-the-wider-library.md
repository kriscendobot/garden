---
title: Connection to the wider library
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

The §3 paper is the **formal underpinning for open-world reasoning over Hardened JavaScript and the @endo discipline**. Three threads:

1. **`Focal` is the formal model of Hardened JavaScript at the language level.** Memory-safety + dynamic typing + module composition without central authority — these are the features `harden` + Compartment + `@endo/static-module-record` give the contemporary developer. The §3.1 module composition operator `*` is the formal abstraction of `@endo/compartment-mapper` + `@endo/init`'s composition mechanics.

2. **`Chainmail` is the spec-language target for documenting Hardened JavaScript invariants.** Designs that need to formalize trust assumptions can use `Chainmail`-style policy structures (named policies; invariants vs Hoare-style vs `any_code` Hoare-style) as the documentation template.

3. **The four code-agnostic rules are the formal underpinning of *defensive consistency*.** Hardened JavaScript code is *defensively consistent* — it must produce correct output given *any* input from any caller, trusted or not. The `METH-CALL-2` axiom and the `FRAME-METHCALL` rule express the formal content of defensive consistency: even an untrusted callee cannot cause effects beyond its access reach.
