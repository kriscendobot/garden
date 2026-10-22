---
tier: mentor
requires: host=endolin-garden-ece02cb4
fallback-tier: minion
dispatch: automatic
---
Relay for endojs/endo-but-for-bots PR #1542 (https://github.com/endojs/endo-but-for-bots/pull/1542). Job `fu-endojs-endo-but-for-bots-pr1542-gauntlet-clean-1` on oros-studio pushed head f5f6ec662, which adds a bwrap driver fix, but `gh pr edit` → `updatePullRequest` returns 403 from that host. The ONLY task: if the PR head is still f5f6ec662 or a descendant of it, set the PR title and body exactly as given below, then verify with `gh pr view 1542 -R endojs/endo-but-for-bots --json title,body`. Do not change code.

Title: fix(sandbox): make bwrap tests pass on Ubuntu 26.04 and kill the sandbox init on cancel

Body (everything between the BEGIN/END lines, verbatim; write it to a file and use `gh pr edit 1542 -R endojs/endo-but-for-bots --title '<title>' --body-file <file>`):

-----BEGIN BODY-----
Refs: #1537, #1538

## Description

Three `packages/sandbox` bwrap tests started failing on every PR on 2026-10-22, when `ubuntu-latest` moved to Ubuntu 26.04. The failures show up in `sandbox-drivers`, `test`, and `cover`, and they block the M3 git-remote PRs #1537 and #1538.

The image change didn't cause these failures. On 24.04 runners, AppArmor blocked unprivileged user namespaces, so `bwrapCheck` took the skip path (`t.pass('SKIP: …')`). On 26.04 bwrap actually runs, and three latent bugs show up. Two are in the tests and one is in the driver:

- **prlimit nproc cap is enforced inside the slice** (test bug). The test ran `/bin/sh -c 'ulimit -u'`. On Debian and Ubuntu, `/bin/sh` is dash, which spells the nproc limit `-p` and rejects `-u`. The test now reads the soft limit from the `Max processes` row of `/proc/self/limits` inside the slice, so it doesn't depend on which shell is installed. It still asserts that the slice sees exactly the requested cap.
- **bwrap parent death leaves no owned process group** (test bug). The test awaited `waitForProcessGroupGone` but never recorded an assertion, so ava failed it with "Test finished without running any assertions". The wait now runs inside `t.notThrowsAsync`.
- **bwrap timeout and repeated cancellation reap process groups** (driver bug). This test failed intermittently with `process group N survived bounded cleanup`. The host process group of a bwrap slice holds only the launcher, because the sandbox init calls `setsid()` for `--new-session`. The slice therefore dies only through `--die-with-parent`. bwrap arms that death signal in the init only *after* the launcher finishes user-namespace setup (see `bubblewrap.c`: the child blocks on `child_wait_fd` and calls `handle_die_with_parent()` later). If a signal kills the launcher inside that window, the init is stranded in one of two ways. It may stay blocked on setup inside our process group, which is the test's failure. Or it may continue past `setsid()` and run the command with no death signal armed, where no group signal can reach it. Node has reaped the leader by then, so `killProcessGroup` correctly refuses every later `SIGKILL`.
  The driver now passes `--info-fd 3`, so bwrap reports the init's host pid. `kill()` and teardown `SIGKILL` the init first and then signal the group. Killing a pid namespace's init kills the whole namespace, and the launcher then exits on its own. A soft signal never reached the command, so this changes no observable outcome.

Files to review: `packages/sandbox/src/drivers/bwrap.js`, `packages/sandbox/test/bwrap.test.js`, and a patch changeset.

### Security Considerations

This is a containment fix. Before it, cancelling or timing out a bwrap spawn during launcher setup could leave a sandbox init running the requested command outside any process group the driver can signal. The init is signalled only while Node has not reaped the launcher, the same single-turn pid-reuse window that `killProcessGroup` already documents.

### Scaling Considerations

None. A kill waits for bwrap's `--info-fd` report for at most 1 s. bwrap writes that report immediately after `clone()`.

### Documentation Considerations

None beyond the changeset and the comments in the code.

### Testing Considerations

On runners with user namespaces, the bwrap tests now run for real instead of skipping. Hosts without user namespaces still skip as before.

A new test, "bwrap cancellation during launcher setup strands no sandbox init", cancels 40 spawns across the setup window and scans procfs for survivors. Against the old driver it fails locally (bubblewrap 0.9.0) with dozens of stranded processes. With the fix it passes on every run. A standalone stress harness showed the same result: 3 of 150 process-group leaks and 18 stranded processes before the fix, and 0 of 300 after. The whole `bwrap.test.js` file passes 42/42 under all four ses-ava configs locally.

The `build` check's missing `tred` and the ironhorse-oracle corpus failures on 26.04 are separate breakages that this PR does not fix.

### Compatibility Considerations

`--info-fd` has been in bubblewrap since its earliest releases. If bwrap does not produce a report, the driver falls back to the process-group signal.

### Upgrade Considerations

None.

<!-- garden-job: build-ubuntu-twenty-six-sandbox-test-compatibility -->

🤖 Generated with [Claude Code](https://claude.com/claude-code)
-----END BODY-----

---
claim:
  host: endolin-garden-ece02cb4
  gardener: 3
  worker_kind: cleric
  tier: 
  provider: openai
  model: 
  claimed_at: 2026-10-22T23:52:44Z
