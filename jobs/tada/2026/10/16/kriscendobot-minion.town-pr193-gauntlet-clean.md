Clean stage for kriscendobot/minion.town PR #193 is done: I added tests and pushed them to the PR, and CI is green on the new head.

**What I did**
- **Starting state:** the PR (`build/ocapn-guest-canary`, head `2c6f59a`) was an open draft. The first status check failed because this host's bot token can't read GitHub's check summary, a known limitation, so I couldn't treat the stage as a no-op.
- **Coverage before:** `node --test --experimental-test-coverage` on `deploy/probe/ocapn-canary.mjs` gave 81.7% of lines. The untested parts were the command-line entry point `main()`, the `makeEndo` wrapper that runs the Endo CLI, and the "unparseable eval output" error path.
- **New tests:** I added 5 tests to `deploy/probe/ocapn-canary.test.mjs`:
  - When one guest fails to bind, the run stops before any message is sent.
  - When `endo eval` returns output that can't be parsed, the message-send step fails and says why.
  - `makeEndo` passes stdin to the CLI and keeps the exit code and stderr. It is tested against the real `node` binary.
  - Run as a command with no guests file, the canary exits 75 with the single `not-provisioned reason=missing` stderr line. The audit file it writes matches what it prints and the `--output` file.
  - Run as a command when the daemon won't start (`ENDO_BIN=false`), the canary exits 1. Its record contains no locator and lists only the `daemon-start` step.
- **Coverage after:** 99.4% of lines; all 17 tests pass. The only untested lines are the internal-error handler.
- **Dead code:** the change left none behind, so I removed nothing.
- **Push and CI:** commit `069d2bc` went to the PR head through `safe-push-pr-head.sh` as a fast-forward from `2c6f59a`. `ci-wait-merge.sh --no-merge` returned 0: the "test (typecheck + vitest)" workflow succeeded. Because of the token limit it checked the Actions runs list instead of the full status summary, so any commit statuses or checks from outside GitHub Actions weren't visible to it.

**Follow-ups:** none. The PR is still a draft, and the next gauntlet stage (panel review) takes it from here.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr193-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 32 tokens (896393 cached reads)
- Output: 6732 tokens
- Cost: $0.7482546
- Wall-clock: 959s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
