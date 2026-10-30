I applied all of panel round 2's must-fix and should-fix items to PR #1573 and pushed them, but CI on the final head is still running. When the handler budget ran out, 17 checks had passed, 9 were pending and none had failed.

**What changed in the code** (latest panel review, 5706533008):
- **Wire-watcher must-fix (crash wedges the secret):** a new stable import now writes its secret record and grant in one SQLite transaction (`writeSecretRecordWithGrant`). Before, a crash between the two writes left a record its creator could never resume.
- **Audit-lookup disagreement (assessor 4, wire-watcher 2):** I kept the code taking the *latest* create attempt and changed the comments to match. Attempts are only logged while no record exists, so the latest one is the operation that actually wrote it. Taking the first would let an earlier attempt that crashed before writing take over a secret a later operation created. A new test covers exactly that case.
- **`setLimits` (assessor 1):** it now checks its `operationId` against the audit log. A repeated call is a no-op, and a repeat with different limits is refused as `idempotency-conflict`.
- **Retire retry (assessor 2):** retrying under a fresh key while the provider is still `retiring` now finishes the existing retirement instead of starting a second one.
- **`revokeGrant` (assessor 3):** it no longer reports failure for a revoke that already took effect when the endpoint failed to open.
- **Prototype keys (warden 1):** grant ids are validated at `revokeGrant` and `inferenceFor`. Record lookups now ignore inherited properties, and writes define their keys, so ids like `constructor` or `__proto__` can't reach `Object.prototype`.
- **Comments:** I added the ones assessor 5 and the out-of-scope note asked for. I did the pruner's deletions and cut the `provideBase64` JSDoc down to a pointer at the changeset.
- **Tests:** new ones for the crash window, the crashed earlier attempt, ids that differ only by `:` versus `.`, the database transaction, and each registry fix.

**PR body:** trimmed from 554 words to about 185 of prose. The `Refs` lines, the regression-evidence sentence and the phase ledger are kept unchanged.

**Commits on `feature/api-key-provider-registry`** (pushed with `safe-push-pr-head.sh`): `0355e37fff`, `1bd7ba6b4c`, `94864787ee`, `c6ac1bd27b`.

**Local checks:** registry tests 25/25 and secret-manager plus backend tests 30/30. Package `tsc` for daemon and hosted-agent, root `tsc`, and eslint all report no errors. I could not run the SQLite-backed tests (`secret-database`, the restart test) locally because the native module won't load in this worktree.

**CI history:**
- **First push:** `lint` failed on root-tsc type errors in my new test, fixed in `94864787ee`. `cover (24.x)` failed on the sandbox bwrap reaping test. The previous head passed `cover`, this PR doesn't touch the sandbox, and `cover` passed on the next run, so that was a flake (related open fix: #1566).
- **Second push:** all four `test` legs failed in `manager-database › database wrappers survive idle garbage collection`. My change called `db.transaction` while building the database wrapper, and that test's fake database has no such method. `c6ac1bd27b` moves the call to when the write happens, and that test now passes locally.
- **Final head (`c6ac1bd27b`):** the last bounded wait ended with rc 4 (still pending).

**Follow-ups:** the driver should re-post this stage to watch CI on `c6ac1bd27b`. The test legs take about 50 minutes, and 9 jobs were still running.

<!-- gauntlet-stage-result: fix=still-pending -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1573-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 160 tokens (10818912 cached reads)
- Output: 45259 tokens
- Cost: $4.421922400000002
- Wall-clock: 6619s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
