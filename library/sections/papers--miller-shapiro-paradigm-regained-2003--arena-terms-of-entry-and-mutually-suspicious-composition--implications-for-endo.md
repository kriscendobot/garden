---
title: Implications for Endo
source: "Paradigm Regained: Abstraction Mechanisms for Access Control (ASIAN 2003, LNCS 2896)"
source_kind: paper
source_authors: [Mark S. Miller, Jonathan S. Shapiro]
source_year: 2003
source_venue: "ASIAN 2003, Springer LNCS 2896"
source_url: https://web.archive.org/web/2018/http://erights.org/talks/asian03/paradigm-revised.pdf
source_pdf_sha256: 6053a29e323e4ff49a81645c76f66e9a8ac1ee7b85cda8ab39af1149b90d6cb5
source_paper_pages: "19-22 (§5.3 The Arena and Terms of Entry, §5.4 Mutually Suspicious Composition, §6 Conclusion)"
ingested: 2026-05-21
ingested_by: liaison-direct-draft
topics: [capability-theory, capability-security, patterns]
status: current
parent: papers--miller-shapiro-paradigm-regained-2003--arena-terms-of-entry-and-mutually-suspicious-composition
---

The §5.3-§5.4 + §6 cluster is the *most ambitious* part of the paper for Endo, because it justifies several non-obvious architectural choices:

1. **Why Endo nests bundles rather than flatten authority.** Each bundle is an *arena* in §5.3's sense. The daemon hosts an arena; each bundle in that arena can host a sub-arena. The §3.5 *nested TCBs follow the spawning tree* result in *Structure of Authority* is the operational consequence of this section's *arena = virtual-machine-within-virtual-machine* framing.
2. **Why marshal pass-style boundaries are load-bearing.** §5.4's "mutually suspicious composition" depends on each party being able to reason about its own behavior without trusting the other's implementation. Marshal's pass-style discipline (pass-by-copy for data, pass-by-presence for capabilities) IS the operational substrate for this. The §5.4 framing makes explicit *why* this matters: without marshal's discipline, "diverse policies over the same graph" would require each party to inspect the other's code, which destroys the composition property.
3. **Why review disciplines in the garden compose rather than conflict.** The garden's gamut (cleaner → judge → fixer → ferry) has multiple review roles that *each apply strict-over-their-own-concern, conservative-over-everything-else*. The §5.4 framing is the *theoretical justification* for why this works: each role's review is a behavioral analysis over the same PR graph, from its own subjective perspective. The composition correctness emerges *without* each role needing to know what the others are checking.
4. **Why "failures of conservatism" matter for Endo automated review.** §6's diagnosis — verification failures are not robust because they may be failures of conservatism rather than failures of the protection model — is the citation for why Endo audits should be careful with arrangement-only checks. A reviewer (human or AI) that flags every cross-bundle reference as suspect is doing arrangement-only analysis. Useful reviews are *behavioral* — they reason about what the specific abstraction in question enforces.
5. **The normative claim is real.** §6's closing sentence — "when more cooperation may be practiced with less vulnerability, we may find we have a more cooperative world" — is what the Endo / Agoric project is *for*. Library design reviews can cite this as the *why*, not just the *what*.
