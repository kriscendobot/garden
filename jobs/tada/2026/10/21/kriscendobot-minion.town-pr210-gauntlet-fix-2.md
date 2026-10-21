Fix round 2 for kriscendobot/minion.town#210 is pushed and CI is green.

**Blocking finding (spell-out-identifiers, `numRuns` in `test/agent-activity.test.ts`):** `numRuns` can't be spelled out because it is fast-check's own option name. I added the probe's exemption header as line 1 instead, worded exactly like the one `test/waitlist.test.ts` already has:
`// spell-out-exempt -- `numRuns` is the fast-check parameter name.`
The probe skips any file with that marker in its first five lines. I didn't re-run the probe; the next panel round will.
- Commit `551914e` is on `feat/agent-last-active` (moved from `4ad236b`), pushed with `safe-push-pr-head.sh --mode advance`.

**Advisory finding (pruner, `deploy/aws/scripts/deploy-accounts-store.sh:7`):** I left this comment unchanged. It records an authorization rule that the code doesn't show: the instance role may run UpdateItem only on the agent-activity partition and cannot Query it, because reading activity is a separate principal's grant. That is design rationale, not narration of the code next to it.

**CI:** `ci-wait-merge.sh --no-merge` exited 0 with 1 of 1 runs passed and none failed. The first waiter was cut off by the 10-minute background limit after about 560s, still pending, so I restarted it and it then reported green.

- The bot's token can't read the PR's combined check status, so the wait script used the Actions runs API instead. Commit statuses and checks from outside Actions weren't visible to it.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr210-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 38 tokens (955054 cached reads)
- Output: 5357 tokens
- Cost: $0.6682388
- Wall-clock: 1121s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
