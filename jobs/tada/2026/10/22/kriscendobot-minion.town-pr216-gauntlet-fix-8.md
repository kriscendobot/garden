Fix round 8 on kriscendobot/minion.town#216 is pushed and CI is green. The PR head is now `a01f5b17`.

The latest panel review (19:28Z, on head `4c25e57e`) had two must-fix items:

1. **archivist #1 (fixed):** `DEPLOYMENT.md` said `ELEVATION_CONTACT` "ships as an obvious placeholder (`TODO: set ELEVATION_CONTACT`)". The unit file actually sets `mailto:kriskowal@kriskowal.com`. The bullet, the change procedure ("replace the placeholder" became "change the value") and the Phase C status row now state the value that ships.
   - The same commit also fixes archivist should-fix #2: the Log out row in the `designs/closed-beta-waitlist.md` table now says it shows "only when this browser's sign-in recovers this guest", which matches § Settings menu.
   - Commit: `a01f5b17`, pushed with `safe-push-pr-head.sh` as a fast-forward from `4c25e57e`.
2. **decomplector #1 (explained in the PR body, not changed in code):** the juror asked to either replace `BrowserGuestDirectory`'s name filter with a child host, or say in the PR body why one can't work. They also asked for maintainer confirmation before changing the re-land's direction. I left the code as it is and added a "Why a name grammar, not a child host" section to the body. It makes three points:
   - On `main` the web service holds the whole root host, so this PR narrows its access.
   - Existing `web-…` and `coupon-…` guests are named in the root, so moving them to a child host would mean migrating each one.
   - Guests created by a child host would send their `HOST` mail to that host instead of the root.

   The `HOST`-mail point is from my understanding of how Endo assigns a guest's host. I did not check it against the Endo source.

**Other changes:**
- **PR body:** I removed the `## Commits` list and the duplicated rollout paragraph, which covers integrator should-fix #3 and pruner #1. The `garden-job` marker is kept.
- **Maintainer message:** sent to the inbox explaining that I did not change direction. If they want browser guests moved to a child host, it should be posted as a separate design/build job.

**CI:** both runs on `a01f5b17` passed ("test (typecheck + vitest)" and "clip frame browser gate"), and `ci-wait-merge.sh --no-merge` returned rc 0. My first background run of the wait script was stopped at its 10-minute limit, so I polled the Actions runs API in the foreground and then ran the script again to get the result.

**Not addressed (should-fix, for later rounds or the maintainer):**
- **breaker #1:** `removeGuest` should refuse when a guest has more than one `-agent` name.
- **breaker #2:** the deletion sweep can race an invitation accept or a send.
- **assessor #1:** a `TransactionConflict` during `bondGuest` comes back as a 500.
- **integrator #1:** nothing cleans up the leftover `guest-formula-fingerprint` index from #213.
- **integrator #2:** regroup the commits.
- **pruner #2–#6:** prose cuts and the section-banner comment in `deploy-accounts-store.sh`, which a test anchors on.
- **decomplector #2:** name one owner for the "guest is deleted" fact.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr216-gauntlet-fix-8.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 48 tokens (1637993 cached reads)
- Output: 10444 tokens
- Cost: $1.1147665999999998
- Wall-clock: 1442s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
