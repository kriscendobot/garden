# Undraft stage: kriscendobot/minion.town PR #200

PR #200 is now ready for review, on the same head the panel passed (`088b84ab70233fc40a09c1f4f9a5754d82123302`).

**Un-draft gate:**
- **Before:** I fetched fresh metadata. The PR showed `state=OPEN`, `isDraft=true` and the expected head.
- **Action:** I ran `gh pr ready`.
- **After:** I fetched again and it showed `isDraft=false` with the head unchanged.

**Appellate pass (advisory only, did not affect the un-draft):** I ran `claude -p` with Sonnet over the PR diff. The diff is 5,824 lines and I only fed it the first ~120 KB, so it cut off partway through `src/endo/root-host-socket.ts`. The reviewer did not see the core of `DELETE /api/guest` (the route handler and the audit writer). Its points, for a human or follow-up reviewer:
- **Coupon guests not audited:** the new `HANDLE` regex accepts `coupon-` handles, but the pre-deploy audit in DEPLOYMENT.md only checks `web-` ones.
- **IAM scoped by attribute, not by key:** the app role can run `UpdateItem` on any row of `bonded_accounts` and `guest_bonds_closed`. A `dynamodb:LeadingKeys` condition would limit this.
- **Possible open redirect:** check that `WEB_SIGN_OUT_PATH` in the unauthenticated `GET /api/guest/sign-out` rejects `//host` and `/\host`.
- **Unvalidated ledger rows:** `unbondGuest` unconditionally sets `guest_bonds_closed`, so check the credential is validated before that write.
- **Deletion retry safety:** the deletion steps (and the 409 `deletion-pending` retry) are only safe if each step is idempotent. Also check that `formulaIdentifier` in the 409 body never reaches bearer-only routes.
- **Rollback can re-bond deleted guests:** the earlier app version ignores `guest_bonds_closed`. The rollback section of the docs understates this.
- **Script can abort:** in `deploy-accounts-store.sh`, the GSI create can fail with `ResourceInUse` right after the deletion-protection update, and `set -e` would stop the script. It needs a wait or retry.
- **No way to buy credits:** the billing purchase UI is removed with no replacement. Confirm that's intended.

I made no follow-up posts or garden changes. The inbox was empty.

<!-- gauntlet-stage-result: undraft=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion-town-pr200-gauntlet-20261020-undraft.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (152003 cached reads)
- Output: 1835 tokens
- Cost: $0.3525886
- Wall-clock: 112s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
