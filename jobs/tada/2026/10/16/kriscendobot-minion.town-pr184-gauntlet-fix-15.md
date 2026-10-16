Fix round 15 for kriscendobot/minion.town#184 is done. I applied the panel's must-fix items in two commits on `fix/prod-probe-dispatch-backstop` (329cf0c → bee6c06), and CI is green on the new head.

**1ed09ad: corner-prober's jq anchoring finding (confirmed real).** The seed check in `provision-ci-runner.sh` used jq's `test("^[!-~]+$")`, and I confirmed it accepts `"ghp_x\n"`. That means a token with a trailing newline could be seeded and then refused by the Lambda on every invocation, which is the exact case the check exists to stop.
- The check now compares each character's code point against the visible-ASCII range instead of using a regex, with a short comment saying why.
- A new provisioner test runs the real `--seed-probe-dispatch-token-stdin` path. It checks that `ghp_x` and `!~` are seeded, and that ten bad inputs exit non-zero and never write a secret: newlines at the start, middle and end, a space, an empty string, a lone newline, a non-ASCII character, `null`, a number and a missing token.

**bee6c06: pruner's eight trim findings.**
- **`DEPLOYMENT.md`:**
  - The 2026-10-11 to 2026-10-15 cron measurements are cut to one sentence; the numbers now live in the commit message.
  - The duplicate-dispatch cost is stated once.
  - The expired/revoked-token sentence becomes "see the Lambda's logs".
- **`provision-ci-runner.sh`:** removed the third copy of the at-least-once note and the "A function without a policy has none." sentence.
- **`prod-probe-backstop.mjs`:** removed "Make the backstop's Lambda handler."
- **`lambda/test/index.test.mjs`:** removed the visible-ASCII comment that repeated the test title.
- **`test/provision-ci-runner.test.mjs`:** cut the fixture comment to its non-obvious notes and removed the comment that repeated the removal-ordering assertions.

**Checks:**
- The node test command from `test.yml` passes locally (29 tests) and `bash -n` is clean.
- I pushed with `safe-push-pr-head.sh` in advance mode.
- `ci-wait-merge.sh --no-merge` returned rc 0 on head bee6c06: `test` and both `Claude harness` checks passed. Its first green result was for the old head because GitHub hadn't registered the push yet, so I waited for the head to update and ran it again.

**Not done:** corner-prober's other items (#1 a test that manual dispatch stays strict, #2 env-default edge cases, #4 the `for … in $(jq …)` loop in the policy cleanup) were advisory and I didn't do them. The decomplector raised nothing that needs action. Panel-16 is next.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr184-gauntlet-fix-15.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 44 tokens (1471370 cached reads)
- Output: 9874 tokens
- Cost: $1.0260100000000003
- Wall-clock: 943s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
