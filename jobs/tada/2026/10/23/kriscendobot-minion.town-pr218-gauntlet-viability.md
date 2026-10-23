PR #218 can go through the gauntlet. It is open, unmerged and still a draft, and nothing newer has replaced it. I spent no clean, panel, fix, CI-wait or un-draft budget.

Deciding question: Does current `main` still lack a per-guest bond ledger and backfill, with nothing landed or open replacing #218 as the storage step that the account-deletion work depends on?

Evidence:
- **PR state:** The PR is titled "feat(accounts): add the guest bond ledger and backfill". Head `split/pr216-ledger` is at `cb05552c`.
- **Base:** The base is now `main-68c3960`, a pinned snapshot. The compare `68c3960...main` shows 0 commits ahead, so the snapshot is current `main`. The last gauntlet stopped because the PR then targeted a floating base, and that is now fixed.
- **Not superseded:**
  - #216, which this PR was split out of, is closed and was never merged.
  - Its other two pieces, #219 (settings and sign-out) and #220 (account deletion), are open. #220 says it "stacks the storage migration in #218" and refuses deploy until the ledger provisioning marker exists.
  - A PR search for "ledger" finds no other implementation.
- **Need still holds:** `src/auth/stores/dynamodb.ts` on `main` has no ledger or `TransactWrite` code (0 matches), so `main` still has no ledger. Account deletion in #220 can't land safely without it.
- **Discussion:** The only comment is the earlier halted-gauntlet notice about the floating base, now fixed. There are no reviews.

There are no follow-ups. The gauntlet can start with the clean stage.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr218-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (157246 cached reads)
- Output: 1457 tokens
- Cost: $0.3621572
- Wall-clock: 38s

<!-- garden-usage-end -->
