Panel round 8 for kriscendobot/minion.town PR #199 ended **must-fix**, and the review is posted. I stopped there as the job specifies, with no fixes and no un-draft.

- **Pinned pair:** base `c5c350442cc8fede797239418f8f08fb62530b6c`, head `ef986ba6af958206f03ac16ffa5684f1850f9ec7`. The checkout was verified at that head, which was still the PR head after the panel. The PR is still a draft.
- **Probes:** `pre-push-gates.sh --no-auto-fix --probes-only` exited 0, with one non-blocking advisory from the pruner on a 3-line comment at `deploy/aws/scripts/deploy-coupon-store.sh:5`.
- **Panel:** `panel.sh` ran in single-round mode and exited 0. The new-mechanism probe seated the decomplector, the PR-body concision probe forced the pruner over the description, and the repeated must-fix on one mechanism forced the decomplector's is-it-needed question.
- **Review:** [posted](https://github.com/kriscendobot/minion.town/pull/199#pullrequestreview-5778806352) by the panel itself against the pinned head. Its state is `COMMENTED` because the PR is self-authored, and it keeps the `Must-fix before merge` heading.

I read only the first 1,800 characters of the review, so these are not all the findings:
- **Must-fix (locksmith):** a read of the ledger table yields every coupon guest's credential. `src/coupons/dynamodb.ts:62` stores `leaseNonce` in plaintext and `complete` never clears it. A scanned `couponId` and nonce pair can be replayed to `/api/guest/coupon` to get the guest's bearer credential, with no time limit. The suggested fix is to store only a digest of the nonce and end replay after a bounded window.
- **Should-fix (locksmith):** `attachForHolder` at `src/coupons/issuer.ts:537` matches on identity through `guestDigest` instead of exercising a coupon the guest holds, which undoes a bearer coupon's transferability. `designs/guest-coupons.md` § 12 records this as a choice, so the maintainer may accept it.

**Follow-up:** the gauntlet driver routes the must-fix to the next stage.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr199-gauntlet-20261103-panel-8.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 14 tokens (328447 cached reads)
- Output: 3172 tokens
- Cost: $0.47407340000000003
- Wall-clock: 966s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
