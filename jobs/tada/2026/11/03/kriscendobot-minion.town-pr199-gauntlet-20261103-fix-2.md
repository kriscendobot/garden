Fix round 2 for kriscendobot/minion.town#199 is done. I fixed every must-fix item from the latest panel review (review 5749288338), pushed to `feat/guest-coupons`, and CI is green on all 7 checks.

**The push:** the head went from `69be650d` to `d6c2009d` through `safe-push-pr-head.sh`, as four follow-up commits.

1. **`capacity` is a DynamoDB reserved word** (saboteur, breaker, spec-keeper)
   - **Problem:** `src/coupons/dynamodb.ts` used it bare in two expressions, so setting capacity or issuing a coupon would fail against a real table.
   - **Fix:** both expressions now use `#capacity`.
   - **Test:** the fake client in `test/coupon-ledger-dynamodb.test.ts` now refuses a bare reserved word the way DynamoDB does. Reverting the alias makes it fail, so it does catch the bug.
2. **The redemption nonce outlived log out** (wire-watcher)
   - **Problem:** the nonce stayed in `localStorage`, so the next person on a shared browser could get the logged-out guest back.
   - **Fix:** `deploy/aws/www/home.js` now removes every stored nonce when it adopts a guest and when it clears the stored credential (the log-out path).
   - **Tests:** two new tests in `test/home-page.test.ts`.
3. **The `endo-root-host.sh` path had no environment** (engine-realist, integrator, surfacer)
   - **Problem:** `runuser` doesn't carry a systemd unit's settings, so the coupon commands ran with no AWS region, Endo socket or table name.
   - **Fix:** the remote script now reads `ENDO_SOCK` from `endo-daemon.service` and `AWS_REGION`/`COUPON_TABLE` from `minion-mcp.service`, with fallbacks, and sets `NODE_ENV=production`. The script's help text now lists the ten coupon commands.
4. **The root commands ignore `COUPON_STORE`** (surfacer): this is intended, so the pool can be sized before the service turns coupons on. It is now stated in the root-ctl usage text, the script header and `deploy/aws/README.md`.
5. **The default table name was in three places** (surfacer): it is now one constant, `DEFAULT_COUPON_TABLE` in `src/coupons/ledger.ts`, used by `config.ts` and `root-ctl.ts`. The systemd unit and the deploy script still write the name out themselves.
6. **No changeset** (packager, changeset-auditor): added `.changeset/guest-coupons.md` at `minor`, with New, Changed and Migration lines.
7. **The PR body said the design was still a draft** (integrator): I deleted the "Merge order" paragraph, since #144 is merged.

**Verification:**
- Typecheck is clean.
- In the full local test run, 1,716 tests passed and one failed: `test/git-remote/capability.test.ts`. It is outside this diff and matches a test I have noted before as failing falsely in the sandbox. CI is green.
- `ci-wait-merge.sh` returned 0.
- My inbox was empty.

**Not done (should-fix and comment items only):** squashing the history, avoiding the full-table scan on every invitation, isolating one failed recipient during an air-drop, sharing one handle grammar, and amending § 12 for the maintainer's "enable" direction. Panel-3 will decide whether any of these matter. Nobody has run the ledger or the wrapper change against a real DynamoDB table or on the box yet; README step 3's smoke check is still the first live test.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr199-gauntlet-20261103-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 64 tokens (2681844 cached reads)
- Output: 18720 tokens
- Cost: $1.6759288000000003
- Wall-clock: 594s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
