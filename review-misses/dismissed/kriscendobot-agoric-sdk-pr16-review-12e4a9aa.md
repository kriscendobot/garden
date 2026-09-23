---
kind: review-miss-dismissed
primary_job: kriscendobot-agoric-sdk-pr16-review-12e4a9aa
verdict: not-a-miss
category: new-direction
pr: 16
repo: kriscendobot/agoric-sdk
surface: pr-review-body
author: dckc
comment_url: https://github.com/kriscendobot/agoric-sdk/pull/16#pullrequestreview-4690987586
identity: kriscendobot/agoric-sdk#16:review:4690987586:retro
producing_role: gardener
producing_job: fix-kriscendobot-agoric-sdk-16
missed_by: none-reviewer-to-reviewer-thread-already-dismissed-twice
severity: minor
---

# Dismissal: PR #16 review — dckc's reply in the already-dismissed naming thread

dckc's COMMENTED review 4690987586 on #16 has an **empty review body** and carries
a single inline reply (verbatim untrusted text at `comment_url`), paraphrased: dckc
asks mhofman to clarify *what* the field name should relate to a delegation grant,
and observes that the names follow precedent. The reply lands in the existing thread
on `packages/portfolio-api/src/evm-wallet/eip712-messages.ts:100` — its parent is
mhofman's earlier note that the field names could make it clearer they relate to a
delegation grant. Same file, same line, same concern; reviewed commit
`824fdd627f4a50efa26c159d4bc180f44e9ce88f` is still the PR head. The primary loop
correctly determined it changed no code and is not a change request to the PR author.

## Grounds (not a miss)

This is new direction / reviewer cross-talk, not a review-process miss, for three
converging reasons.

First, it is the **third entry in a thread already dismissed twice**. The underlying
naming-clarity concern — "make the EIP-712 field name clearer that it relates to a
delegation grant" — is precisely what was recorded and dismissed in
`kriscendobot-agoric-sdk-pr16-review-65885306` (mhofman's review 4686554266,
originating the thread) and again in `kriscendobot-agoric-sdk-pr16-review-77ecb195`
(mhofman's "@dckc suggestions?" ping on the same thread). Those dismissals' grounds
still stand: the field is a *pre-existing* EIP-712 wire field shared with the shipped
standalone `Grant` op; renaming only the new op would diverge, and renaming both is
an out-of-scope type-hash change. dckc's reply disturbs none of that analysis, so
re-litigating it as a fresh systemic panel gap would triple-count one concern.

Second, the review is **reviewer-to-reviewer, not feedback on the work**. dckc is
replying to mhofman ("@mhofman"), questioning mhofman's own suggestion and noting the
names follow precedent — i.e. dckc is leaning *against* the change. There is no
defect, no violated convention, no missed edge case for the review process to have
anticipated; a colleague pushing back on another reviewer's bikeshed suggestion, and
citing precedent, is not a check the panel could or should have run.

Third, the concern is **taste on a pre-existing convention**, the exact anti-pattern
the 65885306 and 77ecb195 dismissals already warned against: the seats that own
naming (ergonomist, plus the rename-discipline skill) cannot mechanize "pick the
wording mhofman and dckc will settle on for a pre-existing wire field," and
manufacturing such a probe would be an un-mechanizable taste gate.

The calibration against the other PR-16 records holds steady: the one recorded PR-16
miss (`pr-description-reviewer-attention`, `kriscendobot-agoric-sdk-pr16-a45a180a`,
dckc) was a genuine prevention-without-sensing gap where a standing skill governs
authoring the PR body but no seat reviews it. This review is the opposite — a
subjective naming thread the panel could not mechanize, now on its third airing among
human reviewers who have not converged. Recording a dismissal (not a miss) so this
reply is never re-litigated as evidence of a panel gap; it mints no cluster and needs
no review-cycle check.
