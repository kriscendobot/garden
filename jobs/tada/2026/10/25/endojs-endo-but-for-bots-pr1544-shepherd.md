# Shepherd report: endojs/endo-but-for-bots#1544 (head `ae8c33b70b`, base `llm-d5ac419`)

#1544 is still red. None of the failures come from its own diff. Both causes are Ubuntu 26.04 runner problems, and each already has a fix PR on the same base. I pushed no code to #1544.

**The six failing checks have two causes:**

1. **`build` (depcheck workflow):** it fails with `scripts/graph.sh: line 32: tred: command not found`. The runner image is now Ubuntu 26.04, whose Graphviz 14.1.2 moved `tred` into a separate `graphviz-tools` package and no longer ships `acyclic` at all. Other PRs pass this check only because it is skipped for them; #1544 runs it because it changes `package.json` dependencies.
   - Fix: **#1546** (pins depcheck to `ubuntu-24.04`). Its gauntlet is done, it is un-drafted and green, and it is waiting to be merged.
2. **`sandbox-drivers`, `test (22.x)`, `test (24.x)`, `cover (22.x)`, `cover (24.x)`:** the only failures are two old tests in `packages/sandbox/test/bwrap.test.js`:
   - `prlimit nproc cap…` fails with `/bin/sh: ulimit: Illegal option -u`.
   - `bwrap parent death leaves no owned process group` finishes without running any assertions.
   - Fix: **#1542**. Its gauntlet is done, it is un-drafted and green, and it is waiting to be merged.

**The PR's own code passes:**
- In those same CI runs, every test #1544 adds or touches passes (the `endo`, `shell-tool`, `sandbox-spawner`, `shell-engine` and `git-tool` suites), and lint is green.
- Locally, the `packages/claude` suite passes 181/181, including the new `Claude MCP evaluate completes the provisioned Git acceptance loop`.
- Also passing locally: `host-spawner` 12/12, `exo-shell` 25/25, `sandbox` 483/483, and `daemon/test/shell.test.js`.
- Four tests failed locally but pass in CI: three in `daemon/test/endo.test.js` and `agent-tools` `git-flow` (the git-repository-identity test). That points to this container, not the PR.

**What I did:** I posted the diagnosis as a comment on #1544: https://github.com/endojs/endo-but-for-bots/pull/1544#issuecomment-6401482933

**Next step:** the maintainer merges #1546 and #1542. After that, #1544 needs a weave onto a base that contains both fixes, and it should go green with no code change. Merging into a frozen snapshot branch can leave the content off live `llm`, as happened with #621, so whoever conducts those merges should make sure the fixes reach the base #1544 is rewoven onto.

**Garden follow-ups:**
- The shared dependency cache for this worktree was built for Node ABI 137 (Node 24), but `/usr/local/bin/node` in this shell is ABI 127 (Node 22). `better-sqlite3` therefore failed to load. I rebuilt it in my own worktree, with the hardlink to the cache broken first, so the cache itself is untouched. It looks like `ensure-project-worktree.sh` resolves `node` from a different `PATH` than the job shell; that is worth a separate check.
- Tests that spawn executables need an exec-capable `TMPDIR`; `/tmp` is mounted noexec here. The default `/home/kris/garden/scratch/tmpexec` works.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1544-shepherd.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 102 tokens (4372518 cached reads)
- Output: 16754 tokens
- Cost: $1.9991356000000011
- Wall-clock: 2015s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
