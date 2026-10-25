The clean stage for kriscendobot/minion.town PR #220 is done: I added three tests and fixed two stale comments, and CI is green at the new head `539835bf36c`.

**What the coverage pass found:** I ran v8 coverage over the PR's touched areas and compared the uncovered lines against the lines the PR adds.
- In `src/web/guest-web-socket-service.ts`, three new code paths had no tests: forgetting a daemon connection that fails to open, `close()`, and the check that refuses to finish a deletion if a new root name points at the guest.
- The other uncovered added lines are either code moved from elsewhere or thin wiring (`connectBrowserGuestDirectory`, the bond-error translation in `http.ts`). The tests replace that wiring with a fake, and it isn't separate logic.
- Everything else the PR adds is fully covered, including `accounts.ts`, `dynamodb.ts`, the router, the deletion audit and `durable-append`.

**Changes pushed** (one commit, `539835bf`, pushed with `safe-push-pr-head.sh` on top of `b0cf0289`):
- `test/web/guest-web-socket-faults.test.ts` has three new tests. I added a `refuseConnections` switch to the test file's mock daemon for the first one.
  - A connection that fails to open is forgotten, and the next call reconnects.
  - After `close()`, the next call gets a fresh connection.
  - If a root name is bound to the guest partway through deletion, the deletion fails with "left a root name", stays pending with its marker and writes no tombstone. A retry finishes once the name is removed.
- Two comments still said the retired landing role panel uses `/account`. I changed them in `src/auth/accounts.ts` and `deploy/aws/caddy/conf.d/minion-town.caddy`.
- I found no dead code: the removed `guestUrl` and the role-panel markup leave nothing behind.

**Checks:**
- `tsc --noEmit` passes.
- The touched test files plus the Caddy and home-page tests pass locally (360 passed, 4 skipped).
- `ci-wait-merge.sh --no-merge` returned rc 0: all 7 checks green at `539835bf`.
- My first CI wait ran into the session's command time limit and was stopped. A second, shorter wait completed and is the result above.

**Follow-ups:** none.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr220-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 62 tokens (2396412 cached reads)
- Output: 13718 tokens
- Cost: $1.4717624
- Wall-clock: 1534s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
