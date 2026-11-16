Clean stage for endojs/endo-but-for-bots PR #1591 ("fix(sandbox): sweep the bwrap process group when the leader exits"): nothing needed changing, so I pushed nothing, and CI is green.

- **PR state:** still a draft and open. Head is `59f6b248` on `endojs:fix/sandbox-bwrap-leader-exit-group-sweep`, based on the frozen branch `llm-48d6f3e`.
- **Coverage:** I reviewed the diff but did not run a coverage tool. The source change is one block in `packages/sandbox/src/drivers/bwrap.js`: an exit handler that sends SIGKILL to the bwrap process group and ignores the "group already empty" error. Every bwrap test that spawns and exits a sandbox runs this handler. The PR also adds a test helper, `describeProcessGroup`, and gives the cleanup tests more time.
- **Dead code:** the change doesn't leave anything unused.
- **CI:** `ci-wait-merge.sh endojs/endo-but-for-bots 1591 --no-merge` returned 0: 35 checks, none failed (17 passed, 18 skipped).

Follow-ups: none for this stage. The panel review stage comes next.

<!-- gauntlet-stage-result: clean=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/endojs-endo-but-for-bots-pr1591-gauntlet-clean.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 8 tokens (188344 cached reads)
- Output: 1298 tokens
- Cost: $0.44626080000000007
- Wall-clock: 30s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
