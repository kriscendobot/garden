---
title: Abstract
source: "Paradigm Regained: Abstraction Mechanisms for Access Control (ASIAN 2003, LNCS 2896)"
source_kind: paper
source_authors: [Mark S. Miller, Jonathan S. Shapiro]
source_year: 2003
source_venue: "ASIAN 2003, Springer LNCS 2896"
source_url: https://web.archive.org/web/2018/http://erights.org/talks/asian03/paradigm-revised.pdf
source_pdf_sha256: 6053a29e323e4ff49a81645c76f66e9a8ac1ee7b85cda8ab39af1149b90d6cb5
source_paper_pages: "7-14 (§4 The Object-Capability Paradigm, including §4.1 Model, §4.2 A Taste of E, §4.3 Redell's Caretaker, §4.4 Analysis and Blind Spots)"
ingested: 2026-05-21
ingested_by: liaison-direct-draft
topics: [capability-theory, capability-security, patterns]
status: current
parent: papers--miller-shapiro-paradigm-regained-2003--object-capability-model-and-redells-caretaker
---

§4 presents the **object-capability model** in its formal lambda-calculus-with-local-side-effects form. The model has six core elements (instance, code, state, index, loader) and three kinds of primitive objects (data, devices, loader). A *reference* indivisibly combines the designation of an object, the permission to access it, and the means to access it. The crucial structural rule is **only connectivity begets connectivity** — two disjoint subgraphs cannot become connected because no one can introduce them; connectivity is bequeathed transitively via message-passing or constructor endowment. §4.2 illustrates with a `pointMaker` E-language example showing how nested object definitions can be transformed into explicit `loader.load(code, ["x" => x, "y" => y])` calls — the linking happens only by virtue of these associations, *only connectivity begets connectivity*. §4.3 walks Redell's 1974 **Caretaker pattern** as the canonical existence proof against the impossibility claim "capabilities cannot revoke": Alice constructs a `caretakerMaker` that builds a `[caretaker, revoker]` pair sharing an assignable `target` variable; Alice gives Bob the caretaker (a forwarding object) and retains the revoker (which sets `target := null`). Bob holds the same designation throughout; what changes is the *behavior* the caretaker dispatches to. §4.4 — *Analysis and Blind Spots* — names the deep failure of permission-only analysis: by Chander-Dean-Mitchell's permission-only analysis [Chander01], Bob *was never given permission to access Carol*, so there was no access to Carol to be revoked; Bob was given permission to access `carol2` (the caretaker), and he still has it. Permission analysis renders the Caretaker pattern *invisible*. The paper's pivotal counter-claim: *to render permission-only analysis useless, a threat model need not include either malice or accident; it need only include subjects following security best practices*. Following POLA *is itself* a behavior that permission-only analysis cannot account for.
