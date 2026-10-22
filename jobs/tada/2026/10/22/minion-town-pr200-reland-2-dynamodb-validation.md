I found and fixed the startup failure; the re-land is draft PR https://github.com/kriscendobot/minion.town/pull/216. One of the three requests behind the probe is invalid: the index Query uses the attribute name `sub`, which is a DynamoDB reserved word. It needed no schema or IAM change.

**Preconditions:** the heal revert merged at 00:38Z and its deploy on `main` succeeded (run 39700868753). I opened the PR only after that deploy passed.

**Reproduction** (AWS CLI against table `minion-town-accounts`, us-west-1, as the `garden-fleet` user, not the app role):
- **Ledger GetItem:** succeeds.
- **Row GetItem:** succeeds.
- **Index Query:** fails, because its projection lists `sub` without a placeholder (`ProjectionExpression: "iss, sub"`). Full error: `ValidationException: Invalid ProjectionExpression: Attribute name is a reserved keyword; reserved keyword: sub`.
- **Same Query with a placeholder** (`"iss, #sub"` plus `ExpressionAttributeNames: {"#sub":"sub"}`): succeeds.

I didn't assume the app role. DynamoDB rejects the request before checking permissions, so it fails the same way for any caller. The app role `garden-ec2-ssm` still has Query permission on the index, and the index is ACTIVE.

**Changes** (branch `reland/pr200-settings-2`):
- `9321f70a` reverts the heal revert (merge `68c3960b`), so this commit's tree is the same as the earlier re-land's merge `a2d2426`.
- `856dae44` adds the fix:
  - `src/auth/stores/dynamodb.ts`: the Query now refers to `sub` through the `#sub` placeholder.
  - `src/http.ts`: the startup probe now logs `error.name: error.message`, not just the name.
  - `test/accounts-dynamodb-bonds.test.ts`: a new test runs the four bond operations against the mock client. It fails if any expression they send contains a bare reserved word or an undefined `#name` placeholder. With the fix taken out it fails with `Query: bare reserved word sub in iss, sub`; with the fix it passes.
- Typecheck is clean and the account-store tests pass (35/35).

**PR:** opened through `ensure-pr.sh` against base `main`. That needed `GARDEN_ALLOW_FLOATING_BASE=1`, because `ensure-pr.sh` normally requires a pinned snapshot base; I used it since the job asks for `main`, matching #213 and #214. The reproduction evidence is in the PR body. It is left to the gauntlet and the proxy screen; I didn't merge it.

**Follow-ups:**
- The new reserved-word test checks against a short hand-picked list, not DynamoDB's full list of reserved words. It would not catch a future attribute named after a reserved word that isn't on the list.
- The startup probe will catch it if this fix still fails in production. It now logs the full error message, so the cause would show up in the deploy log.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/minion-town-pr200-reland-2-dynamodb-validation.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 44 tokens (1440165 cached reads)
- Output: 11209 tokens
- Cost: $1.043525
- Wall-clock: 176s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
