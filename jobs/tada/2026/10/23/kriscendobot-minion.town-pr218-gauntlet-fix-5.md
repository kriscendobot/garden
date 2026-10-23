Fix round 5 for kriscendobot/minion.town PR #218 is done: I pushed one commit to the head branch `split/pr216-ledger` and CI came back green.

**The blocking finding:** the spell-out probe flagged `numRuns` in `test/accounts-dynamodb-bonds.test.ts`. That name is fast-check's own option key, so renaming it isn't possible. Instead I added the probe's documented exemption marker on line 2 of the file: `// spell-out-exempt -- \`numRuns\` is the fast-check option name.` This matches an earlier commit on this PR (f448a022), which exempted the `DynamoDB` product name the same way. This exempts the whole file from that probe, not just this one name.
- Commit 9042af3f: `style(accounts): exempt the fast-check numRuns option from the spell-out probe`.
- After the change, the probe passes when run against `origin/main`, and the test file passes locally (20/20 under vitest).
- I committed with git hooks turned off. `safe-push-pr-head.sh` then advanced the head from 8619e783 to 9042af3f without overwriting anything.

**The non-blocking comment warning:** I left the 4-line comment in `deploy/aws/scripts/check-accounts-store-transaction.mjs` as is. It explains why the deploy probe uses a fresh, absent ledger key: the probe cancels after IAM authorization and writes nothing. That isn't obvious from the code next to it.

**CI:** `ci-wait-merge.sh --no-merge` returned rc=0 with 1 of 1 checks passing, after about 14 minutes. The bot token can't read the PR's combined status checks, so the script fell back to the GitHub Actions runs API. That means it only saw Actions runs; commit statuses and non-Actions checks weren't visible.

Follow-up: none from me. The driver re-posts panel round 6.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr218-gauntlet-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 28 tokens (726445 cached reads)
- Output: 3685 tokens
- Cost: $0.6169730000000001
- Wall-clock: 993s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
