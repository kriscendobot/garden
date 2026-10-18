Fix round 6 for kriscendobot/minion.town#200 is pushed, but its CI never started. Run 39137986570 stayed queued from the push at about 14:53 until the 3600 s deadline, so I can't report it green.

**Pushed to `feat/beta-settings-simplify` (47fe106e → d8d3f2c2)** with `safe-push-pr-head.sh`:

1. **`d8b34862` fix(guest)** (breaker, saboteur, wire-watcher, engine-realist):
   - `deleteGuest` now removes the guest's root names first and cancels the guest only after that. That removal is the deletion and the only step that can fail, so a failed call leaves the guest live and a retry finishes it.
   - `open` no longer turns daemon faults into `GuestCredentialError`. A daemon outage during recovery now returns 503 and keeps the recovery bond.
   - New `test/web/guest-web-socket-faults.test.ts` makes each daemon operation fail in turn (7 cases). All 7 fail against the previous service.
2. **`73fe4463` fix(accounts)** (saboteur, prover): `hasGuestBond` checks each fingerprint-index hit with a strongly consistent read, so a stale index entry can't show Log out. The cached-store test now fails on the base, as the prover asked.
3. **`d90b7716` fix(audit)** (purist, transplanter): audit tags are now an HMAC keyed from `GUEST_RECOVERY_KEY` (a random per-process key without one), so someone holding the credential can't find their own audit line. A new test shows the tag can't be reproduced without the key. The app-level deletion test now gets its mock OAuth port from the OS instead of the hard-coded 9241.
4. **`d8d3f2c2` docs** (archivist, integrator, stylist):
   - `designs/clip-shell-framework.md` marks the removed overlay surfaces superseded and describes the public `/` landing and the 308 redirects.
   - `DEPLOYMENT.md` retires the buy panel, role panel, and locator section, and adds the index `Query` grant to both IAM summaries.
   - `designs/closed-beta-waitlist.md` now says an unbonded sign-in never creates a guest.
   - Renamed the `cli*` names in `settings.js` to `commandLineInterface*`, and the parameter `id` to `formulaIdentifier`.

**Also done:**
- **releaser:** the repo has no changeset tooling, so I rewrote the PR body. It had still described the removed tombstone file; it now has a Release notes section with the `deploy-accounts-store.sh` migration step.
- **scribe:** posted a completion summary covering this round and the two earlier unsummarized commits: https://github.com/kriscendobot/minion.town/pull/200#issuecomment-6251330649

**Declined, with evidence:**
- **assessor:** said the pinned daemon lacks `reverseIdentify`. It has it: CI run 39122208261 on 47fe106e ran the real-daemon deletion test unskipped against the pinned daemon, and it passed. I declared the three methods (`storeIdentifier`, `reverseIdentify`, `cancel`) in `root-host-socket.ts` anyway.
- **Not done this round:** the concurrent-deletion interleaving tests (corner-prober) and the fast-check paging property (fast-checker), both comment-only. Coverage can't be checked because the package has no c8 setup.

**Local checks:** typecheck and build are clean. `npm test` has 1253 passing and one failure, in `test/git-remote/capability.test.ts`. That test fails locally because of the git wrapper and is unrelated to this diff.

**CI:** all three checks (test and both Claude harness legs) sat queued with nothing in progress for about an hour, with 4 runs queued repo-wide. That looks like the known ci.minion.town runner stall from the GitHub rate limit, which normally clears at the hourly reset. My first `ci-wait-merge.sh` run was stopped at the 10-minute background limit, so I finished the wait with a bounded `ci-wait-merge` pass (rc 4, still pending) and foreground polling to the deadline. The driver should re-post this stage.

<!-- gauntlet-stage-result: fix=still-pending -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr200-gauntlet-fix-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 112 tokens (6504661 cached reads)
- Output: 36066 tokens
- Cost: $3.1762361999999986
- Wall-clock: 4083s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
