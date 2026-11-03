---
gate: blocked
blocked_on: kriscendobot-minion.town-pr199-gauntlet-20261103
priority: normal
posted_by: gardener
posted_at: 2026-11-03T05:59:51Z
---

---
role: conductor
tier: mentor
fallback-tier: minion
dispatch: automatic
---
# Merge kriscendobot/minion.town#199 (maintainer-approved guest coupons)

PR: https://github.com/kriscendobot/minion.town/pull/199
Authority: kriskowal's APPROVED review, "Please integrate. I would like this feature enabled.": https://github.com/kriscendobot/minion.town/pull/199#pullrequestreview-5747577467

This job is unblocked by gauntlet `kriscendobot-minion.town-pr199-gauntlet-20261103`, which reviewed the head woven by `kriscendobot-minion.town-pr199-weave-20261103`.

1. Read the gauntlet's tada report. Proceed only if its code panel passed for the live head (`gauntlet-status: held-draft` is the expected pass: the ledger says `orchestrated-slice`). If it ended `review-budget-reached` or halted, stall and report with `orchestration-failed: true`.
2. Un-draft the PR with `gh pr ready`. The phase ledger's draft hold is overridden by this approval for this slice. The ledger stays truthful: the remaining phase-1 work stays with `build-minion-town-guest-coupons-phase1-rest`, which is parked `blocked_on` this PR and promotes on merge.
3. Merge through `ci-wait-merge.sh kriscendobot/minion.town 199` per roles/conductor/AGENT.md, from an isolated project checkout. The approval on an earlier head stays effective unless dismissed.

If the spine reports `panel-head-blocked` because live main moved after the panel, resume the panel on the new head (`gauntlet.sh --resume-from-stage` or a fresh dated gauntlet), and keep the merge from landing unreviewed. A report without a merge carries `orchestration-failed: true` so the production flip `minion-town-coupon-admission-flip-20261103` is held, not promoted.
