I applied the round-2 panel fixes and pushed them, but CI was still pending when the wait ran out. `test` passed. The two Claude harness image builds (amd64 and arm64) never started: they sat queued for about an hour behind a backed-up self-hosted `ci-minion-town` runner queue. Runs on other branches have been stuck in that queue since 10:46, so this isn't caused by the PR.

**What I did** (PR head `cfb8bbd` → `65b37ee`, one follow-up commit pushed with `safe-push-pr-head.sh`):

- **procurer (rate limiter):** I kept the local `makeRateLimiter` and marked it with the build-vs-buy skill's own waiver comment, `// build-not-buy: <reason>`. `@endo/http-confine`'s limiter can't do this job: it is one shared per-minute window and throws when the limit is hit. The waitlist needs a separate count per network, a one-hour window and a cap on how many networks it tracks. The package is also on neither npm nor the npm.minion.town dev registry, which I checked.
- **pruner (cut repeated prose):**
  - **PR body:** cut from 429 to 219 words. The round-1 narrative, Problem and What changed sections are replaced by a pointer to the design doc, Evidence is shortened, and Deploy notes and the veto pointer are kept.
  - **IAM split and privacy posture:** these now live in one place. The `waitlist.ts` header points to the design doc, and the `dynamodb.ts` header points to `deploy-waitlist-store.sh`.
  - **Restated JSDoc:** removed the lines that only repeat names (`WAITLIST_RETENTION_DAYS`, `createdAt`, and the `guestUrl` and `landingMode` summaries in `home.js`).
  - **`clientAddress` comment:** the fallback discussion is down to one clause.
  - **Caddy site block:** removed the repeated `frame-src` sentence from the `handle /` comment, and cut the retired-landings comment to the rule that old fragments survive the 308.
  - **`home.js` header (item 4):** I found no CSP or frame text there to cut, so the matching cut is the Caddy comment above.

**Checks:** `npm run typecheck` is clean. The waitlist, DynamoDB, home-page and Caddy tests pass locally (81 of 81).

**CI:** `ci-wait-merge.sh` returned rc 4 (still pending) on each bounded run. The job asks for one 3600s wait, but my shell commands are capped at about 10 minutes, so I ran three shorter waits covering roughly the same hour (a GitHub API rate limit briefly interrupted the first). The driver will re-post this stage to keep watching. Nothing more needs pushing.

**Follow-up:** someone should look at why the self-hosted `ci-minion-town` runner pool isn't picking up queued jobs. Several minion.town PRs are blocked the same way.

<!-- gauntlet-stage-result: fix=still-pending -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr198-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 64 tokens (2426017 cached reads)
- Output: 11462 tokens
- Cost: $1.3881954000000003
- Wall-clock: 3602s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
