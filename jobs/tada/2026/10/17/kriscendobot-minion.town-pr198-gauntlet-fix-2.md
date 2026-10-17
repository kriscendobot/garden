## Gauntlet fix round 2: kriscendobot/minion.town #198

The must-fix items are all on the PR head, and CI is green on that head (`65b37ee`). I pushed nothing in this attempt: an earlier claimant of this job had already applied the fixes and pushed them as `65b37ee`. I checked that commit against each item in the round-2 verdict.

**pruner** asked for seven cuts. All seven are in:
1. **PR body:** now 219 words. The round-1 narrative is gone, "Problem" and "What changed" are reduced to a pointer to the design, "Evidence" is down to two sentences, and the deploy notes and veto pointer are kept.
2. **IAM split:** now stated only in `deploy-waitlist-store.sh`. `waitlist.ts` and `stores/dynamodb.ts` point to it.
3. **Privacy-posture bullets** in `waitlist.ts`: replaced with one line pointing to the design.
4. **`home.js` header:** no CSP or `frame-src` restatement left. The `frame-src`/`child-src` sentence was also removed from the Caddy comment.
5. **Name-restating JSDoc:** deleted from `WAITLIST_RETENTION_DAYS`, `createdAt`, `guestUrl` and the landing selector. The `@param` and `@returns` tags stay.
6. **`clientAddress` JSDoc:** the fallback discussion is cut to one clause.
7. **Caddy retired-landings comment:** reduced to the fact that old `#v=1&…` fragments survive the 308.

**procurer** objected that the local `makeRateLimiter` duplicates the one in `@endo/http-confine`. This was answered with a written justification, not by switching to the dependency. The function now carries a `build-not-buy` marker, and the PR body says the same: the `@endo/http-confine` limiter is one unkeyed per-minute window that throws, while the waitlist needs per-network keys, an hour-long window and a cap on how many keys it tracks. The next panel round will need to accept that reason under skills/build-vs-buy; if it doesn't, the dependency has to be consumed or the question taken to the maintainer.

**CI:** Actions run https://github.com/kriscendobot/minion.town/actions/runs/39029994992 (`Test (typecheck + vitest)`) succeeded. It sat queued for about two hours before a runner picked it up. The first `ci-wait-merge.sh` call ran past the 10-minute shell limit and was stopped, so I polled the Actions runs API in the foreground until the run finished, then re-ran `ci-wait-merge.sh --no-merge`. It returned rc=0 (CI GREEN). It had to use the Actions runs API because the bot token can't read `statusCheckRollup`, so commit statuses and any check runs outside Actions were not visible to it.

**Follow-ups:** panel-3 is posted by the driver.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr198-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s)
- Input: 92 tokens (3231640 cached reads)
- Output: 16084 tokens
- Cost: $2.09784
- Wall-clock: 5534s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
