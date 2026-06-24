---
source_kind: paper
source_authors: [Ankur Taly, Úlfar Erlingsson, John C. Mitchell, Mark S. Miller, Jasvir Nagra]
source_title: "Automated Analysis of Security-Critical JavaScript APIs"
source_year: 2011
source_venue: "IEEE Symposium on Security and Privacy 2011"
source_url: https://papers.agoric.com/papers/automated-analysis-of-security-critical-javascript-apis/
source_pdf_url: https://papers.agoric.com/assets/pdf/papers/automated-analysis-of-security-critical-javascript-apis.pdf
source_pdf_sha256: 4457eafac35c129dac26fdf163710a1f89b63b0d9a4ba1bc6378fa318c4bec95
source_pdf_pages: 16
ingested: 2026-05-29
ingested_by: liaison-direct-draft
section_count: 3
status: current
---

The 2011 Taly-Erlingsson-Mitchell-Miller-Nagra paper that **gives the formal foundation for SES_light + provides ENCAP, the static-analysis tool that automatically verifies API confinement**. The paper sits at the intersection of three threads:

- **The SES_light language design** — a *standardized restriction* of ES5-strict that adds *transitively-immutable built-in objects* + *variable-restricted eval* to make JavaScript statically analyzable for capability confinement.
- **The Datalog-based static analysis** — flow-insensitive, context-insensitive points-to with explicit semantic-soundness theorem (Theorem 2: D(t, P) ⟹ Confine(t, P)).
- **The applications** — ADSafe vulnerability (found by ENCAP, reported and fixed by Yahoo!); Sealer-Unsealer (Morris 1973) verified confinement; Mint conservation-of-currency verified.

The library can cite this paper whenever:

- **A design needs to ground SES on a formal foundation.** §3-§4 give the small-step operational semantics with labeled allocation sites; the language design rationale is in §2.
- **A design needs the API+Sandbox pattern as the canonical capability-discipline architecture.** §1 frames the pattern; §6 demonstrates it on three benchmarks.
- **A design needs to argue for *static analysis with soundness over informal inspection*.** §6.A's ADSafe vulnerability is the canonical *informal-inspection-missed-it; static-analysis-found-it* worked example.
- **A design needs to invoke *conservation of currency* as a formally-verified property.** §6.C's Mint verification is the canonical citation; the property is formally true under SES_light.
- **A design needs to refer to *transitively-immutable built-in objects* + *variable-restricted eval* as the SES additions over ES5-strict.** §2.B is the canonical statement.

## The argument arc

1. **API+Sandbox approach.** Trusted code exposes an API that mediates access to security-critical resources; the sandbox restricts untrusted code to *only* access the API.
2. **The reference-monitor-as-API thesis** can be subverted by *programming-language-idiosyncrasies* — full JavaScript's lax semantics let an attacker write a valid-looking API and still break confinement. The §1 store-method attack is the worked example.
3. **ES5S (strict mode) fixes three properties**: Lexical Scoping (no `delete`-on-variable, no `with`, no prototype-on-scope-objects); Safe Closure-Based Encapsulation (no `.caller`/`.arguments`); No Ambient Access to Global Object (no `this`-coercion-to-global; safe built-in functions).
4. **SES_light = ES5S + transitively-immutable built-in objects + variable-restricted eval.** Adds two extra properties to close the remaining confinement gaps.
5. **Formal operational semantics for SES_light** (§3): standard store, no first-class scope objects (enabled by ES5S restrictions), heap + stack + state shapes that mirror real JavaScript closely.
6. **Labeled semantics + Confinement Property** (§4): attach unique allocation-site labels to syntax tree nodes; Theorem 1 (Renaming preserves bisimilarity) lets the analyzer α-rename safely; Definition 4 (Confinement Property): `PtsTo(un, Reach(S_0(t))) ∩ P = ∅`.
7. **Flow-insensitive context-insensitive Datalog points-to analysis** (§5): 14-rule inference system (Figure 6) over Datalog relations encoding programs and heap-stack. ENCAP implements this on top of `bddbddb`.
8. **Soundness Theorem 2**: D(t, P) ⟹ Confine(t, P). Three lemmas (encoding-over-approximates-states; initial-facts-over-approximate-initial-states; abstract-points-to-over-approximates-concrete-points-to) compose to the theorem.
9. **§6.A ADSafe**: ENCAP on Yahoo! ADSafe (1700 LOC) takes 5:27 and finds a previously-undiscovered vulnerability — the `lib` and `go` methods combined can write to the `___` (triple-underscore) property that ADSafe uses to hide DOM objects. Exploitable on Firefox, Chrome, Safari. Reported to Yahoo!, fix adopted immediately. The repaired library is then *verified confined* by ENCAP.
10. **§6.B Sealer-Unsealer**: Morris 1973 [17] encryption-decryption-like mechanism. ENCAP verifies confinement of the sealed `secret` function.
11. **§6.C Mint**: the canonical Object-Capabilities-literature Mint function. ENCAP verifies the *conservation-of-currency* property — the sum of balances of all purses is constant.
12. **§6.D unexpected-finding**: SES_light's stricter semantics changes the behavior of code that incidentally relied on the laxer JavaScript semantics. Forward-compatibility-with-stricter-semantics-can-break-confinement.
13. **§7-§8**: Related work + future-work points to object-sensitive analysis, CFA2, better diagnostics.

