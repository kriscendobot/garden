PR #1593 (endojs/endo-but-for-bots) is green again and ready for review: every workflow passed on the new head `aef37dfa84`, the PR is not a draft, and GitHub reports it as CLEAN.

**What was failing.** On the post-weave head `eca953f20c`, only the "Workflow security audit" (zizmor) check actually failed. The other "failures" listed (test, cover, viable-release, test-async-hooks) were jobs from a duplicate CI run that was cancelled. A second CI run for the same commit had started at the same moment and replaced it.

**Cause.** This is the known zizmor floating-tag drift, not something in the PR's diff. The `v8` tag of `peter-evans/create-pull-request` now points to `3ffccacd4605` (v8.1.3). Our workflows pin `5f6978faf089`, which is v8.1.1, so the old `# v8` comment no longer matches. `update-action-pins.yml:49` and `update-action-pins-major.yml:49` both have this comment, and so do `llm` and the frozen base `llm-48d6f3e`.

**Fix.** I pushed one comment-only commit, `aef37dfa84`: "ci: correct peter-evans/create-pull-request pin comment to v8.1.1", changing `# v8` to `# v8.1.1` in both files. I pushed with `--force-with-lease` against the previous head `eca953f20c`. It is a normal `ci:` commit rather than a `--fixup`, because no earlier commit in the PR introduced the problem.

**CI on `aef37dfa84`.** All passed:
- CI (https://github.com/endojs/endo-but-for-bots/actions/runs/43732325621): lint, test 22.x/24.x on ubuntu and macos-15, and cover 22.x/24.x.
- Workflow security audit (zizmor).
- OCapN Guile interop, IronHorse oracle sanitizers, Floot Android, and Test project mutual dependency versions.

**Follow-ups:**
- Open upstream PR #1659 makes the same correction on `llm`. Once it merges, any other PR on a frozen base will still need this one-line comment fix if zizmor goes red.
- I did not post a summary comment on the PR, because this job didn't say commenting was authorized.
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/shepherd-endojs-endo-but-for-bots-pr1593.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 24 tokens (727565 cached reads)
- Output: 3916 tokens
- Cost: $0.690057
- Wall-clock: 755s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
