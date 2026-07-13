---
kind: review-miss-dismissed
primary_job: kriscendobot-agoric-sdk-pr16-review-77ecb195
verdict: not-a-miss
category: new-direction
pr: 16
repo: kriscendobot/agoric-sdk
surface: pr-review-body
author: mhofman
comment_url: https://github.com/kriscendobot/agoric-sdk/pull/16#pullrequestreview-4686737237
identity: kriscendobot/agoric-sdk#16:review:4686737237:retro
producing_role: gardener
producing_job: fix-kriscendobot-agoric-sdk-16
missed_by: none-continuation-of-already-dismissed-naming-thread
severity: minor
---

# Dismissal: PR #16 review — "@dckc suggestions?" ping on an already-dismissed naming thread

mhofman's COMMENTED review 4686737237 on #16 (empty review body; verbatim
untrusted text at `comment_url`) carries a single inline reply, paraphrased:
he tags a third party for naming suggestions on the EIP-712 message field. The
reply lands in the existing thread on
`packages/portfolio-api/src/evm-wallet/eip712-messages.ts:100` whose parent
(mhofman's earlier review 4686554266) had noted the field names could make it
clearer they relate to a delegation grant. Same commit
(`f1f1d07fef2a27a2ca6064a4f9a5a68406b4baa8`), same thread, same concern — this
review only asks a third party for wording ideas; it introduces no new
substantive feedback.

## Grounds (not a miss)

This is not a review miss for two independent reasons.

First, it is a **continuation of an already-dismissed thread**. The underlying
naming-clarity concern — "make the field name clearer that it relates to a
delegation grant" — is the very point recorded and dismissed in
`kriscendobot-agoric-sdk-pr16-review-65885306` (mhofman's prior review
4686554266). That dismissal's grounds already stand: the field is a
*pre-existing* EIP-712 wire field shared with the shipped standalone `Grant` op;
renaming only the new op would diverge, and renaming both is an out-of-scope
type-hash change. Nothing in 4686737237 disturbs that analysis — it is the same
taste refinement on the same convention, so re-litigating it as a fresh systemic
panel gap would double-count one concern.

Second, the review's actual content is a **procedural ping, not feedback on the
work**. "@dckc suggestions?" is mhofman deferring to a third party for wording
ideas on a subjective naming call. There is no defect, no violated convention, no
missed edge case for the review process to have anticipated — a maintainer
soliciting a bikeshed opinion from a colleague is not a check the panel could or
should have run. The seats that own naming (ergonomist, plus the rename-discipline
skill) cannot mechanize "pick the wording mhofman and dckc will prefer for a
pre-existing wire field," and manufacturing such a probe would be an
un-mechanizable taste gate — exactly the anti-pattern the 65885306 dismissal
already warned against.

The contrast with the two prior PR-16 records holds the calibration steady: the
`pr-description-reviewer-attention` miss (`kriscendobot-agoric-sdk-pr16-a45a180a`,
dckc) was a genuine prevention-without-sensing gap; the 65885306 error-handling
review was caught by the panel twice and dismissed as a confirming question. This
third review is thinner still — a naming taste nit's follow-up ping — and lands
squarely as new direction. Recording a dismissal (not a miss) so this ping is
never re-litigated as evidence of a panel gap; it mints no cluster.
