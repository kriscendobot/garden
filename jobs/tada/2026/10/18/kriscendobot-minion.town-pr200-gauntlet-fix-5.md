**Fix round 5 for kriscendobot/minion.town PR #200 is done.** I applied the panel's two must-fix items, pushed two commits (head `c6fa688` → `47fe106`), and CI came back green (`ci-wait-merge` rc 0).

**What I changed**
- **Decomplector: dropped the separate deleted-guests file.**
  - The guest service now opens a credential only while the daemon's root host still names it. Deleting a guest means removing those names, and the daemon stores that itself.
  - Deletion is allowed only if every root name is a web or coupon guest name. It cancels each name, then removes it, then checks that no name is left. If any name remains, it reports a failure.
  - Removed `src/web/deleted-guests.ts`, its startup loader, the wrapper that refused deleted guests, the production 503 and the re-check after bonding.
  - A failed deletion now leaves a live guest that keeps its bonds, and a retry finishes the job. That also settles the saboteur and breaker should-fix items about a failed write, which are moot now that the file is gone.
  - Recovery bonds are removed only after the guest is deleted. If a recovery sign-in finds a bond to a dead credential, it removes that bond and answers 404.
  - Removal failures are no longer silently swallowed (saboteur #3).
  - Tests were rewritten to match: the deletion-failure-and-retry case, the bond-races-a-deletion case, and refusal on every route. The tests for the old file are gone.
- **Archivist: fixed the dead `designs/guest-coupons.md` links** (both of them) in `designs/closed-beta-waitlist.md`. I also rewrote that design's Delete account paragraph for the new mechanism; the formula-collection caveat (`ENDO_GC`) now appears once, in `guest-web-socket-service.ts`.
- **Pruner trims (should-fix):**
  - deleted the repeated Log out header in `settings.js`;
  - removed the before/after "now" and "no longer" wording from `designs/clip-shell-framework.md` §8;
  - removed the repeated note that the index is eventually consistent from `dynamodb.ts`.

**Verification**
- Typecheck is clean and all deletion-related tests pass locally.
- One unrelated local failure: `test/git-remote/capability.test.ts`. This diff doesn't touch that area, and it passed in CI.
- CI passed all three jobs: `test` and the amd64 and arm64 harness builds. CI also runs the real-daemon deletion test, which checks the new root-name rule against a live daemon.

**Follow-ups**
- CI sat queued for about 55 minutes with nothing running, which looks like a self-hosted runner outage. The runners recovered on their own, and green arrived about 100 minutes after the push, past the 3600s deadline.
- Not done (should-fix or comment-only): pruner #1 (the test comment and module doc) and #4 (DEPLOYMENT.md); the archivist's request to hedge the claim that production runs with `ENDO_GC` unset; the breaker's comment that a suspended OAuth account still shows Log out; and the saboteur's comments that the delete button can re-enable mid-request and that the bond index can lag.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr200-gauntlet-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 102 tokens (4921827 cached reads)
- Output: 25942 tokens
- Cost: $2.3952534000000005
- Wall-clock: 6672s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
