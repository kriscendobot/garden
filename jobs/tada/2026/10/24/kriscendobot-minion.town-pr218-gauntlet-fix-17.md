**Fix round 17, kriscendobot/minion.town PR #218: done. I pushed the fixes and CI is green (rc 0, 4 of 4 checks passed).**

There was no pre-pass block in the job, so I worked from the latest panel verdict, review 5638932201 on head `877b7b5c`.

I pushed two commits to `split/pr216-ledger` with `safe-push-pr-head.sh` (`877b7b5c..e01c9880`):

- **`108fc967`, docs (archivist 1–3):**
  - **App-role grants:** `DEPLOYMENT.md` claimed the app role had only `GetItem`+`PutItem`. That bullet now points to the design's § 2 IAM split instead.
  - **Tampering ceiling:** § 8 now matches § 2. A compromised app can write any `role` or `status` value, but the resolver limits what that grants: an undefined role name gets no scopes, and no store role goes above `resident` (read).
  - **Open question 3:** marked resolved, since the adapter-placement amendment has landed.
- **`e01c9880`, chore (pruner 2–13):** deleted the comments that restate the code across `src/auth/stores/dynamodb.ts`, `check-accounts-store-transaction.{mjs,d.mts}` and three test files. For item 6, I kept only the part that isn't obvious from the code: a `row_kind` with a non-string attribute type is not an account.
- **PR body (pruner 1):** cut from 404 to about 275 words. "Upgrading" is folded into "What to attend to", "Not benchmarked" is one sentence, and the `garden-job` marker is unchanged.

Before pushing, `tsc --noEmit` was clean and the four affected test files passed (84 tests).

**Not applied** (explained in a reply on the PR, comment 6386626110):
- **Decomplector 1–2 (should-fix):** these ask to move the backfill and its rollout markers out of `deploy-accounts-store.sh` into a separate one-shot script with append-only records. That would change the rollout procedure that `DEPLOYMENT.md` and the `deploy-app.sh` preflight depend on, so it's a redesign for the arc supervisor to decide. The reply also explains what the `active` (rollback) mode is for.
- **Decomplector 3, archivist 4 (comment-only):** left as is.
- **Pruner 14:** the reviewer marked it a judgement call, so I didn't change it.

Next, the gauntlet driver posts panel round 18.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr218-gauntlet-fix-17.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 38 tokens (1274548 cached reads)
- Output: 8862 tokens
- Cost: $1.0059335999999999
- Wall-clock: 1053s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
