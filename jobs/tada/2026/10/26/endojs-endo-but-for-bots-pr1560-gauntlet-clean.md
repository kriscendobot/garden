---
orchestration-failed: true
---
orchestration-failed: true

**Clean stage for PR #1560 failed: CI is RED.** I did not push anything. The PR is still a draft at head `8c4a87e9`.

`ci-wait-merge.sh` returned rc 3 with 7 of 35 checks failed. I read the logs for each failure:

- **`build`:** `scripts/check-dependency-cycles.sh` fails with `tred: command not found` (exit 127). That is a CI-environment problem, not something this PR's diff caused.
- **`test (22.x ubuntu)`, `test (24.x ubuntu)`, `cover (22.x ubuntu)`, `cover (24.x ubuntu)`, `sandbox-drivers`:** the same 2 bwrap sandbox tests fail in all five.
  - `prlimit nproc cap is enforced inside the slice`: `/bin/sh: 1: ulimit: Illegal option -u`.
  - `bwrap parent death leaves no owned process group`: the test finished without running any assertions.

  My notes list the bwrap and `tred` reds as already seen on other branches. I did not check the base branch's CI to confirm.
- **`test (24.x, macos-15)`:** exit 1, but the failed-job log has no `✘ [fail]` line, so I did not identify the failing test. My notes record a `restore-context` flake on macos-15 legs, but I have not matched it to this run.

I did not run the coverage pass or look for orphaned dead code, because CI is red and the stage fails regardless. Follow-ups for the maintainer or driver:

- Fix or exempt the `tred` and bwrap sandbox environment issues, or confirm they are pre-existing on `llm`.
- Re-run the macos-15 24.x leg.
- Re-post the clean stage once those are resolved.

<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1560-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 1 host(s)
- Input: 104 tokens (3778743 cached reads)
- Output: 17533 tokens
- Cost: $1.9756386999999997
- Wall-clock: 3954s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
