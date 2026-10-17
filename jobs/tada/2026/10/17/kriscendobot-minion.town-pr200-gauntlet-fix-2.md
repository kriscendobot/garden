No new commits from me: the PR head already contains fixes for the round-2 panel's must-fix item, and CI on it is green.

- **Must-fix item:** the corner-prober's torn-tombstone finding. A deletion appended after a crash-torn line in `src/web/deleted-guests.ts` would glue its tag onto the fragment, so the guest could reappear after the next restart. This was reviewed at head `c4ebb83`.
- **Already fixed:** commit `c98a1e7` ends a torn last line with a newline before any append. It also adds a test in `test/web/deletion-state-files.test.ts`. The assessor's matching should-fix is covered by the same commit.
- **Also on the head:** `55fef95` attempts daemon cleanup for every agent name, which is the assessor's other should-fix. `908b48a` trims comments that restate their code, and `8f0de31` switches the www text to ASCII arrows and ellipses.
- **CI:** the three checks on PR #200 are green (`ci-wait-merge.sh` returned rc 0).
- **Not done (should-fix and comment-only items from round 2):**
  - a startup probe for the DynamoDB index
  - the `refuseDeletedGuests` wrapper-table refactor
  - interface naming unification
  - the extra corner tests: concurrent DELETE, non-string `confirm`, allowance table
  - the PR-body trim

I left them because the panel did not mark them must-fix.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr200-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 4 on 1 host(s)
- Input: 136 tokens (4488023 cached reads)
- Output: 23448 tokens
- Cost: $2.3466454
- Wall-clock: 12335s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
