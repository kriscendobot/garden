---
orchestration-failed: true
---
orchestration-failed: true

**PR #1572 clean stage: CI is red, but every failure is in two sandbox (bwrap) tests that this PR doesn't touch.**

The failing checks are `test (22.x)`, `test (24.x)`, `cover (22.x)`, `cover (24.x)` and `sandbox-drivers`, all on ubuntu-latest, at head `15507c93bf`. `ci-wait-merge.sh` returned rc=3 (RED). The other 30 checks passed or were skipped.

**What failed:** every red job fails on the same two tests and nothing else:
- `bwrap › prlimit nproc cap is enforced inside the slice` fails with `/bin/sh: 1: ulimit: Illegal option -u`. The test runs the `ulimit -u` shell command, and the runner's default shell doesn't support that option. This is a problem in the test or the runner environment.
- `bwrap › bwrap parent death leaves no owned process group` fails with "Test finished without running any assertions".

PR #1572 changes the daemon and exo-git packages (`host.js`, `manager.js`, `interfaces.js`, `types.d.ts`, tests, the design doc, a changeset). It doesn't touch the sandbox-drivers package. These bwrap reds matched what I'd previously seen as pre-existing on other PRs, so I expect they also fail on the base branch, `build-daemon-git-next-steps-structured-stash-9e885d3`. I didn't check that.

**Coverage and dead code:** I made no changes and pushed nothing.
- The new read-only path in `provideGit` (`readOnly` recorded in the formula, overriding `allowHistoryRewrite`, surviving reincarnation, and blocking mutation methods at runtime) is covered by the new runtime test in `endo.test.js` and the type tests in `git-authority-types.test-d.ts` and `exo-git/test/types.test-d.ts`.
- The diff left no code orphaned; the one removed piece, a no-longer-needed type cast in `host.js`, is just gone.
- I couldn't run the daemon tests locally. The warm-cache `better-sqlite3` module was built for Node 24 (ABI 137) and this host only has Node 22.23.3. In CI the daemon suites ran under `test` and `cover` without failing.

**Next step:** fix or skip the two bwrap tests in the sandbox-drivers package, separately from this PR, then re-run the clean stage. If they also fail on the base branch, PR #1572 is waiting on that fix, not on changes of its own.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1572-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 24 tokens (705553 cached reads)
- Output: 4514 tokens
- Cost: $0.7039586
- Wall-clock: 2343s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
