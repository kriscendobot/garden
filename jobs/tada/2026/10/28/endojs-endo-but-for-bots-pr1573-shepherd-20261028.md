I couldn't turn CI on endojs/endo-but-for-bots#1573 green from inside the PR, because nothing in its diff is causing the failures. They come from two runner-image problems that also turn `llm` red, plus one flake. I pushed nothing.

**Failures on head `43bf47ffcb` (CI run 40461446943):**
- **`build` (depcheck):** `scripts/graph.sh` stops with `tred: command not found` (exit 127). The `ubuntu-latest` runner is now Ubuntu 26.04, which ships `tred` in a separate package. The latest `llm` CI run (`204ecd158`) is also red.
- **Ubuntu `test` (22.x, 24.x), `cover` (22.x, 24.x) and `sandbox-drivers`:** the same two `@endo/sandbox` bwrap tests fail every time:
  - "prlimit nproc cap is enforced inside the slice": `/bin/sh` is dash, which rejects `ulimit -u`.
  - "bwrap parent death leaves no owned process group": the test finished without running any assertions.

  These come from the same runner-image switch, not from the PR.
- **`test (24.x, macos-15)`:** floot's `factory-system-prompt.test.js` had an unhandled `ClientDestroyedError` rejection. I reran that job alone and it passed, so this was a flake.

**The fix already exists:** endojs/endo-but-for-bots#1566 installs the missing graphviz package and makes the bwrap tests work on the new runner. Its CI is green after its own shepherd job, but it is still a draft and its gauntlet is halted. I didn't copy those CI fixes into #1573, because that would put unrelated changes in a feature PR.

**Classification:** `next: liaison`. Un-drafting and merging #1566 into `llm` needs the maintainer. After that, a weave of #1573 (with a date suffix) and then of endojs/endo-but-for-bots#1575 should bring the stack to green. I've sent the maintainer this inventory and the unblock steps through the inbox (msg-endojs-endo-but-for-bots-pr1573-shepherd-20261028-6cd2f56b3460).
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1573-shepherd-20261028.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 62 tokens (2473951 cached reads)
- Output: 10479 tokens
- Cost: $1.3819142000000002
- Wall-clock: 3663s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
