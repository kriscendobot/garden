---
kind: review-miss-dismissed
primary_job: kriscendobot-agoric-sdk-pr16-review-9b74ccd4
verdict: not-a-miss
category: new-direction
pr: 16
repo: kriscendobot/agoric-sdk
surface: pr-review-body
author: dckc
comment_url: https://github.com/kriscendobot/agoric-sdk/pull/16#pullrequestreview-4690953667
identity: kriscendobot/agoric-sdk#16:review:4690953667:retro
producing_role: gardener
producing_job: fix-kriscendobot-agoric-sdk-16
missed_by: none-confirming-pointer-question-on-already-panel-caught-and-tested-behavior
severity: minor
---

# Dismissal: PR #16 review — "which test proves the fail-closed behavior is deliberate?"

dckc's COMMENTED review 4690953667 on #16 (empty review body; verbatim untrusted
text at `comment_url`) carries a single inline reply on the `asPromise` /
fail-closed thread at `packages/portfolio-contract/src/portfolio.contract.ts:868`.
Paraphrased: replying to the bot's assertion that failing the whole open when the
grantee does not exist is expected and deliberate, dckc invokes his principle that
a behavior is only deliberate if a test says so, and asks which test demonstrates
it. The reply's parent chain roots in mhofman's original must-fix on this thread
(comment 3572348718, "is that expected?"). Reviewed commit is `f1f1d07fef`, still
the PR head at review time.

## Grounds (not a miss)

This is a reviewer confirming/pointer question on behavior the review process
demonstrably anticipated and pinned with a test — new direction / diligence, not a
review-cycle gap — for three converging reasons.

First, **the test dckc asks for already exists because the panel demanded it.**
This thread is the origin of the gauntlet's must-fix #2 (recorded in the
`65885306` dismissal): "untested asymmetric failure mode — unregistered
`accountHolder` aborts the whole open; add a combined-flow failure test." The fixer
landed exactly that test at commit `9fe71d7277` ("cover the open+grant
grant-failure abort path": openPortfolioWithGrant with an unregistered
accountHolder aborts and pulls no deposit), and a focused re-panel passed the
delta. So the deliberate fail-closed behavior is pinned by a named test; dckc's
"which test?" is answered by pointing at it. Asking a reviewer to cite the pinning
test is diligence on already-tested code, not evidence a check escaped review.

Second, this is a **continuation of an already-dismissed thread**. The underlying
fail-closed concern was recorded and dismissed in `65885306` (mhofman's originating
review) as a confirming question the panel had already caught twice. dckc's reply
disturbs none of that analysis — it presses the same point one level deeper
(prove-it-with-a-test), which the existing test satisfies. Re-litigating it as a
fresh systemic panel gap would double-count one concern the panel already handled.

Third, **the genuine defect this thread surfaced is already recorded, and it is not
this review.** dckc's *subsequent* review 4691341878 complained that the bot's
answer to this very question was too wordy (be concise; cite the test and stop) —
that concision failure is the recorded miss `kriscendobot-agoric-sdk-pr16-review-416988d1`
in the `pr-description-reviewer-attention` cluster. Review 4690953667 is the
*question that prompted* that verbose answer, not itself a review miss: the
substance (does a test prove deliberateness?) was already reviewed and tested; only
the bot's over-long reply was faulted, and that is captured elsewhere.

The calibration against the other PR-16 records holds steady: the one genuine PR-16
miss family (`pr-description-reviewer-attention`) is a prevention-without-sensing
gap over garden-authored maintainer-facing prose; the fail-closed/naming reviews on
this PR (`65885306`, `77ecb195`, `12e4a9aa`) are all dismissals where the panel
fired and caught the substance. This review lands squarely with the latter group.
Recording a dismissal (not a miss) so this confirming/pointer question is never
re-litigated as evidence of a panel gap; it mints no cluster and needs no
review-cycle check.
