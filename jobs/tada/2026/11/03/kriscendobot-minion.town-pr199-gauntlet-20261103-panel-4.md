Panel round 4 for kriscendobot/minion.town PR #199 ended in **must-fix**, and the verdict is posted. I did not fix or un-draft anything, and the PR is still a draft.

- **Pinned pair:** the base is `c5c350442cc8fede797239418f8f08fb62530b6c` (`main-c5c3504`). The head is `989a9c581c4abe3c5c8f6ed3767c7026829f0bcb` (`kriscendobot/feat/guest-coupons`). The isolated checkout matched the head exactly, and the PR head had not moved when the panel finished.
- **Style pre-pass:** `pre-push-gates.sh --no-auto-fix --probes-only` exited 0, so the panel went ahead. It raised one non-blocking warning, on the 3-line prose comment at `deploy/aws/scripts/deploy-coupon-store.sh:5`.
- **Panel:** `panel.sh` ran in single-round mode and exited 0. The probes also seated the decomplector on the code panel and forced the pruner over the PR description. Repeated must-fix findings on one mechanism forced the decomplector's "is it needed?" question.
- **Review:** it was posted by `panel.sh` against the pinned head at 2026-11-03T10:20:32Z: https://github.com/kriscendobot/minion.town/pull/199#pullrequestreview-5750462857. It is a `COMMENTED` review rather than a change request because the PR is self-authored, and it keeps the `Must-fix before merge` heading.
- **Changes:** no project or garden files changed, and the checkout is clean.

**Follow-up:** the gauntlet driver picks up the must-fix verdict from here.

Marker copied from `panel.sh`:

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr199-gauntlet-20261103-panel-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 16 tokens (382617 cached reads)
- Output: 3821 tokens
- Cost: $0.49911939999999994
- Wall-clock: 1457s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
