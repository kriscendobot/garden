---
title: Translation block (paper idiom → contemporary practice)
source: "Automated Analysis of Security-Critical JavaScript APIs (Taly, Erlingsson, Mitchell, Miller, Nagra, IEEE S&P 2011)"
source_kind: paper
source_authors: [Ankur Taly, Úlfar Erlingsson, John C. Mitchell, Mark S. Miller, Jasvir Nagra]
source_year: 2011
source_venue: "IEEE Symposium on Security and Privacy 2011"
source_url: https://papers.agoric.com/papers/automated-analysis-of-security-critical-javascript-apis/
source_pdf_sha256: 4457eafac35c129dac26fdf163710a1f89b63b0d9a4ba1bc6378fa318c4bec95
source_paper_pages: "3-12 (§3 The Language SES_light through §5 Analysis Procedure)"
ingested: 2026-05-29
ingested_by: liaison-direct-draft
topics: [capability-security, capability-theory, hardened-javascript]
status: current
parent: papers--taly-automated-analysis-of-security-critical-javascript-apis-2011--static-analysis-procedure-and-soundness-theorem
---

| 2011 paper concept | Contemporary practice |
| ------------------ | --------------------- |
| SES_light formal operational semantics | Hardened JavaScript's operational behavior; same heap/stack/state shapes; same property attributes. |
| Labeled semantics + allocation-site labels | The standard *abstract location* discipline in points-to analysis. |
| Confinement Property `PtsTo(un, Reach(S_0(t))) ∩ P = ∅` | The canonical confinement-property shape; any system that wants to prove *attacker-cannot-reach-forbidden-resources* uses an analogous formalization. |
| Flow-insensitive context-insensitive Datalog | A standard tractable points-to analysis. The contemporary alternative is type-directed analysis or SMT-based verification (which is more precise but slower). |
| Soundness theorem `D(t, P) ⟹ Confine(t, P)` | The over-approximation guarantee: if the analysis says safe, the runtime is safe; if the analysis says unsafe, the runtime *might* be safe (false positives possible). |
| Initial heap labels for built-in objects | The contemporary Hardened JavaScript's `lockdown()` is the operational analog: built-in objects start in a known state and are deeply frozen. |
| Variable-restricted eval encoding | The contemporary Compartment.evaluate(src, options) with explicit endowments; the static-analysis benefit is the same. |
