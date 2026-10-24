**FIX round 2 for kriscendobot/minion.town PR #222** (the `heal/revert-c104813` revert of #218): one of the two failing pre-pass findings is fixed and pushed, and CI is green. The second I left unchanged because it is a false positive, so panel-3 may flag it again.

- **Fixed: `typist-friendly-code-points`.** `designs/account-creation-open-signup.md:98` used U+2192 (→); it now has `->`. I committed this as a follow-up and pushed it with `safe-push-pr-head.sh` in advance mode, moving the head from 354b064c to e742e8df. No other code changed.
- **Not changed: `spell-out-identifiers` on `DynamoDB` in `src/auth/stores/dynamodb.ts`.** DynamoDB is the AWS product name and is part of the SDK's own names (`DynamoDBClient`, `@aws-sdk/client-dynamodb`), so there is nothing to spell out. This PR is a revert, so these lines only restore code that was already on main before #218. The probe needs a proper-noun allowlist entry for AWS product names, or it will fail every PR that touches this adapter.
- **Not changed: the pruner advisory** on the 10-line comment at the top of `deploy/aws/scripts/deploy-accounts-store.sh`. It is non-blocking, and the comment records the IAM split and why the app role cannot change a user's role. That rationale isn't obvious from the code, so I kept it.

**CI:** `ci-wait-merge.sh --no-merge` exited 0 with all 4 checks passed and none failed.

**Follow-up:** add the `DynamoDB` allowlist entry to the `spell-out-identifiers` probe.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr222-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 18 tokens (479653 cached reads)
- Output: 2629 tokens
- Cost: $0.5582546
- Wall-clock: 951s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
