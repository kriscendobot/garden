Viability check for kriscendobot/minion.town#218, "feat(accounts): add the guest bond ledger and backfill". Nothing was spent on clean, panel, fix, CI-wait or un-draft work.

**Current state:** The PR is open and unmerged. It is not a draft and GitHub reports it as mergeable. The head is `split/pr216-ledger` @ `5e2b6232` and the base is `main` @ `27f70ed6`.

**Deciding question:** Does `main` still lack a guest bond ledger or any other replacement for the failed guest-bond index, with #219 and #220 still waiting on this ledger?

**Answer:** Yes.

**Evidence:**
- **Why it exists:** The settings work went into `main` as #200 and was reverted (#211) because a guest-formula-fingerprint index was missing. The re-land, #213, was reverted too (#214) because the guest bond index probe still failed. #216 then tried again with a backfilled ledger and was closed, split into #218 (this ledger and backfill), #219 (settings and protected sign-out) and #220 (account deletion).
- **Not superseded:**
  - #219 and #220 are still open, and #220's body says it stacks on the storage migration in #218.
  - On `main`, `src/auth/stores/dynamodb.ts` has no `ledger` or `row_kind`, so the ledger has not landed by another route.
  - The only commits on `main` since the #214 revert are the #221 merge on 2026-10-24. #221 is a design-only proposal for recursively attenuated DynamoDB capabilities, prompted by the guest-coupon review. It adds no implementation and does not change the bond lookup.
- **Activity:** The panel and fix-loop are still running on the PR. The two most recent reviews (assessor, 2026-10-24 16:47Z and 18:40Z) were comment-only with no must-fix findings. There is no maintainer objection on the PR.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion-town-pr218-screen-5e2b6232-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 10 tokens (242720 cached reads)
- Output: 1969 tokens
- Cost: $0.501244
- Wall-clock: 30s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
