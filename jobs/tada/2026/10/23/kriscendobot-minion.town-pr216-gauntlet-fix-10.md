# Gauntlet fix round 10: kriscendobot/minion.town PR #216

**Result:** I pushed fixes for 10 of panel-10's 14 items, and CI is green on head `6e99a367` (`ci-wait-merge` rc 0; "test (typecheck + vitest)" and "clip frame browser gate" both passed). The other four I left alone, for the reasons given below. The PR moved from `a864841e` to `6e99a367` through `safe-push-pr-head.sh` with six follow-up commits.

**Missing input:** the panel review's item list is cut off after about 100 characters per item, and the durable record `74027fd13aa1` on `journal2` holds the same truncated text. So I worked out each defect from the file and line it cites, the start of its sentence, and earlier panel reviews (round 9's saboteur text spelled out the same race in full).

## What changed
1. **assessor (`home.js:403`):** when adding a recovery sign-in failed, the page tried to write to a `guest-status` element this PR removed, so the error was never shown. The failure message is now held and shown in the settings status once the shell is up, the same way the success message already was.
2. **migrator:** a merge to main deploys the app automatically but never runs `deploy-accounts-store.sh`, so the app could go live before its database permissions and the backfill existed.
   - `deploy-accounts-store.sh` now writes a marker row as its last step.
   - `deploy-app.sh` has a new step 4a.1 that refuses to promote the new app until the server can read that marker (it fails closed if the read fails).
   - New `test/deploy-ledger-gate.test.ts` covers the gate and checks the marker key is spelled the same in both scripts and the store.
3. **breaker:** the post-deploy backfill could race a guest deletion and leave an account bonded to a deleted guest. The backfill now adds an entry only while the guest's ledger is open. If the ledger is already closed, it removes the account's bond instead, using the same condition the app uses. Any other error fails the run. Four new backfill tests cover this.
4. **locksmith (`root-host-socket.ts:503`):** the restricted guest directory object was only shallowly frozen, so its methods could still be changed. It now uses `harden` from `@endo/harden`, and a test checks each method is frozen. This was my best guess at the truncated finding.
5. **saboteur:** a deletion started by another process could overtake a `send` or remote invite already in flight, and the request still succeeded. Both now check the guest again after acting and reject with `GuestDeletionPendingError`. A remote invite also cancels its invitation, so its link is never returned. Three new tests cover this.
6. **corner-prober and fast-checker:** new tests for closing a guest's bonds in both the in-memory and DynamoDB stores (closing twice, closing a guest that was never bonded, an account re-bonded to another guest). Also a randomized test that runs sequences of bond, unbond and close against both stores and checks they agree at every step.
7. **archivist:** the `clip-shell-framework.md` status line now names `home.js` and `settings.js` too, and says the Public Suffix List submission for clip isolation is still pending.
8. **pruner:** removed the "planned, delivered, then removed" history from `account-creation-open-signup.md`.
9. **stylist:** renamed `tmp` to `temporaryDaemon` in `test/web/guest-web-daemon.test.ts`.

## Not changed
- **wire-watcher (add `dynamodb:TransactWriteItems` to the policy):** I believe this is a false positive. As far as I know, AWS does not have a `TransactWriteItems` IAM action. A transaction is authorized item by item under `UpdateItem`, and `test/accounts-store-iam.test.ts` already asserts exactly that.
- **transplanter (GNU-only `base64 -w0` / `numfmt` in `deploy-app.sh`):** marked should-fix, and every cited line predates this PR.
- **Two saboteur "Mitigated" lines:** these are notes, not defects.

## Verification
- `npm run typecheck` is clean.
- `npm test`: 1515 passed, 1 failed. The failure is `test/git-remote/capability.test.ts`, which the PR doesn't touch. It fails here because the fleet's `git` wrapper on PATH changes git's behavior. CI ran the full suite and passed.

## Follow-ups
- The panel review's must-fix list arrives truncated, which forces guessing. The panel aggregate should keep the full text of each seat's findings.
- An earlier notice that the gauntlet hit its review-round limit (`kriscendobot-minion.town-pr216-gauntlet-review-budget-reached`) is still unread in the maintainer inbox.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr216-gauntlet-fix-10.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 142 tokens (7745881 cached reads)
- Output: 42685 tokens
- Cost: $3.629228199999999
- Wall-clock: 1915s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
