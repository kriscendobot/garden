Fix round 1 for kriscendobot/minion.town PR #198 is pushed and CI is green: all 3 checks passed (`test`, `Claude harness (amd64)`, `Claude harness (arm64)`).

I applied every failing finding from the style prepass in one follow-up commit, `e8e73598`, pushed with `safe-push-pr-head.sh --mode advance` (`c2484cc1..e8e73598`):

- **prefer-endo-primitives** (`test/home-page.test.ts`): I added a `prefer-endo-primitives-exempt` marker at the top of the file. `@endo/sha256` isn't published, and the test has to compute the SHA-256 hash that the page's security policy uses to allow its inline script. Two other files in the repo use the same exemption: `test/endo-claude-vendor.test.ts` and `src/endo/git-remote/capability.ts`.
- **spell-out-identifiers** (three findings):
  - `src/waitlist/stores/dynamodb.ts`: `DynamoDB` is the AWS service and SDK client name, so I added a `spell-out-exempt` marker rather than renaming it.
  - `test/waitlist.test.ts`: `numRuns` is fast-check's own option name, so this also got a `spell-out-exempt` marker.
  - `test/web/guest-web-http.test.ts`: I renamed `...args` to `...connectArguments` in both `connectLocal` overrides.
- **Advisory pruner comment** (non-blocking): I left the comment in `deploy/aws/scripts/deploy-waitlist-store.sh` as is. It isn't narration: it says the store must be provisioned before the app deploy, otherwise `/api/waitlist` answers 503.

**Checks:** after the commit, both probes pass against the branch's merge base. The vitest run on the 3 touched test files passed (90/90), and `tsc --noEmit` reported no errors.

**CI wait:** `ci-wait-merge.sh` ran as told, but my tool calls stop after 10 minutes. The first run with the 3600s deadline was cut off at that limit before it finished. The second, with a 560s deadline, timed out while all 3 checks were still pending. I watched the rest with a bounded `gh pr checks` polling loop until every check finished. The checks sat in the queue for about 30 minutes before a runner picked them up; the GitHub API rate limit had plenty left, so that wasn't the cause.

There are no follow-ups. The driver re-runs the panel as panel-2.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr198-gauntlet-20261019-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 36 tokens (1059112 cached reads)
- Output: 5642 tokens
- Cost: $0.7744704
- Wall-clock: 3238s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
