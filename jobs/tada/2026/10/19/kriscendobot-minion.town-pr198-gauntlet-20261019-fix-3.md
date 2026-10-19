Fix round 3 for kriscendobot/minion.town PR #198 is done: the panel's one must-fix was already on the PR head, so I pushed nothing new, and CI is green.

**The must-fix.** The latest panel verdict (review 5569781848, 2026-10-19T09:53Z) had one must-fix item, raised by both the saboteur and wire-watcher jurors. When a visitor accepted an invitation, `deploy/aws/www/home.js` deleted their stored guest credential on any 401/403. The server also returns 401 when the invitation is unknown, already used, or mid-accept. So one bad or stale invitation link could wipe a visitor's only copy of their guest.

**Already fixed on the PR head.** Commit `d248526` ("fix(web): keep a working guest when an invitation is refused") was pushed at 11:00Z, after that review, probably by an earlier run of this same job. It applies both remedies the jurors proposed:
- **Server:** `src/web/guest-web-router.ts` now answers invitation failures with `404 {code: "invitation-unavailable"}` instead of 401.
- **Client:** `home.js` forgets the stored guest only if a separate `GET /api/guest` with the same credential is also refused (the new `credentialRejected` helper).
- **Tests:** added in `test/home-page.test.ts` and `test/web/guest-web-http.test.ts`.

The head is now `5ea6269`.

**CI.** `ci-wait-merge.sh --no-merge` returned rc 0 (green). The bot token can't read the PR's combined check status, so the script used the Actions runs API instead: 1 run, 0 failures. Commit statuses and checks from outside GitHub Actions aren't visible that way.

**Not done.** The jurors' should-fix items were outside this stage's scope:
- The invitation token stays in the address bar until the visitor accepts or declines.
- A comment overstates how much the waitlist rate limiter's dedupe bounds the damage.

The driver posts panel-4 next.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr198-gauntlet-20261019-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 96 tokens (3475544 cached reads)
- Output: 20359 tokens
- Cost: $2.1834087999999996
- Wall-clock: 3878s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
