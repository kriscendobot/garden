## PR #1538 fix round: 2026-10-25 panel must-fix items addressed, all CI green

I pushed seven commits to `build/daemon-git-clone`; the new head is `1509ed043e`. Every CI check passes on it (lint, sandbox-drivers, and test and cover on Node 22 and 24, ubuntu and macOS), and I posted a summary comment on the PR. The PR is ready for its next gauntlet panel.

**bwrap kill hang (raised by six seats)** — `4527947c7c`, plus fixup `548a5bd57f`
- A terminal kill now waits at most 250 ms for bwrap's init-pid report (`--info-fd`), then signals the process group regardless. The report also settles when the pipe closes, so an over-size report can't stall it.
- Before killing the init pid, the code re-checks that bwrap is still alive, so a recycled pid can't be hit.
- A reported `child-pid` of 1 or less is rejected, and a malformed report is logged.
- I kept SIGTERM killing the init and corrected the docs and changeset instead. Once bwrap's `--die-with-parent` is armed, SIGTERM already takes the whole sandbox down.
- New tests replace bwrap with a stand-in script, so they run without bwrap installed. Against the old driver, the "never reports" test hung until the run was killed. With the fix, all four kill tests pass in about a second.

**A data-loss bug found during local testing** — `7ad0305ad3`
- The existing test `discard keeps an entry and a name another holder replaced` failed locally. ext4 reused the clone's freed inode number for another holder's new `.git`, and cleanup deleted that holder's directory.
- Entry identity is now device, inode and birth time. On filesystems that don't record birth time it falls back to device and inode, and the design says so.

**Staging safety** — `5d320d22d0`
- Each staging record is now written before its directory exists, and atomically (written to a `.partial` file, then renamed). A record left by a daemon that stopped mid-creation lets a later clone remove the empty directory; a new test covers this.
- Cleanup now ignores only "file not found" errors. Other errors are logged or rethrown instead of being swallowed or reported as "replaced".
- A failed unpin after the names are bound no longer fails a clone that has already been published.

**Docs, types and changesets** — `e6e30067b1`, plus fixup `1509ed043e`
- The `provideGitClone` JSDoc said the clone is staged "inside" the destination; it now says "beside".
- The design now explains why the simpler alternatives the decomplector proposed don't meet the contract, credits #706 for the `identity` option, and drops the planning-history sentence.
- `GitCloneOriginOptions` is now exported; the fixup commit corrects that export, which had failed CI typecheck.
- The changesets now cover the new `FilePowers` requirements, cloning being unavailable on XS, the wider `DriverProcess.kill` contract and the SIGTERM behavior.
- The `renameNoReplace` doc now names its POSIX-only, cross-filesystem and no-hard-link limits.

**Tests and PR body** — `ce57f1cc20`
- I renamed the XS clone-cleanup test to say it runs over Node stand-ins for the XS host functions, not on XS itself.
- I removed a string concatenation that was failing CI lint on the previous head.
- I rewrote the PR body: down from 504 to about 300 words, and it no longer claims the XS code is executed.

**Declined or deferred** (reasons are in the PR comment)
- An XS-native daemon test: the daemon package has no XS test setup, and cloning is refused on XS anyway.
- A floot changeset: `@endo/floot` is private.
- Changing the `major` bump: the old call shape exists on the base branch `llm`, so the migration note applies.
- Splitting `provideGitClone`, a hard-link probe, a Windows `taskkill` note, and the remaining corner-prober test-coverage items: all optional, left for later.

**Local checks**
- Passed: sandbox `bwrap.test.js` (45 tests) and the daemon `git-remote`, `rename-no-replace` and `mount-platform-fs-conformance` tests (85). Typecheck is clean for the sandbox, daemon and agent-mcp-stdio packages, eslint reports no errors on the touched files, and the garden pre-push probes pass.
- Skipped: the real-bwrap tests, because this host has no bwrap; the sandbox-drivers CI job runs them and passed.
- To run the daemon tests at all, I swapped in a Node 22 build of `better-sqlite3`. The warm cache had a build for a newer Node. I changed only this job's worktree copy and kept the original beside it.
- I also started the full daemon suite, but stopped it. Before I stopped it, its channel and channel-relay tests were failing; those tests don't call `provideGitClone`. CI's test legs, which run it, passed.

Nothing changed in the garden repo. Follow-ups: the next gauntlet panel on `1509ed043e`. Before merge, the conductor will need to autosquash the two `fixup!` commits.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1538-gauntlet-fix-20261025.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 244 tokens (18660563 cached reads)
- Output: 55698 tokens
- Cost: $6.465512599999999
- Wall-clock: 6214s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
