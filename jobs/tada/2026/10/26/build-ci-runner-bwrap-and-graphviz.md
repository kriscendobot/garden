I fixed the runner-image CI breaks in draft PR endojs/endo-but-for-bots#1566. The checks it targets (depcheck `build`, `sandbox-drivers`, both `cover` legs and both Node 22 `test` legs) now pass, but the two Node 24 `test` legs still fail. That failure is a separate floot bug that predates this change, and I've posted a job for it.

**What broke:** GitHub's `ubuntu-latest` runner moved to Ubuntu 26.04, which broke three checks on every PR, including the M3 stack #1560–#1564.

**PR #1566** (head `fix/ci-runner-bwrap-and-graphviz`, base the frozen snapshot `llm-d5ac419`, 2 commits):
- **depcheck `Build` (`tred: command not found`):** Ubuntu 26.04 ships graphviz 14, which moved `tred` into a new `graphviz-tools` package and stopped shipping `acyclic` at all.
  - `.github/workflows/depcheck.yml` now installs `graphviz-tools` only when `tred` is missing, so older images keep working. The step fails if `dot` or `tred` is still missing.
  - `scripts/graph.sh` now checks for cycles with coreutils `tsort` instead of `acyclic`. It still produces one line per cyclic edge, so `check-dependency-cycles.sh` keeps counting the same way, and the input it feeds to `dot` is byte-identical to before.
  - Locally, with `dot`/`tred` stubbed: the real package set has 0 cycles, and a synthetic three-package loop is counted as 3 and fails the check.
- **bwrap `prlimit nproc cap…`:** `/bin/sh` is dash, which rejects `ulimit -u`. The test now reads the process limit from `/proc/self/limits` inside the slice, which works in any shell. I checked the parsing locally against `prlimit --nproc=77`.
- **bwrap `parent death leaves no owned process group`:** the test made no assertions, so AVA failed it. It now asserts the owner's pid and records a pass once the process group is gone.

**Still red, separate bug:** `@endo/floot` `test/factory-system-prompt.test.js` crashes on Node 24 (ubuntu and macOS) after all its tests pass, with `TypeError: Cannot assign to read only property 'message' of object 'ClientDestroyedError'`. It shows up the same way on unrelated PRs (#1564's stack and a git-next-steps PR), and an earlier gauntlet report on #1559 also concluded it's a real teardown bug, not a flake. I posted `fix-floot-client-destroyed-error-node24` for it, and a gardener has already claimed it.

**What's left:**
- The gauntlet for #1566 should start automatically now that this build job is done.
- After #1566 merges, the #1560–#1564 stack needs a weave onto a snapshot that includes it, then a fresh gauntlet run. #1560's last halt was a failed clean stage on red CI.
- No garden-repo changes were made.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-ci-runner-bwrap-and-graphviz.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 118 tokens (5530654 cached reads)
- Output: 26034 tokens
- Cost: $2.5180347999999997
- Wall-clock: 1650s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
