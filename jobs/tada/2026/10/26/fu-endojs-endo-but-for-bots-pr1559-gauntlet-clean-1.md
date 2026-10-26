I didn't push a new fix: the one this job asks for is already open as endojs/endo-but-for-bots#1542, so these reds go away once that PR is merged.

**What fails on endojs/endo-but-for-bots#1559:** the `sandbox-drivers`, `test (22.x/24.x, ubuntu-latest)` and `cover` legs all fail on the same two bwrap tests. They started failing after `ubuntu-latest` moved to Ubuntu 26.04, where bwrap really runs instead of skipping.
- **`prlimit nproc cap is enforced inside the slice`:** `/bin/sh` on the runners is dash, and dash rejects `ulimit -u` ("Illegal option -u"). That spelling only works in bash.
- **`bwrap parent death leaves no owned process group`:** the test makes no assertion, so ava fails it with "Test finished without running any assertions". The cleanup itself was working.

**Existing fix:** endojs/endo-but-for-bots#1542 (`fix/sandbox-ubuntu-2604-bwrap-tests`, base `llm-d5ac419`) fixes both tests:
- the nproc test now reads "Max processes" from `/proc/self/limits`;
- the parent-death wait now runs inside `t.notThrowsAsync`.

It also adds a driver containment fix (it learns the sandbox init's pid via `--info-fd` and kills it directly). It's un-drafted, has no failing checks, is mergeable, and has had only bot reviews.

**What I did:**
- Wrote the same two test fixes in an isolated `llm` checkout (a dash/bash fallback for `ulimit`, plus `t.notThrowsAsync`). I couldn't run them because this host has no bwrap. Once I found #1542 I discarded them, since a second PR would duplicate it and conflict. No garden or project commits.
- Messaged the maintainer: merging #1542 and then re-running CI on #1559 clears these reds. I offered to post a separate test-only PR if they want the driver change reviewed on its own.

**Follow-ups:**
- The maintainer needs to merge endojs/endo-but-for-bots#1542, or ask for the split.
- After that, #1559's CI needs a re-run. Its other leg failures (`test (24.x, macos-15)`) weren't part of this job, and I didn't look into them.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/fu-endojs-endo-but-for-bots-pr1559-gauntlet-clean-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 28 tokens (888278 cached reads)
- Output: 6528 tokens
- Cost: $0.8258236000000001
- Wall-clock: 138s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
