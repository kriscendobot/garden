Fix round 5 for kriscendobot/minion.town#86: both of the panel's must-fix items are fixed and pushed, and CI is green on the new head. I did not re-run the panel; the driver posts panel-6.

**Commit `099e9b3`** was added on top of `1f8d6c0` on `git-remote-capability-increment-1`, pushed with `safe-push-pr-head.sh`.

1. **assessor: a git failure no longer wipes published content.** Before, any failure while looking up the served branch was treated as "branch absent", so the push handler cleared the recorded content root without logging anything. Now:
   - `spawnGit` (`git-backend.ts`) reports a failed git command as a new `GitExitError` that includes git's exit code.
   - `projectPartition` (`projection.ts`) uses `rev-parse --verify --quiet` and treats only exit code 1 as "branch absent". Any other failure is passed up to the push handler's existing error path, which logs it and leaves the recorded content root alone.
   - When a push really does empty the served branch, the recorded content root is still cleared; the existing end-to-end test for that case passes.
2. **saboteur: a corrupt partition record is no longer silent.** `readSidecar` (`partition-store.ts`) now reads the file and parses the JSON in separate steps:
   - A missing file still just means "unknown partition".
   - Any other read error, or a JSON parse error, is logged with the file's path, and access is still denied.
   - `makeFsPartitionStore` takes an optional `log` argument that defaults to `console.error`, so existing callers don't change.
3. **Tests** (`test/git-remote/capability.test.ts`):
   - A corrupt record denies access and logs its path.
   - An unknown partition logs nothing.
   - Projecting against a missing repository throws instead of returning an empty result.

**Verification:** the `test/git-remote` tests pass locally (66/66) and `tsc --noEmit` is clean. CI came back green on all 3 checks (`ci-wait-merge.sh` rc 0).

**Not done:** the saboteur's should-fix, running one `git cat-file --batch` process instead of one `git cat-file` per file during projection, is still open. The panel said it doesn't block on its own, since caps on push size are already out of scope for this increment. It needs to be done before this is relied on beyond a low-traffic pilot.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr86-gauntlet-fix-5.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 28 tokens (809090 cached reads)
- Output: 7218 tokens
- Cost: $0.7812820000000001
- Wall-clock: 389s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
