**Fix round 4 for kriscendobot/minion.town PR #216 is done: all three must-fix items are fixed and pushed, and CI is green at the new head `343455c5`.**

The job had no pre-pass block, so I worked from the latest panel review (10:14:27Z, review 5612608338). It had three must-fix items:

1. **Breaker: a grammar mismatch deleted a live guest's bond.** The recovery route (`GET /account/guest-recovery`) used to drop a sign-in's bond on any credential refusal. That included a live guest the root names outside the new `web-`/`coupon-` grammar, such as an MCP `g-…-agent` guest.
   - Now it drops the bond only when the daemon's deletion record (the tombstone) proves the guest was deleted; any other refusal returns 404 and keeps the bond.
   - `designs/closed-beta-waitlist.md` no longer documents opening an MCP guest in the shell. The new path is to accept an invitation, then add a recovery sign-in.
   - I added veto item 5 to that design rather than widening the grammar to `g-` names, because widening it would let the settings menu's Delete account remove MCP guests.
   - New test in `test/web/guest-web-socket-faults.test.ts`. It fails without the fix and passes with it.
   - Commit `c7b31ead`.
2. **Decomplector: `hasGuestBond` had no caller except its own startup probe.** I removed it from the bond-admin interface, both stores and `http.ts`, together with the production startup probe behind the #211 and #214 reverts.
3. **Decomplector: the ledger and the `guest-formula-fingerprint` index recorded the same fact.**
   - `closeGuestBonds` now reads only the ledger.
   - `deploy-accounts-store.sh` no longer creates or waits for the index, and the app role loses its `Query` grant.
   - In their place, the script runs an admin backfill that adds every bonded account row to its guest's ledger. It is safe to re-run and needs no recovery key.
   - `DEPLOYMENT.md` now says to run the script before the app deploy and once after it, because the old app writes no ledger entries. It also updates the rollback and IAM text.
   - New `test/deploy-accounts-store-backfill.test.ts` exercises the backfill against a fake `aws`. The IAM test now also checks that a `Query` on the index is refused.
   - Commit `343455c5`.

**Push and checks:** both commits went to `reland/pr200-settings-2` through `safe-push-pr-head.sh`, a fast-forward from `8bd49c9d`, and I posted a summary comment on the PR. Typecheck is clean. The full local test suite passed except one test, `test/git-remote/capability.test.ts` › "propagates a git failure rather than reporting the ref absent". That file is outside this PR and fails because of this host's git setup; CI passed it.

**CI:** my first `ci-wait-merge` run was in the background and was stopped at the 10-minute limit. I re-ran it in the foreground and it returned rc 0: 2 runs, 0 failed.

**Follow-ups:**
- The round-4 should-fix items were not addressed, among them the deploy gate's check covering only `web-` names, the race between a concurrent invitation accept and deletion, and the decomplector's question for the maintainer about eager bond removal.
- Whether to allow `g-` names in the browser shell is now a veto item for the maintainer.
- The old fingerprint index may still exist in production from earlier deploys. Nothing reads it now and the script doesn't drop it.
- The panel-5 run comes next from the driver.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr216-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 104 tokens (5956240 cached reads)
- Output: 31861 tokens
- Cost: $2.999044
- Wall-clock: 1839s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
