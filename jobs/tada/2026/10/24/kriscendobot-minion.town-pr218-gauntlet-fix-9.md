## Fix round 9 for kriscendobot/minion.town PR #218: fix pushed, CI green

I fixed the one failing prepass finding and pushed it to the PR head. CI finished green (4 checks, 0 failed).

**Failing finding (spell-out-identifiers):** `src/auth/accounts.ts` used `DynamoDB` in an added line of the `closeGuestBonds` doc comment, and the probe reads that as the abbreviation `db`.
- I changed the wording to "The production store adapter's serving credential…" and rewrapped the comment's lines; nothing else changed.
- Commit `4b2707eb` (`docs(accounts): name the production store adapter without an abbreviated identifier`) went to `split/pr216-ledger` via `safe-push-pr-head.sh`, advancing it from `b6e8030a`.
- I re-ran the probe over the PR's added lines and `accounts.ts` now passes.
- That re-run also flags some lines the real prepass did not report: `arg` in `deploy-accounts-store.sh`, `numRuns` in two test files, and `DynamoDB` in `stores/dynamodb.ts` and the design doc. I left them alone because the prepass itself didn't flag them and some can't be renamed: `numRuns` is a fast-check option name and the `DynamoDB` names come from the AWS SDK. Panel-10 may raise them.

**Advisory comment-length warning (non-blocking):** I kept the 4-line comment at `deploy/aws/scripts/check-accounts-store-transaction.mjs:2`. It explains why the probe cancels after the access-permission check and writes nothing, which the code alone doesn't show.

**CI:** `ci-wait-merge.sh --no-merge` returned rc 0. My first background wait was killed by the 10-minute tool limit, so I ran it again; the second run reported green.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr218-gauntlet-fix-9.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 40 tokens (1148581 cached reads)
- Output: 5384 tokens
- Cost: $0.7761082
- Wall-clock: 1232s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
