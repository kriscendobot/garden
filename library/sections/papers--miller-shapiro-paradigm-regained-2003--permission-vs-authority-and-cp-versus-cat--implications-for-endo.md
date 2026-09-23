---
title: Implications for Endo
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

This section is the *foundational citation* for several Endo invariants that show up wherever capability discipline is named:

1. **Permission ≠ authority. Always reason about authority.** Endo's review discipline for bundle designs (judge / fixer / cleaner) should be asking the *authority* question: what can this bundle ultimately cause? Not just: what does it directly hold? The library concept `[[principle-of-least-authority]]` (deferred concept page; three citations now) should anchor this.
2. **Designation conveys authority.** Endo's bundle-endowment-object pattern is the cat-style discipline at the language level. Path-string parameters are the cp-style anti-pattern; capability-handle parameters are the cat-style discipline. The paper makes this *the* architectural choice.
3. **Two styles coexist in legacy substrates; eliminate the broad one.** Hardened JavaScript on top of plain Node already inherits the broad style (process can `fs.readFile()` any path the user can). Endo's compartment + lockdown discipline progressively eliminates the broad style; remaining ambient authority is a *technical debt* item rather than an architectural fact.
4. **The cat lesson generalises to argument passing inside the language.** Lexical scoping is the cat pattern at the function-call level: the caller evaluates argument expressions in the caller's namespace, and the callee receives first-class anonymous objects under callee-local names. JavaScript already does this; the discipline is to *use it intentionally* — pass capability handles rather than path strings, even at the in-language level.
