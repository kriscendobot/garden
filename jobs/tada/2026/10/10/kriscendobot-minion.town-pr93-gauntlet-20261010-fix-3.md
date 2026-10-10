**Fix round 3 complete: kriscendobot/minion.town#93.** I applied all three must-fix items from panel round 3 in one follow-up commit, `c8ad060`, and pushed it with `safe-push-pr-head.sh` (578cba7 → c8ad060). CI is green: `ci-wait-merge.sh` returned rc 0 with 3 of 3 checks passing.

**What I changed:**
1. **breaker (bug confirmed):** The git remote stores its content in the same content store as the gateway. By default both use `GATEWAY_STORE_DIR`, and the deployed units set it to the same path. But the git remote records each partition's content root only under `<partitions>/content-roots/<id>`, never as a vhost record. So the GC with `--delete` would have deleted live git-partition content once the grace period passed.
   - `runGc` now treats those roots as live (`git-partition-content-roots`).
   - The CLI finds the partition directory through `GIT_REMOTE_PARTITIONS_DIR`, which defaults to `/var/lib/minion-git/partitions`.
   - If the directory doesn't exist, there are simply no git roots. If it can't be read, holds an invalid root or a stray entry, or a root's manifest is missing, the run stops before deleting anything.
   - The GC service user can't read the partition store today. `deploy-endo-gateway-gc.sh` and `deploy-git-remote.sh` now both grant it, via `setfacl`, the right to pass through the partition store and read `content-roots/` only. It can't read the token files. Either deploy order works.
   - I documented this in the design doc (as Provider 3) and in `DEPLOYMENT.md`, and updated the `clip-store.ts` comment.
   - Tests cover: git roots kept while a real orphan is deleted, a missing partition store, and stops on bad entries. A deploy test checks that both scripts apply the grant.
2. **prover:** Added two tests. One fails if `writeVhostRecord` stops writing atomically. The other fails if `readVhostRecordStrict` stops treating a record that disappears mid-read as absent. I confirmed both fail when those protections are reverted.
3. **stylist:** Renamed `graceMs` to `gracePeriodMilliseconds` in the config, CLI, GC module, tests and design doc. The `GATEWAY_GC_GRACE_MS` setting and the `--grace-ms` flag keep their names.

I also updated the PR body to mention the git-partition roots.

**Checks:** Type checking passes, and the GC, CLI, deploy and config tests pass (44 tests). The full local suite had one failure: `test/git-remote/capability.test.ts` › "propagates a git failure". That code isn't touched by this change, and the test passed in CI both before and after the push, so it looks specific to this machine.

**Follow-ups:**
- The production audit from 2026-09-04 (35 orphan manifests) ran before git partitions were counted as live, so some of those "orphans" may be live git content. Re-run the audit before the first `--delete`; the PR body now says this.
- On the production host, the ACL grant needs the `setfacl` command. The deploy scripts stop with an error if it's missing.
- I didn't address the should-fix items: the gap between the timestamp check and the delete in the sweep, a minimum grace period, alerting on a permanently stopped GC, and the second copy of the default grace value.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr93-gauntlet-20261010-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 84 tokens (4384533 cached reads)
- Output: 25567 tokens
- Cost: $2.3504226
- Wall-clock: 1555s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
