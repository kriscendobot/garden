Work complete. Writing the report.

## Completion report

**Job:** Fix the `triager.sh` ref-resolution so a missing `refs/remotes/origin/$ref` can't poison `new_sha` with a two-line `refs/remotes/origin/master\n<sha>` value (the recurring "ambiguous argument" FATAL on `kriscendobot-agoric-sdk`, whose bare clone keeps refs under `refs/heads/*`, not `refs/remotes/origin/*`).

**What I found:** The core `--verify -q` fix was already landed on `origin/main2` by a prior pass (commits `469cab01`, `4ceaff39`, `7cc02046`), along with the `^[0-9a-f]{40}$` tripwire assert and test cases E (fallback-resolves) and F (poison-trips-guard). I confirmed the exact bug scenario still reproduces against the real bare clone: `refs/remotes/origin/master` is absent, plain `master` resolves to `37a4fa31…`; the old bare `rev-parse` emits the two-line poison, while the landed `--verify -q` form emits a single clean SHA.

**What I changed (commit `80acdfce0` on main2):**
- Added the job's recommended `^{commit}` peel to both `rev-parse` calls in `scripts/jobs/triager.sh`, so an annotated-tag watch ref normalizes to its commit before the downstream diff. Documented the resolution comment with the root cause and the peel's purpose.
- Updated `scripts/jobs/test/triager-test.sh` case F's fake-git poison matcher to key on the peeled primary arg `refs/remotes/origin/<ref>^{commit}` so the guard test stays valid.

**Verification:**
- Full triager suite: **29/29 pass**.
- Real-world resolution against `kriscendobot-agoric-sdk` with production config (empty `GARDEN_WATCH_REF` → `symbolic-ref HEAD` → `master`): `new_sha=37a4fa31964909c7876f8dcdf2f9bfd722d3f42c`, `line_count=1`, guard passes, **no ambiguous-argument fatal**.

**Failcount:** Cleared the stuck cursor `cursors/failcount/kriscendobot-agoric-sdk`, which held the poisoned value (`fail_sha: refs/remotes/origin/master\n37a4fa…`, `fail_count: 1`). It's now `fail_count: 0`. Note `fail_count` was 1 (below the threshold of 5), so the breaker was not actually suppressing — only the poisoned value was lingering.

**Follow-ups:**
- The `^{commit}` peel reaches the running fleet only on the next deliberate deploy (`deploy-garden.sh`, liaison-supervised). The `--verify -q` core fix's deployment state depends on the last deploy of the garden root.
- If the deployed root still predates the `--verify -q` fix, a buggy triager tick before the next deploy could transiently re-set `fail_count` to 1; it self-heals post-deploy, since the clean `new_sha` differs from any recorded poisoned `fail_sha` and overwrites it on the first tick.
