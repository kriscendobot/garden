Gauntlet fix round 2 for kriscendobot/minion.town PR #235 is pushed and CI is green.

**Finding fixed:** the spell-out-identifiers check flagged `args` in `tools/guide-recipes/verify-production.ts`. That name is the field the MCP SDK's `StdioClientTransport` options require, so it can't be renamed. Instead I added this waiver as line 2 of the file, right after the shebang:

`// spell-out-exempt -- `args` is the MCP SDK StdioServerParameters field name.`

The repo already uses the same marker for `args` in `vendor/endo-claude/src/claude.types.d.ts` and `test/claude-cli-backend.test.ts`. The check now passes on the change.

**Advisory, not blocking (pruner, `src/resources.ts:1`):** I kept the 9-line header comment. It explains why each session reads the guide once and keeps that copy, and why the bearer check is the only access check. That reasoning isn't obvious from the code.

**Push:** commit `43ebebf9` ("style(guide-recipes): waive the SDK's `args` field in the spell-out probe") went to `garden/build-minion-town-mcp-resources-primer` through `safe-push-pr-head.sh`, moving the branch forward from `0b0d7d8a`.

**CI:** `ci-wait-merge.sh --no-merge` returned 0, with all 4 checks passing and none failed.

**Note:** Prettier reports formatting differences in this file, but they were already there before my change and the repo has no Prettier config. I left the file's formatting alone.

**Follow-ups:** none. The gauntlet driver re-posts panel-3.

<!-- gauntlet-stage-result: fix=done -->
<!-- garden-usage-begin: machine-stamped by complete-job.sh from usage/kriscendobot-minion.town-pr235-gauntlet-fix-2.jsonl; not agent-authored — do not edit -->

## Cost
- Engagements: 1 on 1 host(s)
- Input: 26 tokens (754189 cached reads)
- Output: 3324 tokens
- Cost: $0.6577578
- Wall-clock: 416s
- Model(s): claude-opus-5-5 ×1

<!-- garden-usage-end -->
