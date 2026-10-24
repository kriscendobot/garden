Panel-16 fix round for kriscendobot/minion.town#218 is done: three follow-up commits are on the PR head (`6816a61a` → `877b7b5c`) and CI is green. `ci-wait-merge.sh` returned rc 0 with 4 of 4 checks passing.

There was no pre-pass block, so I worked from the latest panel review (5638846671). Of its nine request-changes seats, I fixed six, closed benchmarker with a written "not benchmarked" rationale, and pushed back on two (purist and decomplector).

**Fixes**
- **locksmith** (`b14038ce`): a rebind now only goes through if the account still has the key version it read, not just the fingerprint. A row with no version must still have none. A new test has another key commit in between the read and the write and checks that the rebind retries and deletes the right ledger row. It fails against the old check.
- **breaker** (`b14038ce`):
  - A `row_kind` that is present but isn't the text `account` (for example the number `{N:"1"}`) is no longer read as an account. Covered by a test.
  - For the should-fix item, the comment now gives the 64-bit hash's 2^-64 collision odds instead of saying a rotated key "always" gets a new version. The version stays 16 hex digits because the backfill script and the ledger keys already use that width.
- **spec-keeper** (`b14038ce`): `split` and `some` are saved when the module loads and called with `Reflect.apply`. A new test swaps out both methods after the store is built, and it fails with the old `split`.
- **saboteur** (`cffbdfc7`): if any bond has no key version, the backfill now stops before writing a marker unless `UNVERSIONED_BONDS_KEY=current` is set, meaning the operator confirms the current key made all such bonds. Any other value is refused before any AWS call. DEPLOYMENT.md step 1 documents this, with tests.
- **archivist** (`cffbdfc7`): the rollout item in DEPLOYMENT.md now has an anchor, `#rolling-out-the-guest-bond-ledger`. The DEPLOYMENT.md reference links to it, and the script's comments name it.
- **typist** (`877b7b5c`): the type for the IAM preflight's `send` now names the two DynamoDB commands it sends and the response shapes it reads, instead of `unknown`.
- **benchmarker**: the PR body has a new *Not benchmarked* section explaining why the two claims aren't being benchmarked. Both are correctness claims, and neither is on a serving path.

**Pushed back, no code change** (explained in the follow-up comment, issuecomment-6386333035)
- **purist**: DynamoDB has no `dynamodb:TransactWriteItems` IAM permission. AWS's "Using IAM with DynamoDB transactions" page says transactions are authorized by the underlying item permissions (`UpdateItem`, `DeleteItem` and so on). The deploy preflight also runs a real transaction under the instance role, so a wrong grant would stop the deploy.
- **decomplector**: the ledger staying in this PR was already decided by the arc supervisor on 2026-10-23 and 2026-10-24, per the round-13 reply. Deletion lives on #220.

**Checks run locally:** the five accounts test files pass (96 tests), `tsc --noEmit` is clean, shellcheck shows no new warnings, and `pre-push-gates --probes-only` passes. The full test suite had one failure, `test/git-remote/capability.test.ts`. This diff doesn't touch it, and it's the known local git-wrapper false failure.

**Follow-up for the operator:** the first backfill now needs `UNVERSIONED_BONDS_KEY=current` if any bond predates versioning. Only set it if the recovery key has never been rotated.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr218-gauntlet-fix-16.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 76 tokens (3793843 cached reads)
- Output: 23024 tokens
- Cost: $2.1928886000000003
- Wall-clock: 1283s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
