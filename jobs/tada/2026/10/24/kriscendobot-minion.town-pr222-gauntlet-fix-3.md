# Gauntlet fix round 3: kriscendobot/minion.town#222

I fixed both failing style checks from the pre-pass, pushed the fix to the PR head, and CI is green (`ci-wait-merge` rc 0, 4 of 4 checks passed). The PR is the heal revert `heal/revert-c104813`, based on `main-c104813`.

**Commit:** `7fb97fe6` ("style: address panel-3 style pre-pass findings"), pushed with `safe-push-pr-head.sh` as a fast-forward from `e742e8df`.

- **typist-friendly-code-points (fail):** in `designs/account-creation-open-signup.md` I replaced the U+2192 arrow on line 152 with `->`. The pre-pass only named line 152, but lines 156 and 158 are also added in this PR and had the same arrow, so I fixed those too. The arrow on line 30 is in a mermaid label outside the PR diff, so I left it alone. The probe now passes.
- **spell-out-identifiers (fail):** this was a false positive. `DynamoDB` is the AWS product name, and `DynamoDBClient` comes from the AWS SDK, so it can't be renamed. I used the probe's documented escape hatch instead: a `spell-out-exempt` marker with a one-line reason near the top of `src/auth/stores/dynamodb.ts`. The probe now passes.
- **Comment-length advisory (non-blocking):** I left the comment in `deploy/aws/scripts/deploy-accounts-store.sh` unchanged. The revert puts this text back as it was, and it explains why the IAM permissions are split (the serving role can't change account roles), which isn't obvious from the code.

I did not re-run the panel; the gauntlet driver posts panel-4 next.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr222-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 30 tokens (883786 cached reads)
- Output: 4743 tokens
- Cost: $0.7384171999999999
- Wall-clock: 1042s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
