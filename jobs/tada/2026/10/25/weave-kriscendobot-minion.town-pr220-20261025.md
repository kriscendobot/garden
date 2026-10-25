# Weave report: kriscendobot/minion.town#220

#220 now sits on a pinned base and holds only the account-deletion slice, with #219's commit beneath it. CI is green and GitHub reports it MERGEABLE/CLEAN. The PR is still a draft.

**What changed**
- **New base:** I made the frozen branch `main-df5bd2d` from `main` at `df5bd2d7`, which includes #218's merge `c104813b` and #224. I pointed #220's base at it.
- **Head:** went from 39 commits at `4343522a` to 5 linear commits at `b0cf0289`, pushed with `--force-with-lease`.
  1. `2e563013`: #219's single commit `1ae8bc4d`. **#219 is still open**, so it stays beneath #220; I said so in the PR comment.
  2. `7c34f50d` feat(settings): add resumable guest account deletion
  3. `b0adc2c2` feat(accounts): carry the guest deletion facet from #218
  4. `0311f90a` fix(settings): adapt account deletion to #218's ledger
  5. `b0cf0289` docs(accounts): describe the guest bond ledger's per-bond rows. This one is new: one DEPLOYMENT.md paragraph still described the old single `bonded_accounts` ledger row, which #218 replaced.
- **Dropped:** all of #218's pre-merge history (33 commits), the `62a0e650` restack merge, and the stale `4e33e459` that moved the deletion facet out of #218. #218's final versions of all this are already on main.
- **How I rebuilt it:** I made a temporary commit equal to old #218 + #219 and replayed the deletion feature from there. That moved only the deletion slice, not #218's old history.

**Conflicts that needed judgment** (all in commit 3, which re-adds the deletion facet on top of #218's final ledger code; #218 had 11 more commits after the restack)
- **`src/auth/stores/dynamodb.ts`:** kept #218's final `bond()` (first bonds run one at a time, rebinds check the key version, backoff). I added the guest's ledger row as transaction item 0, which fails if the guest has been closed. A failure there raises `GuestBondsClosedError`, and the account-row race check moved from index 1 to index 2.
- **`deploy-accounts-store.sh` backfill:** the transaction is now four items: guest ledger row, bond row, key-version row, then a check on the account row.
  - If the first item fails, the guest was deleted, so the script unbonds the account (#220's behavior).
  - If the last item fails, the bond went stale, so it re-reads and retries (#218's behavior).
  - Any other failure stops the run without recording a marker.
- **`designs/account-creation-open-signup.md` and `DEPLOYMENT.md`:** kept #218's final wording and added the deletion parts (`guest_bonds_closed`, the `Query` grant on the ledger, the `guest/<version>/<fingerprint>` row, the `GuestBondAdmin` facet, a note on what a compromised app could change). I removed the clause saying the app "cannot query the ledger", because #220 grants that.
- **Tests:** updated for the four-item transaction, the two-facet store, and the exported `GUEST_BOND_RECONCILED_SUB`.

**Verification**
- Locally: `npm run typecheck` is clean. `npm test` had 1605 passing and 1 failing: `test/git-remote/capability.test.ts`, a git-remote test this diff doesn't touch. It passed in CI.
- On CI for `b0cf0289`, all jobs passed:
  - test (typecheck + vitest)
  - the browser gate on chromium, firefox and webkit
  - both Claude harness builds (amd64 and arm64)
- The first two commits don't typecheck on their own. In the old history they were also never typechecked alone, because the restack merge sat between them; the full stack is clean.

**Follow-ups**
- When #219 merges, the next weave should drop `2e563013`.
- The un-draft is left to the gauntlet.

Summary comment: https://github.com/kriscendobot/minion.town/pull/220#issuecomment-6394885501
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/weave-kriscendobot-minion.town-pr220-20261025.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 140 tokens (8819182 cached reads)
- Output: 32289 tokens
- Cost: $3.7119124
- Wall-clock: 3027s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
