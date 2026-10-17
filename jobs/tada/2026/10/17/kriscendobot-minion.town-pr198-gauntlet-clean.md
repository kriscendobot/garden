# Gauntlet CLEAN stage: kriscendobot/minion.town PR #198

**Result:** I added tests for the untested waitlist code and fixed two comments that still named a deleted file. I pushed one commit to the PR head, and CI is green on it.

**Starting state:** The PR is a draft and open. Head `bbf6c15` was green, but nobody had done a coverage pass on it yet, so this stage still had work to do.

**Coverage pass:** I scoped it to the source this PR touches: `src/waitlist/**`, `src/waitlist-cli.ts` and `src/http.ts`.
- `src/waitlist/stores/dynamodb.ts` had **0% coverage**.
  - I added `test/waitlist-dynamodb.test.ts`, which mocks the AWS SDK and runs 6 tests.
  - They check:
    - the region option goes to the client only when configured;
    - adding uses a conditional put (`attribute_not_exists(email)`);
    - `ConditionalCheckFailedException` returns `"exists"` and other errors are rethrown;
    - listing follows every page of a Scan, fills in blank rows and sorts by signup time;
    - removing normalizes the email and reports `ALL_OLD` as true or false.
  - The file is now at 100% statements, branches and functions.
- `src/waitlist/waitlist.ts` lines 93–94 were uncovered: `coarseNetwork` returning `"unknown"` for something that isn't an IP address. I added a test for it, and the file is now at 100% line coverage.
- `src/waitlist-cli.ts` was already fully covered.
- `src/http.ts` adds only the waitlist store selection. The test suite always picks the memory store there; the DynamoDB branch is a lazy import, which I left alone.

**Dead code:** `dev/guest-web-daemon-demo.ts` had two comments that still referred to the deleted `deploy/aws/www/guest.js`. I changed them to `home.js`. A search found no other leftover references to `guest.html`, `guest.js` or `shell.html`; the remaining mentions are intentional, such as the redirect rules and the test that checks the old pages are gone.

**Push:** Commit `9b76559` ("test(waitlist): cover the DynamoDB adapter and the unknown rate bucket") went to `feat/beta-home-splash-waitlist` via `safe-push-pr-head.sh --mode advance` (`bbf6c15..9b76559`). Before pushing, typecheck passed locally and the touched tests passed (30/30 in the waitlist files).

**CI:** Run 39015855842 on head `9b76559` **completed with success**. All three jobs passed: `test`, `Claude harness (amd64)` and `Claude harness (arm64)`.
- The run sat queued for about 18 minutes waiting for a self-hosted `ci-minion-town` runner to pick it up.
- `ci-wait-merge.sh` was stopped by my shell's 10-minute limit for background commands before it returned a result. I watched the run to completion by polling the Actions runs API instead, because the bot token can't read the PR's check status.

**Follow-ups:** None. Like this adapter before, the auth and billing DynamoDB adapters have no unit tests, but they are outside this PR.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr198-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 54 tokens (1598902 cached reads)
- Output: 12058 tokens
- Cost: $1.0573324
- Wall-clock: 2070s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
