---
title: "Setting up the Puzzle: roles, least authority, and mutual distrust"
source_kind: web
source_url: https://erights.org/elib/equality/grant-matcher/index.html
source_content_sha256: d25136c94d42dc389c74d8bdff8ae63871bd6a00bc85a07b3c1aad4606107b58
source_authors: [Mark S. Miller]
source_date: 2000-01-01
ingested: 2026-06-27
ingested_by: scholar
topics: [capability-security, capability-theory]
status: current
---

The role assignment that maps the abstract three-object diagram onto the concrete scenario. The **Grant Matcher** itself plays Bob; a charity named **KEQD** plays Carol (the destination); **Dana**'s situation is exactly symmetric with **Alice** — Alice and Dana are two donors, both of whom trust the Grant Matcher to perform its duties but **do not trust each other at all**, which is *why* they use the Grant Matcher as a mutually trusted third party. Their only protection against misbehavior by the Grant Matcher is the **principle of least authority** (Saltzer and Schroeder's principle of least privilege): the protocol requires of Alice and Dana only the capabilities the Grant Matcher would need to honestly perform its duties, and a protocol demanding more should raise eyebrows.

In the initial conditions of the Grant Matcher Puzzle, the Grant Matcher itself plays the role of Bob, and a charity named KEQD plays the role of Carol. Dana's situation is exactly symmetric with Alice. Alice and Dana are both assumed to trust the Grant Matcher to perform its duties.

Their only protection against misbehavior by the Grant Matcher is the **principle of least authority** (called by Saltzer and Schroeder the principle of least privilege). The Grant Matcher's protocol only requires Alice and Dana to give the Grant Matcher those capabilities it would require to honestly perform its duties. A protocol requiring more authority than this should raise eyebrows. In the context of the Grant Matcher Puzzle as posed, Alice and Dana are vulnerable to the misbehavior possible within these bounds, about which we will not concern ourselves further.

Money is itself an interesting problem but is simply assumed for this puzzle (there is an implementation of money adequate for the example, given that the Grant Matcher already has prior knowledge of the currency Alice and Dana use). Alice and Dana are assumed not to trust each other at all — that is why they use the Grant Matcher as a mutually trusted third party. No system can enable cooperation in the absence of any trust; the Grant Matcher pattern brings about a particular kind of cooperation between Alice and Dana requiring only that they both trust the Grant Matcher and a common monetary system.

Source: [The Grant Matcher Puzzle](https://erights.org/elib/equality/grant-matcher/index.html) § Setting up the Puzzle, Mark S. Miller, erights.org; ingested from the Internet Archive original-bytes capture, content SHA-256 `d25136c9`.
