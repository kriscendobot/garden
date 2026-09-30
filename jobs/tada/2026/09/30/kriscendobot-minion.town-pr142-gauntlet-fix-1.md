CI for PR #142 never ran, so this fix round isn't green: GitHub Actions refused to start the jobs because the account's billing is blocked.

- **Fixes were already on the PR:** an earlier claimant of this job had pushed two follow-up commits to `design/clip-lifecycle-capabilities` after the panel reviewed `0e2ccb8`: `a0df506` and `debd2aa`. I made no further changes.
- **Every must-fix item is covered.** I checked this in `designs/clip-lifecycle-capabilities.md`:
  - **critic 1 (persistence):** new § 7.1 says controllers, caretakers and revokers are stored as daemon formulas. Revocation and unpublish are written as permanent markers in the registry's store, so they survive a restart.
  - **skeptic 1 (identity reads):** § 4 now lists every remaining read of the account field, and each one is for billing, not for deciding who may act. Upgrade bytes are charged to the clip's own account, and the section says what happens when that account is over quota.
  - **skeptic 2 (orphaned clips):** § 5 now says what happens when a guest drops its only name for a clip's controller, and gives two ways to recover.
  - **copyeditor / pedant:** the Unicode ellipses are gone.
  - The two commits also cover most of the should-fix items: a stable registration id, one stored copy of the account, consistent method names, an MCP `adopt` path, migration edge cases, a terms block and more tests.
- **CI:** `ci-wait-merge.sh kriscendobot/minion.town 142 --no-merge` against head `debd2aa7` exited rc 5. All three jobs (`test`, `Claude harness (amd64)`, `Claude harness (arm64)`) were refused because of the account's payment or spending limit. The script says it has already alerted the maintainer. The PR only changes a design document, so no commit can fix this.
- **Marker:** the job spec only lists rc 0, 3 and 4. I used the `fix=ci-billing-blocked` marker, which the current driver (`scripts/jobs/gauntlet.sh`) accepts for rc 5. It parks the gauntlet so it can be resumed, rather than marking it failed.

**Follow-up for the maintainer:** fix Billing & plans on the kriscendobot account, rerun the failed runs on the PR head, then resume the gauntlet. That will re-post panel-2.

<!-- gauntlet-stage-result: fix=ci-billing-blocked -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr142-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 3 on 2 host(s)
- Input: 74 tokens (2206786 cached reads)
- Output: 22128 tokens
- Cost: $2.3298772000000003
- Wall-clock: 418s
- Model(s): claude-opus-5-5 ×3

<!-- garden-usage-end -->
