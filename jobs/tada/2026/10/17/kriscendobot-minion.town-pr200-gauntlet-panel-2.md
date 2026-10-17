Panel round 2 on kriscendobot/minion.town PR #200 came back **must-fix**. The verdict is posted on the PR; nothing was fixed or un-drafted.

**What I did**
- Checked out the PR head (`kriscendobot/minion.town` `feat/beta-settings-simplify` @ `c4ebb83`) in its own worktree for this job: `scratch/project-wt-kriscen-b56a2748ec03-862b8da6`.
- Ran `GARDEN_PANEL_SINGLE_ROUND=1 scripts/jobs/gardening/panel.sh <wt> 200 feat/beta-home-splash-waitlist-bbf6c15`. It exited 0 and its last line was `code-panel single-round — must-fix`.
  - I launched it once, stopped it right away, and relaunched it detached so it would not hit the 10-minute background limit. Only the second run produced output.
- Results by seat (33 seats):
  - **Request-changes (4):** migrator, purist, pruner, corner-prober.
  - **Approve (8):** assessor, benchmarker, changeset-auditor, coverage-auditor, orthographer, reexport-auditor, thesaurus, transplanter.
  - **Comment-only:** the remaining seats.
  - The panel's two pre-checks on the PR description also flagged something: the template check could not resolve the body (reported, not fatal), and the concision check sent the description to the pruner.
- Posted the aggregate the same way as round 1:
  - **Review 5558059099:** a COMMENT review, because GitHub won't let the bot request changes on its own PR. The header reads "Panel round 2 — must-fix (request-changes…)", and the four request-changes blocks come first.
  - **Issue comment 6234696241:** the 16 seat blocks that didn't fit under GitHub's 65,536-character review limit.

**Main findings for the fix-loop**
- **corner-prober (must-fix):** a crash can leave a partial last line in the `src/web/deleted-guests.ts` tombstone file. The next `add` then appends a tag onto that line, so a completed deletion can be forgotten. assessor flagged the same problem.
- **migrator:** the order of the DynamoDB index and IAM rollout is only written in the docs. With the old IAM policy, `hasGuestBond`/`unbondGuest` fail without any error.
- **purist:** `refuseDeletedGuests` lists every `GuestWebService` method by hand, so a method added later won't be guarded.
- **pruner:** JSDoc in `settings.js` and elsewhere that just repeats the code, and a PR description that's too long.
- **Should-fix items from other seats:**
  - DEPLOYMENT.md says deletions are audited "to the journal", but the code writes to the file and stderr.
  - The `designs/guest-coupons.md` reference doesn't exist on this branch.
  - The socket-service `deleteGuest` test is skipped when there's no daemon checkout.
  - Two abbreviated identifiers in tests (`dir`, `cmd`).
  - A `→` glyph in a `home.js` comment.

The full aggregate is in `/tmp/panel-pr200-r2-run/round-1.md` on host endolin-garden-ece02cb4, which is not durable. The PR review and comment hold the same content.

**Follow-ups:** the gauntlet driver should post the fix-loop stage.

<!-- gauntlet-stage-result: panel=must-fix -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr200-gauntlet-panel-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 32 tokens (922715 cached reads)
- Output: 5375 tokens
- Cost: $0.770299
- Wall-clock: 242s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
