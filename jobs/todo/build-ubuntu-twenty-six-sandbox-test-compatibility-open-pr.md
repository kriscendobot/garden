---
role: builder
tier: mentor
requires: host=endolin-garden-ece02cb4
arc: minion-town-git-remote
fallback-tier: minion
dispatch: automatic
---
Open the draft PR for the already-pushed fix branch: `endojs/endo-but-for-bots` head `fix/sandbox-ubuntu-2604-bwrap-tests` (commit 35d932937), base `llm-d5ac419` (the frozen base already exists on the fork at the `llm` tip d5ac41980). Predecessor job `build-ubuntu-twenty-six-sandbox-test-compatibility` (on oros-studio) pushed both branches, but `createPullRequest` returned 403 on that host.

Your only task: in a project worktree from `ensure-project-worktree.sh <this-base> endojs/endo-but-for-bots fix/sandbox-ubuntu-2604-bwrap-tests`, write the body below (between the BODY markers) to a file and run:

    scripts/jobs/gardening/ensure-pr.sh build-ubuntu-twenty-six-sandbox-test-compatibility endojs/endo-but-for-bots fix/sandbox-ubuntu-2604-bwrap-tests llm-d5ac419 --title "test(sandbox): make bwrap nproc and owner-death tests pass on Ubuntu 26.04" --body-file <file>

Keep the `garden-job: build-ubuntu-twenty-six-sandbox-test-compatibility` marker so the PR is adopted under the build job's identity. Name the PR number in your completion report; the gauntlet is staged by completion as for a normal build. After it merges, #1537 and #1538 (based on `llm-54d3d2a`) need a weave to pick up the fix.

----- BODY -----
Refs: #1537, #1538

## Description

Two `packages/sandbox` bwrap tests started failing on every PR on 2026-10-22, when `ubuntu-latest` moved to Ubuntu 26.04. The failures show up in `sandbox-drivers`, `test`, and `cover`, and they block the M3 git-remote PRs #1537 and #1538.

The tests weren't broken by the image change. They were already wrong. On 24.04 runners, AppArmor blocked unprivileged user namespaces, so `bwrapCheck` took the skip path (`t.pass('SKIP: …')`). That is why both tests passed in about 6 ms. On 26.04, bwrap actually runs, and two latent bugs show up:

- **prlimit nproc cap is enforced inside the slice.** The test ran `/bin/sh -c 'ulimit -u'`. On Debian and Ubuntu, `/bin/sh` is dash, which spells the nproc limit `-p` and rejects `-u` (`/bin/sh: 1: ulimit: Illegal option -u`). The test now reads the soft limit from the `Max processes` row of `/proc/self/limits`. The slice mounts a fresh procfs, and `cat` inherits the slice's RLIMIT_NPROC, so the check doesn't depend on which shell is installed. It still asserts that the slice sees exactly the requested cap.
- **bwrap parent death leaves no owned process group.** The test awaited `waitForProcessGroupGone` but never recorded an assertion, so ava failed it with "Test finished without running any assertions" even though the group was gone. The wait now runs inside `t.notThrowsAsync`, so a surviving process group still fails the test, and a clean teardown counts as a pass.

The only file to review is `packages/sandbox/test/bwrap.test.js`.

### Security Considerations

None. Only tests change. The tests still check the same two hardening properties: the nproc cap and owner-death cleanup.

### Scaling Considerations

None.

### Documentation Considerations

None. This is a test-only change.

### Testing Considerations

On runners with user namespaces, these two tests now run for real instead of skipping. Hosts without user namespaces still skip as before. I checked locally that `prlimit --nproc=4242 cat /proc/self/limits` parses to `4242`. This host has no bwrap, so the real end-to-end check is this PR's `sandbox-drivers`, `test`, and `cover` runs on the 26.04 image. The `build` check's missing `tred` and the ironhorse-oracle corpus failures on 26.04 are separate breakages that this PR does not fix.

### Compatibility Considerations

None. Only tests change.

### Upgrade Considerations

None. This is a test-only change, so there is no changeset.

<!-- garden-job: build-ubuntu-twenty-six-sandbox-test-compatibility -->

🤖 Generated with [Claude Code](https://claude.com/claude-code)
----- END BODY -----
