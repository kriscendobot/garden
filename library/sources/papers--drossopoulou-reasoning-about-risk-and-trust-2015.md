---
source_kind: paper
source_authors: [Sophia Drossopoulou, James Noble, Mark S. Miller, Toby Murray]
source_title: "Reasoning about Risk and Trust in an Open World"
source_year: 2015
source_venue: "Workshop paper / technical report; referenced as Drossopoulou-Noble *Swapsies on the Internet* (PLAS 2015 [17] in own bibliography); full technical report ECSTR-15-08, VUW, 2015 [18]"
source_url: https://papers.agoric.com/papers/reasoning-about-risk-and-trust-in-an-open-world/
source_pdf_url: https://papers.agoric.com/assets/pdf/papers/reasoning-about-risk-and-trust-in-an-open-world.pdf
source_pdf_sha256: 3f4b20422cda8899380377c6d3c43c279ef2dca07f748febe79bc5a2302c2809
source_pdf_pages: 34
ingested: 2026-05-29
ingested_by: liaison-direct-draft
section_count: 3
status: current
---

The 2015 Drossopoulou-Noble-Miller-Murray paper that lays the **formal foundations for reasoning about trust and risk in object-capability programs in an open world**. The paper introduces three specification-language constructs that make trust *explicit and dischargeable* — **`obeys`** (a hypothetical trust predicate; *o obeys Spec* means we trust `o` to adhere to `Spec`), **`MayAccess(o, p)`** (the abstract transitive points-to closure — bounds *what an untrusted callee could reach*), **`MayAffect(o, p)`** (the dual mutation closure — bounds *what an untrusted callee could change*). The paper then specifies the **`ValidPurse`** policy in five named sub-policies and uses it to prove the **escrow exchange** of Miller-Van Cutsem-Tulloh 2013 has *weaker* guarantees than originally thought — surprising both the reviewers and the original escrow designers (one of whom, Miller, is a co-author). The paper develops the formal model in three layers: ***Focal*** (Featherweight Object Capability Language; the dynamic-typed core OO language that models JavaScript / Grace / E / Dart unchecked-mode); ***Chainmail*** (the specification language; named policies of three shapes — invariant, code-specific Hoare, or `any_code`-Hoare); and a **Hoare four-tuple logic** (the inference system that distinguishes *postcondition* from *invariant*, allowing reasoning about *no-bad-behaviour-during-execution* not just at termination). The paper's central inferential payoff is **four code-agnostic inference rules** — `METH-CALL-2` (only-connectivity-begets-connectivity), `FRAME-METHCALL` (POLA framing), `CODE-INVAR-1` (reasoning under `obeys` hypothesis), `CODE-INVAR-2` (`obeys` preserved across statement execution) — that let the verifier conclude useful things about a method call *even when the call's effects on the receiver are unknown*. The library can cite this paper whenever a design needs:

- **A formal model of trust as a dischargeable hypothesis.** `obeys` is the canonical predicate; the hypothesis enters proofs as an antecedent of an implication and is discharged either by ground-truth provenance or by structural argument (trusted introduction chain).
- **A formal bound on damage in the untrusted case.** `MayAccess` and `MayAffect` bound what an untrusted callee can read and change. *Only connectivity begets connectivity* (Miller PhD 2006 [30]) is the formal axiom.
- **A specification template for multi-party trust-sensitive contracts.** The four-case `ValidEscrow` spec is the canonical pattern: enumerate the cases on participant-trust (trustworthy-only, mixed) and specify what holds *and* what risk is bounded in each.
- **A formal underpinning for defensive consistency.** The four code-agnostic rules are exactly the formal content of *defensive consistency*: a verifier can argue useful conclusions in the absence of caller / callee source.
- **A specification methodology for the open world.** The §1 paper is the canonical statement of the open-world specification problem; the rest of the paper is the worked-example demonstration.

## The argument arc

