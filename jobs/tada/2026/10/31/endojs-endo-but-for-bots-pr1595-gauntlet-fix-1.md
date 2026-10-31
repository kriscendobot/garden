Fix round 1 for endojs/endo-but-for-bots#1595 is done: the style fix is pushed and CI is green on all 36 checks.

**What I fixed.** The pre-pass probe flagged two abbreviated names in `packages/cli/test/git-remote-integration.test.js`: `XDG_RUNTIME_DIR` and `ENDO_ADDR`. Neither can be renamed. They are environment-variable names the test has to pass through: `XDG_RUNTIME_DIR` comes from the XDG spec, and `ENDO_ADDR` is the daemon's existing address setting, already used the same way in `_daemon-context.js` and `trace.test.js`. So I used the probe's documented escape hatch instead: a `// spell-out-exempt:` comment near the top of the file that says why.

- **Commit:** 47955499c (`test(cli): mark git-remote integration test spell-out-exempt for env var names`), pushed with `safe-push-pr-head.sh` as a follow-up commit on top of 86afe57e1, with no history rewritten.
- **Local checks:** the spell-out-identifiers probe now passes over the whole PR diff against base `llm-9a14ddf`, and Prettier passes.

**CI.**
- **First run:** one leg failed, `test (22.x, ubuntu-latest)`. The only failing test was in `packages/sandbox` (`bwrap › bwrap timeout and repeated cancellation reap process groups`). Neither this PR nor my change touches that package, and bwrap failures are a known problem on other PRs.
- **Rerun:** I reran only the failed leg once. After that, `ci-wait-merge.sh` returned rc 0: 36 checks, 0 failed, GREEN.

**Follow-up (optional):** the probe will raise the same false alarm whenever a test sets environment variables in upper case. Exempting environment-variable keys in the probe would avoid this, but it could also hide a genuinely abbreviated new constant, so I left the probe unchanged.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1595-gauntlet-fix-1.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 58 tokens (1979552 cached reads)
- Output: 6963 tokens
- Cost: $1.0876743999999998
- Wall-clock: 5861s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
