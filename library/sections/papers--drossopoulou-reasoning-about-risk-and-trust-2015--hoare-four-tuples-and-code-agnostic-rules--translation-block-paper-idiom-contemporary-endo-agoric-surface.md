---
title: Translation block (paper idiom → contemporary Endo / Agoric surface)
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

| 2015 paper concept | Contemporary Endo / Agoric equivalent |
| ------------------ | ------------------------------------- |
| `Focal` (Featherweight Object Capability Language) | Hardened JavaScript (SES + lockdown + Compartment + harden); the language-level features are the same. |
| `Chainmail` named-policy specification | TypeScript interface contracts + JSDoc invariants + comment-block specification idioms; less formal but structurally analogous. |
| Module linking via `*` | `@endo/compartment-mapper` + `@endo/init` + endowment-passing — the composition is *additive* and *checks-domain-disjointness* but performs no other trust check. |
| `MayAccess` as transitive points-to closure | The pass-by-reference / pass-by-copy / pass-by-presence taxonomy in `@endo/marshal`; the formal model is the abstract graph, the implementation distinguishes how the reference traversal can happen. |
| Hoare four-tuple `M ⊢ A { stmts } A' ⋈ B` | An informal "code that holds an invariant during execution" discipline; design docs can adopt the four-tuple syntax to make the invariant explicit. |
| `(METH-CALL-2)` only-connectivity-begets-connectivity | The structural rule for capability passing in `@endo/marshal` + `captp`: a remote call cannot introduce references its arguments and receiver did not already imply. |
| `(FRAME-METHCALL)` POLA framing | The `harden`-induced *immutability-by-default*: an alleged-trustworthy object's mutations are restricted to what its access-graph permits. |
| `(CODE-INVAR-1)` reasoning under hypothesis | The contemporary Hardened JavaScript review style: *if* the alleged interface contract holds, *then* the call's effects are bounded by the contract; reviewers should consider the case where the contract fails to detect spec drift. |
| `(CODE-INVAR-2)` trust is preserved | The contemporary practice: once a capability is *committed* to via `harden` + endowment, the trust assumption holds for the lifetime of the program — there is no untrust-then-retrust dance. |
