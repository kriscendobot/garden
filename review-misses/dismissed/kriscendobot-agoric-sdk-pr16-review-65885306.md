---
kind: review-miss-dismissed
primary_job: kriscendobot-agoric-sdk-pr16-review-65885306
verdict: not-a-miss
category: new-direction
pr: 16
repo: kriscendobot/agoric-sdk
surface: pr-review-body
author: mhofman
comment_url: https://github.com/kriscendobot/agoric-sdk/pull/16#pullrequestreview-4686554266
identity: kriscendobot/agoric-sdk#16:review:4686554266:retro
producing_role: gardener
producing_job: fix-kriscendobot-agoric-sdk-16
---

# Dismissal: PR #16 review — error-handling concern the panel already caught

mhofman's COMMENTED review 4686554266 on #16 (verbatim untrusted text at
`comment_url`), paraphrased: the change follows the expected
`OpenPortfolioWithAutoFeatures` pattern but he is concerned about error handling.
Two inline threads carry the substance — (1) the EIP-712 message field name should
make clearer it relates to a delegation grant; (2) there is no note on why
`asPromise(grant)` is safe, the grant is prompt only because the grantee is assumed
to already have a smart wallet, and the whole open fails if the grantee does not
exist — is that expected? The primary loop resolved it docs-only (`824fdd627f`):
expanded the doc comments to state the fail-closed rationale and cite the existing
test, kept the pre-existing wire field name, and offered a rename-both follow-up.

## Grounds (not a miss)

This is new direction / refinement of degree, not a review miss, because the
review process **demonstrably anticipated the substantive concern before mhofman
reviewed.** The gauntlet ran an 8-seat panel (disposition: changes requested) whose
two must-fix items are mhofman's two concerns almost verbatim: must-fix #1
"inline comment overstates atomicity — a rejected grant orphans a registered shell
portfolio; only funding is truly gated" is his inline "missing a note on why
`asPromise` is safe"; must-fix #2 "untested asymmetric failure mode — unregistered
`accountHolder` aborts the whole open; add a combined-flow failure test" is his
"portfolio will completely fail to go through the open step if the grantee doesn't
exist, is that expected?". The fixer round then addressed both — reworded the
atomicity comment (`94ec9df7fe`, refined `f1f1d07fef`) and added the exact test
`open+grant with an unregistered accountHolder aborts and pulls no deposit`
(`9fe71d7277`) — and a focused 8-seat re-panel (prover, spec-keeper, purist,
breaker, saboteur, corner-prober, surfacer, skeptic) passed the delta. mhofman's
review commit_id is `f1f1d07fef2a27a2ca6064a4f9a5a68406b4baa8`, i.e. he reviewed
*after* those fixes landed.

So what reached the maintainer was not a defect the review missed. Read against
that history, his review is three things, none a miss: (a) a **confirming
question** — "is that expected?" — about behavior that was already deliberately
implemented fail-closed and pinned by a test; the maintainer confirming intended
behavior is not a missed check; (b) a request to **sharpen the inline doc further**
than the fixer's already-present atomicity rewording — a subjective matter of
documentation depth on correct, tested code, not an absent review lens; (c) a
**naming-clarity taste nit** on `accountHolder`, a *pre-existing* wire field shared
with the shipped standalone `Grant` op, where renaming only the new op would
diverge and renaming both is an out-of-scope EIP-712 type-hash change — a taste
refinement on an existing convention, not a violated naming rule the panel holds.

The contrast with the *other* recorded PR-16 miss is instructive: the
`pr-description-reviewer-attention` miss (`kriscendobot-agoric-sdk-pr16-a45a180a`,
dckc) was a genuine prevention-without-sensing gap — a standing skill governs
authoring the PR body but no seat reviews the produced body. Here the opposite is
true: the seats that own this category (breaker, saboteur, corner-prober, prover)
**fired and caught it**, twice. There is no review-cycle check to add, because the
existing checks worked; manufacturing a probe for "the asPromise comment must be
maximally explanatory" would be an un-mechanizable taste gate. Recording a
dismissal (not a miss) so this confirming-question/doc-depth review is never
re-litigated as evidence of a systemic panel gap.
