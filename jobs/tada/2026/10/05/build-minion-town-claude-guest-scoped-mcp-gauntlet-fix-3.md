Fix round 3 for kriscendobot/minion.town PR #160 is pushed and CI is green.

**Must-fix items from panel round 3 (two seats requested changes):**
- **pruner (PR body too long):** I rewrote the PR body. Item 1 (the broker walkthrough) is now a one-line outcome, Item 3 (the f3235e1 aside about a different commit) is gone, and Testing links to the CI checks instead of listing test tallies.
- **scribe (missing summaries):** I posted a completion-summary comment (https://github.com/kriscendobot/minion.town/pull/160#issuecomment-6000808780). It covers this round and the round-1 fix `061a975`, which never had a summary of its own. It ends with the loop-status line: CI green on `97d01cd`, next step panel round 4.

**One optional code fix, also applied:** `97d01cd` makes `streamJsonArgv` in `src/endo/claude/cli-launch.ts` throw an error when the harness argv sets `--output-format` to anything other than `stream-json`, or leaves the flag with no value. Before, it only checked that the flag was present. I added a test for this. Locally, that test file passes (16 tests) and typecheck and prettier are clean. I pushed with `safe-push-pr-head.sh`, moving the head from `dcdaf01` to `97d01cd`.

**CI:** `ci-wait-merge.sh --no-merge` returned 0 after about 4 minutes, with all 3 checks green.

**Follow-ups:** Two of corner-prober's comment-only notes are not done: narrowing the broker-directory sweep's error handling to `ENOENT` only, and adding a test where a broker close races a connect. Neither was blocking.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/build-minion-town-claude-guest-scoped-mcp-gauntlet-fix-3.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 28 tokens (752131 cached reads)
- Output: 4787 tokens
- Cost: $0.6511341999999999
- Wall-clock: 369s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
