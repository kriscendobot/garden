---
title: Abstract
source: "Paradigm Regained: Abstraction Mechanisms for Access Control (ASIAN 2003, LNCS 2896)"
source_kind: paper
source_authors: [Mark S. Miller, Jonathan S. Shapiro]
source_year: 2003
source_venue: "ASIAN 2003, Springer LNCS 2896"
source_url: https://web.archive.org/web/2018/http://erights.org/talks/asian03/paradigm-revised.pdf
source_pdf_sha256: 6053a29e323e4ff49a81645c76f66e9a8ac1ee7b85cda8ab39af1149b90d6cb5
source_paper_pages: "1-7 (§1 Introduction, §2 Terminology and Distinctions, §3 How Much Authority Does cp Need?)"
ingested: 2026-05-21
ingested_by: liaison-direct-draft
topics: [capability-theory, capability-security]
status: current
parent: papers--miller-shapiro-paradigm-regained-2003--permission-vs-authority-and-cp-versus-cat
---

§1 sets up the problem: we live in a world of insecure computing because *all widely-deployed operating systems routinely allow programs to execute with excessive and largely unnecessary authority*. Solitaire needs to render into its window, receive UI events, and save a score file — yet instead receives full user authority. The flaws are not bugs in the usual sense: each OS is functioning *as specified*, and each specification is a valid embodiment of its **access-control paradigm**. The fix is not patches but a paradigm shift. §2 establishes the load-bearing terminology distinction the rest of the paper rests on: **permission** (what an individual program may perform on objects it can directly access — the system's protection state) versus **authority** (the effects a program may cause on objects it can access either directly *or indirectly via permitted interactions with other programs*). Authority subsumes permission and adds *behavior*: what objects actually do when invoked. The paper formalizes two analysis classes: *arrangement-only* bounds (reasoning only from the current permission arrangement, conservative and decidable in many cases — corresponds to Bishop-Snyder's *de jure* and *de facto* analyses) versus *partially-behavioral* bounds (taking the state and behavior of some subjects and objects into account, tighter but harder). The closing distinction of §2 is one Saltzer-Schroeder left ambiguous: "It is unclear whether Saltzer and Schroeder's *Principle of Least Privilege* is best interpreted as least permission or least authority. As we will see, there is an enormous difference between the two." §3 makes the difference concrete with the **cp-versus-cat** comparison — the same lesson *Structure of Authority* (2004) later reprises, here in its first published form. Designation method determines least authority by orders of magnitude.
