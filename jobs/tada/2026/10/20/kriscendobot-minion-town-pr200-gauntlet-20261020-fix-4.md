## Fix round 4 for kriscendobot/minion.town#200: done, CI green

I applied the must-fix items from panel review 5589643997 and pushed them as three follow-up commits. The new head is `f74f14bb`, pushed with `safe-push-pr-head.sh`. `ci-wait-merge.sh` returned rc 0: both workflows passed.

**Commits:**
- **`9cd642a0` fix(landing): resuming an unfinished deletion** (saboteur 1, breaker 1). If a deletion stopped partway, every guest route answers 409 `deletion-pending`, so the settings menu that held the retry could never load. The landing now recognizes that answer and shows a *Finish deleting* card. Its one button sends `DELETE /api/guest` again.
- **`d4d5e1ef` fix(guest-web): recovery and the audit log.**
  - `GET /account/guest-recovery` now answers the same 409 and includes the guest's identifier. A second browser can then pick up the guest and finish deleting it.
  - When bond cleanup fails, the audit log now records the error's name (saboteur 2).
  - Tests cover the landing mode, recognizing the 409, recovery → finish deleting → 204 with bonds removed, and the cleanup error.
- **`f74f14bb` docs: deletion routes and audit file; retired surfaces removed** (integrator 2, 3, 5, 6; surfacer 1–3; pruner 1–4).
  - `DEPLOYMENT.md` has a new *Account deletion audit* paragraph covering `account-deletions.jsonl` and `ACCOUNT_DELETION_AUDIT_FILE`.
  - The probe-guest paragraph no longer says there is no delete route.
  - The Caddy route statement and comment now name the settings read and the `DELETE` route.
  - "Landing role panel" is gone from four code comments, the status-table rows, and the Phase C list.
  - "Recovery provider" is renamed to "recovery sign-in" everywhere.
  - The Delete account bullet in the design is shorter. The "superseded in part" and "no longer" history sentences are cut, the Log out rule is stated in one place, and the duplicate doc comments are removed.

**Other changes on the PR:**
- I rewrote the PR body (integrator 1). It now says the PR follows #198 instead of being stacked on it, and lists the new routes, the 409 code, the audit file, and the production startup refusal.
- I posted a summary comment for this round: https://github.com/kriscendobot/minion.town/pull/200#issuecomment-6298924021

**Not done:**
- **Integrator 4 (regroup the 25 commits):** I declined it. This stage only adds follow-up commits, and rewriting history would detach the review comments from their lines. A retcon at ferry time is the right place for it.
- **Surfacer 4:** nothing to do. `test/settings-menu.test.ts` already checks that the client and server confirmation phrases match.

**Local checks:** typecheck is clean. The full test suite had one failure, in `test/git-remote/capability.test.ts`, which expects git to exit 128. It touches nothing I changed and passed in CI, so it looks specific to this host.

**Follow-up:** the CI runners are backed up. The test workflow sat in the queue for about 40 minutes before it ran, and other PRs were queued too.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion-town-pr200-gauntlet-20261020-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 114 tokens (5547577 cached reads)
- Output: 26839 tokens
- Cost: $2.574919400000001
- Wall-clock: 3917s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
