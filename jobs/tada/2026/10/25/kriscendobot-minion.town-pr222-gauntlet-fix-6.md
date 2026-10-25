I applied the round-6 fixes for kriscendobot/minion.town#222, a draft PR that reverts #218 (the guest bond ledger) because #218 broke the `main` deploy. CI on the new head `714075d4` is green: `ci-wait-merge` exited 0 with 4/4 checks passing.

**What I applied.** There was no pre-pass block in the job, so I worked from the latest panel verdict, review 5640769693 (11 juror seats, on `5011ac03`). Two commits went to `heal/revert-c104813` through `safe-push-pr-head.sh`:

- **`301c9ba7` (tests and roster filter)**
  - New `test/accounts-dynamodb.test.ts`, 14 tests against a mocked DynamoDB table:
    - Rejecting a bond for an account that doesn't exist.
    - The encrypted round trip, with only ciphertext stored.
    - Rebinding to a new guest, and two bonds racing on one account.
    - Malformed bonds, and bonds sealed under a different key.
    - The short-key guard, and both outcomes of a lost provisioning race.
  - Recovery still works when `String.prototype.split` is replaced after the module loads. I checked that this test fails if the code goes back to `sealed.split(".")`.
  - A fast-check property (200 runs): after any sequence of rebinds, each identity recovers its latest bond and no other identity's bond changes.
  - A policy check that reads the inline IAM policy from `deploy-accounts-store.sh`. It confirms every request the adapter sends is allowed, and that role/status updates, `DeleteItem` and `Scan` are not.
  - `set-account-role.sh list` skips non-account rows again. It filters on `row_kind` and also skips the `minion-town:` issuer namespace, so the ledger rows #218's branch left in production stay out of the roster.
- **`714075d4` (docs)**
  - DEPLOYMENT.md and the design's §2 and §8 now state the real ceiling if the app's database access is compromised. The app role's unconditioned `PutItem` can rewrite any account row (status, recovery bond, credits, role). The highest store role grants `mcp/tools` + `mcp/guest`. The old text said a compromise "tops out at read", which was wrong.
  - Design §3 now opens with a note that the current role map (`guest`/`resident`, which grant the same scopes) supersedes its old `visitor` / `mcp/minions:*` tables. The table row for `role` now reads `guest | resident`.
  - The portability rule now says adapters live under each domain's `stores/` directory.
  - The cost bullet now says the 60-second cache is unbenchmarked, and that writes happen once per identity at provisioning plus one update per bond or rebind.

I also posted the summary comment the scribe seat asked for, covering all rounds: https://github.com/kriscendobot/minion.town/pull/222#issuecomment-6391486214

**What I declined, with reasons in that comment:**
- **Changeset:** minion.town has no `.changeset/` directory or changelog. The upgrade notes are already in the PR body.
- **Switching to `@endo/sha256`:** this was a should-fix. The `node:crypto` digest predates #218 and the revert doesn't touch it, and `@endo/sha256` isn't published.

**Verification.** `npm run typecheck` passes. In the full local `npm test`, 1 of 1435 tests fails: `test/git-remote/capability.test.ts`, a file this PR doesn't touch. I believe it's the git-wrapper false failure seen before in this sandbox. CI's `test` job passed.

**Follow-ups.**
- Panel-7 is next; the driver re-posts it.
- About 11 older passages in the design doc still say `visitor`: the diagram, the §3 tables, §4 and the landing-page section. The new §3 note covers them, but they haven't been rewritten.
- `main` is still at the broken #218 merge, so every deploy keeps failing until this revert lands.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr222-gauntlet-fix-6.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 54 tokens (2266749 cached reads)
- Output: 18270 tokens
- Cost: $1.5818617999999998
- Wall-clock: 1094s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
