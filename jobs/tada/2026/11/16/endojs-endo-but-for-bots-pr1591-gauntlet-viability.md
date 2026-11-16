Viability for PR #1591 (draft, open, not merged): proceed.

- Deciding question: does current `llm` already sweep the bwrap process group when the leader exits, or has a newer implementation displaced this PR? No to both.
- Evidence:
  - On `llm`, `packages/sandbox/src/drivers/bwrap.js` still resolves the exit on `child.once('exit', …)` (line 900). Nothing there sweeps `-pid` on leader exit.
  - `killProcessGroup` in `llm`'s `child-process.js` returns early once the leader has exited (`exitCode`/`signalCode` set). An orphaned pid-namespace init therefore survives, which is the race the PR describes. `llm`'s teardown SIGKILL is the same guarded call, so it does not cover this case.
  - No merged change has replaced the fix. The nearby open PRs (#1542, #1566, #1538) are related. The PR body says #1591 cherry-picks from #1504 and #1566.
  - The earlier "halted" comment on this PR (2026-10-31) says the previous viability report lacked a named question and the exact option line. It records no substantive finding that the PR was overtaken.
  - Not checked: the PR's diff also touches unrelated files (two `update-action-pins*.yml` workflows and the hardened262 `sesNode/module` baselines). Those may be stale-base noise and are worth a look in the clean stage. They do not affect viability.

<!-- gauntlet-stage-result: viability=proceed -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1591-gauntlet-viability.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 2 on 2 host(s)
- Input: 22 tokens (504680 cached reads)
- Output: 5170 tokens
- Cost: $0.7159959
- Wall-clock: 121s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
