Fix round 1 for kriscendobot/minion.town PR #222 (the revert of #218) is pushed and CI is green: `ci-wait-merge.sh --no-merge` returned rc=0, with all 4 checks passing.

**What I did**
- Fixed all three typist-friendly code-point failures by replacing each character with its ASCII form:
  - `DEPLOYMENT.md:1837`: `…` → `...`
  - `designs/account-creation-open-signup.md:76`: `→` → `->`
  - `designs/account-creation-open-signup.md:81`: `≤` → `<=`
- Committed this as one review-feedback follow-up commit, `354b064c` ("docs: replace typist-unfriendly code points flagged by the style pre-pass"). It was pushed with `safe-push-pr-head.sh`, moving `heal/revert-c104813` from `be6889a5` to `354b064c`.

**What I left unchanged, and why**
- **spell-out-identifiers on `src/auth/stores/dynamodb.ts` (`DynamoDB`):** this is a false positive. "DynamoDB" is the AWS product name, and `DynamoDBClient` is a class from the external AWS SDK, so neither can be renamed. If panel-2 flags it again, the probe needs an allowlist entry for proper nouns and vendor names.
- **Comment-concision advisory on `deploy/aws/scripts/deploy-accounts-store.sh:2` (non-blocking):** I kept the comment. It explains why the IAM permissions are split: the serving role lacks broad UpdateItem, DeleteItem and Scan, and role elevation needs separate admin credentials. That reasoning can't be read off the adjacent code.

**Follow-ups:** none for this stage; the driver re-posts panel-2.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr222-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 16 tokens (415309 cached reads)
- Output: 2738 tokens
- Cost: $0.5285578000000001
- Wall-clock: 890s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