1. **The open-world problem with closed-world specs.** Given `x.m(y)` with unknown receiver, what can we conclude? Traditional specs cannot answer; they implicitly assume `x` is trustworthy.
2. **`obeys`, `MayAccess`, `MayAffect`.** Three new specification predicates that make trust and risk explicit. `obeys` is hypothetical (no runtime check); `MayAccess` is the transitive reachability closure; `MayAffect` is the mutation closure.
3. **The naive escrow fails and why a runtime trust-bit doesn't help.** §2.1 shows the sprouted-malicious-purse attack; §2.1 closes by arguing that a runtime `trusted` method is *worse than useless* because untrustworthy code lies about it.
4. **`ValidPurse` specification.** Five named policies + abstract `CanTrade` predicate. The policies cover successful deposit, failed deposit, sprout, `CanTrade`-is-invariant, and POLA on balance.
5. **Mutual trust by reciprocal zero-amount deposits.** §2.4 establishes a *biconditional* on `obeys` between two purses; neither is individually resolved, but both are hypothesis-locked together.
6. **`deal_version2` with explicit mutual-trust setup.** §2.5 revises the naive escrow to set up mutual trust through fresh escrow purses *before* the actual transfer.
7. **The four-case `ValidEscrow` spec.** §2.6 distinguishes (result × all-trustworthy?) four cases. The Discussion's surprise: *the return value does not communicate trustworthiness* — `true` could come from case 1 (all honest) or case 4 (jointly conspiring).
8. **`Focal` and `Chainmail`.** §3.1-§3.2 define the language and spec language. `Focal` is dynamic + memory-safe; `Chainmail` is the named-policy specification language.
9. **Hoare four-tuples.** §3.3 introduces `M ⊢ A { stmts } A' ⋈ B` where `B` is the *during-execution* invariant. The four-tuple is necessary to model risk: untrusted code might temporarily expose a capability and withdraw it; the invariant catches that.
10. **The four code-agnostic rules.** `METH-CALL-2`, `FRAME-METHCALL`, `CODE-INVAR-1`, `CODE-INVAR-2`. These let the verifier derive useful conclusions about an unknown callee's risk to the rest of the system.
11. **Soundness theorem.** §3.3 Theorem 3: if the logic derives a four-tuple, the semantic four-tuple holds. Proof in the technical report [18].
12. **Application to mutual-trust proof.** §3.4 walks the Hoare-tuple derivation for `escrowMoney := sellerMoney.sprout` and shows how the code-agnostic rules produce the risk-bound clauses that hold regardless of `sellerMoney`'s trustworthiness.

## For the Endo / Agoric library

This paper is the **canonical formal specification methodology for open-world capability-based programs**. The library now has, for the trust-and-risk reasoning thread:

- **Informal motivation**: Miller-Drexler 1988 (agoric vision); Miller-Morningstar-Frantz 2000 (capability money). Mark Miller has worked these patterns informally for decades.
- **Worked-example specification**: Miller-Van Cutsem-Tulloh 2013 (Dr. SES escrow exchange in 22 lines). The canonical JavaScript-native worked example.
- **Formal specification & verification**: this paper (2015). The escrow's *actual* guarantees are weaker than its designers thought; the spec methodology lets us see this *and* prove what *is* achievable.
- **Production realization**: Agoric Zoe / Hardened JavaScript / `@endo/marshal` + `captp` — the engineering descendents of the *Focal*-Chainmail abstractions.

The library can pair the 2013 paper's *worked example* with the 2015 paper's *formal specification* whenever a design needs both the practical pattern and its formal guarantees.

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [trust-as-hypothetical-and-risk-via-may-access-may-affect](../sections/papers--drossopoulou-reasoning-about-risk-and-trust-2015--trust-as-hypothetical-and-risk-via-may-access-may-affect.md) | capability-security, capability-theory, spec-to-implementation | current |
| [escrow-failure-and-four-case-valid-escrow-spec](../sections/papers--drossopoulou-reasoning-about-risk-and-trust-2015--escrow-failure-and-four-case-valid-escrow-spec.md) | capability-security, capability-theory, patterns, spec-to-implementation | current |
| [hoare-four-tuples-and-code-agnostic-rules](../sections/papers--drossopoulou-reasoning-about-risk-and-trust-2015--hoare-four-tuples-and-code-agnostic-rules.md) | capability-security, capability-theory, spec-to-implementation | current |

The paper's five sections (§1, §2, §3, §4, §5) collapse to three argument-cluster sections. §1+§2.2 → the introduction-of-three-new-constructs cluster; §2.1+§2.3+§2.4+§2.5+§2.6 → the escrow-failure-and-the-four-case-spec cluster; §3 → the Focal+Chainmail+Hoare-four-tuples cluster. §4 (Related Work) and §5 (Conclusions and Further Work) are summarised inline in the §3 section.

## Provenance

- Fetched 2026-05-29 from `papers.agoric.com/assets/pdf/papers/reasoning-about-risk-and-trust-in-an-open-world.pdf`.
- PDF SHA-256 `3f4b20422cda8899380377c6d3c43c279ef2dca07f748febe79bc5a2302c2809`, 34 pages.
- The Agoric mirror's URL slug is `reasoning-about-risk-and-trust-in-an-open-world`; this dispatch was originally planned as a *Stiegler 2006* ingest, but the PDF at the URL is the 2015 Drossopoulou-Noble-Miller-Murray paper.
- The paper's title page contains a typo (`Open Word` instead of `Open World`); preserved here for archival faithfulness.
- Drafted by the liaison via orchestrator-direct-draft. **Eighth Miller-coauthored paper** in the library (with Drossopoulou and Noble and Murray as coauthors); the library's first explicitly-formal Hoare-style verification paper.
