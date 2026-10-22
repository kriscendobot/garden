---
orchestration-failed: true
---
orchestration-failed: true

# Clean stage report: endojs/endo-but-for-bots PR #1542 (gauntlet iteration 0)

**CI is RED at head `35d93293`, so this stage failed.** `ci-wait-merge.sh --no-merge` returned rc 3. I pushed nothing.

## What I did
- **Idempotence check:** the PR is an open draft. It changes one file, `packages/sandbox/test/bwrap.test.js`, and the CI rollup was already terminal with 2 failures.
- **Coverage and dead-code pass:** there was nothing to do. The diff only touches a test (it reads RLIMIT_NPROC from `/proc/self/limits` and wraps the owner-death wait in `t.notThrowsAsync`), so no source lines need coverage and no code is orphaned. I made no commits.
- **CI wait:** rc 3 (RED).

## Failing checks
- `sandbox-drivers`: FAILURE
- `cover (24.x, ubuntu-latest)`: FAILURE

Both checks fail on the same single test. The two tests this PR targets (nproc cap and parent-death) now pass.

```
bwrap › bwrap timeout and repeated cancellation reap process groups
Error: process group <pid> survived bounded cleanup
  at waitForProcessGroupGone (packages/sandbox/test/bwrap.test.js:266:9)
  at async packages/sandbox/test/bwrap.test.js:1102:5
```

Line 1102 is the last `waitForProcessGroupGone(cancelledPid)` call. It runs after `/bin/sleep 300` is killed twice with `E(cancelled).kill()` and `wait()` has rejected with "cancelled".

This test always skipped on 24.04, because AppArmor blocked user namespaces and `bwrapCheck` took the skip path. Ubuntu 26.04 lets bwrap run, so it is the third bwrap test the image change exposed. The PR description only covers two.

## Diagnosis (unverified: bwrap isn't installed on this host)
This may be a real cleanup gap in the driver, not just a test bug:
- `reapProcess` in `src/factory.js` treats the process as reaped as soon as the outer bwrap's `exit` fires. That only proves the group leader exited, not that the whole host process group is gone.
- With `--unshare-pid`, the inner bwrap (init of the new PID namespace) is in the same host process group. A PID-namespace init ignores SIGTERM from an ancestor namespace unless it has a handler, so only `--die-with-parent` (PDEATHSIG) or a reparent-and-reap removes it.
- If it lingers, or sits as an unreaped zombie under a subreaper, `kill(-pgid, 0)` still succeeds and the 3 s wait times out.

Possible fixes:
- In the bwrap driver's `kill`/`stop`, send SIGKILL to the group after the leader exits.
- Or make reap wait until the group is gone (ESRCH on `kill(-pgid, 0)`).
- Or, if the lingering member is a zombie, make the test's check zombie-aware.

To confirm which, someone needs a host with bwrap 0.11 and user namespaces, or iteration on the CI runner. I didn't install bubblewrap on this host because that would change the container every fleet job shares.

## Follow-ups
- The fix-loop should either fix the cancel-path cleanup (driver or test) or widen the PR's scope and description to cover this third newly-unskipped test.
- The separate 26.04 breakages (`build` missing `tred`, the ironhorse-oracle corpus) did not show up as failures in this rollup; their checks were skipped.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1542-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 40 tokens (1169299 cached reads)
- Output: 8545 tokens
- Cost: $0.9025758000000002
- Wall-clock: 328s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
