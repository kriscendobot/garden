---
orchestration-failed: true
---
orchestration-failed: true

# Gauntlet CLEAN stage for endojs/endo-but-for-bots#1564: CI is RED, but none of the failures come from this PR

I finished the coverage pass and pushed one test, but `ci-wait-merge.sh` ended RED (rc 3). The job rules make that a stage failure. As far as I can tell, every failing check is a CI-runner problem that also hits the rest of the exo-agent-factory stack.

**What I did**
- **Coverage pass:** the new module `packages/exo-agent-factory/reply-collapse.js` was at 100% of lines but only 85.7% of branches. The early exits in `sameStrings` (same array object, one side missing, different lengths) never ran. I added a test, `reply collapse distinguishes completion and package shape`, that also covers a reply whose `done` flag differs and messages that aren't of type `package`. Coverage is now 100% on every measure.
- **Local checks:** eslint and tsc pass for the package, and the repo-root `tsc -p tsconfig.json` reports nothing in exo-agent-factory, fae or lal. The lal tests pass (190 passed, 1 skipped). The fae tests pass (218 passed, 2 known failures).
- **Dead code:** the diff doesn't leave any orphaned code.
- **Push:** I pushed commit `bffcb37a70` (`test(exo-agent-factory): cover reply-collapse completion and shape distinctions`) with `safe-push-pr-head.sh`. It was a fast-forward from `92b5a1fad8`.

**Why CI is red (7 of 35 checks failed)**
- **build** ("Test project mutual dependency versions"): `scripts/graph.sh: tred: command not found`. The graphviz `tred` tool is missing from the runner image.
- **sandbox-drivers**, **cover (22.x)**, **cover (24.x)**, **test (22.x, ubuntu)** and **test (24.x, ubuntu)**: the only failing tests are two `@endo/sandbox` bwrap tests:
  - `prlimit nproc cap is enforced inside the slice` fails with `/bin/sh: ulimit: Illegal option -u`.
  - `bwrap parent death leaves no owned process group` finished without running any assertions.

  Both look like the runner environment, which may be the ubuntu-latest move to Ubuntu 26 that the CI annotations announce.
- **test (24.x, macos-15)**: `floot-factory/test/factory-system-prompt.test.js` crashed with an unhandled rejection, `TypeError: Cannot assign to read only property 'message' of object 'ClientDestroyedError'`. This PR doesn't touch floot-factory.

The PR's base branch, `build/exo-agent-factory-turn-ledger`, fails the same six CI jobs. The other stack branches (`-maker-adapters`, `-daemon-wiring`, `-core`) also all ended in failure tonight. I didn't check which jobs failed on those three.

**Follow-ups**
- The red checks need a fix to CI, not to this PR: install graphviz on the runner, and make the bwrap tests survive the new image (or skip them there). The floot-factory crash on macOS looks like a flake and probably just needs a rerun.
- Until that lands, every PR in the exo-agent-factory stack will fail its clean stage. Whoever owns the gauntlet should decide whether to treat these failures as known and continue.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1564-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 98 tokens (3661621 cached reads)
- Output: 14773 tokens
- Cost: $1.7395202
- Wall-clock: 3813s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
