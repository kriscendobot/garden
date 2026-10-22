I applied the round-7 must-fix items to kriscendobot/minion.town PR #216 and pushed three commits; the head moved from `33a82ecc` to `4c25e57e`, and CI is green on the new head (2 of 2 runs passed, `ci-wait-merge` rc 0).

The latest panel review had cut each item short, so I worked from the seats' full text in the panel run directory (`garden-panel-…-6891b0e07b66-…-216`, which reviewed `33a82ecc`).

**Commits:**
- **`0c73d072` (deploy gate):**
  - The deploy gate in `deploy-app.sh` and the audit command in `DEPLOYMENT.md` now catch `coupon-` guests as well as `web-` guests, matching the app's `HANDLE` grammar in `src/endo/root-host-socket.ts`. Before this, a coupon guest that lost its agent name would pass both checks and lose access silently (archivist #1, decomplector #1).
  - Step 1 of the "Rolling out the settings menu" runbook now describes both kinds of handle.
  - New tests: a coupon guest passes or is refused by the gate as expected, and a check fails if the gate's pattern drifts from `HANDLE`.
  - The "Account deletion audit" paragraph in `DEPLOYMENT.md` is rewritten and shorter (archivist #2, pruner #3, assessor #1). It now says journald rather than "journal", and it states that with `GUEST_RECOVERY_KEY` unset, each process tags guests with a random key, so tags don't match across restarts. It also says `bondsRemoved` counts per attempt.
- **`931778e4` (bond count):** when the final `deleted` audit line can't be written, the route now writes a `failed` line carrying that attempt's bond count. Before, the retry recorded 0 and the real count was lost (assessor #1). The test now checks this.
- **`4c25e57e` (docs and comments):**
  - The forget-this-browser JSDoc now names `designs/invitation-only-guest-onboarding.md` § 4, and the sentence that broke across lines is rewritten (archivist #3).
  - `closed-beta-waitlist.md` § Settings menu now names recovery's bond removal as a deliberate fallback for a bond deletion missed (decomplector #2).
  - A comment in `bondGuest` explains that `CancellationReasons[0]` refers to the ledger update because reasons follow `TransactItems` order (assessor #2).

**Tests:** the typecheck passes. Locally, the full suite passed except one test: `test/git-remote/capability.test.ts`, "propagates a git failure rather than reporting the ref absent". That code is untouched by these commits and probably fails because of this host's git setup; CI passed on this head.

**Not done:** none of the pruner's cuts (test comments that restate code, the superseded settings-menu bullet in `DEPLOYMENT.md`, the long PR body) were applied. They aren't in the review's aggregated must-fix list, and several of those test comments explain things the code alone doesn't (for example, why exactly two cancellations are expected).

I posted a summary comment on the PR: https://github.com/kriscendobot/minion.town/pull/216#issuecomment-6346810953. The panel was not re-run; the driver posts panel round 8.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr216-gauntlet-fix-7.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 106 tokens (4151991 cached reads)
- Output: 19917 tokens
- Cost: $1.9768582000000001
- Wall-clock: 1635s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
