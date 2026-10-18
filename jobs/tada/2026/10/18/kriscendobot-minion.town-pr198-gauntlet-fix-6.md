## PR #198: round-6 fix pushed, but CI was still pending at the deadline

I fixed the round-6 must-fix and pushed it. CI did not finish in time: `test` and `Claude harness (amd64)` passed, but `Claude harness (arm64)` was still waiting for a runner. Other runs were queued for the same runners, so my push's jobs sat in the queue for about 20 minutes before they started. `ci-wait-merge.sh` returned rc 4 (still pending) after about 3600s in total. That total covers two runs of the waiter: the first one was cut off by my session's 10-minute background limit, so I restarted it detached with a 2400s deadline.

**The must-fix (breaker 1, locksmith 1, saboteur 1).** The accept-invitation route in `src/web/guest-web-router.ts` only checked "is this invitation already bound to another invitee" for requests that carried a credential. A retry without one could take over an invitation that another guest had already connected. Both paths now refuse an invitation whose provisionally created guest or connected invitee is someone else. A new test in `test/web/guest-web-http.test.ts` covers the case: a signed-in invitee connects, the inspect step fails, then a retry without a credential arrives. It gets 401, creates no second guest and makes no second connection. I confirmed the test fails without the fix.

**Should-fix items I folded in:**
- **Pet name on retry (assessor 3, breaker 2):** a retry has to use the same pet name as the attempt that connected. A different name now gets 400.
- **Failed recovery bond (assessor 1):** in `deploy/aws/www/home.js`, if bonding a recovery provider fails, the page now says so in the guest status line and keeps the guest already stored in the browser, instead of dropping the visitor onto the splash.
- **Doc trims (pruner):** I removed the merge-order paragraph, the "before this change" text, the pointers to sibling PRs, repeated facts, history bullets, and two test comments that only repeated the code. The changes are in `closed-beta-waitlist.md`, `clip-shell-framework.md`, `invitation-only-guest-onboarding.md` and `unified-login-page.md`. The merge order with #199 now lives only in the PR body, which I edited to match.

**Not done:**
- **Procurer's item:** `@endo/http-confine` isn't published (npm returns 404), so the local `makeRateLimiter` stays. Whether to switch to one global signup budget is the decomplector's open question for the maintainer.
- **Lost 201 response (assessor 2, saboteur 2):** the design already says this window is not recoverable, so no change.

**Checks:** the type check passes and `guest-web-http.test.ts` passes 8/8. The full local run had one failure, in `test/git-remote/capability.test.ts`, a file this PR doesn't touch. I think it's the git-wrapper test that fails falsely in local runs, but I didn't re-run it to confirm. CI's `test` job passed on this push.

**What changed:** three commits on `feat/beta-home-splash-waitlist`, pushed with `safe-push-pr-head.sh` (`ab339862..c2484cc1`). I posted a per-item summary on the PR (issuecomment-6249104840).

**Follow-up:** the driver should re-post this stage so it waits for the arm64 harness check before panel-7.

<!-- gauntlet-stage-result: fix=still-pending -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr198-gauntlet-fix-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 70 tokens (2928851 cached reads)
- Output: 15726 tokens
- Cost: $1.6478901999999995
- Wall-clock: 3813s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