## For the Endo / Agoric library

This paper is the **canonical formal-foundation paper for the contemporary Hardened JavaScript stack**. The library now has the SES-foundation thread:

- **1988-2005 E lineage**: Miller-Drexler 1988, Miller-Morningstar-Frantz 2000, Miller-Yee-Shapiro 2003, Miller-Shapiro 2003, Miller-Tulloh-Shapiro 2004, Miller-Tribble-Shapiro 2005 (cycles 65-78).
- **2009 ACL critique**: Tyler Close *ACLs Don't* (cycle 88) — Confused Deputy formalized in access-matrix terminology.
- **2011 SES + static-analysis foundation**: this paper. The formal SES_light spec + ENCAP tool + ADSafe-vulnerability-discovery + Mint-conservation-verification.
- **2013 JavaScript bridge**: Miller-Van Cutsem-Tulloh *Distributed Electronic Rights in JavaScript* (cycle 82) — Dr. SES = SES + Q + NodeKen.
- **2015 formal Hoare-logic**: Drossopoulou-Noble-Miller-Murray (cycle 85) — `obeys` / `MayAccess` / `MayAffect` + four-tuple Hoare logic.
- **Contemporary @endo / Agoric**: the production-realization with lockdown + Compartment + endowments + eventual-send + marshal + captp.

The 2011 paper is the *bridge between informal capability discipline and formal-static-analysis-verification*. The library can pair this paper with the 2015 Drossopoulou paper whenever a design needs both the static-analysis foundation (Taly et al) and the dynamic-trust-and-risk foundation (Drossopoulou et al).

## Sections

| Section | Topics | Status |
|---------|--------|--------|
| [api-confinement-problem-and-ses-light-language-design](../sections/papers--taly-automated-analysis-of-security-critical-javascript-apis-2011--api-confinement-problem-and-ses-light-language-design.md) | capability-security, capability-theory, hardened-javascript | current |
| [static-analysis-procedure-and-soundness-theorem](../sections/papers--taly-automated-analysis-of-security-critical-javascript-apis-2011--static-analysis-procedure-and-soundness-theorem.md) | capability-security, capability-theory, hardened-javascript | current |
| [applications-adsafe-vulnerability-sealer-unsealer-and-mint](../sections/papers--taly-automated-analysis-of-security-critical-javascript-apis-2011--applications-adsafe-vulnerability-sealer-unsealer-and-mint.md) | capability-security, capability-theory, hardened-javascript | current |

The paper's eight top-level sections collapse to three argument-cluster sections. §1 Introduction + §2 From JavaScript to ES5S to SES_light → section 1 (language-design rationale). §3 The Language SES_light + §4 The API Confinement Problem + §5 Analysis Procedure → section 2 (formal foundations + analysis procedure + soundness). §6 Applications + §7 Related Work + §8 Conclusion → section 3 (applications + future work).

## Provenance

- Fetched 2026-05-29 from `papers.agoric.com/assets/pdf/papers/automated-analysis-of-security-critical-javascript-apis.pdf`.
- PDF SHA-256 `4457eafac35c129dac26fdf163710a1f89b63b0d9a4ba1bc6378fa318c4bec95`, 16 pages.
- IEEE S&P 2011 (cited as ref [35] in cycle 85's Drossopoulou paper as a technical-report version; the IEEE S&P publication itself is the canonical citation per the §1 paper's heading).
- **Ninth Miller-coauthored paper** in the library (Mark is third-of-five authors; first author is Ankur Taly, Stanford). The library's **first Stanford-authored paper**, **first IEEE S&P paper**, and **first formal-static-analysis paper** distinct from the formal Hoare-logic paper (cycle 85).
- Drafted by the liaison via orchestrator-direct-draft.
