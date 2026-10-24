# Fix round 4: https://github.com/kriscendobot/minion.town/pull/222

I applied the panel-4 must-fix items, pushed three follow-up commits to `heal/revert-c104813` (`7fb97fe6` → `9e7074fb`), and CI is green (4/4 checks, 0 failed).

The PR is a heal revert of https://github.com/kriscendobot/minion.town/pull/218 (the guest bond ledger). The panel's findings fell into two groups: the revert had also undone two pieces of hardening that have nothing to do with the ledger, and the restored docs made false claims about the grants and the production state.

**Code (commits `3ae25a2e`, `cbcb5fb5`):**
- **Account key collision (locksmith, warden, wire-watcher, fast-checker):** I put back #218's `JSON.stringify([iss, sub])` account key in `src/auth/accounts.ts`, with a reworded comment. The revert's space join made `("a b","c")` and `("a","b c")` the same cache key. I also restored its example test and its fast-check property test, plus the `ledger.ts` and `identity.ts` comments that no longer claim the account store uses the same space join.
- **Prototype hardening (warden):** `open()` in `src/auth/stores/dynamodb.ts` again reads a stored bond with a `Reflect.apply`/`String.prototype.split` captured when the module loads.
- **Header comment (locksmith):** the file header claimed "GetItem + PutItem only" for the serving path. It now says that path also has an `UpdateItem` limited to the guest-recovery attributes.

**Docs (commit `9e7074fb`):**
- **Grant claims (archivist #1, #2):** `DEPLOYMENT.md:48` and design § 2 now include the restricted `UpdateItem`.
- **Interface (archivist #3):** the design's `AccountStore` description now lists `bondGuest` and `recoverGuest`.
- **Open question 3 (archivist #4, pruner #5):** marked resolved, since the portability amendment is already in `DEPLOYMENT.md`.
- **Ceiling and "git-only" wording (archivist #6, #7):** reworded.
- **Leftover production state (migrator, breaker, engine-realist, wire-watcher):** new `DEPLOYMENT.md` bullet "The reverted guest bond ledger", described below.

**Production leftovers:** the PR body says the migration never ran against production. I checked read-only on 2026-10-24, and an early version of #218's branch (`59473f2e`) did run there:
- Two rows sit under `iss=minion-town:guest-bond-ledger`: one bond entry and one `provisioned` marker. No account row carries ledger attributes, and the markers partition is empty.
- The inline policy `minion-accounts-store-readprovision` is wider than what the reverted script installs. It also allows `bonded_accounts` and `guest_bonds_closed`, and names `dynamodb:TransactWriteItems`, which isn't a real IAM action.

The new bullet records this and the cleanup: rerun `deploy-accounts-store.sh`, which overwrites that policy with the narrower one, then delete the two rows with admin credentials. The reverted serving path never reads that partition, but `set-account-role.sh list` will show both rows as blank accounts until they are deleted. I changed nothing in production. I messaged the maintainer to ask whether to post a job for the cleanup.

**Checks:** typecheck is clean and `test/accounts.test.ts` passes 19/19. The full local suite has one failure, `test/git-remote/capability.test.ts` "propagates a git failure…", which this PR doesn't touch. It looks like the known local git-wrapper false failure, and CI is green.

**Not addressed:** should-fix and follow-up items that only made sense with the ledger in place (bond-version guard, `row_kind` filter, the deleted preflight, the cross-module key-agreement property), and pruner's comment trims beyond the claims I corrected.

**Follow-up:** the production cleanup above, pending the maintainer's answer.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr222-gauntlet-fix-4.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 58 tokens (2595792 cached reads)
- Output: 15361 tokens
- Cost: $1.6730104000000003
- Wall-clock: 1148s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
