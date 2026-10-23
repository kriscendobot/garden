Fix round 6 for kriscendobot/minion.town PR #218 is pushed and CI is green: `ci-wait-merge.sh` returned rc 0 at head `311c1f11`. There was no pre-pass block, so I worked from the latest panel verdict (review 5632303454: breaker, wire-watcher, pruner).

**Changes**, pushed to `split/pr216-ledger` with `safe-push-pr-head.sh` (advance mode, `9042af3f → 311c1f11`):
- **`20ad59c0` fix(deploy)**, covering breaker 1 and 2 and wire-watcher 1 and 2:
  - **Rollback refusal (the must-fix):** a `retired` run used to delete the `reconciled` marker before scanning, so a run that failed partway let an `active` rollback through. A successful `retired` run now also writes a `legacy-writers-retired` marker that no run ever deletes. A `retired` run that finds an existing `reconciled` marker writes the new marker before deleting the old one. `active` is refused while either marker exists, and a failed marker read now aborts the run instead of counting as "no marker".
  - **Scan read-back:** the scan comes back as one JSON object per row, so a newline in a fingerprint can no longer shift the next row's fields.
  - **Encoding:** ledger entries are now encoded with node's `JSON.stringify`, the same encoder the app uses. jq's `tojson` wrote U+007F differently, which produced duplicate entries.
  - **Policy check:** the installed-policy read-back now also requires the PutItem deny to cover both the ledger and marker partitions.
  - **Tests:** I added cases for each of the above, including the reviewer's sequence (reconciled store, a `retired` scan fails, then `active` must die) and two new bad policies (no put denial, a put denial that leaves the marker partition open).
- **`d9985935` fix(accounts)**, wire-watcher 1: `closeGuestBonds` now deletes the exact entry it read rather than a re-encoded one. I added a test with an entry in jq's encoding next to the app's encoding.
- **`311c1f11` docs(accounts)**, covering pruner 1–5 and the comment-only items breaker 3 and 6 and wire-watcher 5:
  - The IAM split is described only in the design; `DEPLOYMENT.md` and the script header point to it.
  - Repeated sentences are cut from the design paragraph and from comments in `dynamodb.ts`, `deploy-app.sh` and the script.
  - The rollback rule now names the new marker and says the refusal applies only to `deploy-accounts-store.sh`.
  - The comments about how `iss` and `sub` are joined in `accounts.ts`, `endo/identity.ts` and `billing/ledger.ts` are corrected.

**Verification:**
- `tsc --noEmit` is clean.
- The four account test files and `test/deploy-accounts-store-backfill.test.ts` pass.
- I swapped the old script and old store back in temporarily: the 10 new or updated script cases and the new store case all fail against them.
- The full local `npm test` has one failure, in `test/git-remote/capability.test.ts` ("propagates a git failure rather than reporting the ref absent"). It fails the same way when run alone, and this PR doesn't touch that area.
- I posted a follow-up summary comment on the PR: https://github.com/kriscendobot/minion.town/pull/218#issuecomment-6371761848

**Follow-ups:**
- I didn't apply three reviewer notes that called for no change:
  - The app role can reopen a closed ledger; this is within the stated compromise ceiling, and the design already names it as a caveat.
  - The preflight probe exercises one ledger attribute rather than both; this is comment-only.
  - The bond/close race was found already handled.
- Breaker's self-improvement suggestion, a probe in `adversarial-tests` for "a flag cleared at the start of a run and read by a guard on the next run", is a garden-library change I didn't make.
- The panel re-runs as panel-7.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr218-gauntlet-fix-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 80 tokens (3647432 cached reads)
- Output: 29596 tokens
- Cost: $2.179206400000001
- Wall-clock: 1407s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
